//The object that can be pushed around by the player. This is the Pikachu object
class Boulder
{
    int facing;            //direction the boulder is facing
    int x, y;              //position of the boulder
    int originX, originY;  //default position of the boulder
    
    Boulder(int bX, int bY, int Facing)
    {
      x = bX;
      originX = bX;
      y = bY;
      originY = bY;
      facing = Facing;
    }
    
    //display boulder on screen
    void display()
    {
      image(imgAssets[0][facing-1], x*cellSize, y*cellSize, cellSize, cellSize);
    }
    
    //reset the position of the boulder
    void resetPosition(int[][] mapIn)
    {
      mapIn[y][x] = EMPTY;
      x = originX;
      y = originY;
      facing = 3;
      mapIn[y][x] = ROCK;
    }
}
