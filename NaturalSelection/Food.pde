class Food{
 //#Fields!
 private float xpos;
 private float ypos;
 private PVector position;
 private boolean isEaten; 
 private int size = 5;
  
  public boolean hasBeenEaten(){
    return(isEaten);
  }
  
  public void eat(){
   isEaten=true; 
  }
  
  //Constructor for food! Generates each piece at a random location.
  public Food(){
    this.xpos=random(regionLeft,regionLeft+regionWidth);
    this.ypos=random(regionTop, regionTop+regionHeight);
    this.position=new PVector(xpos, ypos);
  }
  public int getSize(){
   return(size); 
  }
  public PVector getPosition(){
   return(position); 
  }
  
  public void render(){
    if(!isEaten){
      fill(0);
      stroke(0);
      circle(xpos, ypos, size);
    }
  }
  
  
}
