final int EMPTY = 0;
final int WALL = 1;
final int ROCK = 2;
final int PLAYER = 3;
final int WIN = 4;
final int FLUTE = 5;
final int GATE = 6;

class Cell 
{
  int x;          //column number in the grid
  int y;          //row number in the grid
  int contents;   //what is in grid[x][y]
  
  Cell()
  {
    x = 0;               
    y = 0;               
    contents = EMPTY;    
  }
  // Cell Constructor
  Cell(int x_in, int y_in, int contents_in) 
  {
    x = x_in;
    y = y_in;
    contents = contents_in;
  }
  
  void display()
  {
    if (contents == WALL)
      image(imgAssets[0], x*cellSize, y*cellSize, cellSize, cellSize);
    if (contents == ROCK)
    {
      image(imgAssets[1], x*cellSize, y*cellSize, cellSize, cellSize);
      text( "b (" + x*cellSize + "," + y*cellSize+")", 350, height-15);  
    }
    if (contents == PLAYER)
    {
      image(imgAssets[2], x*cellSize, y*cellSize, cellSize, cellSize);
      text( "p (" + x*cellSize + "," + y*cellSize+")", 350, height-40);
    }
    if (contents == WIN)
      image(imgAssets[3], x*cellSize, y*cellSize, cellSize, cellSize);
    if (contents == FLUTE)
      image(imgAssets[4], x*cellSize, y*cellSize, cellSize, cellSize);
    if (contents == GATE)
      image(imgAssets[5], x*cellSize, y*cellSize, cellSize, cellSize);
  }
}


