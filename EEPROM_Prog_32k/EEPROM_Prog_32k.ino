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
#define MAX_ADDR 0x8000
#define WE 2
#define OE 3
#define LIGHT 13

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

void write_address(unsigned int address, byte data) {
  if (read_address(address) == data) {
    return; //improves prog speed
  }
  digitalWrite(OE, HIGH); //disable output (no need to set addr again...)

  for (int i = 0; i < DATA_SIZE; i++) {
    pinMode(DATA_PINS[i], OUTPUT);
  }

  byte orig_data = data;

  for (int i = 0; i < DATA_SIZE; i++) {
    digitalWrite(DATA_PINS[i], data & 1);
    data = data >> 1; //Shift data right 1 to read each digit
  }

  digitalWrite(WE, LOW); //enable writing
  delayMicroseconds(1);
  digitalWrite(WE, HIGH); //disable writing
  digitalWrite(LIGHT, HIGH);
  delay(1);

  while (read_address(address) != orig_data) {
    delay(1);
  }
  digitalWrite(LIGHT, LOW);
}

byte read_byte_from_serial() {
  String s_buf = "";
  while (true) {
    if (Serial.available()) {
      char c = Serial.read();
      if (c == '\n') {
        break;
      }
      else {
        s_buf += c;
      }
    }
  }
  return s_buf.toInt();
}


void setup() {
  Serial.begin(115200);
  Serial.println("Serial connected.");


  for (int i = 0; i < ADDR_SIZE; i++) {
    pinMode(ADDR_PINS[i], OUTPUT);
  }
  pinMode(WE, OUTPUT);
  pinMode(OE, OUTPUT);
  pinMode(LIGHT, OUTPUT);
  digitalWrite(WE, HIGH); //disable writing
  digitalWrite(LIGHT, LOW);

  Serial.println("IO Configured.");

  Serial.println("Ready for writing data...");
  for (unsigned int addr = 0; addr < MAX_ADDR; addr++) {
    write_address(addr, read_byte_from_serial());
    Serial.println("OK");
  }

  Serial.println("Write Completed!");

  for (unsigned int addr = 0; addr < MAX_ADDR; addr++) {
    byte r = read_byte_from_serial();
    byte e = read_address(addr);
    if (e != r) {
      char o_buf [256];
      sprintf(o_buf, "VERIFICATION ERROR on addr %04x: EEPROM: %02x, FILE: %02x", addr, e, r);
      Serial.println(o_buf);
      break;
    }
    else {
      Serial.println("OK");
    }
  }

  Serial.println("Verification Completed!");
}

void loop() {
  // put your main code here, to run repeatedly:

}
