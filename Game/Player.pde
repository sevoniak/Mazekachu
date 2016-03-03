//The player object
class Player
{
  int facing;            //direction the player is facing
  int x, y;              //position of the player
  int originX, originY;  //default position of the player
  
  Player(int pX, int pY, int Facing)
  {
    x = pX;
    originX = pX;
    y = pY;
    originY = pY;
    facing = Facing;
  }
  
  //display player on screen
  void display()
  {
    image(imgAssets[1][facing-1], x*cellSize, y*cellSize, cellSize, cellSize);
  }
  
  //reset the position of the player
  void resetPosition(int[][] mapIn)
  {
    mapIn[y][x] = EMPTY;
    x = originX;
    y = originY;
    facing = 3;
    mapIn[y][x] = PLAYER;
  }
}
