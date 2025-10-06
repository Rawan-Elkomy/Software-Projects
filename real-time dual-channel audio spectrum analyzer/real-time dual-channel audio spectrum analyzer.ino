#include <Wire.h> 
#include <LiquidCrystal_I2C.h>
#include "arduinoFFT.h"

#define SAMPLES 64             
#define SAMPLING_FREQUENCY 1000 

unsigned int sampling_period_us;
unsigned long microseconds;

LiquidCrystal_I2C lcd(0x27,16,2);
arduinoFFT FFT = arduinoFFT();
arduinoFFT FFT2 = arduinoFFT(); 

double vReal[SAMPLES];
double vImag[SAMPLES];

double vReal2[SAMPLES]; 
double vImag2[SAMPLES]; 

// For display on LCD
int data_avgs[SAMPLES];
int peaks[SAMPLES] = {0};

// Custom characters
byte v[8][8] = {
  {B00000, B00000, B00000, B00000, B00000, B00000, B00000, B11111},
  {B00000, B00000, B00000, B00000, B00000, B00000, B11111, B11111},
  {B00000, B00000, B00000, B00000, B00000, B11111, B11111, B11111},
  {B00000, B00000, B00000, B00000, B11111, B11111, B11111, B11111},
  {B00000, B00000, B00000, B11111, B11111, B11111, B11111, B11111},
  {B00000, B00000, B11111, B11111, B11111, B11111, B11111, B11111},
  {B00000, B11111, B11111, B11111, B11111, B11111, B11111, B11111},
  {B11111, B11111, B11111, B11111, B11111, B11111, B11111, B11111}
};

void setup() {
  lcd.init(); 
  lcd.backlight();
  sampling_period_us = round(1000000*(1.0/SAMPLING_FREQUENCY));

  // Add custom characters
  for (int i = 0; i < 8; i++) {
    lcd.createChar(i, v[i]);
  }
}

void loop() {
  /* Sampling */
  for(int i=0; i<SAMPLES; i++) {
    microseconds = micros();
    vReal[i] = analogRead(A0);
    vImag[i] = 0;

    vReal2[i] = analogRead(A1); 
    vImag2[i] = 0;

    //Wait until sampling period ends
    while(micros() < (microseconds + sampling_period_us)){
      // do nothing to wait out the sample period
    }
  }

  /* FFT */
  FFT.Windowing(vReal, SAMPLES, FFT_WIN_TYP_HAMMING, FFT_FORWARD);
  FFT.Compute(vReal, vImag, SAMPLES, FFT_FORWARD);
  FFT.ComplexToMagnitude(vReal, vImag, SAMPLES);

  FFT2.Windowing(vReal2, SAMPLES, FFT_WIN_TYP_HAMMING, FFT_FORWARD); 
  FFT2.Compute(vReal2, vImag2, SAMPLES, FFT_FORWARD);
  FFT2.ComplexToMagnitude(vReal2, vImag2, SAMPLES);

  // Find peak frequency in first half of data for each channel
  for (int i = 0; i < SAMPLES / 2; i++) {
    // scale from 0 to 8 for LCD display
    data_avgs[i] = constrain((int)vReal[i]/32, 0, 7);
    if (data_avgs[i] > peaks[i]) {
      peaks[i] = data_avgs[i];
    }
    data_avgs[i + SAMPLES / 2] = constrain((int)vReal2[i]/32, 0, 7);
    if (data_avgs[i + SAMPLES / 2] > peaks[i + SAMPLES / 2]) {
      peaks[i + SAMPLES / 2] = data_avgs[i + SAMPLES / 2];
    }
  }
  
  displayOnLCD();
  decay();
}

void displayOnLCD() {
  lcd.setCursor(0, 0);
  lcd.print("L"); 
  lcd.setCursor(0, 1);
  lcd.print("R"); 

  for (int x = 1; x < 16; x++) {
    int y = x + 16;
    lcd.setCursor(x, 0);
    if (peaks[x] == 0) {
      lcd.print("_");
    }
    else {
      lcd.write(peaks[x]);
    }
    lcd.setCursor(x, 1);
    if (peaks[y] == 0) {
      lcd.print("_");
    }
    else {
      lcd.write(peaks[y]);
    }
  }
}

void decay() {
  for (int i = 0; i < SAMPLES; i++) {
    if(peaks[i] > 0)
      peaks[i]--;
  }
}