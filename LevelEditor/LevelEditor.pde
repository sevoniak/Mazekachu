import java.io.File;
final int LOADSCREEN = 0;
final int EDITSCREEN = 1;
final int NEWFILE = 2;
String PATH;
PImage[] imgAssets;
int numImgAssets;
int stage;
String[] listOfXML;
int rows, cols;
int maxRows, maxCols, minRows, minCols;
int resizeRows, resizeCols;
int cellSize;
PFont font;
String fileClicked;
Cell grid[][];
Button[] buttons;
int numButtons;
int oldMouseOver;
int scrollPos;
boolean saved;
boolean input;
String typing;
int ticks;
int selected;
boolean playerPlaced;
boolean boulderPlaced;
boolean exitPlaced;

void setup()
{
  size(600,400);
  frame.setResizable(true);
  fill(0);
  font = createFont("Arial", 20);
  textFont(font);
  PATH = sketchPath.substring(0,sketchPath.length()-11)+"Game/res/levels/";
  numImgAssets = 6;
  loadImageAssets();
  cellSize = 20;
  stage = LOADSCREEN; 
  setupLoader();
  oldMouseOver = mouseOverIndex();
  scrollPos = 0;
  saved = false;
  input = false;
  playerPlaced = false;
  boulderPlaced = false;
  exitPlaced = false;
  ticks = 0;
  maxRows = 50;
  maxCols = 75;
  minRows = 14;
  minCols = 16;
  resizeRows = 40;
  resizeCols = 85;
}

void draw()
{
  background(255);
  fill(0);
  if (stage == LOADSCREEN)
    drawLoader();
  if (stage == EDITSCREEN)
    drawEditor();
  if (stage == NEWFILE)
    drawNew();
}

void loadImageAssets()
{
  imgAssets = new PImage[numImgAssets];
  imgAssets[0] = loadImage("res/img/PokemonRock.png");
  imgAssets[1] = loadImage("res/img/PokemonPikachuDown.png");
  imgAssets[2] = loadImage("res/img/PokemonAshDown.png");
  imgAssets[3] = loadImage("res/img/PokemonWomanHole.png");
  imgAssets[4] = loadImage("res/img/PokemonFlute.png");
  imgAssets[5] = loadImage("res/img/PokemonSnorlax.png");
}

String[] setupFileNames()
{
  int numXMLfiles = 0;
  File folder = new File(PATH);
  File[] listOfFiles = folder.listFiles(); 
 
  for (int i = 0; i < listOfFiles.length; i++) 
    if (listOfFiles[i].isFile() && listOfFiles[i].getName().endsWith(".xml")) 
      numXMLfiles++;
  String[] temp = new String[numXMLfiles];
  int currentIndex = 0;
  for (int i = 0; i < listOfFiles.length; i++) 
    if (listOfFiles[i].isFile() && listOfFiles[i].getName().endsWith(".xml")) 
    {
      temp[currentIndex] = listOfFiles[i].getName();
      currentIndex++;
    }
  return temp;
}

void setupLoader()
{
  listOfXML = setupFileNames();
  numButtons = listOfXML.length + 3;
  buttons = new Button[numButtons];
  buttons[0] = new Button(0,120,110,350,40,"Create a new file");
  buttons[0].setStyle(true,true,true,0,0,255,0);
  buttons[1] = new Button(1,440,150,30,60,"^");
  buttons[1].setStyle(true,true,true,0,0,255,0);
  buttons[2] = new Button(2,440,290,30,60,"v");
  buttons[2].setStyle(true,true,true,0,0,255,0);
  for (int i = 3; i < numButtons; i++)
  {
    buttons[i] = new Button(i,121,151+(i-3)*40,319,39,listOfXML[i-3]);
    buttons[i].setStyle(true,false,false,30,255,255,0);
  }
  oldMouseOver = -1;
  scrollPos = 0;
  playerPlaced = false;
  boulderPlaced = false;
  exitPlaced = false;
}

void drawLoader()
{
  fill(255);
  rect(120, 110, 350, 240);
  fill(0);
  textAlign(LEFT);
  text("Dungeon Level Editor", width/2-100, 20);
  text("Load a file for editing, or create a new one:", 80, 100);
  if (saved)
  { 
    fill(0);
    textAlign(LEFT);
    text("...file: " + fileClicked + " has been saved.", 20, height-18);
  }
 
  int mouseOver = mouseOverIndex(); 
  if (mouseOver > 2)
    mouseOver += scrollPos;
  if (mouseOver != oldMouseOver)
  {
    if (mouseOver >= 0)
    {
      color c = color(0,0,230);
      buttons[mouseOver].setColors(c,c,0);
    }
    if (oldMouseOver >= 0)
      buttons[oldMouseOver].setColors(0,255,0);
    oldMouseOver = mouseOver;
  }
  
  for (int i = 0; i < 3; i++)
      buttons[i].print(0);
  for (int i = scrollPos+3; i < min(8+scrollPos,listOfXML.length+3); i++)
      buttons[i].print(scrollPos);
}

void setupEditor(int w, int h)
{
  numButtons = 13;
  buttons = new Button[numButtons];
  buttons[0] = new Button(0,35,h-85,100,40,"Back");
  buttons[1] = new Button(1,150,h-85,100,40,"Save");
  buttons[0].setStyle(true,true,true,0,255,0,255);
  buttons[1].setStyle(true,true,true,0,255,0,255);
  for (int i = 2; i < numButtons; i=i+2)
  {
    buttons[i] = new Button(i,w-130,50*i/2,40,40,""+(i-1));
    buttons[i].setStyle(false,true,true,0,255,0,255);
  }
  for (int i = 3; i < numButtons; i=i+2)
  {
    buttons[i] = new Button(i,w-80,50*(i-1)/2,40,40,""+(i-1));
    buttons[i].setStyle(false,true,true,0,255,0,255);
  }
  buttons[numButtons-1] = new Button(numButtons-1,w-120,50*(numButtons-1)/2,70,40,"erase");
  buttons[numButtons-1].setStyle(true,true,true,0,255,0,255);
  saved = false;
  selected = -1;
  oldMouseOver = -1;
}

void drawEditor()
{
  background(0);
  stroke(100);
  for (int i = 0; i < rows+1; i++)
    line(0,i*cellSize,cols*cellSize,i*cellSize);
  for (int i = 0; i < cols+1; i++)
    line(i*cellSize,0,i*cellSize,rows*cellSize);
  for (int i = 0; i < rows; i++)  
    for (int j = 0; j < cols; j++)
      grid[i][j].display();
  for (int i = 0; i < numButtons; i++)
    buttons[i].print(0);
  fill(255);
  text("Block Select", buttons[2].x+40,40);
  
  int mouseOver = mouseOverIndex();
  if (mouseOver != oldMouseOver)
  {
    color c = color(0,0,230);
    if (mouseOver == 0 || mouseOver == 1)
      buttons[mouseOver].setColors(c,c,0);
    if (mouseOver > 1 && selected != mouseOver)
      buttons[mouseOver].setColors(c,0,255);
    if (oldMouseOver == 0 || oldMouseOver == 1)
      buttons[oldMouseOver].setColors(255,0,255);
    if (oldMouseOver > 1 && selected != oldMouseOver)
      buttons[oldMouseOver].setColors(255,0,255);
    oldMouseOver = mouseOver;
  }
  stroke(0);
}

void setupNew()
{
  ticks = 0;
  rows = 25;
  cols = 40;
  typing = "";
  oldMouseOver = -1;
  numButtons = 6;
  buttons = new Button[numButtons];
  buttons[0] = new Button(0,35,height-85,100,40,"Back");
  buttons[0].setStyle(true,true,true,0,0,255,0);
  buttons[1] = new Button(1,150,height-85,100,40,"Next");
  buttons[1].setStyle(true,true,true,0,0,255,0);
  buttons[2] = new Button(2,220,200,30,30,"^");
  buttons[2].setStyle(true,true,true,0,0,255,0);
  buttons[3] = new Button(3,220,230,30,30,"v");
  buttons[3].setStyle(true,true,true,0,0,255,0);
  buttons[4] = new Button(4,440,200,30,30,"^");
  buttons[4].setStyle(true,true,true,0,0,255,0);
  buttons[5] = new Button(5,440,230,30,30,"v");
  buttons[5].setStyle(true,true,true,0,0,255,0);
}

void drawNew()
{
  background(255);
  fill(255);
  rect(50, 100, 450, 30);
  rect(140,200,80,60);
  rect(360,200,80,60);
  fill(0);
  textAlign(LEFT);
  text("Dungeon Level Editor", width/2-100, 20);
  text("Name your dungeon:", 50, 85);
  text("Map width",140,190);
  text("Map height",360,190);
  text(cols,170,235);
  text(rows,390,235);
  text(typing,60,122);
  
  if (input)
  {
    if (ticks < 25)
      line(55,105,55,125);
    if (ticks > 50)
      ticks = 0;
    ticks++;
  }
  
  int mouseOver = mouseOverIndex();
  if (mouseOver != oldMouseOver)
  {
    if (mouseOver >= 0)
    {
      color c = color(0,0,230);
      buttons[mouseOver].setColors(c,c,0);
    }
    if (oldMouseOver >= 0)
      buttons[oldMouseOver].setColors(0,255,0);
    oldMouseOver = mouseOver;
  }
  for (int i = 0; i < numButtons; i++)
    buttons[i].print(0);
    
}

int mouseOverIndex()
{
  int i = 0;
  int id = -1;
  while (i < numButtons && id == -1)
  {
    id = buttons[i].isOver(mouseX,mouseY);
    i++;
  }
  return id;
}

void mousePressed()
{
  if (stage == LOADSCREEN)
  {
    int mouseOver = mouseOverIndex();
    if (mouseOver == 0)
    {
      fileClicked = "New";
      stage = NEWFILE;
      setupNew();
    }
    if (mouseOver == 2)
      if (scrollPos < numButtons-8)
        scrollPos++;
    if (mouseOver == 1)
      if (scrollPos > 0)
        scrollPos--;
    if (mouseOver > 2 && mouseOver < numButtons)
    {
      fileClicked = listOfXML[mouseOver-3+scrollPos];
      loadLevel(fileClicked);
      stage = EDITSCREEN;
    }
    return;
  }
  
  if (stage == EDITSCREEN)
  {
    int mouseOver = mouseOverIndex();
    if (mouseOver == 0)
    {
      frame.setSize(616,436);
      stage = LOADSCREEN;
      setupLoader();
    }
    if (mouseOver == 1)
    {
      saveLevel();
      saved = true;
      frame.setSize(616,436);
      stage = LOADSCREEN;
      setupLoader();
    }
    if (mouseOver > 1)
    {
      buttons[mouseOver].setColors(color(0,200,0),0,255);
      if (selected > -1 && selected != mouseOver)
        buttons[selected].setColors(255,0,255);
      selected = mouseOver;
    }
    if (mouseX >= 0 && mouseX <= cols*cellSize)
      if (mouseY >= 0 && mouseY <= rows*cellSize)
        if (selected > 0)
        {
          if (mouseY/cellSize == 0 || mouseX/cellSize == 0 || mouseY/cellSize == rows-1|| mouseX/cellSize == cols-1)
            return;
          if (selected == 3)
          {
            if (boulderPlaced)
              return;
            else
              boulderPlaced = true;
          }
          if (selected == 4)
          {
            if (playerPlaced)
              return;
            else
              playerPlaced = true;
          }
          if (selected == 5)
          {
            if (exitPlaced)
              return;
            else
              exitPlaced = true;
          }
          if (selected-2 < imgAssets.length)
            grid[mouseY/cellSize][mouseX/cellSize].contents = selected-1;
          if (selected == 12)
          {
            if (grid[mouseY/cellSize][mouseX/cellSize].contents == 2)
              boulderPlaced = false;
            if (grid[mouseY/cellSize][mouseX/cellSize].contents == 3)
              playerPlaced = false;
            if (grid[mouseY/cellSize][mouseX/cellSize].contents == 4)
              exitPlaced = false;
            grid[mouseY/cellSize][mouseX/cellSize].contents = 0;
          }
            
        }
    return;
  }
  
  if (stage == NEWFILE)
  {
    input = false;
    int mouseOver = mouseOverIndex();
    if (mouseOver == 0)
    {
      rows = 0;
      cols = 0;
      fileClicked = "";
      stage = LOADSCREEN;
      setupLoader();
    }
    if (mouseOver == 1)
    {
      grid = new Cell[rows][cols];
      for (int i = 0; i < rows; i++)
        for (int j = 0; j < cols; j++)
        {
          if (i == 0 || i == rows-1 || j == 0 || j == cols-1)
            grid[i][j] = new Cell(j,i,WALL);
          else
            grid[i][j] = new Cell(j,i,EMPTY);
        }
      cellSize = 20;
      if (rows >= resizeRows || cols >= resizeCols)
        cellSize = 15;
      frame.setSize(cols*cellSize+216,rows*cellSize+136);
      setupEditor(cols*cellSize+216,rows*cellSize+136);
      stage = EDITSCREEN;
      if (typing == "")
        fileClicked = "default.xml";
      else
      {
        typing = typing.trim();
        typing = typing.substring(0,min(typing.length(),20));
        fileClicked = typing + ".xml";
      }
    }

    if (mouseOver == 2)
      if (cols < maxCols)
        cols++;
    if (mouseOver == 3)
      if (cols > minCols)
        cols--;
    if (mouseOver == 4)
      if (rows < maxRows)
        rows++;
    if (mouseOver == 5)
      if (rows > minRows)
        rows--;
    
    if (mouseX > 50 && mouseX < 500)
      if (mouseY > 100 && mouseY < 130)
        input = true;
    return;
  }
}

void keyPressed()
{
  if (input)
  {
    if (key == ENTER || key == RETURN || key == ESC || key == DELETE)
    {
      input = false;
      return;
    }
    if (keyCode == SHIFT || keyCode == CONTROL || keyCode == ALT)
      return;
    if (key == BACKSPACE)
    {
      typing = typing.substring(0,typing.length()-1);
      return;
    }
    
    String bad = "/\\:;*?\"|<>=+!@#$%^&()-`~[]{}";
    if (bad.indexOf(key) >= 0)
    {
      println(bad.indexOf(key));
      return;
    }
    if (typing.length() < 25)
      typing += key;
  }
}

void loadLevel(String filename)
{
   XML xmlData;
   XML[] children;
   xmlData =  loadXML(PATH + filename);
   children = xmlData.getChildren("row");
  
   rows = children.length;
   String[] temp = split(children[0].getContent(),',');
   cols = temp.length;
   grid = new Cell[rows][cols];
   
   playerPlaced = false;
   boulderPlaced = false;
   exitPlaced = false;

   for (int i = 0; i < rows; i++)
   {
     String[] cont = split(children[i].getContent(), ',');
     for (int j = 0; j < cols; j++)
     {
       int val = Integer.parseInt(cont[j]);
       grid[i][j] = new Cell(j,i,val);
       if (val == 2)
         boulderPlaced = true;
       if (val == 3)
         playerPlaced = true;
       if (val == 4)
         exitPlaced = true;
     }
   }
   cellSize = 20;
   if (rows >= resizeRows || cols >= resizeCols)
     cellSize = 15;
   frame.setSize(max(cols*cellSize+216,400),max(rows*cellSize+136,475));
   setupEditor(max(cols*cellSize+216,400),max(rows*cellSize+136,475));
}

void saveLevel()
{
  String[] cont = new String[rows+3];
  cont[0] = "<?xml version=\"1.0\"?>";
  cont[1] = "<level name=\"" + fileClicked.substring(0,fileClicked.indexOf('.')) + "\">";
  for (int i = 0; i < rows; i++)
  {
    String out =  "<row id=\"" + i + "\">";
    for (int j = 0; j < cols; j++)
    {
      out += grid[i][j].contents;
      if (j < cols-1)
        out += ",";
      else
        out += "</row>";
    }
    cont[i+2] = out;
  }
  cont[rows+2] = "</level>";
  saveStrings(PATH + fileClicked, cont);
}
