include("lcd")
 ; START HEADER
lcd_command, lcd_char, lcd_wait, lcd_init
LCD_CONTROL, LCD_DATA, DDR_LCD_CONTROL, DDR_LCD_DATA, RS, RW, E, BF
 ; END HEADER

print_value = malloc(2) ; 2 bytes | Initial print_value for bin to dec conversion
_mod10 = malloc(1)      ; 1 byte  | Mod10 result from binary division

print_number:           ; Print 16 bit value from print_value onto LCD
  lda #0
  pha                   ; Push null byte onto stack

_div_start:              
  lda #0                ; Init mod10 to 0           
  sta _mod10

  ldx #16               ; Repeat 16 times max
_rol_loop:
  rol print_value       ; ROL print_value into mod10 (carry <- mod10 <- print_value[8-15] <- print_value [0-7])
  rol print_value + 1
  rol _mod10

  sec                   ; Set carry bit (if carry bit is 0 after subtraction, we borrowed and mod10 < 10)
  lda _mod10
  sbc #10

  bcc _ignore_result    ; Branch if carry clear (if we borrowed)
  sta _mod10            ; Move result of subtraction back into mod10

_ignore_result:
  dex
  bne _rol_loop         ; Repeat 16 times max

 ; Loop done, time to output print_values
  rol print_value       ; Shift last bit into print_value (print_value[8-15] <- print_value [0-7] <- carry)
  rol print_value + 1

  lda _mod10
  clc
  adc #"0"              ; Convert to ascii
  pha                   ; Push char onto stack
  
  lda print_value
  ora print_value + 1
  bne _div_start
  

_write_loop:            ; Write each char from stack onto LCD
  pla
  beq loop
  jsr lcd_char
  jmp _write_loop

  rts
