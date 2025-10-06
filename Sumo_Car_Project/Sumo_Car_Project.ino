#include <NewPing.h> // ultrasonic sensor library

#define enA 5 //L298N enable pins
#define enB 6
#define in1 3 //L298N input pins
#define in2 4
#define in3 2
#define in4 7

#define irFrontR 10 //IR Sensor pins
#define irFrontL 11
#define irFrontC 8
#define irBack 9

#define trigpin 12 //ultrasonic sensor pins
#define echopin 13
#define maxdis 500 //ultrasonic max scan distance

NewPing sonar(trigpin,echopin,maxdis); // initiate ultrasonic and assign pins

void setup() {

delay(200);

Serial.begin(9600);

pinMode(in1,OUTPUT); //assign motor pins as output
pinMode(in2,OUTPUT);
pinMode(in3,OUTPUT);
pinMode(in4,OUTPUT);

pinMode(irFrontR,INPUT); // assign sensor pins as input
pinMode(irFrontL,INPUT);
pinMode(irFrontC,INPUT);
pinMode(irBack,INPUT);

pinMode(trigpin,OUTPUT); // trigger pin as output
pinMode(echopin,INPUT); //echopin as input

}

void loop() {

bool irReadingR = digitalRead(irFrontR); //create boolean values based on ir readings
bool irReadingL = digitalRead(irFrontL);
bool irReadingC = digitalRead(irFrontC);
bool irReadingB = digitalRead(irBack);

/*Serial.print("ir front right = ");
Serial.println(irReadingR);
Serial.println(" ");

Serial.print("ir front left = ");
Serial.println(irReadingL);
Serial.println(" ");

Serial.print("ir center = ");
Serial.println(irReadingC);
Serial.println(" ");

Serial.print("ir back = ");
Serial.println(irReadingB);
Serial.println(" ");*/

if (irReadingR == 1 || irReadingL == 1 || irReadingC == 1){ // if line is detected in front
  analogWrite(enA,150); //go back
  digitalWrite(in1,LOW);
  digitalWrite(in2,HIGH);  

  analogWrite(enB,150);
  digitalWrite(in3,LOW);
  digitalWrite(in4,HIGH);
  delay(300);
}
else if (irReadingB == 1){ // if line is detected behind
 analogWrite(enA,255); // go forward
  digitalWrite(in1,HIGH);
  digitalWrite(in2,LOW);

  analogWrite(enB,255);
  digitalWrite(in3,HIGH);          
  digitalWrite(in4,LOW);
  delay(300);
}
else{
  if(sonar.ping_cm() < 35 && irReadingR == 0 && irReadingL == 0 && irReadingC == 0 ){ // if an object is detected and line is not detected
  Serial.print("reading = ");
  Serial.println(sonar.ping_cm());

  analogWrite(enA,255); //attack
  digitalWrite(in1,HIGH);
  digitalWrite(in2,LOW);  

  analogWrite(enB,255);
  digitalWrite(in3,HIGH);
  digitalWrite(in4,LOW);
}

else{ // if no line or object is detected

  analogWrite(enA,150); // rotate to scan
  digitalWrite(in1,LOW);
  digitalWrite(in2,HIGH);

  analogWrite(enB,150);
  digitalWrite(in3,HIGH);          
  digitalWrite(in4,LOW);
  delay(550);

  analogWrite(enA,200); 
  digitalWrite(in1,HIGH);
  digitalWrite(in2,LOW);

  analogWrite(enB,150);
  digitalWrite(in3,LOW);          
  digitalWrite(in4,HIGH);
  delay(550);
    }
}
}
