MAX_ADDR = 16

rom = bytearray([0xea] * MAX_ADDR)

with open("rom.bin", "wb") as f:
    f.write(rom)