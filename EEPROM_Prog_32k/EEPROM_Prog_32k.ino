/* EEPROM INFO
WIRING: A15 - A0 | D7 - D0 | ~WE | ~OE
Read Sequence:
 - Set Address
 - Set OE false (enable output)
 - Wait 1 Microsecond
 - Read Data Lines

Write Sequence:
 - Set Address
 - Set OE true (disable output)
 - Set Data lines
 - Set WE false (enable writing)
 - Wait 1 Microsecond
 - Set WE true (disable writing)
 - Loop until read matches data
 - Verify once eeprom has been fully written
*/

#define ADDR_SIZE 15
#define DATA_SIZE 8
#define WE 2
#define OE 3

//A0 through A15
int ADDR_PINS [ADDR_SIZE] = {37, 35, 33, 31, 29, 27, 25, 23,
                             36, 34, 32, 30, 28, 26, 24}; //22 is not used for 15 bit addr

//D0 through D15
int DATA_PINS [DATA_SIZE] = {52, 50, 48, 46, 44, 42, 40, 38};



void set_address(unsigned int address) {
  for (int i = 0; i < ADDR_SIZE; i++) {
    digitalWrite(ADDR_PINS[i], address & 1);
    address = address >> 1; //Shift addr right 1 to read each digit
  }
}

byte read_address(unsigned int address) {
  set_address(address);
  digitalWrite(OE, LOW); //enable output

  for (int i = 0; i < DATA_SIZE; i++) {
    pinMode(DATA_PINS[i], INPUT);
  }

  delayMicroseconds(1);

  byte data = 0;
  for (int i = DATA_SIZE - 1; i >= 0; i--) {
    data = (data << 1) + digitalRead(DATA_PINS[i]); //Read in each bit from the EEPROM
  }
  return data;
}

byte write_address(unsigned int address, byte data) {
  set_address(address);
  digitalWrite(OE, HIGH); //disable output

  for (int i = 0; i < DATA_SIZE; i++) {
    pinMode(DATA_PINS[i], OUTPUT);
  }

  byte orig_data = data;

  for (int i = 0; i < DATA_SIZE; o++) {
    digitalWrite(DATA_PINS[i], data & 1);
    data = data >> 1; //Shift data right 1 to read each digit
  }
  
  digitalWrite(WE, LOW); //enable writing
  delayMicroseconds(1);
  digitalWrite(WRITE_ENABLE, HIGH); //disable writing
  delay(1);

  while (read_address(address) != origdata) {
    delay(1);
  }
}


void setup() {
  Serial.begin(115200);
  Serial.println("Serial connected.");


  for (int i = 0; i < ADDR_SIZE; i++) {
    pinMode(ADDR_PINS[i], OUTPUT);
  }
  pinMode(WE, OUTPUT);
  pinMode(OE, OUTPUT);
  digitalWrite(WE, HIGH); //disable writing

  Serial.println("IO Configured.");
}

void loop() {
  // put your main code here, to run repeatedly:

}
