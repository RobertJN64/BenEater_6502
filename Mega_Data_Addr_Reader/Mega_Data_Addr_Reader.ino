#define CLOCK 2
#define RW 3

#define ADDR_COUNT 16
#define DATA_COUNT 8

const int ADDR_PINS [ADDR_COUNT] = {22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52};
const int DATA_PINS [DATA_COUNT] = {23, 25, 27, 29, 31, 33, 35, 37};


void setup() {
  Serial.begin(115200);
  Serial.println("Serial connected!");
  pinMode(CLOCK, INPUT);
  pinMode(RW, INPUT);

  for (int i = 0; i < ADDR_COUNT; i++) {
    pinMode(ADDR_PINS[i], INPUT);
  }

  for (int i = 0; i < DATA_COUNT; i++) {
    pinMode(DATA_PINS[i], INPUT);
  }
}

void loop() {
  while (digitalRead(CLOCK) == 0) {
    //busy loop
  }
  

  unsigned int addr = 0;
  for (int i = ADDR_COUNT -1; i >= 0; i--) {
    addr = (addr << 1) + digitalRead(ADDR_PINS[i]);
  }

  unsigned int data = 0;
  for (int i = DATA_COUNT - 1; i >= 0; i--) {
    data = (data << 1) + digitalRead(DATA_PINS[i]);
  }

  if (digitalRead(RW)) {
    Serial.print("Read on  ");
  }
  else {
    Serial.print("Write to ");
  }

  char output[32]; 
  sprintf(output, "%04x: %02x", addr, data);
  Serial.print(output);

  Serial.println();

  while (digitalRead(CLOCK) == 1) {
    //busy loop
  }
}
