// 20161031 Halloween Layers
// acd

import peasy.*;
import com.jogamp.opengl.*;  // new jogl - 3.0b7

PeasyCam cam;
PImage[] img = new PImage[3];
Layer layer0, layer1, layer2;
boolean video = false;

void setup() {
  size(640, 360, OPENGL);
  cam = new PeasyCam(this, 100);
  img[0] = loadImage("pumpkin.png");
  img[1] = loadImage("skull.png");
  img[2] = loadImage("ghost.png");
  colorMode(HSB, 360, 100, 100);
  layer0 = new Layer();
  layer1 = new Layer();
  layer2 = new Layer();
}

void draw() {
  background(0);
  // PJOGL 2.2.1, 30b7
  GL gl = ((PJOGL)beginPGL()).gl.getGL();

  // additive blending
  gl.glEnable(GL.GL_BLEND);
  gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE);
  gl.glDisable(GL.GL_DEPTH_TEST);
  layer0.draw();
  layer1.draw();
  layer2.draw();
  
  if (video) {
    saveFrame("frame#####.png");
    if (frameCount > 500) {
      exit();
    }
  }
}

class Layer {
  float a, px, py, pz, dx, dy, dz;
  PShape shape;
  int imgIndex;
  float MAX_PERIOD = 2;
  float RAD = 30;
  color colour;

  Layer() {
    a = random(TWO_PI); // angle
    dx = random(-.02, .02); // change of angle
    px = random(-MAX_PERIOD, MAX_PERIOD);
    py = random(-MAX_PERIOD, MAX_PERIOD);
    pz = random(-MAX_PERIOD, MAX_PERIOD);
    imgIndex = (int)random(img.length);
    colour = color((int)random(360), 100, 100);
  }

  int TSZ = 40;
  int SZ = TSZ * 10;
  void draw() {
    a += dx;
    if (shape == null) {
      // just a plane of textures
      shape = createShape();
      shape.beginShape(QUAD);
      shape.textureMode(NORMAL);
      shape.texture(img[imgIndex]);
      shape.tint(colour);
      for (int y = -SZ; y < SZ; y += TSZ) {
        for (int x = -SZ; x < SZ; x += TSZ) {
          shape.vertex(x, y, 0, 0, 0);
          shape.vertex(x, y + TSZ, 0, 0, 1);
          shape.vertex(x + TSZ, y + TSZ, 0, 1, 1);
          shape.vertex(x + TSZ, y, 0, 1, 0);
        }
      }
      shape.endShape();
    }
    pushMatrix();
    // lissajous
    translate(RAD * cos(a * px), RAD * cos(a * py), RAD * .5 * cos(a* pz));
    shape(shape);
    popMatrix();
  }
}

void keyPressed() {
  if (key == 's') {
    saveFrame("frame####.png");
  }
}