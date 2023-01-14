  .org $8000

include("lcd")
 ; START HEADER
lcd_command, lcd_char, lcd_wait, lcd_init
LCD_CONTROL, LCD_DATA, DDR_LCD_CONTROL, DDR_LCD_DATA, RS, RW, E, BF
 ; END HEADER


reset:
  jsr lcd_init

  ldx #0                ; Load X index reg with 0
print:
  lda message,x         ; Print the x'th byte of message
  beq loop              ; If null byte (end) - jump to end
  jsr lcd_char   
  inx                   ; Increment x reg
  jmp print

loop:
  jmp loop

message: .asciiz "linker.py works"

  .org $fffc
  .word reset
  .word $0000
