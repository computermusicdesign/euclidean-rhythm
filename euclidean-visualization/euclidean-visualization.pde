/**
 * Euclidean Rhythm Generator / Demonstration
 * Ian Hattwick, October 23, 2017
 * 
 * Processing sketch to create a visualization of the simplest euclidean rhythm algorithm
 * as explained in the blog post:
 *   http://www.computermusicdesign.com/simplest-euclidean-rhythm-algorithm-explained
 */

//Primary euclidean rhythm parameters.
int STEPS = 8;
int PULSES =3;
int ROTATION = 1; // a rotation of 1 places the first pulse on step 1

//this determines whether the program saves jpgs of each
//step, for assembling into a GIF
int PRINT_OUTPUT = 0;

// parameters to change the way the visualization looks
int tSize = 16; //size of text
int diameter; //diameter of pulses circles

//General global variables
int x, y;
int gridX, gridY; // the spacing between pulse circles and steps
int curStep = 1;
int pulseCounter = PULSES;
int pulseOffset = 0; //used to determine the location of the first beat of pulses

//timing variables for drawing the beats
long timer = 0;
int firstInterval = 200; //the period between running the program and the first beat
int secondInterval = 1000; //the interval between each subsequent beat
int interval = firstInterval;

void setup() {
  size(1000, 320); //canvas size
  background(255);
  
  diameter = height/((STEPS+1) * 2); //diameter of the circles
  //basic grid for where the circles are located
  gridX = width/(STEPS + 4 );
  gridY = (diameter * (STEPS) * 2) + 4;

  //draw steps
  stroke(0);
  pulseOffset = STEPS*2;
  drawPulses(gridX, gridY, STEPS, 255);
  drawLabel( "steps", gridX );
  
  //draw pulses
  stroke(230);
  pulseOffset = 0;
  drawPulses(gridX * 2, gridY, PULSES, 200);
  drawLabel("pulses", gridX * 2);

  //draw boundary line
  stroke(0);
  x = gridX * 10 / 4;
  y = gridY - diameter;
  line(x, y, x, STEPS * 2);
  
  //draw labels for each step
  for(int i=0;i<STEPS;i++){
    y = (diameter * (STEPS) * 2) + diameter ;
    drawLabel(str(i), calcXrotate(gridX,i,1));
  }

  if(PRINT_OUTPUT==1)save("euclid0.jpg");
  stroke(230);
}

void draw() {
  //the timer loop here allows us to see each step drawn one at a time
  if (millis() - timer > interval) {
    timer = millis();
    interval = secondInterval;

    //If we want to 'brute force' a pulse on step 1, we can take the approach used by 11olsen.
    //To implement this, uncomment the following block and set ROTATION to 0.
    //Otherwise, keep  the following block comment and set ROTATION to 1 to put the first pulse
    //on step 1 using regular rotation.
    /*
    //draw step 1
    if (curStep == 100) {
      drawPulses(gridX*3, gridY, STEPS, 100, "1");
      if (PRINT_OUTPUT==1) save("euclid1.jpg");
    } 
    
    //draw subsequent steps
    else  */ //end block comment
    if (curStep <= STEPS) {  //for each step
      //determine rotation of rhythm, and then draw all of the circles for the current step
      drawPulses(calcXrotate(gridX,curStep,ROTATION), gridY, pulseCounter, 200);
      //if number of counted pulses exceeds steps, substract steps and display
      if (pulseCounter >= STEPS) {
        pulseCounter -= STEPS;
        pulseOffset = pulseCounter;
      }
      pulseCounter += PULSES;
      
      //save a jpg of the progress so far
      if (PRINT_OUTPUT==1){
        String jpgName = "euclid";
        String outName = jpgName.concat(str(curStep));
        outName = outName.concat(".jpg");
        save(outName);
      } //print
    } //steps
    curStep++;
  }//end of millis loop
}//void draw

/*
Draw the pulses in the bucket on a single step
*/
void drawPulses(int x, int y, int num, int cFill) {
  int tempY = y;
  
  //we are going to make the first beat of a pulse a darker color, 
  //so that we can identify multiple pulses in the bucket
  //and then draw each pulses
  fill(cFill); 
  for (int i=0; i<num; i++) {
    if( i % PULSES == pulseOffset ) fill(cFill-100); //the first beat
    else fill(cFill); //for every other beat
    //update Y location
    y -= diameter+4;
    //draw the beats
    ellipse(x, y, diameter, diameter);
  } //end basic drawPulses
  
  //here we draw an outline for each circle if a pulse is found
  if(num >= STEPS){
    stroke(0);
    fill(255,255,255,0);
    for (int i=0; i<STEPS; i++) {
      tempY -= diameter+4;
      ellipse(x, tempY, diameter, diameter);
    }
    stroke(255);
  } //draw outline
  
}//drawPulses

/*
Print a text label at a location on the screen
*/
void drawLabel(String t, int x){
  int y = (diameter * (STEPS) * 2) + diameter;
  textSize(tSize);
  textAlign(CENTER);
  fill(0);
  text(t, x, y);
}// drawLabel()

/*
Modify the X location of each step to rotate the rhythm
*/
int calcXrotate(int gridX,int curStep, int curRotate){
  if ( curStep + curRotate > STEPS) curRotate -= STEPS;
  int val = gridX*(curStep+curRotate+2);
  return val;
} //calcXrotate()
