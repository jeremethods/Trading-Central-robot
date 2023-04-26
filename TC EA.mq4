//+------------------------------------------------------------------+
//|                                                        TC EA.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property version   "1.1"
#property strict



input double lot0 = 0.10; //Lot size
input bool logs = false; // Print debug logs
input int magic = 56432; //Magic number

datetime new_data = 0;
datetime old_data = 0;
double pivot=0, S1=0, S2=0, S3=0, R1=0, R2=0, R3=0;
double checksum =0;
double old_checksum=0;
string dir = "not found";
datetime opent;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//clear_chart();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   get_levels();
   if(pivot==0)
     {
      return;
     }

   comment_results();

   checksum = pivot+S1+S2+S3+R1+R2+R3;

   if(old_checksum == 0)
     {
      old_checksum = checksum;
      clear_chart();
      return;
     }

   if(checksum==old_checksum)
     {
      clear_chart();
      return;
     }

   old_checksum = checksum;

   /*
   // Max 1 trade per 5-minute candle
      if(iTime(NULL, PERIOD_M5, 0) == opent)
         return;
      opent = iTime(NULL, PERIOD_M5, 0);
   */

   Print("New levels, opening a trade...");
   int tck = 0;
   if(dir=="up")
      tck = OrderSend(NULL, OP_BUY, lot0, Ask, 5, pivot, R1, "TC EA", magic);
   if(dir=="down")
      tck = OrderSend(NULL, OP_SELL, lot0, Bid, 5, pivot, S1, "TC EA", magic);
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void get_levels()
  {
   dir = "not found";
   pivot=0;
   S1=0;
   S2=0;
   S3=0;
   R1=0;
   R2=0;
   R3=0;

   string linename;
   int tot = ObjectsTotal(0,-1, -1);
   for(int i=tot-1; i>= 0; i--)
     {
      if(ObjectGetString(0, ObjectName(0, i), OBJPROP_TEXT) == "Pivot")
        {
         linename = ObjectName(0, i);
         StringSetCharacter(linename, StringLen(ObjectName(0, i))-1, StringGetCharacter("L",0));
         pivot = ObjectGetDouble(0, linename, OBJPROP_PRICE1);
        }
      if(ObjectGetString(0, ObjectName(0, i), OBJPROP_TEXT) == "S1")
        {
         linename = ObjectName(0, i);
         StringSetCharacter(linename, StringLen(ObjectName(0, i))-1, StringGetCharacter("L",0));
         S1 = ObjectGetDouble(0, linename, OBJPROP_PRICE1);
         dir = "down";
        }
      if(ObjectGetString(0, ObjectName(0, i), OBJPROP_TEXT) == "S2")
        {
         linename = ObjectName(0, i);
         StringSetCharacter(linename, StringLen(ObjectName(0, i))-1, StringGetCharacter("L",0));
         S2 = ObjectGetDouble(0, linename, OBJPROP_PRICE1);
        }
      if(ObjectGetString(0, ObjectName(0, i), OBJPROP_TEXT) == "S3")
        {
         linename = ObjectName(0, i);
         StringSetCharacter(linename, StringLen(ObjectName(0, i))-1, StringGetCharacter("L",0));
         S3 = ObjectGetDouble(0, linename, OBJPROP_PRICE1);
        }
      if(ObjectGetString(0, ObjectName(0, i), OBJPROP_TEXT) == "R1")
        {
         linename = ObjectName(0, i);
         StringSetCharacter(linename, StringLen(ObjectName(0, i))-1, StringGetCharacter("L",0));
         R1 = ObjectGetDouble(0, linename, OBJPROP_PRICE1);
         dir = "up";
        }
      if(ObjectGetString(0, ObjectName(0, i), OBJPROP_TEXT) == "R2")
        {
         linename = ObjectName(0, i);
         StringSetCharacter(linename, StringLen(ObjectName(0, i))-1, StringGetCharacter("L",0));
         R2 = ObjectGetDouble(0, linename, OBJPROP_PRICE1);
        }
      if(ObjectGetString(0, ObjectName(0, i), OBJPROP_TEXT) == "R3")
        {
         linename = ObjectName(0, i);
         StringSetCharacter(linename, StringLen(ObjectName(0, i))-1, StringGetCharacter("L",0));
         R3 = ObjectGetDouble(0, linename, OBJPROP_PRICE1);
        }
     }
   if(S1==0)
      S1 = pivot;
   if(R1==0)
      R1 = pivot;

   new_data = TimeCurrent();

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void comment_results()
  {
   string cmt = "";
//cmt += "\n" + "Newest update: " + (string) new_data;
//cmt += "\n" + "Earlier update: " + (string) old_data;
   cmt += "\n" + "Direction: " + dir;
   cmt += "\n" + " Pivot: " + (string) pivot;
   cmt += "\n" + " S1: " + (string) S1;
   cmt += "\n" + " S2: " + (string) S2;
   cmt += "\n" + " S3: " + (string) S3;
   cmt += "\n" + " R1: " + (string) R1;
   cmt += "\n" + " R2: " + (string) R2;
   cmt += "\n" + " R3: " + (string) R3;
//Comment("asd");
   if(pivot != 0)
     {
      Comment(cmt);
      if(logs)
         Print(cmt);
     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void clear_chart()
  {
   int tot = ObjectsTotal(0,-1, -1);
   for(int i=tot-1; i>= 0; i--)
     {
      if(StringFind(ObjectName(0, i), "TCA_") != -1)
         ObjectDelete(0, ObjectName(0, i));
     }
  }
//+------------------------------------------------------------------+
