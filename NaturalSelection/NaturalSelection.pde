public static final int screenWidth=800;
public static final int screenHeight=1000;
private float fps;//Number of frames per second. In other words, the number of cycles per second.

//#UI sizes: fields stored here for setting up/using the GUI
 private float UIHeight=screenHeight/8;
 private float UIWidth=screenWidth;
 private float speedButtonWidth=UIWidth/16;
 private float speedButtonHeight=UIHeight/2;
 private float UITop = screenHeight-UIHeight;
 private float speedButtonLeft = 0;
 
 //#Region Specifications
 private float regionTop = 100;
 private float regionLeft = 100;
 private float regionHeight = 600;
 private float regionWidth = 600;
 
 //#Fields regarding entities!
 private ArrayList<Entity> currentGeneration;


void settings(){//Used for specifying the height and width of size(). It's a quirk of processing.
  size(screenWidth,screenHeight);
}

void setup(){
  fps=60;//Initial framerate.
  frameRate(fps);
  currentGeneration = new ArrayList<Entity>();
  for(int i=0; i<50; i++){
    currentGeneration.add(new Entity());}
  

}

public void drawGUI(){//Draws a scaling GUI.
 fill(255);
 noStroke();
 rect(0,UITop,UIWidth,UIHeight);//Draws the container "bar" of the UI. 
 stroke(2);
 rect(speedButtonLeft, UITop,speedButtonWidth, speedButtonHeight);//Speed up button
 rect(speedButtonLeft, UITop+speedButtonHeight, speedButtonWidth, speedButtonHeight);//Slow down button
 
 fill(255);//Set colour to white
 float CycleCounterSize =15;
 textSize(CycleCounterSize);
 text("Cycles/Second:"+fps, 0, CycleCounterSize);
 
}


void draw(){
  frameRate(fps);
  background(0);//Sets background to black. In other words, wipes the screen
  drawGUI();
  fill(220);
  rect(regionLeft, regionTop, regionWidth, regionHeight);//Draw the region itself.
  for(Entity e: currentGeneration){
    e.render();
    e.step();
  }
  
  
  

}


void mouseReleased(){//The mouselistener!
  if((mouseX>speedButtonLeft)&&(mouseX<speedButtonLeft+speedButtonWidth)&&(mouseY>UITop)&&(mouseY<UITop+speedButtonHeight)){//If "speed up" button is hit
    fps=fps+10;//Increases the current FPs by 10.
  }
  else if((mouseX>speedButtonLeft)&&(mouseX<speedButtonLeft+speedButtonWidth)&&(mouseY>UITop+speedButtonHeight)&&(mouseY<UITop+speedButtonHeight*2)){//If "slow down" button is hit and framerate is above 10
    if(fps>10){//Sets the FPS 10 lower than the current value
    fps=fps-10;
    }
    if(fps<10){//FPS's minimum is 10.
    fps=10;
    }
  }
  
  
}
