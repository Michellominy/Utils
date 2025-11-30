const int REED_PIN = A3; 
const int BUZZER_PIN = 3; // D3 
bool isClosed = true;
unsigned long delayStart = 0;

void setup() {
  pinMode(REED_PIN, INPUT_PULLUP);
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(BUZZER_PIN, OUTPUT);
  delayStart = millis();   
}

void loop() {
  int proximity = digitalRead(REED_PIN);
  if (proximity == LOW) {
      Serial.println("Switch close, Nothing to do...");
      delayStart = millis();
      digitalWrite(LED_BUILTIN, LOW);
      noTone(BUZZER_PIN);
    }
    // If open for 1min
    if((millis() - delayStart) >= 60000) {
      Serial.println("Switch open");
      tone(BUZZER_PIN, 1000);
      digitalWrite(LED_BUILTIN, HIGH);
  }

}