  .org $8000

reset:
  jsr lcd_init

loop:
  jmp loop

nmi:
  rti
irq:
  rti

  .org $fffa
  .word nmi
  .word reset
  .word irq
