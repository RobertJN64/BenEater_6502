include("lcd")
 ; START HEADER
LCD_CONTROL, LCD_DATA, DDR_LCD_CONTROL, DDR_LCD_DATA, RS, RW, E, BF
 ; END HEADER


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

  ldx #0                ; Load X index reg with 0
print:
  lda message,x         ; Print the x'th byte of message
  beq loop              ; If null byte (end) - jump to end
  jsr lcd_char   
  inx                   ; Increment x reg
  jmp print

loop:
  jmp loop

message: .asciiz "Hello, world!"

  .org $fffc
  .word reset           ; 8000
  .word $0000
