import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;
import peasy.test.*;

PeasyCam cam;
PImage[] img = new PImage[2];
Layer layer0, layer1, layer2;

void setup() {
  size(640, 480, OPENGL);
  cam = new PeasyCam(this, 400);
  img[0] = loadImage("pumpkin.png");
  img[1] = loadImage("skull.png");
  layer0 = new Layer();
  layer1 = new Layer();
  layer2 = new Layer();
}

void draw() {
  background(0);
  layer0.draw();
  layer1.draw();
  layer2.draw();
}

class Layer {
  float a, px, py, pz, dx, dy, dz;
  PShape shape;
  int imgIndex;
  float MAX_PERIOD = 3;
  float RAD = 300;

  Layer() {
    a = random(TWO_PI);
    dx = random(-.02, .02);
    px = random(-MAX_PERIOD, MAX_PERIOD);
    py = random(-MAX_PERIOD, MAX_PERIOD);
    pz = random(-MAX_PERIOD, MAX_PERIOD);
    imgIndex = (int)random(img.length);
  }

  float SZ = 200;
  float TSZ = 10;
  void draw() {
    a += dx;
    if (shape == null) {
      shape = createShape();
      shape.beginShape(QUAD);
      shape.textureMode(NORMAL);
      shape.texture(img[imgIndex]);
      for (int y = -SZ; y < SZ; y += SZ / 20) {
        for (int x = -SZ; x < SZ; y += SZ / 20) {
          shape.vertex(x, y, 0, 0, 0);
          shape.vertex(x, y + SZ / 20, 0, 0, 1);
          shape.vertex(x + SZ / 20, y + SZ / 20, 0, 1, 1);
          shape.vertex(x + SZ / 20, y, 0, 1, 0);
        }
      }
      shape.endShape();
    }
    pushMatrix();
    translate(RAD * cos(a * px), RAD * cos(a * py), RAD * cos(a* pz));
    shape(shape);
    popMatrix();
  }
}