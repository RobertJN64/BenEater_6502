LCD_CONTROL = $6000
LCD_DATA = $6001     ; PORTA
DDR_LCD_CONTROL = $6002
DDR_LCD_DATA = $6003 ; DDRA

RS = %00000001       ; LCD Register Select  0: Instruction / 1: Data
RW = %00000010       ; LCD Read/Write       0: Write       / 1: Read
E  = %00000100       ; LCD Enable

  .org $8000

reset:
  lda #%11111111     ; Set LCD data pins as output
  sta DDR_LCD_DATA

  lda #(RS | RW | E) ; Set LCD control pins as output
  sta DDR_LCD_CONTROL

  lda #%00111000     ; Set 8-bit mode; 2-line display; 5x8 font
  jsr lcd_command

  lda #%00001110     ; Display on; cursor on; blink off
  jsr lcd_command

  lda #%00000110     ; Increment and shift cursor; don't shift display
  jsr lcd_command

  lda #%00000001     ; Clear display
  jsr lcd_command

  lda #"H"           ; Send H
  jsr lcd_char

  lda #"E"           ; Send E
  jsr lcd_char

  lda #"L"           ; Send L
  jsr lcd_char

  lda #"L"           ; Send L
  jsr lcd_char

  lda #"O"           ; Send O
  jsr lcd_char

  lda #" "           ; Send ' '
  jsr lcd_char

  lda #"W"           ; Send W
  jsr lcd_char

  lda #"O"           ; Send O
  jsr lcd_char

  lda #"R"           ; Send R
  jsr lcd_char

  lda #"L"           ; Send L
  jsr lcd_char

  lda #"D"           ; Send D
  jsr lcd_char

  lda #"!"           ; Send !
  jsr lcd_char

loop:
  jmp loop

lcd_command:         ; Send a command to the LCD (from the A register)
  sta LCD_DATA

  lda #0             ; Clear RS/RW/E bits
  sta LCD_CONTROL
  lda #E             ; Set E bit to send instruction
  sta LCD_CONTROL
  lda #0             ; Clear RS/RW/E bits
  sta LCD_CONTROL

  rts

lcd_char:            ; Print a character to the LCD (from the A register)
  sta LCD_DATA

  lda #RS            ; Set RS bit
  sta LCD_CONTROL
  lda #(RS | E)      ; Set E bit to send instruction
  sta LCD_CONTROL
  lda #RS            ; Clear E bit
  sta LCD_CONTROL

  rts

  .org $fffc
  .word reset        ; 8000
  .word $0000
