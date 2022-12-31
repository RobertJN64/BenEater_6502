  .org $8000

  lda #$ff ; Configure port B as output
  sta $6002

  lda #$50

loop:
  sta $6000
  ror
  jmp loop

  .org $fffc
  .word $8000
  .word $0000