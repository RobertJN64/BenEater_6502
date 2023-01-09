import os


def main():
    fname = input("Enter filename: ")
    with open("VASM/Assembly Programs/" + fname + ".65c02.s"):
        pass
    # http://www.compilers.de/vasm.html
    os.system(
        f'cd VASM && vasm6502_oldstyle.exe "Assembly Programs/{fname}.65c02.s" -Fbin -dotdir -o bin/{fname}.bin')

    if input("Prepare to write EEPROM? y/n ") == "y":
        with open("VASM/bin/" + fname + ".bin", "rb") as f:
            with open("rom.bin", "wb") as g:
                g.write(f.read())


main()
