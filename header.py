def main():
  fname = input("Enter filename: ")
  with open("VASM/MacroASM/Util/" + fname + ".65c02.s") as f:
    lines = [line.replace("\n", "") for line in f.readlines()]
  
  for index, line in enumerate(lines):
    lines[index] = line.split(';')[0].strip()

  while '' in lines:
    lines.remove('')

  sects = ''
  variables = ''
  
  for line in lines:
    if ':' in line:
      sects += line.replace(':', '') + ', '
    if ' = ' in line:
      variables += line.split('=')[0].strip() + ', '
      
  header = 'include("' + fname + '")\n ; START HEADER\n'
  if len(sects) > 0:
    header += sects[:-2] + '\n' #remove trailing ', '
  if len(variables) > 0:
    header += variables[:-2] + '\n' #remove trailing ', '

  header += " ; END HEADER\n"
  
  with open("VASM/MacroASM/Util/" + fname + ".header", 'w+') as f:
    f.write(header)
    
main()