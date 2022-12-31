LCD_CONTROL = $6000
LCD_DATA = $6001 ; PORTA
DDR_LCD_CONTROL = $6002
DDR_LCD_DATA = $6003 ; DDRA

RS = %00000001 ; LCD Register Select  0: Instruction / 1: Data
RW = %00000010 ; LCD Read/Write       0: Write       / 1: Read
E  = %00000100 ; LCD Enable

  .org $8000

reset:
  lda #%11111111 ; Set LCD data pins as output
  sta DDR_LCD_DATA

  lda #(RS | RW | E) ; Set LCD control pins as output
  sta DDR_LCD_CONTROL

  lda #%00111000 ; Set 8-bit mode; 2-line display; 5x8 font
  sta LCD_DATA

  lda #0         ; Clear RS/RW/E bits
  sta LCD_CONTROL
  lda #E         ; Set E bit to send instruction
  sta LCD_CONTROL
  lda #0         ; Clear RS/RW/E bits
  sta LCD_CONTROL

  lda #%00001110 ; Display on; cursor on; blink off
  sta LCD_DATA
  
  lda #0         ; Clear RS/RW/E bits
  sta LCD_CONTROL
  lda #E         ; Set E bit to send instruction
  sta LCD_CONTROL
  lda #0         ; Clear RS/RW/E bits
  sta LCD_CONTROL

  lda #%00000110 ; Increment and shift cursor; don't shift display
  sta LCD_DATA
  
  lda #0         ; Clear RS/RW/E bits
  sta LCD_CONTROL
  lda #E         ; Set E bit to send instruction
  sta LCD_CONTROL
  lda #0         ; Clear RS/RW/E bits
  sta LCD_CONTROL

  lda #"H"       ; Send H
  sta LCD_DATA

  lda #RS         ; Set RS bit
  sta LCD_CONTROL
  lda #(RS | E)   ; Set E bit to send instruction
  sta LCD_CONTROL
  lda #RS         ; Clear E bit
  sta LCD_CONTROL

  lda #"E"       ; Send E
  sta LCD_DATA

  lda #RS         ; Set RS bit
  sta LCD_CONTROL
  lda #(RS | E)   ; Set E bit to send instruction
  sta LCD_CONTROL
  lda #RS         ; Clear E bit
  sta LCD_CONTROL

  lda #"L"       ; Send L
  sta LCD_DATA

  lda #RS         ; Set RS bit
  sta LCD_CONTROL
  lda #(RS | E)   ; Set E bit to send instruction
  sta LCD_CONTROL
  lda #RS         ; Clear E bit
  sta LCD_CONTROL

  lda #"L"       ; Send L
  sta LCD_DATA

  lda #RS         ; Set RS bit
  sta LCD_CONTROL
  lda #(RS | E)   ; Set E bit to send instruction
  sta LCD_CONTROL
  lda #RS         ; Clear E bit
  sta LCD_CONTROL

  lda #"O"       ; Send O
  sta LCD_DATA

  lda #RS         ; Set RS bit
  sta LCD_CONTROL
  lda #(RS | E)   ; Set E bit to send instruction
  sta LCD_CONTROL
  lda #RS         ; Clear E bit
  sta LCD_CONTROL

  lda #" "       ; Send ' '
  sta LCD_DATA

  lda #RS         ; Set RS bit
  sta LCD_CONTROL
  lda #(RS | E)   ; Set E bit to send instruction
  sta LCD_CONTROL
  lda #RS         ; Clear E bit
  sta LCD_CONTROL

  lda #"W"       ; Send W
  sta LCD_DATA

  lda #RS         ; Set RS bit
  sta LCD_CONTROL
  lda #(RS | E)   ; Set E bit to send instruction
  sta LCD_CONTROL
  lda #RS         ; Clear E bit
  sta LCD_CONTROL

  lda #"O"       ; Send O
  sta LCD_DATA

  lda #RS         ; Set RS bit
  sta LCD_CONTROL
  lda #(RS | E)   ; Set E bit to send instruction
  sta LCD_CONTROL
  lda #RS         ; Clear E bit
  sta LCD_CONTROL

  lda #"R"       ; Send R
  sta LCD_DATA

  lda #RS         ; Set RS bit
  sta LCD_CONTROL
  lda #(RS | E)   ; Set E bit to send instruction
  sta LCD_CONTROL
  lda #RS         ; Clear E bit
  sta LCD_CONTROL

  lda #"L"       ; Send L
  sta LCD_DATA

  lda #RS         ; Set RS bit
  sta LCD_CONTROL
  lda #(RS | E)   ; Set E bit to send instruction
  sta LCD_CONTROL
  lda #RS         ; Clear E bit
  sta LCD_CONTROL

  lda #"D"       ; Send D
  sta LCD_DATA

  lda #RS         ; Set RS bit
  sta LCD_CONTROL
  lda #(RS | E)   ; Set E bit to send instruction
  sta LCD_CONTROL
  lda #RS         ; Clear E bit
  sta LCD_CONTROL

  lda #"!"       ; Send !
  sta LCD_DATA

  lda #RS         ; Set RS bit
  sta LCD_CONTROL
  lda #(RS | E)   ; Set E bit to send instruction
  sta LCD_CONTROL
  lda #RS         ; Clear E bit
  sta LCD_CONTROL

loop:
  jmp loop

  .org $fffc
  .word reset ; 8000
  .word $0000