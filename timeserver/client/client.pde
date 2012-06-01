/**
 * oscP5broadcastClient by andreas schlegel
 * an osc broadcast client.
 * an example for broadcast server is located in the oscP5broadcaster exmaple.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;

static String[] args;

OscP5 oscP5;

/* a NetAddress contains the ip address and port number of a remote location in the network. */
NetAddress myBroadcastLocation;

int curMillis = 0, prevMillis = 0;
int curTime = 0;

int beatNumber = 0;
int beatLengthMillis = 0;
PFont f;

String connectedStr = "Not connected.";
String beatStr = "On beat 0.";
boolean running = false;

int scrollSpeed = 180; // in pixels per second
int hitX = 180;
int opticalIllusionCorrection = 6;

int playerNumber = 9;
int[] notes;

void setup() {
  size(1200,700);
  frameRate(60);
  
  /* create a new instance of oscP5. 
   * 12000 is the port number you are listening for incoming osc messages.
   */
  oscP5 = new OscP5(this,8000);
  
  /* create a new NetAddress. a NetAddress is used when sending osc messages
   * with the oscP5.send method.
   */
  
  /* the address of the osc broadcast server */
  myBroadcastLocation = new NetAddress("224.0.0.1",32000);
  f = loadFont("Monaco-40.vlw");
  
  // open data file
  String[] lines;
  lines = loadStrings("idea03parts.txt");
  String[] args;
  args = loadStrings("args");
  playerNumber = args[0].charAt(0) - 'a' ;
  connectedStr = "Not connected.  Player " + (char)('a'+playerNumber);
  
  String[] notesStr = split(lines[playerNumber], ' ');
  notes = new int[notesStr.length];
  for (int i = 0; i < notesStr.length; i++) {
     notes[i] = int(notesStr[i]);
  }
}


void draw() {
  background(0);
  textFont(f, 40);
  noStroke();
  fill(255);
  text(connectedStr, 20, 50);
  
  if (curTime < 40 && running) {
    fill(255);
  } else {
    fill(40);
  }
  ellipse(1120, 80, 110, 110);
  
  if (running) {
    beatStr = "On beat " + beatNumber + ".";
    fill(255);
    text(beatStr, 20, 100);
    
    for (int x = (int) (hitX - (scrollSpeed * curTime / 1000.0)
                             - 5 * (scrollSpeed * beatLengthMillis / 1000.0))
                             + opticalIllusionCorrection; 
          x < 1300; 
          x += scrollSpeed * beatLengthMillis / 1000.0) {
      drawTick(x);
    }
    drawHitCircle(curTime < 40);
    drawNotes(curTime);
    
    curMillis = millis();
    curTime += curMillis - prevMillis;
    prevMillis = curMillis;
  }
}

void drawTick(int x) {
  stroke(100);
  strokeCap(SQUARE);
  strokeWeight(8);
  line(x, 340, x, 460);
}

void drawHitCircle(boolean lightUp) {
  if (lightUp) {
    noFill();
    stroke(200);
    strokeWeight(10);
    ellipse(hitX, 400, 80, 80);
  }
  fill(200);
  noStroke();
  triangle(hitX - 20, 300, hitX + 20, 300, hitX, 330);
  triangle(hitX - 20, 500, hitX + 20, 500, hitX, 470);
}

void drawNotes(int curTime) {
  fill(255);
  noStroke();
  for (int i = 0; i < notes.length; i++) {
    int noteX = (int) ((notes[i] - beatNumber)
      * (scrollSpeed * beatLengthMillis / 1000.0) 
      - (scrollSpeed * curTime / 1000.0) + hitX)
      + opticalIllusionCorrection;
    if (noteX > -200 && noteX < 1400) {
      ellipse(noteX, 400, 55, 55);
    }
  }
}

void stop() {
  disconnect();
}

void keyPressed() {
  switch(key) {
    case('c'):
      /* connect to the broadcaster */
      connect();
      break;
    case('d'):
      /* disconnect from the broadcaster */
      disconnect();
      break;

  }  
}

void connect() {
  OscMessage m;
  m = new OscMessage("/server/connect",new Object[0]);
  oscP5.flush(m,myBroadcastLocation);  
  connectedStr = "Connected.";
}

void disconnect() {
  OscMessage m;
  m = new OscMessage("/server/disconnect",new Object[0]);
  oscP5.flush(m,myBroadcastLocation);  
  connectedStr = "Not connected.  Player " + (char)('a'+playerNumber);
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* get and print the address pattern and the typetag of the received OscMessage */
 /*8 println("### received an osc message with addrpattern "+theOscMessage.addrPattern()+" and typetag "+theOscMessage.typetag());
  theOscMessage.print();*/
  if (theOscMessage.addrPattern().equals("/beat")) {
    println("received beat");
    running = true;
    beatNumber = theOscMessage.get(0).intValue();
    curTime = 0;
  }
  else if (theOscMessage.addrPattern().equals("/duration")) {
    beatLengthMillis = theOscMessage.get(0).intValue();
  }
  
}
