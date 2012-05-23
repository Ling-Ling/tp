/**
 * oscP5broadcastClient by andreas schlegel
 * an osc broadcast client.
 * an example for broadcast server is located in the oscP5broadcaster exmaple.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;


OscP5 oscP5;

/* a NetAddress contains the ip address and port number of a remote location in the network. */
NetAddress myBroadcastLocation;

int curMillis = 0, prevMillis = 0;
int curTime = 0;

int beatNumber = 0;
PFont f;

String connectedStr = "Not connected.";
String beatStr = "On beat 0.";

void setup() {
  size(1200,700);
  frameRate(60);
  
  /* create a new instance of oscP5. 
   * 12000 is the port number you are listening for incoming osc messages.
   */
  oscP5 = new OscP5(this,12000);
  
  /* create a new NetAddress. a NetAddress is used when sending osc messages
   * with the oscP5.send method.
   */
  
  /* the address of the osc broadcast server */
  myBroadcastLocation = new NetAddress("127.0.0.1",32000);
  f = loadFont("Monaco-40.vlw");
}


void draw() {
  background(0);
  textFont(f, 40);
  fill(255);
  text(connectedStr, 20, 50);
  beatStr = "On beat " + beatNumber + ".";
  text(beatStr, 20, 100);
  
  if (curTime < 60) {
    fill(255);
  } else {
    fill(40);
  }
  ellipse(1120, 80, 110, 110);
  
  curMillis = millis();
  curTime += curMillis - prevMillis;
  prevMillis = curMillis;
}


void mousePressed() {
  /* create a new OscMessage with an address pattern, in this case /test. */
  OscMessage myOscMessage = new OscMessage("/test");
  /* add a value (an integer) to the OscMessage */
  myOscMessage.add(100);
  /* send the OscMessage to a remote location specified in myNetAddress */
  oscP5.send(myOscMessage, myBroadcastLocation);
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
  connectedStr = "Not connected.";
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* get and print the address pattern and the typetag of the received OscMessage */
  /*println("### received an osc message with addrpattern "+theOscMessage.addrPattern()+" and typetag "+theOscMessage.typetag());
  theOscMessage.print();*/
  if (theOscMessage.addrPattern().equals("/beat")) {
    println("received beat");
    beatNumber = theOscMessage.get(0).intValue();
    curTime = 0;
  }
}
