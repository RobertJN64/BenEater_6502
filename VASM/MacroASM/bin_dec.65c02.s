  .org $8000

include("print_num")
 ; START HEADER
print_number
print_value
 ; END HEADER


reset:
  jsr lcd_init

  lda number ; Init value to number
  sta print_value
  lda number + 1
  sta print_value + 1

  jsr print_number
  

loop:
  jmp loop

number: .word 2048

  .org $fffc
  .word reset
  .word $0000
