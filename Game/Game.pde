import ddf.minim.*;
import processing.video.*;
PImage[][] imgAssets;         //the images for the player and boulder
PImage imgAssetsWin, imgAssetsWall, imgAssetsFlute, imgAssetsGate;  //tile images
PImage titleScreen;           //title screen background
PFont font, creditsFont;      //display fonts

Cell[] mapCells;              //the array of tiles used to draw the map
Player p;                     //the player
Boulder b;                    //the boulder - Pikachu
AudioPlayer[] audioPlayers;   //background music resources
AudioPlayer audio;            //the main background music player
Minim minim;                  //sound library
Movie openingMovie;           //opening cinematic
Button[] buttons;             //title and credits screen buttons

int[][] map;            //map of the current level
int level;              //the current level
int maxLevel;           //the last level
int numKeys;            //number of keys the player is carrying
int numResets;          //number of time the player has become stuck in a corner
int cols = 30;          //default number of columns
int rows = 30;          //default number of rows
int cellSize = 20;      //default tile size
int resizeRows = 40;    //number or rows above which the tiles are resized
int resizeCols = 85;    //number of columns above which the tiles are resized
int ticks = 0;          //timer for credits
int textOffset = 35;    //vertical text offset for credits         
float brightValue;      //oscillating brightness values for text in credits
boolean goingRight = true;
int runHeight = 300; 
boolean showMovie;      //flag. True: showing opening movie.
boolean showTitle;      //flag. True: showing title screen.
boolean showGame;       //flag. True: showing game screen.
boolean showWin;        //flag. True: showing win screen.
boolean showCredits;    //flag. True: showing credits.

//tile types
final int EMPTY = 0;
final int WALL = 1;
final int ROCK = 2;
final int PLAYER = 3;
final int WIN = 4;
final int FLUTE = 5;
final int GATE = 6;
 
void setup()
{
  size(960,720);
  frame.setResizable(true);
  font = createFont("Arial",20);
  textFont(font);
  creditsFont = createFont("Arial", 25);
  createButtons();
  LoadAssets();
  
  level = 1;
  maxLevel = 7;
  numKeys = 0;
  numResets = 0;
  showMovie = true;
  showTitle = false;
  showGame = false;
  showWin = false;
  showCredits = false;
  openingMovie.play();
}
 
void draw()
{
  background(0);
  if (showTitle)
    displayTitles();
  else if (showMovie)
    displayMovie();
  else if (showCredits)
    displayCredits();
  else
  {
    for (Cell c : mapCells)   //draw tile graphics
      c.display();
    
    if (showGame)             //draw player and Pikachu, and status bar
    {
      p.display();
      b.display();
      stroke(255,0,0);
      line(0,height-30,width,height-30);
      fill(255);
      stroke(0);
      image(imgAssetsFlute,width-75,height-25);
      text("x " + numKeys,width-45,height-8);
      text("stuck: "+ numResets, width-170, height-8);
      if (buttons[3].isOver(mouseX, mouseY))
        buttons[3].setColors(-1,color(0,0,225),color(0));
      else
        buttons[3].setColors(-1,color(0),color(255));
      buttons[3].print();
    }
    else
    {
      fill(255);
      text("--Press 'Enter'--", 225, height-8);      //message on win screen
    }
    if (level == 1)           //diplay the tutorial messages on Level 1
      displayTutorial();
  }
}

void keyPressed()
{
  if(showGame)
  {
    //handle movement when the arrow keys are pressed
    if (key == CODED)
    {
      //face and attempt to move right
      if (keyCode == RIGHT)
      {
        p.facing = 2;
        if (map[p.y][p.x+1] == EMPTY)
        {
          map[p.y][p.x] = EMPTY;
          p.x++;
          map[p.y][p.x] = PLAYER;
        }
        //attempt to push Pikachu to the right
        else if (map[p.y][p.x+1] == ROCK)
        {
          //check if Pikachu has been pushed onto the exit tile
          if (map[b.y][b.x+1] == WIN)
            levelComplete(); 
          else
          {
            //check if Pikachu has been pushed onto a key
            if (map[b.y][b.x+1] == FLUTE)
            {
              numKeys++;
              map[b.y][b.x+1] = EMPTY;
              mapCells[b.y*cols+b.x+1].setCellType(EMPTY);
            }
            //check if Pikachu has been pushed onto a gate
            if (map[b.y][b.x+1] == GATE)
            {
              if (numKeys > 0)
              {
                numKeys--;
                map[b.y][b.x+1] = EMPTY;
                mapCells[b.y*cols+b.x+1].setCellType(EMPTY);
              }
            }
            if (map[b.y][b.x+1] == EMPTY)
            {
              map[b.y][b.x] = PLAYER;
              b.x++;
              map[b.y][b.x] = ROCK;
              
              map[p.y][p.x] = EMPTY;
              p.x++;
              b.facing = 2;
            }
          }
        }
      }
      
      //face and attempt to move left
      else if (keyCode == LEFT)
      {
        p.facing = 4;
        if (map[p.y][p.x-1] == EMPTY)
        {
          map[p.y][p.x] = EMPTY;
          p.x--;
          map[p.y][p.x] = PLAYER;
        }
        //attempt to push Pikachu to the left
        else if (map[p.y][p.x-1] == ROCK)
        {
          //check if Pikachu has been pushed onto the exit tile
          if (map[b.y][b.x-1] == WIN)
            levelComplete();
          else
          {
            //check if Pikachu has been pushed onto a key
            if (map[b.y][b.x-1] == FLUTE)
            {
              numKeys++;
              map[b.y][b.x-1] = EMPTY;
              mapCells[b.y*cols+b.x-1].setCellType(EMPTY);
            }
            //check if Pikachu has been pushed onto a gate
            if (map[b.y][b.x-1] == GATE)
            {
              if (numKeys > 0)
              {
                numKeys--;
                map[b.y][b.x-1] = EMPTY;
                mapCells[b.y*cols+b.x-1].setCellType(EMPTY);
              }
            }
            if (map[b.y][b.x-1] == EMPTY)
            {
              map[b.y][b.x] = PLAYER;
              b.x--;
              map[b.y][b.x] = ROCK;
              
              map[p.y][p.x] = EMPTY;
              p.x--;
              b.facing = 4;
            }
          }
        }
      }
      
      //face and attempt to move up
      else if (keyCode == UP)
      {
        p.facing = 1;
        if (map[p.y-1][p.x] == EMPTY)
        {
          map[p.y][p.x] = 0;
          p.y--;
          map[p.y][p.x] = 3;
        }
        //attempt to push Pikachu upwards
        else if (map[p.y-1][p.x] == ROCK)
        {
          //check if Pikachu has been pushed onto the exit tile
          if (map[b.y-1][b.x] == WIN)
            levelComplete();
          else
          {
            //check if Pikachu has been pushed onto a key
            if (map[b.y-1][b.x] == FLUTE)
            {
              numKeys++;
              map[b.y-1][b.x] = EMPTY;
              mapCells[(b.y-1)*cols+b.x].setCellType(EMPTY);
            }
            //check if Pikachu has been pushed onto a gate
            if (map[b.y-1][b.x] == GATE)
            {
              if (numKeys > 0)
              {
                numKeys--;
                map[b.y-1][b.x] = EMPTY;
                mapCells[(b.y-1)*cols+b.x].setCellType(EMPTY);
              }
            }
            if (map[b.y-1][b.x] == EMPTY)
            {
              map[b.y][b.x] = PLAYER;
              b.y--;
              map[b.y][b.x] = ROCK;
              
              map[p.y][p.x] = EMPTY;
              p.y--;
              b.facing = 1;
            }
          }
        }
      }
      
      //face and attempt to move down
      else if (keyCode == DOWN)  
      {
        p.facing = 3;
        if (map[p.y+1][p.x] == EMPTY)
        {
          map[p.y][p.x] = 0;
          p.y++;
          map[p.y][p.x] = 3;
        }
        //attempt to push Pikachu downwards
        else if (map[p.y+1][p.x] == ROCK)
        {
          
          //check if Pikachu has been pushed onto the exit tile
          if (map[b.y+1][b.x] == WIN)
            levelComplete();
          else
          {
            //check if Pikachu has been pushed onto a key
            if (map[b.y+1][b.x] == FLUTE)
            {
              numKeys++;
              map[b.y+1][b.x] = EMPTY;
              mapCells[(b.y+1)*cols+b.x].setCellType(EMPTY);
            }
            //check if Pikachu has been pushed onto a gate
            if (map[b.y+1][b.x] == GATE)
            {
              if (numKeys > 0)
              {
                numKeys--;
                map[b.y+1][b.x] = EMPTY;
                mapCells[(b.y+1)*cols+b.x].setCellType(EMPTY);
              }
            }
            if (map[b.y+1][b.x] == EMPTY)
            {
              map[b.y][b.x] = PLAYER;
              b.y++;
              map[b.y][b.x] = ROCK;
              
              map[p.y][p.x] = EMPTY;
              p.y++;
              b.facing = 3;
            }
          }
        }
      }
    }
    //check and reset the level if Pikachu has been pushed into a corner
    if (showGame)
      handleBlocked();
  }
  //win screen is displayed, prepare the next level
  if (key == ENTER)
  {
    if (showWin)
    {
      if (level > maxLevel)    //show credits when all levels are cleared
      {
        ticks = 0;
        showCredits = true;
        showWin = false;
        frame.setSize(800,600);
        textFont(creditsFont);
        fill(255);
        audio.close();
        audio = audioPlayers[9];
        audio.play();
      }
      else        //load the next level
      {
        String levelName = "res/levels/level";
        if (level < 10)
          levelName += "0";
        map = loadLevel(levelName+level+".xml"); 
        CreateObjects();
        buttons[3].setPosition(10,frame.getSize().height-65);
        showWin = false;
        showGame = true;
      }
    }
    if (showMovie)      //skip the opening movie
    {
      openingMovie.stop();
      showMovie = false;
      showTitle = true;
      frame.setSize(630,450);
      audio = audioPlayers[0];
      audio.play();
    }
  } 
}

void mouseClicked()
{
  //handle mouse clicks on the title screen
  if (showTitle)
  {
    if (buttons[0].isOver(mouseX,mouseY))    //start game
    {
      showTitle = false;
      showGame = true;
      textAlign(LEFT);
      String levelName = "res/levels/level";
        if (level < 10)
          levelName += "0";
        map = loadLevel(levelName+level+".xml"); 
      if (level == 1)
        frame.setSize(618,550);
      CreateObjects();
      buttons[3].setPosition(10, frame.getSize().height-65);
    }
    else if (buttons[1].isOver(mouseX,mouseY))  //exit
      System.exit(0);
  }
  //handle mouse click on the end credits screen
  if (showCredits && ticks >= height+27*textOffset-height/2 )
    if (buttons[2].isOver(mouseX,mouseY))    //exit
      System.exit(0);
  //handles mouse clicks on the Reset Level button
  if (showGame)
    if (buttons[3].isOver(mouseX,mouseY))
    {
      numResets++;
      numKeys = 0;
      String levelName = "res/levels/level";
      if (level < 10)
        levelName += "0";
      map = loadLevel(levelName+level+".xml");
      if (level == 1)
        frame.setSize(618,550); 
      CreateObjects();
      buttons[3].setPosition(10,frame.getSize().height-65);
    }
}

void LoadAssets()
{
  //load all the sound resources audioPlayers
  minim = new Minim(this);
  audioPlayers = new AudioPlayer[10];
  audioPlayers[0] = minim.loadFile("res/snd/intro.mp3");
  audioPlayers[1] = minim.loadFile("res/snd/bgm1.mp3");
  audioPlayers[2] = minim.loadFile("res/snd/bgm2.mp3");
  audioPlayers[3] = minim.loadFile("res/snd/bgm3.mp3");
  audioPlayers[4] = minim.loadFile("res/snd/bgm4.mp3");
  audioPlayers[5] = minim.loadFile("res/snd/bgm5.mp3");
  audioPlayers[6] = minim.loadFile("res/snd/bgm6.mp3");
  audioPlayers[7] = minim.loadFile("res/snd/bgm7.mp3");
  audioPlayers[8] = minim.loadFile("res/snd/win.mp3");
  audioPlayers[9] = minim.loadFile("res/snd/end.mp3");
  
  //load all the images into imgAssets
  imgAssets = new PImage[2][4];
  imgAssets[0][0] = loadImage("res/img/PokemonPikachuUp.png");
  imgAssets[0][1] = loadImage("res/img/PokemonPikachuRight.png");
  imgAssets[0][2] = loadImage("res/img/PokemonPikachuDown.png");
  imgAssets[0][3] = loadImage("res/img/PokemonPikachuLeft.png");
  imgAssets[1][0] = loadImage("res/img/PokemonAshUp.png");
  imgAssets[1][1] = loadImage("res/img/PokemonAshRight.png");
  imgAssets[1][2] = loadImage("res/img/PokemonAshDown.png");
  imgAssets[1][3] = loadImage("res/img/PokemonAshLeft.png");
  imgAssetsWin = loadImage("res/img/PokemonWomanHole.png");
  imgAssetsWall = loadImage("res/img/PokemonRock.png");
  imgAssetsFlute = loadImage("res/img/PokemonFlute.png");
  imgAssetsGate = loadImage("res/img/PokemonSnorlax.png");
  
  //load cinematic and title screen
  openingMovie = new Movie(this,"GameCinematic.mov");
  titleScreen = loadImage("data/TitleScreen.png");
}

void createButtons()
{
  buttons = new Button[4];      //create buttons for title screen and credits.
  buttons[0] = new Button(0, 150, 350, 130, 30, "Start Game");
  buttons[0].setStyle(true, true, true, 0, color(0,255,0), color(255), color(0));
  buttons[1] = new Button(1, 400, 350, 100, 30, "Exit");
  buttons[1].setStyle(true, true, true, 0, color(255,0,0), color(255), color(0));
  buttons[2] = new Button(2, 635, 500, 130, 30, "Exit Game");
  buttons[2].setStyle(true, true, true, 0, color(255,0,0), color(255), color(0));
  buttons[3] = new Button(3, 0, 0, 130, 25, "Reset Level");
  buttons[3].setStyle(true, true, true, 0, color(0,255,0), color(0), color(255));
}

void CreateObjects()
{
  //create the tiles, player and boulder objects based on the loaded map
  mapCells = new Cell[cols*rows];   
  for (int i = 0; i < rows; i ++ ){ 
    for (int j = 0; j < cols; j ++ ) 
    {
       if(map[i][j] == PLAYER){
        p = new Player(j, i, 3);
      }else if(map[i][j] == ROCK){
        b = new Boulder(j, i, 3);
      }
      mapCells[j + i*cols] = new Cell(j, i, map[i][j]); 
    }
  }
  //set bmg music for the level
  if (audio != null)
  {
    audio.pause();
    audio.rewind();
  }

  audio = audioPlayers[(level-1)%(audioPlayers.length-3)+1];
  audio.rewind();
  audio.loop();
}

void handleBlocked()
{
  //determine whether the player has pushed pikachu into a corner or not.
  boolean upBlocked = false;
  boolean downBlocked = false;
  boolean rightBlocked = false;
  boolean leftBlocked = false;
  if (map[b.y][b.x+1] == WALL || (map[b.y][b.x+1] == GATE && numKeys == 0))
    rightBlocked = true;
  if (map[b.y][b.x-1] == WALL || (map[b.y][b.x-1] == GATE && numKeys == 0))
    leftBlocked = true;
  if (map[b.y+1][b.x] == WALL || (map[b.y+1][b.x] == GATE && numKeys == 0))
    upBlocked = true;
  if (map[b.y-1][b.x] == WALL || (map[b.y-1][b.x] == GATE && numKeys == 0))
    downBlocked = true;
  if ((rightBlocked && (upBlocked || downBlocked)) || (leftBlocked && (upBlocked || downBlocked)))
  {
    numResets++;            //pikachu is in a corner, reset the player's location
    p.resetPosition(map);
    b.resetPosition(map);
  }
}
 
void stop()
{
  // always close Minim audio classes when you are done with them
  for (int i = 0; i < audioPlayers.length; i++)
    audioPlayers[i].close();
  audio.close();
  minim.stop();
  super.stop();
}

int[][] loadLevel(String filename)
{
   //load the XML encoded level map
   int[][] loadMap;
   XML xmlData;
   XML[] children;
   xmlData =  loadXML(filename);
   children = xmlData.getChildren("row");
  
   //determine the size of the loaded map
   rows = children.length;
   String[] rowElements = split(children[0].getContent(),',');
   cols = rowElements.length;
   loadMap = new int[rows][cols];

   //populate the map with the loaded tile types
   for (int i = 0; i < rows; i++)
   {
     rowElements = split(children[i].getContent(), ',');
     for (int j = 0; j < cols; j++)
     {
       int type = Integer.parseInt(rowElements[j]);
       loadMap[i][j] = type;
     }
   }
   //resize the window is the level is too big
   cellSize = 20;
   if (rows >= resizeRows || cols >= resizeCols)
     cellSize = 15;
   frame.setSize(cols*cellSize+18,rows*cellSize+70);
   return loadMap;
}

void levelComplete()
{
  //level is complete, load the win message
  level += 1;
  map = loadLevel("res/levels/win.xml"); 
  CreateObjects();
  showWin = true;
  showGame = false;
  audio.pause();
  audio = audioPlayers[8];
  audio.play();
}

void displayTutorial()
{
  //display tutorial messages on Level 1
  fill(255);
  text("Controls:", 50, 200);
  text("------------", 50, 215);
  text("Move Up", 100, 235);
  text("Move Down", 100, 260);
  text("Move Right", 100, 285);
  text("Move Left", 100, 310);
  text("Up arrow", 250, 235);
  text("Down arrow", 250, 260);
  text("Right arrow", 250, 285);
  text("Left arrow", 250, 310);
  
  text("Tips:", 50, 350);
  text("* Move Pikachu towards the goal by pushing him", 50, 375);
  text("* Pikachu can only be pushed, not pulled", 50, 400);
  text("* Pushing Pikachu into a corner resets the level", 50, 425);
  text("* Only Pikachu can interact with items (keys, gates, etc)", 50, 450);
  text("* Interact with item by pushing Pikachu onto them", 50, 475);
}


void displayMovie()
{
  //play the opening cinematic
  if (openingMovie.duration() - openingMovie.time() > 0.1)
    image(openingMovie,-160,0);
  else
  {
    openingMovie.stop();
    showMovie = false;
    showTitle = true;
    frame.setSize(630,450);
    audio = audioPlayers[0];
    audio.play();
  }
}
void movieEvent(Movie m)  { m.read(); }

void displayTitles()
{
  //show the main title screen
  image(titleScreen,0,0);
  image(imgAssetsFlute,ticks+600,80*cos(ticks/20.0)+215);
  image(imgAssetsFlute,ticks+450,80*cos(ticks/20.0+3*HALF_PI)+215);
  image(imgAssetsFlute,ticks+300,80*cos(ticks/20.0+PI)+215);
  image(imgAssetsFlute,ticks+150,80*cos(ticks/20.0+HALF_PI)+215);
  image(imgAssetsFlute,ticks,80*cos(ticks/20.0)+215);
  image(imgAssetsFlute,ticks-150,80*cos(ticks/20.0-HALF_PI)+215);
  image(imgAssetsFlute,ticks-300,80*cos(ticks/20.0-PI)+215);
  image(imgAssetsFlute,ticks-450,80*cos(ticks/20.0-3*HALF_PI)+215);
  image(imgAssetsFlute,ticks-600,80*cos(ticks/20.0)+215);
  image(imgAssetsFlute,ticks-750,80*cos(ticks/20.0-HALF_PI)+215);
  if (goingRight)
  {
    image(imgAssets[1][1],(ticks%400)*2-30,runHeight,30,30);
    image(imgAssets[0][1],(ticks%400)*2,runHeight,30,30);
    image(imgAssetsGate, 800-2*(ticks%400),600-2*(ticks%400),30,30);
    ticks++;
  }
  else
  {
    image(imgAssets[1][3],600-(ticks%400)*2,runHeight,30,30);
    image(imgAssets[0][3],600-(ticks%400)*2-30,runHeight,30,30);
    image(imgAssetsGate, 2*(ticks%400)-200,2*(ticks%400)-200,30,30);
    ticks++;
  }
  if (ticks%400 == 0)
  {
    goingRight = !goingRight;
    runHeight = (int)random(50,400);
    if (ticks == 800)
      ticks = 1;
  }
  for (int i = 0; i < 2; i++)
  {
    if (buttons[i].isOver(mouseX, mouseY))
      buttons[i].setColors(-1,color(0,0,225),color(0));
    else
      buttons[i].setColors(-1,color(225),color(0));
    buttons[i].print();
  }
}

void displayCredits()
{
  //show the end credits
  if (ticks < height+27*textOffset-height/2)
  {
    fill(225);
    textAlign(CENTER);
    text("Maze-kachu", width/2, height+textOffset-ticks);
    text("---------------------", width/2, height+2*textOffset-ticks);
    text("created for COMP 1501", width/2, height+3*textOffset-ticks);
    text("by", width/2, height+4*textOffset-ticks);
    text("Karles Belanger", width/2, height+5*textOffset-ticks);
    text("Jean-Luc Caron", width/2, height+6*textOffset-ticks);
    text("Sebastian Evoniak", width/2, height+7*textOffset-ticks);
    text("Resources", width/2, height+10*textOffset-ticks);
    text("---------------------", width/2, height+11*textOffset-ticks);
    textAlign(LEFT);
    text("Music:              Pokemon Games", 2*width/7, height+12*textOffset-ticks);
    text("Sprites:            Pokemon Games", 2*width/7, height+13*textOffset-ticks);
    text("Software:         Processing 2.0b7", 2*width/7, height+14*textOffset-ticks);
    text("                        Sony Vegas Pro 11", 2*width/7, height+15*textOffset-ticks);
    text("Libraries:         minim", 2*width/7, height+16*textOffset-ticks);
    text("                        processing.video", 2*width/7, height+17*textOffset-ticks);
    fill(255,0,0);
    text("--=The End=--", width/4, height+27*textOffset-ticks);
  }
  else
  {
    //oscillate the brightness of the text
    textAlign(LEFT);
    brightValue = 255 * abs(cos(ticks/20.0));
    fill(brightValue,0,0);
    text("--=The End=--", width/4, height/2);
    if (buttons[2].isOver(mouseX, mouseY))
      buttons[2].setColors(-1,color(0,0,225),color(0));
    else
      buttons[2].setColors(-1,color(225),color(0));
    fill(255);
    if (numResets < 5)
    {
      text("Congratulations! You only got stuck " + numResets + " times.", 150, 380);
      text("You are a Mazekachu master!", 230, 410);
    }
    else if (numResets < 10)
      text("You got stuck " + numResets + " times. Not bad!", 200, 380);
    else if (numResets > 14)
    {
      text("Getting stuck " + numResets + " times... Maybe you need more practice.", 80, 380);
      text("Keep practicing!", 300, 410);
    }
    buttons[2].print();
  }
  ticks++;
  if (ticks > 10*(height+27*textOffset-height/2))
    ticks = height+27*textOffset-height/2;
}
