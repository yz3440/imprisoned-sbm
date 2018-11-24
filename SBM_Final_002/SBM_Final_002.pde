import java.awt.Rectangle;
import gab.opencv.*;

PImage human;
int num = 300;
PVector[] bodyPoints;
PVector[] netPoints;
OpenCV opencv;



void setup() {
  size(640, 480);
  setupGui();
  human = loadImage("human.jpg");
  opencv = new OpenCV(this, 640, 480);
  bodyPoints = updateContourPointsArray(human, num);
  netPoints = new PVector[num];
  for (int i = 0; i < num; i++) {
    netPoints[i] = new PVector(random(width), random(height));
  }
}

void draw() {
  background(0);
  PVector average = averagePointInArray(bodyPoints);
  for (int i = 0; i < num; i++) {
    PVector p = bodyPoints[i];
    PVector target = p.copy();
    PVector pLast = bodyPoints[(i-1+num)%num]; 
    PVector pNext = bodyPoints[(i+1+num)%num];
    PVector normal = calculateNormal(p, pLast, pNext);
    PVector fromCenter = PVector.sub(p, average).normalize();
    target.add(normal.mult(random(20, 40)));
    target.add(fromCenter.mult(random(10, 20)));
    netPoints[i].lerp(target, 0.01);


    if (displayNetVertices) {
      stroke(255, 0, 0);
      strokeWeight(5);
      point(netPoints[i].x, netPoints[i].y);
    }
    if (displayNet) {
      stroke(255, 0, 0);
      strokeWeight(2);
      line(netPoints[i].x, netPoints[i].y, netPoints[(i+1+num)%num].x, netPoints[(i+1+num)%num].y);
    }
    if (displayBody) {
      stroke(255);
        strokeWeight(2);
      line(p.x, p.y, pNext.x, pNext.y);
    }
    if (displayBodyVertices) {
      stroke(255);
      strokeWeight(5);
      point(p.x, p.y);
    }
    if (displayBodyToNet) {
      stroke(255);
      strokeWeight(1);
      line(netPoints[i].x, netPoints[i].y, p.x, p.y);
    }
  }
  drawGui();
}