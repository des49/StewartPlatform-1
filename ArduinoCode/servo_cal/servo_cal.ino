#include <Servo.h>

Servo servo1;
Servo servo2;
Servo servo3; 
Servo servo4;
Servo servo5;
Servo servo6;
float angles[6];

void setup() {
  // put your setup code here, to run once:
  servo1.attach(3);
  servo2.attach(5);
  servo3.attach(6);
  servo4.attach(9);
  servo5.attach(10);
  servo6.attach(11);

  int i;
  for(i = 0; i < 6; i++)
  {
    angles[i] = 45*PI/180;
  }
  moveAllServos();
}

void loop() {
  // put your main code here, to run repeatedly:

}

void moveAllServos()
{
  servo1.write((-angles[0]*180/PI)+85);
  servo2.write((angles[1]*180/PI)+75);
  servo3.write((-angles[2]*180/PI)+100);
  servo4.write((angles[3]*180/PI)+90);
  servo5.write((-angles[4]*180/PI)+85);
  servo6.write((angles[5]*180/PI)+90);
}
