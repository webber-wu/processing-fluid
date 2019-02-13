/***********************************************************************
 
 Demo of the MSAFluid library (www.memo.tv/msafluid_for_processing)
 Move mouse to add dye and forces to the fluid.
 Click mouse to turn off fluid rendering seeing only particles and their paths.
 Demonstrates feeding input into the fluid and reading data back (to update the particles).
 Also demonstrates using Vertex Arrays for particle rendering.
 
/***********************************************************************
 
 Copyright (c) 2008, 2009, Memo Akten, www.memo.tv
 *** The Mega Super Awesome Visuals Company ***
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of MSA Visuals nor the names of its contributors 
 *       may be used to endorse or promote products derived from this software
 *       without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS 
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONpTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE. 
 *
 * ***********************************************************************/

import msafluid.*;
import javax.media.opengl.GL2;
import controlP5.*;

// set controlP5
int count;
//int colorR;
//int colorG;
//int colorB;
int framerate = 60;
int speed;
int pos;
int speed2;
boolean toggleParticle = false;
boolean bottomJet = false;
boolean showTime = true;
boolean showColor = false;

ControlP5 cp5;
Accordion accordion;

// set countdown
PFont font;
int timer;
int t;
String countdown = "10";
int interval;


// set color
int [][] season = new color[5][6];
int seasonNum;
int colorNum;



final float FLUID_WIDTH = 500;
float invWidth, invHeight;    // inverse of screen dimensions
float aspectRatio, aspectRatio2;

MSAFluidSolver2D fluidSolver;

ParticleSystem particleSystem;

PImage imgFluid;

boolean drawFluid = true;



void setup() {
  
  size(8640, 1080, P3D);    // use OPENGL rendering for bilinear filtering on texture
  invWidth = 1.0f/width;
  invHeight = 1.0f/height;
  aspectRatio = width * invHeight;
  aspectRatio2 = aspectRatio * aspectRatio;

  // create fluid and set options
  fluidSolver = new MSAFluidSolver2D((int)(FLUID_WIDTH), (int)(FLUID_WIDTH * height/width));
  fluidSolver.enableRGB(true).setFadeSpeed(0.01).setDeltaT(0.05).setVisc(0.0001);

  // create image to hold fluid picture
  imgFluid = createImage(fluidSolver.getWidth(), fluidSolver.getHeight(), RGB);
  
  // create particle system
  particleSystem = new ParticleSystem();
  
  // start gui
  gui();
  
  // set time
  timer = 90;
  interval = timer;
  
  // set color
  
  int divisor = 10;
  season[0][0] = color(126/divisor, 172/divisor, 2/divisor); // bottom color
  season[0][1] = color(228/divisor,124/divisor,123/divisor);
  season[0][2] = color(246/divisor, 206/divisor, 207/divisor);
  season[0][3] = color(237/divisor, 199/divisor, 189/divisor);
  season[0][4] = color(224/divisor, 242/divisor, 234/divisor);
  season[0][5] = color(147/divisor, 198/divisor, 193/divisor);
  
  season[1][0] = color(221/divisor, 72/divisor, 128/divisor); // bottom color
  season[1][1] = color(221/divisor, 129/divisor, 1/divisor);
  season[1][2] = color(243/divisor, 185/divisor, 60/divisor);
  season[1][3] = color(255/divisor, 236/divisor, 141/divisor);
  season[1][4] = color(126/divisor, 172/divisor, 2/divisor);
  season[1][5] = color(53/divisor, 92/divisor, 1/divisor);
  
  season[2][0] = color(220/divisor, 160/divisor, 85/divisor); // bottom color
  season[2][1] = color(97/divisor, 105/divisor, 115/divisor);
  season[2][2] = color(178/divisor, 173/divisor, 169/divisor);
  season[2][3] = color(230/divisor, 229/divisor, 224/divisor);
  season[2][4] = color(197/divisor, 209/divisor, 221/divisor);
  season[2][5] = color(164/divisor, 188/divisor, 212/divisor);
  
  season[3][0] = color(255/divisor, 255/divisor, 255/divisor); // bottom color
  season[3][1] = color(244/divisor, 235/divisor, 230/divisor);
  season[3][2] = color(192/divisor, 131/divisor, 87/divisor);
  season[3][3] = color(157/divisor, 64/divisor, 32/divisor);
  season[3][4] = color(86/divisor, 22/divisor, 9/divisor);
  season[3][5] = color(42/divisor, 2/divisor, 2/divisor);
  
  season[4][0] = color(0,0,0); // bottom color
  
}

void gui() {
  
  int left = 20;
  
  cp5 = new ControlP5(this);
  // group 1, top jet
  
  Group g1 = cp5.addGroup("MyGroup1")
                .setBackgroundColor(color(0,0,125,75))
                .setWidth(200)
                .setLabel("TOP")
                .setBackgroundHeight(160);
  
//  cp5.addSlider("count")
//     .setPosition(left, 20)
//     .setSize(100, 30)
//     .setRange(1, 10)
//     .setValue(1)
//     .moveTo(g1);
  cp5.addSlider("speed")
     .setPosition(left, 20)
     .setSize(100, 30)
     .setRange(1,10)
     .setValue(5)
     .moveTo(g1);
  cp5.addSlider("seasonNum")
     .setPosition(left, 60)
     .setLabel("season")
     .setSize(100, 30)
     .setRange(1,4)
     .setValue(0)
     .moveTo(g1);
  cp5.addSlider("colorNum")
     .setPosition(left, 100)
     .setLabel("color wheel")
     .setSize(100, 30)
     .setRange(1,5)
     .setValue(0)
     .moveTo(g1);
//  cp5.addSlider("colorR")
//     .setPosition(left, 100)
//     .setSize(100, 30)
//     .setRange(0, 255)
//     .setValue(255)
//     .moveTo(g1);
//  cp5.addSlider("colorG")
//     .setPosition(left, 140)
//     .setSize(100, 30)
//     .setRange(0, 255)
//     .setValue(0)
//     .moveTo(g1);
//  cp5.addSlider("colorB")
//     .setPosition(left, 180)
//     .setSize(100, 30)
//     .setRange(0, 255)
//     .setValue(0)
//     .moveTo(g1);
//  cp5.addToggle("toggleParticle")
//     .setPosition(20,140)
//     .setSize(30,30)
//     .moveTo(g1);
     
  Group g2 = cp5.addGroup("MyGroup2")
                .setBackgroundColor(color(0,0,125,75))
                .setWidth(200)
                .setLabel("Bottom")
                .setBackgroundHeight(120);
                
  cp5.addSlider("speed2")
     .setPosition(20, 20)
     .setSize(100, 30)
     .setRange(1,10)
     .setValue(5)
     .setLabel("speed")
     .moveTo(g2);
  cp5.addToggle("bottomJet")
     .setPosition(20,60)
     .setSize(30,30)
     .setLabel("open")
     .moveTo(g2);
  cp5.addToggle("showColor")
     .setPosition(60,60)
     .setSize(30,30)
     .setLabel("show color")
     .moveTo(g2);
     
//  Group g3 = cp5.addGroup("MyGroup3")
//                .setBackgroundColor(color(0,0,125,75))
//                .setWidth(200)
//                .setLabel("Timer")
//                .setBackgroundHeight(120);
//
//  cp5.addSlider("timer")
//     .setPosition(20, 20)
//     .setSize(100, 30)
//     .setRange(1, 90)
//     .setValue(90)
//     .setLabel("Timer(s)")
//     .moveTo(g3);
//  cp5.addToggle("showTime")
//     .setPosition(20, 60)
//     .setSize(30,30)
//     .moveTo(g3);

//  Group g4 = cp5.addGroup("MyGroup4")
//                .setBackgroundColor(color(0,0,125,75))
//                .setWidth(200)
//                .setLabel("others")
//                .setBackgroundHeight(100);
                
//  cp5.addSlider("framerate")
//     .setPosition(20, 20)
//     .setSize(100, 30)
//     .setRange(60, 120)
//     .setValue(60)
//     .moveTo(g4);
     
  accordion = cp5.addAccordion("acc")
                 .setPosition(40,40)
                 .setWidth(200)
                 .addItem(g1)
                 .addItem(g2);
//                 .addItem(g3)
//                 .addItem(g4);
  accordion.open(0,1);
  accordion.setCollapseMode(Accordion.MULTI);
}

void draw() {
  
  fluidSolver.update();
  if (drawFluid) {
    
    for (int i=0; i<fluidSolver.getNumCells (); i++) {
      int d = 10;
      imgFluid.pixels[i] = color(fluidSolver.r[i] * d, fluidSolver.g[i] * d, fluidSolver.b[i] * d);
    }
    imgFluid.updatePixels();
    image(imgFluid, 0, 0, width, height);
    
  }
  particleSystem.updateAndDraw();
  
  
  if(bottomJet == true){
//    wind();
    if(frameCount % framerate == 0){ // every 1 sec
      wind();
    }
  }
  
  // set countdown

  countdown = nf(t,1);
  textSize(20);
  if(showTime){
    fill(255,255,255,255);
  } else {
    fill(255,255,255,0);
  }
  text("CountDown:", 50, height - 50);  
  text(countdown, 200, height - 50);
  text("sec",240, height - 50);
  t = interval - int(millis()/1000);
  if( t < 0 ){
    interval += timer;
    if(seasonNum < 4){
      seasonNum += 1;
      cp5.getController("seasonNum").setValue(seasonNum);
    }else{
      seasonNum = 1;
      cp5.getController("seasonNum").setValue(seasonNum);
    }
    println(seasonNum);
  }
}

//void timer(int theTime){
//  timer = theTime;
//  interval = theTime;
//}


//void mouseMoved() {
//  float mouseNormX = mouseX * invWidth;
//  float mouseNormY = mouseY * invHeight;
//  float mouseVelX = (mouseX - pmouseX) * invWidth;
//  float mouseVelY = (mouseY - pmouseY) * invHeight;
//  addForce(mouseNormX, mouseNormY, mouseVelX, mouseVelY, seasonNum - 1, colorNum - 1);
//}


void keyPressed() {
  switch(key) {
  case 'q':
    singleJet(0);
    break;
  case 'w':
    singleJet(1);
    break;
  case 'e':
    singleJet(2);
    break;
  case 'r':
    singleJet(3);
    break;
  case 't':
    singleJet(4);
    break;
  case 'y':
    singleJet(5);
    break;
  case 'u':
    singleJet(6);
    break;
  case 'i':
    singleJet(7);
    break;
  case 'o':
    singleJet(8);
    break;
  case 'p':
    singleJet(9);
    break;
//  case 'c':
//    cp5.hide();
//    break;
//  case 'o':
//    cp5.show();
//    break;
  }
}

void singleJet(int pos){
  float power = speed * 5 + speed * 20;
  int gap = width / 10;
  float mouseNormX = invWidth * (pos * gap + gap/2);
  float mouseVelX = 0;
  int rColor = int(random(1,5));
  for (int j=0; j<power; j++) {
    float mouseNormY = j * invHeight;
    float mouseVelY = (j-5) * invHeight;
    addForce(mouseNormX, mouseNormY, mouseVelX, mouseVelY, seasonNum - 1, rColor);
  }
}

void allJet(){ // 
    float power = speed * 5 + speed * 20;
//    int r = colorR;
//    int g = colorG;
//    int b = colorB;
    int gap = width / 10;
//    float mouseNormX = width / 2 * invWidth;
//    float mouseNormX = invWidth * (count * gap);
//    float mouseVelX = 0;
//    float baseHue = 180 - random(360);
    
//    colorNum = (int) random(5);
    for (int i=0; i<count; i++){
      float mouseNormX = invWidth * (i * gap + gap/2);
      float mouseVelX = 0;
      int rColor = int(random(1,5));
      for (int j=0; j<power; j++) {
        float mouseNormY = j * invHeight;
        float mouseVelY = (j-5) * invHeight;
  //      addForce(mouseNormX, mouseNormY, mouseVelX, mouseVelY, colorNum, baseHue);
  //      addForce(mouseNormX, mouseNormY, mouseVelX, mouseVelY, r, g, b);
        addForce(mouseNormX, mouseNormY, mouseVelX, mouseVelY, seasonNum - 1, rColor);
      }
    }
    
}

void wind(){
    float power = speed2 * 5 * 2;
    int gap = width / 10;
    int sNum;
    if(showColor){
      sNum = seasonNum;
    } else {
      sNum = 5;
    }
    for (int i=0; i<10; i++){
      float mouseNormX = invWidth * (i * gap + gap/2);
      float mouseVelX = 0;
      for (int j=0; j<power; j++) {
        float mouseNormY = height * invHeight;
        float mouseVelY = -(j-0.5) * invHeight;
  //      addForce(mouseNormX, mouseNormY, mouseVelX, mouseVelY, colorNum, baseHue);
        addForce(mouseNormX, mouseNormY, mouseVelX, mouseVelY, sNum - 1, 0);
      }
    }
    
}


// add force and dye to fluid, and create particles
//void addForce(float x, float y, float dx, float dy, int colorNum, float baseHue) {
//void addForce(float x, float y, float dx, float dy, int r, int g, int b) {
void addForce(float x, float y, float dx, float dy, int seasonNum, int colorNum) {  
  float speed = dx * dx  + dy * dy * aspectRatio2;    // balance the x and y components of speed with the screen aspect ratio
  int divisor = 10;
  
//  int[] colors = new color[4];
//  colorMode(RGB, 255,255,255);
//  colors[0] = color(79/4,172/4,21/4);
//  colors[1] = color(252/4,66/4,36/4);
//  colors[2] = color(254/8,161/8,160/8);
//  colors[3] = color(73/4,174/4,253/4);
  
  
  if (speed > 0) {
    if (x<0) x = 0; 
    else if (x>1) x = 1;
    if (y<0) y = 0; 
    else if (y>1) y = 1;
    
    float colorMult = 5;
    float velocityMult = 60.0f;

    int index = fluidSolver.getIndexForNormalizedPosition(x, y);

    color drawColor;

    colorMode(RGB, 255);

    drawColor = season[seasonNum][colorNum];


//    colorMode(HSB, 360, 1, 1);
//    float hue = 180 + baseHue; //((x + y) * 360) % 360;
    //hue += 180 - random(360);
//    println(hue);
//    drawColor = color(hue, 1, 1);


//    colorMode(HSB, 360, 1, 1);
    colorMode(RGB, 1);
    
  
      

    fluidSolver.rOld[index]  += red(drawColor) * colorMult;
    fluidSolver.gOld[index]  += green(drawColor) * colorMult;
    fluidSolver.bOld[index]  += blue(drawColor) * colorMult;

    if(toggleParticle==true) {
      particleSystem.addParticles(x * width, y * height, 5);
    }

    fluidSolver.uOld[index] += dx * velocityMult;
    fluidSolver.vOld[index] += dy * velocityMult;
  }
}

