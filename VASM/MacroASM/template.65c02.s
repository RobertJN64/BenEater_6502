  .org $8000

include("lcd")
 ; START HEADER
lcd_command, lcd_char, lcd_wait, lcd_busy
LCD_CONTROL, LCD_DATA, DDR_LCD_CONTROL, DDR_LCD_DATA, RS, RW, E, BF
 ; END HEADER


var = malloc(2)    ; 2 bytes | Some variable

reset:
  lda #%11111111   ; Load ff into A reg
loop:
  jmp loop

number: .word 1729 ; Binary number

  .org $fffc
  .word reset      ; 8000
  .word $0000
