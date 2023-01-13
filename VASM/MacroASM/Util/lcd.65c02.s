LCD_CONTROL = $6000     ; PORTB
LCD_DATA = $6001        ; PORTA
DDR_LCD_CONTROL = $6002 ; DDRB
DDR_LCD_DATA = $6003    ; DDRA

RS = %00000001          ; LCD Register Select  0: Instruction / 1: Data
RW = %00000010          ; LCD Read/Write       0: Write       / 1: Read
E  = %00000100          ; LCD Enable
BF = %10000000          ; LCD Busy Flag        0: Not Busy    / 1: Busy

lcd_command:            ; Send a command to the LCD (from the A register)
  jsr lcd_wait
  sta LCD_DATA

  lda #0                ; Clear RS/RW/E bits
  sta LCD_CONTROL
  lda #E                ; Set E bit to send instruction
  sta LCD_CONTROL
  lda #0                ; Clear RS/RW/E bits
  sta LCD_CONTROL

  rts

lcd_char:               ; Print a character to the LCD (from the A register)
  jsr lcd_wait
  sta LCD_DATA

  lda #RS               ; Set RS bit
  sta LCD_CONTROL
  lda #(RS | E)         ; Set E bit to send instruction
  sta LCD_CONTROL
  lda #RS               ; Clear E bit
  sta LCD_CONTROL

  rts

lcd_wait:               ; Read busy flag and block until LCD ready
  pha                   ; Preserve A register

  lda #%00000000        ; Set LCD_DATA as input
  sta DDR_LCD_DATA 

_lcd_busy:
  lda #RW               ; Enable reading from LCD
  sta LCD_CONTROL
  lda #(RW | E)         ; Set E bit to send instruction
  sta LCD_CONTROL

  lda LCD_DATA          ; Read from LCD
  and #BF               ; AND busy flag - sets Zero flag if not busy
  bne _lcd_busy         ; Jump back to start of loop if busy
   

  lda #0                ; Clear RS/RW/E bits
  sta LCD_CONTROL

  lda #%11111111        ; Set LCD data pins as output
  sta DDR_LCD_DATA
  pla                   ; Restore A register
  rts

lcd_init:
  lda #%11111111        ; Set LCD data pins as output
  sta DDR_LCD_DATA

  lda #(RS | RW | E)    ; Set LCD control pins as output
  sta DDR_LCD_CONTROL

  lda #%00111000        ; Set 8-bit mode; 2-line display; 5x8 font
  jsr lcd_command

  lda #%00001110        ; Display on; cursor on; blink off
  jsr lcd_command

  lda #%00000110        ; Increment and shift cursor; don't shift display
  jsr lcd_command

  lda #%00000001        ; Clear display
  jsr lcd_command
  rts
