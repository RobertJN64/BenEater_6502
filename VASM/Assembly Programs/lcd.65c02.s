PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003

  .org $8000
  lda #%11111111
  sta $6002

loop:
  lda #$55
  sta $6000

  lda #$aa
  sta $6000

  jmp loop

  .org $fffc
  .word $8000
  .word $0000