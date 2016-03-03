// Cells are the graphical tiles beneath your feet that dont have to be interactive
class Cell
{
    int x,y;    //position of the cell
    int type;   //contents of the cell
    
    Cell(int cX, int cY, int cType )
    {
      x = cX;
      y = cY;
      type = cType;
    }
    
    //display the contents of the cell on screen
    void display()
    {
      if (type == WALL)
        image(imgAssetsWall, x*cellSize, y*cellSize, cellSize, cellSize);
      if (type == WIN)
        image(imgAssetsWin, x*cellSize, y*cellSize, cellSize, cellSize);
      if (type == FLUTE)
        image(imgAssetsFlute, x*cellSize, y*cellSize, cellSize, cellSize);
      if (type == GATE)
        image(imgAssetsGate, x*cellSize, y*cellSize, cellSize, cellSize);
    }
    
    //set the contents of the cell
    void setCellType(int cType)
    {
      type = cType;
    }
}
