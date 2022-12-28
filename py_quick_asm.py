import os

def main():
    fname = input("Enter filename: ")
    with open("Assembly Programs/" + fname + ".s"):
        pass

    # http://www.compilers.de/vasm.html
    os.system(f'cd "Assembly Programs" && vasm6502_oldstyle {fname}.s -Fbin -dotdir -o {fname}.bin')

main()