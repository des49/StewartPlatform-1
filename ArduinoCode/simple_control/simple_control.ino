/*  Stewart Platform Simple Control Code
 *  Angles can be commanded over serial connection
 *  
 *  
 *  by Scott Christensen
 * 
 *  last modified 3/31/2016
 * 
 *  Part of the stewart platform project at
 *  http://www.github.com/meowFlute/StewartPlatform
 */
#include <Servo.h>

Servo servo1;
Servo servo2;
Servo servo3; 
Servo servo4;
Servo servo5;
Servo servo6;

char incomingBuffer[24];
float commands[6];

void setup() 
{
  //attach the servos to their respective pwm pins
  servo1.attach(3);
  servo2.attach(5);
  servo3.attach(6);
  servo4.attach(9);
  servo5.attach(10);
  servo6.attach(11);

  Serial.begin(9600);
}

void loop() 
{
  /*
  for(pos = 0; pos <= 180; pos += 1) // goes from 0 degrees to 180 degrees 
  {                                  // in steps of 1 degree 
    moveAllServos(pos);              // tell servo to go to position in variable 'pos' 
    delay(15);                       // waits 15ms for the servo to reach the position 
  } 
  for(pos = 180; pos>=0; pos-=1)     // goes from 180 degrees to 0 degrees 
  {                                
    moveAllServos(pos);              // tell servo to go to position in variable 'pos' 
    delay(15);                       // waits 15ms for the servo to reach the position 
  } 
  */
  if (Serial.available() >= 24) 
  {
    while(Serial.available() > 24)
    {
      char wastedChar = Serial.read();
    }
    // read the incoming byte:
    unsigned int bytesRecieved;
    bytesRecieved = Serial.readBytes(incomingBuffer, 24);
    Serial.print(bytesRecieved);
    Serial.write(" Bytes Recieved: ");
    int i;
    for(i = 0; i<24; i++)
    {
      if(i%4 == 0)
      {
        Serial.print(' ');
        Serial.print("0x");
      }
      Serial.print((byte)incomingBuffer[i], HEX); 
    }
    Serial.print('\n');
  }
}

void moveAllServos(int angle)
{
  servo1.write( angle);
  servo2.write(-angle);
  servo3.write( angle);
  servo4.write(-angle);
  servo5.write( angle);
  servo6.write(-angle);
}

