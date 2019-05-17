class Entity{
  //#Fields go here!
  
  //#Fields: Positional/Movement
  private float ypos;
  private float xpos;
  private PVector position;
  private float defaultMoveSpeed = 2;//The typical "movement speed" for each entity, NOT the varying speed that comes into play later on.
  private float defaultEnergyUsage = .25;
  
  private PVector directionalAngle; //The angle the entity is moving in. A vector with a length of 1.
  private float energy; //The energy the entity has. When energy is 0, it can no longer move. Out of 100.
  private boolean isOutOfEnergy; //simpler flag to check if an entity has no more energy: The "end of it's life cycle".
  private float size;//Diameter of each entity. #0.1 - 5
  private int foodConsumed; //The amount of food consumed on any particular trip. Shouldn't ever exceed 2.
  private int foodRequired=2;//Food required to BREED/REPRODUCE on average. Will vary for "hungry" entities.
  private int foodToSurvive=1;//Keeps track of the amount of food needed to survive this cycle. 1 by default for non-hungry entities.
  
  //#Fields: Trait values/Modifiers
  private float speed;
  
  private float turnyness; //How likely the entity is to "turn" before moving again
  
  
  //#Fields: Aesthetics
  private float r;
  private float g;
  private float b;
  
  public Entity(){//Constructor for Generation 0 Entities: Entities with no significant traits whatsoever.
    r=random(128);//Neutral colouring.
    g=random(128);
    b=random(128);
    energy=100;//Default starting energy is 100.
    this.assignStartingPoint();
    size=10;
    turnyness=0.03;
    speed=1;
    
    
    
  }
  
  public float getSize(){
   return(size); 
  }
  public PVector getPosition(){
   return(position); 
  }
  public void eatFood(){
   this.foodConsumed=this.foodConsumed+1; 
  }
  
  public void assignStartingPoint(){//Assigns an entity a random starting point on one of the map's borders.
    float startPointDecider = random(1);
    if(startPointDecider<.25){//Top side
        this.ypos=regionTop;
        this.xpos=random(regionLeft, regionLeft+regionWidth);
        directionalAngle=(new PVector().fromAngle(radians(90))).normalize();
    }
    else if(startPointDecider<.5){//Left side
        this.xpos=regionLeft;
        this.ypos=random(regionTop, regionTop+regionHeight);
        directionalAngle=(new PVector().fromAngle(radians(0))).normalize();
    }
    else if(startPointDecider<.75){//Bottom side
        this.ypos=regionTop+regionHeight;
        this.xpos=random(regionLeft, regionLeft+regionWidth);
        directionalAngle=(new PVector().fromAngle(radians(270))).normalize();
    }
    else{//Right side
        this.xpos=regionLeft+regionWidth;
        this.ypos=random(regionTop, regionTop+regionHeight);
        directionalAngle=(new PVector().fromAngle(radians(180))).normalize();
    }
    position=new PVector(this.xpos, this.ypos);
    this.foodConsumed=0;
    
    
  }
  
  
  
  
  public void step(){//Where the thing actually "walks".
    if(this.energy<=0){return;}
  PVector movement=directionalAngle;
  movement.mult(9999);//Multiplies the direction vector by a ludicrous amount in one direction.
  movement.limit(defaultMoveSpeed*speed);//How far the entity ACTUALLY moves. Effectively "cuts off" everything after this distance.
  position.add(movement);
  float energyUsage=defaultEnergyUsage;
  this.energy=this.energy-energyUsage;
  if(turnyness>random(1)&&foodConsumed<foodRequired){//If it passes a "turning check", and hasn't found it's prerequisite amount of food, then it'll change direction
    directionalAngle = new PVector().fromAngle(radians(random(0,360))).normalize();//Gives it a random angle
  }
  
  if(foodConsumed>=foodRequired){//The "go-home" logic: If an entity has enough food, then it will head back towards one of the edges. ==THE CLOSEST EDGE==
  String returnHomeDirection = "up";//Tracks which is the shortest "way home". Defaults to upward.
  float distTracker=position.dist(new PVector(position.x, regionTop));//Distance between entity and the top of the map. Rest should be self-explanatory.
  if(distTracker>position.dist(new PVector(position.x, regionTop+regionHeight))){//Is downwards edge closer?
  returnHomeDirection="down";
  distTracker=position.dist(new PVector(position.x, regionTop+regionHeight));
  }
  if(distTracker>position.dist(new PVector(regionLeft, position.y))){//Is leftmost edge closer?
  returnHomeDirection="left";
  distTracker=position.dist(new PVector(regionLeft, position.y));
  }
  if(distTracker>position.dist(new PVector(regionLeft+regionWidth, position.y))){//Is rightmost edge closer?
   returnHomeDirection="right";//No distance tracker: No longer required.
  }
    //At the end of checking WHICH direction to go in: Now go in that direction
    faceCardinalDirection(returnHomeDirection);
  }
  
  
  //====#The following checks to see if an entity is clipping through a boundary. If so, puts it back into place and "bounces" it away.
  //However, if the entity has the required amount of food, it's energy will drop immediately to 0. Also known as "going home.
    if(position.y<regionTop){//If an entity clips through the top
      faceCardinalDirection("down");//Face down
      position.y=regionTop;
      stopIfFull();
    }
    else if(position.y>regionTop+regionHeight){//If an entity clips through the bottom
      faceCardinalDirection("up");//Face up
      position.y=regionTop+regionHeight;
      stopIfFull();
    }
    if(position.x<regionLeft){//If an entity clips through the left side
      faceCardinalDirection("right");//Face right
      position.x=regionLeft;
      stopIfFull();
    }
    else if(position.x>regionLeft+regionWidth){//If an entity clips through the right side
      faceCardinalDirection("left");//Face left
      position.x=regionLeft+regionWidth;
      stopIfFull();
    }
  //====End of the "edge bounce" checks.
  
    
  }
  
  public void stopIfFull(){
   if(foodConsumed>=foodRequired){
    this.energy=0; 
   }
  }
  
  public void faceCardinalDirection(String directionToFace){//Tells the entity to face a particular direction. Limited usage.
    if(directionToFace.equals("up")){
    directionalAngle=(new PVector().fromAngle(radians(270))).normalize();//Face up
    }
    else if(directionToFace.equals("down")){
    directionalAngle=(new PVector().fromAngle(radians(90))).normalize();//Face down
    }
    else if(directionToFace.equals("left")){
    directionalAngle=(new PVector().fromAngle(radians(180))).normalize();//Face left
    }
    else if(directionToFace.equals("right")){
    directionalAngle=(new PVector().fromAngle(radians(0))).normalize();//Face right
    }
    else{println("ERROR! INVALID CARDINAL DIRECTION GIVEN TO TURN! GIVEN ANGLE:"+directionToFace); return;}
    
  }
  
  public void render(){//Simple but important - draw the entity!
  fill(r,g,b);
  stroke(1);
    circle(position.x, position.y, size);
    
  }
  
  
}
