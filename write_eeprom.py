import serial

def verify_line(prog: serial.Serial, correct: str, state:str, p):
    l = prog.readline().decode('utf-8').strip()
    if l != correct:
        print(f"Error while {state}, expected '{correct}' recieved: '{l}'")
        return False
    if p:
        print(l)
    return True

def main():
    port = input("Enter port number (COM6): ")
    prog = serial.Serial(port, 115200)

    print("Waiting for programmer reboot...")
    while True:
        l = prog.readline().decode('utf-8').strip()
        print(l)
        if l == "Ready for writing data...":
            break

    with open("rom.bin", "rb") as f:
        barr = f.read()

    last_p = 0
    for index, char in enumerate(barr):
        if int(index * 100/len(barr)) > last_p:
            last_p = int(index * 100/len(barr))
            print(f"Writing... {last_p}% Complete")

        prog.write((str(char) + "\n").encode())
        if not verify_line(prog, "OK", "writing", False):
            return

    if not verify_line(prog, "Write Completed!", "writing", True):
        return

    last_p = 0
    for index, char in enumerate(barr):
        if int(index * 100 / len(barr)) > last_p:
            last_p = int(index * 100/ len(barr))
            print(f"Verifying... {last_p}% Complete")

        prog.write((str(char) + "\n").encode())
        if not verify_line(prog, "OK", "verifying", False):
            return

    if not verify_line(prog, "Verification Completed!", "verifying", True):
        return



if __name__ == '__main__':
    main()
