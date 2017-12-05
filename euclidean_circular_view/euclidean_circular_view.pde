/**
 * Euclidean Rhythm Circular Visualizer 
 * Ian Hattwick, December 4, 2017
 * 
 * Processing v2 sketch to create a circular visualization of euclidean rhythms.
 * Utilizes the simplest euclidean rhythm algorithm as explained in the blog post:
 * http://www.computermusicdesign.com/simplest-euclidean-rhythm-algorithm-explained
 */
 
int size = 500;
float scale = 0.9;
int steps = 8; 
int pulses = 3;
int rotate = 1;
int tSize = 40;

//this determines whether the program saves jpgs of image
int PRINT_OUTPUT = 1;

//create an array to store the rhythm
int[] storedRhythm = new int[0];

void setup(){
  size(size,size);
  noStroke();
  background(255);
  fill(0);
  
  //generate a euclidean rhythm and store in storedRhythm
  euclid(steps,pulses,rotate);
  for(int i=0;i<storedRhythm.length;i++) print(storedRhythm[i], " ");
  print();
  
  //create a circular display
  for(int i=0;i<steps;i++){
    if(storedRhythm[i] == 1) fill(200);
    else fill(0);

    arc(width/2,height/2,width*scale,height*scale,
    (float)(i-1)/steps * TWO_PI - HALF_PI, //starting angle
    (float)(i+0)/steps * TWO_PI - (TWO_PI*0.005) - HALF_PI //ending angle
    );
    
    if(storedRhythm[i] == 1) fill(0);
    else fill(255);
    drawLabel(i);
  }
  
  //clear center of circle
  fill(255);
  ellipse(width/2,height/2,width*0.7,height*0.7);
  
  //draw labels for beats
  for(int i=0;i<steps;i++){
    //drawLabel(str(i),i);
  }
  
  //indicate current settings
  drawText("Steps = ", steps,  height/2, width/2 - tSize);
  drawText("Pulses = ", pulses, height/2, width/2);
  drawText("Rotation = ", rotate, height/2, width/2 + tSize);
  
  //save output as jpg
  if(PRINT_OUTPUT==1) {
    String[] imageName = new String[4];
    imageName[0] = "euclid";
    imageName[1] = str(steps);
    imageName[2] = str(pulses);
    imageName[3] = str(rotate);
    
    String imageName2  = join(imageName,"_");

    print(imageName2);
    save(imageName2);
  }
  
}

void draw(){
}

//calculate a euclidean rhythm
void euclid(int steps, int pulses,int rotate){
  print("Create new euclidean rhythm \n");
  print("Steps", steps, "Pulses", pulses, "Rotate", rotate, "\n");
  rotate += 1;
  rotate %= steps;
  clearArray(); //empty the array
  int bucket = 0;
  
  //fill track with rhythm
  for(int i=0;i< steps;i++){
    bucket += pulses;
    if(bucket >= steps) {
      bucket -= steps;
      storedRhythm = append( storedRhythm, 1);
    } else {
      storedRhythm = append( storedRhythm, 0);
    }
   }

  //rotate
  if(rotate > 0) rotateSeq( steps, rotate);
}

//rotate a sequence
void rotateSeq( int steps, int rotate){
  int[] output  = new int[steps];
  int val = steps - rotate;
  for(int i=0;i<storedRhythm.length;i++){
    output[i] = storedRhythm[ Math.abs( (i+val) % storedRhythm.length) ];
  }
  storedRhythm =  output;
}

void clearArray(){
  while(storedRhythm.length > 0) {
    storedRhythm = shorten(storedRhythm);
  }
}

/*
Print a text label for each arc segment
*/
void drawLabel( int num){
  int curNum = num - 1;
  if(curNum < 0) curNum=steps-1;
  String t = str(curNum);
  float x,y;
  float curAngle = ((float)-(num+0)/steps * TWO_PI) + PI + (TWO_PI/steps/2);
  float textScale = 0.89;
  x =  sin(curAngle) * width/2 * textScale  * scale + width/2 ;
  y =  cos(curAngle) * width/2 * textScale  * scale +  width/2 + tSize*0.6/2;
    
  textSize(tSize*0.6);
  textAlign(CENTER);
  text(t, x, y);
}// drawLabel()

//write text indicating current settings
void drawText(String t, int num, int x, int y){
    
  x += tSize/0.5;
  textSize(tSize);
  fill(0);
  textAlign(RIGHT);
  text(t, x, y);
  textAlign(LEFT);
  //x -= tSize/0.5;
  text(str(num), x, y);

}
