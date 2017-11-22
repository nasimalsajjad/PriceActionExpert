//+------------------------------------------------------------------+
//|                                            PriceActionExpert.mq4 |
//|                               Copyright 2017, Md Nasim Al Sajjad |
//|                                          nasimalsajjad@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Md Nasim Al Sajjad"
#property link      "nasimalsajjad@gmail.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
double LowestPrice=0.0;
double  HighestPrice= 0.0;
int HighestCandle=0;
int LowestCandle=0;
int cHighestCandle = 0;
int cLowestCandle = 0;
bool openOrder = true;
double bs =0;
double ls = 0;
double bulls = 0;
int t1,t2=0;
int fibSignal = 0;
double fus=0.0;
    double fls=0.0;

void OnTick(){

// Calculate fibonacci perios and market trend based on fibonacci
    fibSignal = calculateFibSignal(20,15);
  //calculate lot size  
    ls = lotSize();
      
      
 // Reset if there is no open order
  if(OrdersTotal() ==0){
  openOrder = true;
  t1 = 0;
  t2 = 0;
  }
  if(OrdersTotal( )> 0){
  
  
  }
  
   
 
 
   int nt = priceAction();
   // When market is bullish if there is any bullish price action formed, it triggers buy
  if(nt ==1 &&fibSignal == 1 && openOrder == true ){
   
   bulls = fls-0.002;
    t1 = OrderSend(_Symbol,OP_BUY,ls,Ask,3,bulls,Ask+0.01,NULL,0,0,clrAliceBlue);
   openOrder = false;
   }
   // When market is bearish if any bearish price action formed, it triggers sells
   else if(nt ==2 && fibSignal ==2 && openOrder == true ){
   
   bs = fus + 0.002;
    t2 = OrderSend(_Symbol,OP_SELL,ls,Bid,3,bs,Ask-0.01,NULL,0,0,clrAliceBlue);
   openOrder = false;
   }
   // if there is any buy is open, if bearish price action formed, it closes the position.
   if( OrdersTotal()> 0){
   if(t1>0 && nt ==2){
  bool res = OrderModify(t1,0,Ask-0.003,0,0,clrAliceBlue);
   
   // if there is any open sell position, if bullish price action formed, it closes the position
   }else if(t2>0 && nt == 1){
   bool res = OrderModify(t2,0,Ask+0.003,0,0,clrAliceBlue);
   
   }
   }
  }
  
  
  // Calculating lot size
  
   double lotSize(){
  double currentBalance = AccountBalance();
   double lotss =  currentBalance/ 10000;
   
   return lotss;
   
   }
   
   // Calculating price action signal based on pinbar,Engulfing bar, morning star candle pattern
  
  int priceAction(){
  int pa = 0;
  int v = calculatePinBar();
   int p = calculateEngulfingBar();
   int m = calculateMorningStar();
   if (v ==1 || p==1 || m==1){
   pa =1;
   }
   else if(v==2 || p==2 || m==2){
   pa = 2;
   }
   return pa;
  
  }
  
  
  
  int calculateMorningStar(){
  int n=0;
   double a = Open[2]- Close[2];
  double b = High[2] - Low[2];
  if(fibSignal==2){
 
  if(Open[3]> Close[3] && Low[2]< Low[3] && MathAbs(a) < b/4){
  if(Open[1]< Close[1] && High[1] > High[2] && Low[1]> Low[2]){
  n=1;
  Comment("BullishMorningStar Formed");
  }
  
  }
  }else if( fibSignal==1){
  if( Open[3] < Close[3] && High[2]> High[3] && MathAbs(a) < b/4){
  if(Open[1]> Close[1] && High[1] < High[2] && Low[1] < Low[2]){
  n=2;
  Comment(" Bearish Evening Star formed");
  }
  }
  }
  
  return n;
  }
  
  int calculateEngulfingBar(){
  int n=0;
  if(fibSignal==1){
  if(Close[2] > Open[2] && Close[1]< Open[1]){
 if( High[1]>High[2] && Low[1] < Low[2]){
 Comment( "Bearsh engulf");
  n=2;
  }
  }
  }else if (fibSignal==2){
  if(Close[2] < Open[2] && Close[1]>Open[1]){
  if(High[1]>High[2] && Low[1] < Low[2]){
  n=1;
  Comment("Bullish Engulfing");
  
  }
  }
  }else{
  n=0;
  }
  return n;
  }
  
  int calculatePinBar(){
   int n = 0;
   if(fibSignal == 1){
   if(n == 0 && Close[1] < Open[1] &&(High[1]-Open[1])> 2 * (High[1]- Low[1])/3){
   Comment ("Bearish candle formed",n);
   n=2;
   }else if (n == 2 && Low[0] < Low[1] && High[0] < High[1]){
   n=2;
   }
   }else if(fibSignal == 2){
   if(n == 0 && Close[1]> Open[1] && (Open[1]- Low[1]) > 2 * (High[1]-Low[1])/3){
   
   Comment ("Bullish candle formed",n);
   n=1;
   
   }else if ( n == 1 && Low[0] > Low[1] && High[0]>High[1]){
   n=1;
   
   }
   }else {
   n= 0;
   }
   return n;
   }
   
   
   int calculateFibSignal(int n,int m){
 int fp = 0;
 int bullPeriod = findLowest(n,m);
 int bearPeriod = findHighest(n,m);
 if(bullPeriod>bearPeriod){
 
 
 fp = 1;
 }else if( bearPeriod>bullPeriod){
 
 fp =2;
 }
 return fp;
 }
 
 
  
int findLowest(int n,int m){


 double currentLowest = findCurrentLowest(n);
 int p = n+m;
calculateLowestCandle(p);
while (LowestPrice<currentLowest){
 n=n+m;
 p = n+m;
 calculateLowestCandle(p);
 currentLowest = findCurrentLowest(n);
 
 }
return n;

}

int findHighest(int n,int m){

double currentHighest = findCurrentHighest(n);
int p = n+m;
 calculateHighestCandle(p);

while (HighestPrice>currentHighest){
 n=n+m;
 p = n +m;
 calculateHighestCandle(p);
 currentHighest = findCurrentHighest(n);
 
 }
return n;

}
 double findCurrentLowest(int n){
  
 double cLowestPrice = Low[0];
  cLowestCandle = 0;
 for(int i=1; i<n;i++){
 if( cLowestPrice > Low[i]){
 cLowestPrice = Low[i];
 cLowestCandle = i;
 }
 }
  return cLowestPrice;
   
  
  
  }
  
  
  double findCurrentHighest(int n){
  
 double cHighestPrice = High[0];
   cHighestCandle = 0;
 for(int i=1; i<n;i++){
 if(cHighestPrice<High[i]){
 cHighestPrice = High[i];
 cHighestCandle = i;
 
 }
 }
  return cHighestPrice;
   
  
  
  }
  void calculateHighestCandle(int n){
  HighestPrice = High[0];
  HighestCandle = 0;
  
  //Get Highest Price and Highest Candle
  for(int i=1; i<n;i++){
 if( HighestPrice < High[i]){
 HighestPrice = High[i];
 HighestCandle = i;
 }
 }
 }
 //Get Lowest Candle and Lowest Price
 void calculateLowestCandle(int n){
 
 LowestPrice = Low[0];
  LowestCandle = 0;
 for(int i=1; i<n;i++){
 if( LowestPrice > Low[i]){
 LowestPrice = Low[i];
 LowestCandle = i;
 }
 
  
 }  
  
  }
 