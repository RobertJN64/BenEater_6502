import shutil
import os

# Features
# malloc(x) cmd for allocating x bytes
# include(x) cmd for including files
# automatically remove header text
# activate assembler when finished

malloc = int("0x200", 16)

def parse_file(lines):
  global malloc
  header_flag = False
  out = []
  for line in lines:
    if not header_flag:
      if '=malloc(' in line.replace(" ", ''):
        size = int(line.split('(')[1].split(')')[0])
        line = line.split('=')[0] + ' = '
        line += hex(malloc)
        out.append(line)

        malloc += size

      elif 'include(' in line:
        fname = line.split('"')[1]
        with open("VASM/MacroASM/Util/" + fname + ".65c02.s") as h:
          l2 = parse_file([line.replace("\n", "") for line in h.readlines()])
        for line in l2:
          out.append(line)

      elif '; START HEADER' in line:
        header_flag = True
      else:
        out.append(line)


    if '; END HEADER' in line:
      header_flag = False

  return out

def main():
  fname = input("Enter filename: ")
  with open("VASM/MacroASM/" + fname + ".65c02.s") as f:
    lines = [line.replace("\n", "") for line in f.readlines()]

  with open("VASM/out.65c02.s", 'w+') as f:
    for line in parse_file(lines):
      f.write(line + '\n')

  # http://www.compilers.de/vasm.html
  os.system(f'cd VASM && vasm6502_oldstyle.exe "out.65c02.s" -Fbin -dotdir -o bin/out.bin')
  shutil.move("VASM/bin/out.bin", "rom.bin")

main()