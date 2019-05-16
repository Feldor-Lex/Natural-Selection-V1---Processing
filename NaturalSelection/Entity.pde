class Entity{
  //#Fields go here!
  
  //#Fields: Positional/Movement
  private float ypos;
  private float xpos;
  private PVector position;
  private float defaultMoveSpeed = 2;//The typical "movement speed" for each entity, NOT the varying speed that comes into play later on.
  
  private PVector directionalAngle; //The angle the entity is moving in. A vector with a length of 1.
  private float energy; //The energy the entity has. When energy is 0, it can no longer move. Out of 100.
  private boolean isOutOfEnergy; //simpler flag to check if an entity has no more energy: The "end of it's life cycle".
  private float size;//Radius of each entity. #0.1 - 5
  private int foodConsumed; //The amount of food consumed on any particular trip. Shouldn't ever exceed 2.
  
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
    energy=100;//Default starting energy.
    this.assignStartingPoint();
    size=10;
    turnyness=0.03;
    speed=1;
    
    
    
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
    
    
    
  }
  
  
  
  
  public void step(){//Where the thing actually "walks".
  PVector movement=directionalAngle;
  movement.mult(9999);//Multiplies the direction vector by a ludicrous amount in one direction.
  movement.limit(defaultMoveSpeed*speed);//How far the entity ACTUALLY moves. Effectively "cuts off" everything after this distance.
  position.add(movement);
  if(turnyness>random(1)){//If it passes a "turning check", then it'll change direction
    directionalAngle = new PVector().fromAngle(radians(random(0,360))).normalize();//Gives it a random angle
  }
  //#The following checks to see if an entity is clipping through a boundary. If so, puts it back into place and "bounces" it away.
    if(position.y<regionTop){//If an entity clips through the top
      directionalAngle=(new PVector().fromAngle(radians(90))).normalize();
      position.y=regionTop;
    }
    else if(position.y>regionTop+regionHeight){//If an entity clips through the bottom
      directionalAngle=(new PVector().fromAngle(radians(270))).normalize();
      position.y=regionTop+regionHeight;
    }
    if(position.x<regionLeft){//If an entity clips through the left side
      directionalAngle=(new PVector().fromAngle(radians(0))).normalize();
      position.x=regionLeft;
    }
    else if(position.x>regionLeft+regionWidth){//If an entity clips through the right side
      directionalAngle=(new PVector().fromAngle(radians(180))).normalize();
      position.x=regionLeft+regionWidth;
    }
  
  
    
  }
  
  public void render(){//Simple but important - draw the entity!
  fill(r,g,b);
  stroke(1);
    circle(position.x, position.y, size);
    
  }
  
  
}
