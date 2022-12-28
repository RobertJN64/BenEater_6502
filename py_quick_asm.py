import os

def main():
    fname = input("Enter filename: ")
    with open("Assembly Programs/" + fname + ".65c02.s"):
        pass

    # http://www.compilers.de/vasm.html
    os.system(f'cd "Assembly Programs" && vasm6502_oldstyle {fname}.65c02.s -Fbin -dotdir -o {fname}.bin')

main()