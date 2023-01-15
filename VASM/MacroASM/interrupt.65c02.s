  .org $8000

include("print_num")
 ; START HEADER
print_number
print_value
 ; END HEADER

include("lcd")
 ; START HEADER
lcd_command, lcd_char, lcd_wait, lcd_init
LCD_CONTROL, LCD_DATA, DDR_LCD_CONTROL, DDR_LCD_DATA, RS, RW, E, BF
 ; END HEADER


counter = malloc(2) ; 2 byte counter for interrupts

reset:
  jsr lcd_init
  lda #0
  sta counter
  sta counter + 1

  

print_loop:
  sei               ; Disable interrupts
  lda counter
  sta print_value
  lda counter + 1
  sta print_value
  cli               ; Enable interrupts
  jsr print_number

  lda #%00000010    ; Move cursor home
  jsr lcd_command
  jmp print_loop

nmi:
irq:
  inc counter
  bne end_irq
  inc counter + 1
end_irq:
  rti

  .org $fffa
  .word nmi
  .word reset
  .word irq
