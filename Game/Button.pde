class Button
{
  int x, y, w, h;        //position and size
  int id;                //button id
  int offset;            //amount to indent text to the right.
  boolean drawFrame;     //flag. True: draw a frame around the button.
  boolean centerText;    //flag. True: text is center-aligned. False: text is left-aligned
  String bText;          //the button's text
  color textCol;         //button text's color
  color frameCol;        //button frame's color
  color backCol;         //button background's color
  boolean isText;        //flag. True: this button contains text. False: no text
  
 Button(int id_in, int x_in, int y_in, int w_in, int h_in, String text_in)
 {
   id = id_in;
   x = x_in;
   y = y_in;
   w = w_in;
   h = h_in;
   bText = text_in;
   drawFrame = true;
   centerText = true;
   offset = 0;
   textCol = 0;
   frameCol = 0;
   backCol = 255;
 } 
 
 void setStyle(boolean isText_in, boolean drawFrame_in, boolean centerText_in, int offset_in, color frameCol_in, color backCol_in, color textCol_in)
 {
   //set the various style variables of a newly created button. Call this after the constructor.
   isText = isText_in;
   drawFrame = drawFrame_in;
   centerText = centerText_in;
   offset = offset_in;
   textCol = textCol_in;
   frameCol = frameCol_in;
   backCol = backCol_in;
 }
 
 void setColors(color frameCol_in, color backCol_in, color textCol_in)
 {
   //change the colors of the frame, text, and background.
   if (frameCol_in >= 0)
     frameCol = frameCol_in;
   backCol = backCol_in;
   textCol = textCol_in;
 }
 
 //set the position of the button
 void setPosition(int x_in, int y_in)
 {
   x = x_in;
   y = y_in;
 }
 
 //display the button on screen
 void print()
 {
   if (drawFrame)
     stroke(frameCol);
   else
     noStroke();
     
   fill(backCol);
   rect(x,y,w,h);
   fill(textCol);
   
   if (isText)
   {
     if (centerText)
     {
       textAlign(CENTER);
       text(bText, x+w/2, y+2*h/3+3);
     }
     else
     {
       textAlign(LEFT);
       text(bText, x+offset, y+2*h/3+3);
     }
   }
   stroke(0);
   fill(0);
   textAlign(LEFT);
 }
 
 //test to see if the mouse is currently on top of the button
 boolean isOver(int testX, int testY)
 {
   if (testX >= x && testX <= x+w)
     if (testY >= y && testY <= y+h)
       return true;
   return false;
  }
}
