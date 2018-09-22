/*
Ian Hattwick
October 21, 2017
Euclidean rhythm generator

Generates and stores a euclidean rhythm in the array "storedRhythm"

After Godfried Toussaint's paper:
http://cgm.cs.mcgill.ca/~godfried/publications/banff.pdf
using a variation of 11olsen's implementation:
https://cycling74.com/forums/using-euclideanbjorklund-algorithm-for-rhythm-generation-purely-in-max/

functions:
euclid (steps in sequence, pulses in sequence, number of steps to rotate)
	 - generate a euclidean rhythm and stores in array "storedRhythm"
rotateSeq(array to rotate, length in steps, number of steps to rotate) 
	- returns the input array rotated by the specified number of steps
int() - integer value of current beat, 
	outputs state of current step out left outlet (pulse or no pulse)

output:
0: indicates 1 for pulse at current beat, or 0 for no pulse
1: connect to a matrixcontrol to visualize
*/
autowatch = 1;
inlets = 1;
outlets = 3;

//create an array to store the rhythm
var storedRhythm = new Array(0,0,0,0);

//calculate a euclidean rhythm
function euclid( steps,  pulses, rotate){
	rotate += 1;
	rotate %= steps;
	storedRhythm = []; //empty current track
	var bucket = 0;
	
	//fill track with rhythm
	for(var i=0;i< steps;i++){
		bucket += pulses;
		if(bucket >= steps) {
			bucket -= steps;
			storedRhythm.push(1);
		} else {
			storedRhythm.push(0);
		}
 	}

	//rotate
	if(rotate > 0) storedRhythm = rotateSeq(storedRhythm, steps, rotate);
	
	//send output visualization
	sendOutput(storedRhythm);
}

//rotate a sequence
function rotateSeq(seq2, steps, rotate){
	var output = new Array(steps);
	var val = steps - rotate;
	for(var i=0;i<seq2.length;i++){
		output[i] = seq2[ Math.abs( (i+val) % seq2.length) ];
	}
	return output;
}
	
//send visual display to a matrixControl object
function sendOutput(seqOut){
	outlet(1,"columns", seqOut.length);
	for(var i=0;i<seqOut.length;i++) {
		var output = [i,0,seqOut[i]];
		outlet(1,output);
	}
}

//send triggers
function msg_int(val){
	var curStep = val % storedRhythm.length;
	outlet(0, storedRhythm[curStep]);
	outToLcd(storedRhythm[curStep], curStep);
}

function outToLcd(state, step){
	for(var i=0;i < storedRhythm.length; i++){
		if(storedRhythm[i] > 0) outlet(2, "frgb", 0,0,0);
		else outlet(2, "frgb", 255,255,255);
		outlet(2, "paintrect",i*40,0,i*40+40,40);
	}
	outlet(2, "frgb", 150,150,150);
	outlet(2, "paintoval",step*40+5,5,step*40+35,35);
}

