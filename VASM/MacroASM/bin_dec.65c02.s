  .org $8000

include("lcd")
 ; START HEADER
lcd_command, lcd_char, lcd_wait, lcd_init
LCD_CONTROL, LCD_DATA, DDR_LCD_CONTROL, DDR_LCD_DATA, RS, RW, E, BF
 ; END HEADER


value = malloc(2)           ; 2 bytes | Initial value for bin to dec conversion
mod10 = malloc(1)           ; 1 byte  | Mod10 result from binary division

reset:
  jsr lcd_init

  lda number            ; Init value to number
  sta value
  lda number + 1
  sta value + 1

div_start:              
  lda #0                ; Init mod10 to 0
  pha                   ; Push null byte onto stack
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

  .org $fffc
  .word reset           ; 8000
  .word $0000
