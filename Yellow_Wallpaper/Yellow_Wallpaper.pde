import shiffman.box2d.*;
import processing.pdf.*;
import processing.video.*;

String inputText = " ";
float fontSizeMax = 24;
float fontSizeMin = 10;
float spacing = 12; // line height
float kerning = 0.5; // between letters
int camX;
int camY;
float r = 255, g = 255, b = 255, alpha = 255;
float rDec = 2, gDec = 2, bDec = 4, aDec = 1.5;
color c;

boolean fontSizeStatic = false;
boolean blackAndWhite = false;
boolean endPhase = false;

PFont font;
PImage img;
Capture cam;

void setup() {
  //size(1000,800);
  fullScreen();
  smooth(); 
  colorMode(RGB, 255);
  
  String[] lines = loadStrings("text.txt");
  inputText = String.join(" ", lines);
  font = createFont("Times", 10);
  cam = new Capture(this, 160, 120);
  img = loadImage("pic.png");
  
  cam.start();
  println(img.width+" x "+img.height);
  
}

void draw() {
  //background(255);
  background(r, g, b);
  println(r + " " + g + " " + b + " " + alpha);
  
  //decrement colors
  r -= rDec;
  g -= gDec;
  b -= bDec;
  
  textAlign(LEFT);
  //textAlign(LEFT,CENTER); //// also nice!

  float x = 0, y = 10;
  int counter = 0;

  //loops over something
  while (y < height) {
    // translate position (display) to position (image)
    camX = (int) map(x, 0, width, 0, cam.width);
    camY = (int) map(y, 0, height, 0, cam.height);
    // get current color 
    color oldColor = cam.pixels[camY*cam.width+camX];
    float red = oldColor >> 16 & 0xFF;
    float green = oldColor >> 8 & 0xFF;
    float blue = oldColor & 0xFF;
    c = color(red, green, blue, alpha);
    
    int greyscale = round(red(c)*0.222 + green(c)*0.707 + blue(c)*0.071);

    pushMatrix();
    translate(x, y);

    if (fontSizeStatic) {
      textFont(font, fontSizeMax);
      if (blackAndWhite) fill(greyscale);
      else fill(c);
    } 
    else {
      // greyscale to fontsize
      float fontSize = map(greyscale, 0,255, fontSizeMax,fontSizeMin);
      fontSize = max(fontSize, 1);
      textFont(font, fontSize);
      if (blackAndWhite) fill(0);
      else fill(c);
    } 

    char letter = inputText.charAt(counter);
    text(letter, 0, 0);
    float letterWidth = textWidth(letter) + kerning;
    // for the next letter ... x + letter width
    x = x + letterWidth; // update x-coordinate
    popMatrix();

    // linebreaks
    if (x+letterWidth >= width) {
      x = 0;
      y = y + spacing; // add line height
    }

    counter++;
    if (counter > inputText.length()-1) counter = 0;
  }
  alpha -= aDec;
}


void keyReleased() {
  // change render mode
  if (key == '1') fontSizeStatic = !fontSizeStatic;
  // change color stlye
  if (key == '2') blackAndWhite = !blackAndWhite;
  println("fontSizeMin: "+fontSizeMin+"  fontSizeMax: "+fontSizeMax+"   fontSizeStatic: "+fontSizeStatic+"   blackAndWhite: "+blackAndWhite);
}

void captureEvent(Capture c) {
  c.read();
}

void keyPressed() {
  // change fontSizeMax with arrowkeys up/down 
  if (keyCode == UP) fontSizeMax += 2;
  if (keyCode == DOWN) fontSizeMax -= 2; 
  // change fontSizeMin with arrowkeys left/right
  if (keyCode == RIGHT) fontSizeMin += 2;
  if (keyCode == LEFT) fontSizeMin -= 2; 

  //fontSizeMin = max(fontSizeMin, 2);
  //fontSizeMax = max(fontSizeMax, 2);
}
