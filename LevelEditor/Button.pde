class Button
{
  int x, y, w, h;
  int id;
  int offset;
  boolean drawFrame;
  boolean centerText;
  String bText;
  color textCol;
  color frameCol;
  color backCol;
  boolean isText;
  
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
   frameCol = frameCol_in;
   backCol = backCol_in;
   textCol = textCol_in;
 }
 
 void print(int scrollPos)
 {
   int py = y - 40*scrollPos;
   if (drawFrame)
     stroke(frameCol);
   else
     noStroke();
     
     fill(backCol);
     rect(x,py,w,h);
     fill(textCol);
   
   if (isText)
   {
     if (centerText)
     {
       textAlign(CENTER);
       text(bText, x+w/2, py+2*h/3);
     }
     else
     {
       textAlign(LEFT);
       text(bText, x+offset, py+2*h/3);
     }
   }
   else
   {
     if (id >= 2 && id < numImgAssets+2)
       image(imgAssets[id-2], x+10, y+10, cellSize, cellSize);
    
   }
   stroke(0);
   fill(0);
 }
 
 int isOver(int testX, int testY)
 {
   if (testX >= x && testX <= x+w)
     if (testY >= y && testY <= y+h)
       return id;
   return -1;
  }
}
