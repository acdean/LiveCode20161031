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
  float MAX_DIST = 200;

  Layer() {
    a = random(TWO_PI);
    dx = random(-.02, .02);
    px = random(-MAX_DIST, MAX_DIST);
    py = random(-MAX_DIST, MAX_DIST);
    pz = random(-MAX_DIST, MAX_DIST);
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
      shape.vertex(-SZ, -SZ, 0, -TSZ, -TSZ);
      shape.vertex(-SZ, SZ, 0, -TSZ, TSZ);
      shape.vertex(SZ, SZ, 0, TSZ, TSZ);
      shape.vertex(SZ, -SZ, 0, TSZ, -TSZ);
      shape.endShape();
    }
    pushMatrix();
    translate(cos(a * px), cos(a * py), cos(a* pz));
    shape(shape);
    popMatrix();
  }
}