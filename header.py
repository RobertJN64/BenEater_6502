def main():
  fname = input("Enter filename: ")
  with open("VASM/MacroASM/Util/" + fname + ".65c02.s") as f:
    lines = [line.replace("\n", "") for line in f.readlines()]
  
  for index, line in enumerate(lines):
    lines[index] = line.split(';')[0].strip()

  while '' in lines:
    lines.remove('')

  header = 'include("' + fname + '")\n ; START HEADER\n'
  for line in lines:
    if ':' in lines:
      header += line.replace(':', '') + ', '
    if ' = ' in line:
      header += line.split('=')[0].strip() + ', '
  header = header[:-2] #remove trailing ', '
  header += "\n ; END HEADER\n"
  
  with open("VASM/MacroASM/Util/" + fname + ".header", 'w+') as f:
    f.write(header)
    
main()