import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;
import peasy.test.*;
import com.jogamp.opengl.*;  // new jogl - 3.0b7

PeasyCam cam;
PImage[] img = new PImage[2];
Layer layer0, layer1, layer2;

void setup() {
  size(640, 480, OPENGL);
  cam = new PeasyCam(this, 100);
  img[0] = loadImage("pumpkin.png");
  img[1] = loadImage("skull.png");
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
}

class Layer {
  float a, px, py, pz, dx, dy, dz;
  PShape shape;
  int imgIndex;
  float MAX_PERIOD = 2;
  float RAD = 30;
  int colour;

  Layer() {
    a = random(TWO_PI);
    dx = random(-.02, .02);
    px = random(-MAX_PERIOD, MAX_PERIOD);
    py = random(-MAX_PERIOD, MAX_PERIOD);
    pz = random(-MAX_PERIOD, MAX_PERIOD);
    imgIndex = (int)random(img.length);
    colour = color((int)random(64, 192), (int)random(64, 192), (int)random(64, 192));
  }

  int SZ = 100;
  float TSZ = 10;
  void draw() {
    a += dx;
    if (shape == null) {
      shape = createShape();
      shape.beginShape(QUAD);
      shape.textureMode(NORMAL);
      shape.texture(img[imgIndex]);
      shape.tint(colour);
      for (int y = -SZ; y < SZ; y += 20) {
        for (int x = -SZ; x < SZ; x += 20) {
          shape.vertex(x, y, 0, 0, 0);
          shape.vertex(x, y + 20, 0, 0, 1);
          shape.vertex(x + 20, y + 20, 0, 1, 1);
          shape.vertex(x + 20, y, 0, 1, 0);
        }
      }
      shape.endShape();
    }
    pushMatrix();
    translate(RAD * cos(a * px), RAD * cos(a * py), RAD * .5 * cos(a* pz));
    shape(shape);
    popMatrix();
  }
}