def main():
    fname = input("Enter filename: ")
    with open("VASM/Assembly Programs/" + fname + ".65c02.s") as f:
      lines = [line.replace("\n", "") for line in f.readlines()]
    
    # Calc indent
    m = 0
    for l in lines:
      if ';' in l:
        m = max(m, l.index(';'))

    for index, line in enumerate(lines):
      if ';' in line:
        i = line.index(';')
        if i <= 2:
          continue # Don't move comments on start of line
        while i < m:
          line = line.split(';')
          line[0] = line[0] + " "
          line = ';'.join(line)
          i = line.index(';')
        lines[index] = line
    
    with open("VASM/Assembly Programs/" + fname + ".65c02.s", "w+") as f:
      for line in lines:
        f.write(line + '\n')
main()