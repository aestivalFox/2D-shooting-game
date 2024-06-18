int joystick_x=A0;
int joystick_y=A1;
int joystick_sw=8;
int button=7;
int x_value,y_value,sw_value;
void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  pinMode(joystick_x,INPUT);
  pinMode(joystick_y,INPUT);
  pinMode(joystick_sw,INPUT_PULLUP);
  pinMode(button,INPUT);

}
int a=0b00000111;

void loop() {
  // put your main code here, to run repeatedly:
  x_value=analogRead(joystick_x);
  y_value=analogRead(joystick_y);
  sw_value=digitalRead(joystick_sw);

  if(x_value>300&&x_value<700&&y_value>300&&y_value<700){
    //Serial.println(0);
    a=0;
  }
  if(x_value>700&&y_value>300&&y_value<700){
    //Serial.println(1);
    a&=0b10000;
    a|=0b00001;
  }
  if(x_value>700&&y_value>700){
    //Serial.println(2);
    a&=0b10000;
    a|=0b00011;
  }
  if(x_value>300&&x_value<700&&y_value>700){
    //Serial.println(3);
    a&=0b10000;
    a|=0b00010;
  }
  if(x_value<300&&y_value>700){
    //Serial.println(4);
    a&=0b10000;
    a|=0b00110;
  }
  if(x_value<300&&y_value>300&&y_value<700){
    //Serial.println(5);
    a&=0b10000;
    a|=0b00100;
  }
  if(x_value<300&&y_value<300){
    //Serial.println(6);
    a&=0b10000;
    a|=0b01100;
  }
  if(x_value>300&&x_value<700&&y_value<300){
    //Serial.println(7);
    a&=0b10000;
    a|=0b01000;
  }
  if(x_value>700&&y_value<300){
    //Serial.println(8);
    a&=0b10000;
    a|=0b01001;
  }
  if(digitalRead(button)==HIGH){
    //Serial.println("HIGH");
    a&=0b01111;
    a|=0b10000;
  }
  else{
    a&=0b01111;
  }
  
  

  //Serial.println(a,BIN);
  Serial.write(a);
  //Serial.println(x_value,DEC);
  //Serial.println(y_value,DEC);
  //Serial.println(digitalRead(joystick_sw));
  delay(50);
}
