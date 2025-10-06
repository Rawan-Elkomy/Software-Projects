#include <Wire.h> 
#include <LiquidCrystal_I2C.h>
#include "arduinoFFT.h"

#define SAMPLES 64             
#define SAMPLING_FREQUENCY 1000 

unsigned int sampling_period_us;
unsigned long microseconds;
byte peak[] = {0,0,0,0,0,0,0};

LiquidCrystal_I2C lcd(0x27,16,2);
arduinoFFT FFT = arduinoFFT();
arduinoFFT FFT2 = arduinoFFT(); // For the second channel

double vReal[SAMPLES];
double vImag[SAMPLES];

double vReal2[SAMPLES]; // For the second channel
double vImag2[SAMPLES]; // For the second channel

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

    vReal2[i] = analogRead(A1); // Reading the second channel
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

  FFT2.Windowing(vReal2, SAMPLES, FFT_WIN_TYP_HAMMING, FFT_FORWARD); // Second channel
  FFT2.Compute(vReal2, vImag2, SAMPLES, FFT_FORWARD);
  FFT2.ComplexToMagnitude(vReal2, vImag2, SAMPLES);

  /* Find peak frequency */
  double peakFrequency = FFT.MajorPeak(vReal, SAMPLES, SAMPLING_FREQUENCY);
  double peakFrequency2 = FFT2.MajorPeak(vReal2, SAMPLES, SAMPLING_FREQUENCY); // Second channel

  /* Print out to the LCD screen */
  lcd.setCursor(0, 0);
  lcd.print("Freq1: ");
  lcd.print(peakFrequency);
  lcd.print(" Hz");

  lcd.setCursor(0, 1); // Move to the second line of the LCD
  lcd.print("Freq2: ");
  lcd.print(peakFrequency2);
  lcd.print(" Hz");
}