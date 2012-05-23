/**
 * oscP5broadcaster by andreas schlegel
 * an osc broadcast server.
 * osc clients can connect to the server by sending a connect and
 * disconnect osc message as defined below to the server.
 * incoming messages at the server will then be broadcasted to
 * all connected clients. 
 * an example for a client is located in the oscP5broadcastClient exmaple.
 * oscP5 website at http://www.sojamo.de/oscP5
 */
 
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddressList myNetAddressList = new NetAddressList();
/* listeningPort is the port the server is listening for incoming messages */
int myListeningPort = 32000;
/* the broadcast port is the port the clients should listen for incoming messages from the server*/
int myBroadcastPort = 12000;

String myConnectPattern = "/server/connect";
String myDisconnectPattern = "/server/disconnect";
  
PFont f;  
String numClientsStr = "No clients connected.";

String beatStr = "Not counting/sending beats.";
int beatNumber = 0;
boolean runningBeats = false;

int beatLengthMillis = 1500;
int curMillis, prevMillis = 0;
int curTime = 0;

void setup() {
  size(1200, 700);
  oscP5 = new OscP5(this, myListeningPort);
  frameRate(60);
  f = loadFont("Monaco-40.vlw");
}

void draw() {
  background(0);
  textFont(f, 40);
  fill(255);
  text(numClientsStr, 20, 50);
    
  if (beatNumber > 0) {
    beatStr = "On beat " + beatNumber + ".";
  }
  text(beatStr, 20, 100);
  
  if (curTime < 60) {
    fill(255);
  } else {
    fill(40);
  }
  ellipse(1120, 80, 110, 110);
  
  curMillis = millis();
  curTime += curMillis - prevMillis;
  if (curTime > beatLengthMillis) {
    // beat
    if (runningBeats) {
      beatNumber++;
    }
    OscMessage beatMessage = new OscMessage("/beat");
    beatMessage.add(beatNumber);
    beatMessage.add(beatLengthMillis);
    oscP5.send(beatMessage, myNetAddressList);
    curTime -= beatLengthMillis;
  }
  prevMillis = curMillis;
}

void keyPressed() {
  if (key == 'r') {
    runningBeats = true;
  }
}

void oscEvent(OscMessage theOscMessage) {
  /* check if the address pattern fits any of our patterns */
  if (theOscMessage.addrPattern().equals(myConnectPattern)) {
    connect(theOscMessage.netAddress().address());
  }
  else if (theOscMessage.addrPattern().equals(myDisconnectPattern)) {
    disconnect(theOscMessage.netAddress().address());
  }
  /**
   * if pattern matching was not successful, then broadcast the incoming
   * message to all addresses in the netAddresList. 
   */
  else {
    oscP5.send(theOscMessage, myNetAddressList);
  }
}


 private void connect(String theIPaddress) {
  if (!myNetAddressList.contains(theIPaddress, myBroadcastPort)) {
    myNetAddressList.add(new NetAddress(theIPaddress, myBroadcastPort));
    println("### adding "+theIPaddress+" to the list.");
  } else {
    println("### "+theIPaddress+" is already connected.");
  }
  println("### currently there are "+myNetAddressList.list().size()+" remote locations connected.");
  numClientsStr = myNetAddressList.list().size() + " clients connected.";
 }



private void disconnect(String theIPaddress) {
  if (myNetAddressList.contains(theIPaddress, myBroadcastPort)) {
    myNetAddressList.remove(theIPaddress, myBroadcastPort);
    println("### removing "+theIPaddress+" from the list.");
  } else {
    println("### "+theIPaddress+" is not connected.");
  }
  println("### currently there are "+myNetAddressList.list().size());
  if (myNetAddressList.list().size() == 0) {
    numClientsStr = "No clients connected.";
  } else {
    numClientsStr = myNetAddressList.list().size() + " client(s) connected.";
  }
}
