 ; IO

LCD_CONTROL = $6000     ; PORTB
LCD_DATA = $6001        ; PORTA
DDR_LCD_CONTROL = $6002 ; DDRB
DDR_LCD_DATA = $6003    ; DDRA

 ; RAM

value = $0200           ; 2 bytes | Initial value for bin to dec conversion
mod10 = $0202           ; 1 byte  | Mod10 result from binary division


RS = %00000001          ; LCD Register Select  0: Instruction / 1: Data
RW = %00000010          ; LCD Read/Write       0: Write       / 1: Read
E  = %00000100          ; LCD Enable
BF = %10000000          ; LCD Busy Flag        0: Not Busy    / 1: Busy

  .org $8000

reset:
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

  lda number            ; Init value to number
  sta value
  lda number + 1
  sta value + 1

div_start:
  pha #0                ; Push null byte onto stack
  lda #0                ; Init mod10 to 0
  sta mod10

  ldx #16               ; Repeat 16 times max
rol_loop:
  rol value             ; ROL value into mod10 (carry <- mod10 <- value[8-15] <- value [0-7])
  rol value + 1
  rol mod10

  sec                   ; Set carry bit (if carry bit is 0 after subtraction, we borrowed and mod10 < 10)
  lda mod10
  sbc #10

  bcc ignore_result     ; Branch if carry clear (if we borrowed)
  sta mod10             ; Move result of subtraction back into mod10

ignore_result:
  dex
  bne rol_loop          ; Repeat 16 times max

                        ; Loop done, time to output values
  rol value             ; Shift last bit into value (value[8-15] <- value [0-7] <- carry)
  rol value + 1
  clc
  adc #"0"              ; Convert to ascii
  pha                   ; Push char onto stack
  lda value
  ora value + 1
  bne div_start

write_loop:
  pla
  beq loop
  jsr lcd_char
  jmp write_loop

loop:
  jmp loop


number: .word 1729

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

lcd_busy:
  lda #RW               ; Enable reading from LCD
  sta LCD_CONTROL
  lda #(RW | E)         ; Set E bit to send instruction
  sta LCD_CONTROL

  lda LCD_DATA          ; Read from LCD
  and #BF               ; AND busy flag - sets Zero flag if not busy
  bne lcd_busy          ; Jump back to start of loop if busy
   

  lda #0                ; Clear RS/RW/E bits
  sta LCD_CONTROL

  lda #%11111111        ; Set LCD data pins as output
  sta DDR_LCD_DATA
  pla                   ; Restore A register
  rts



  .org $fffc
  .word reset           ; 8000
  .word $0000
