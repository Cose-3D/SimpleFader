FLASHING A .HEX FILE TO ARDUINO PRO MICRO BOARD ON APPLE SILICON MAC
======================================================================

ONE-TIME SETUP
---------------
1. Install Homebrew (if not already installed). Open Terminal and run:

   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

2. Install avrdude:

   brew install avrdude


FILES NEEDED
------------
- Your .hex firmware file
- The flash.sh script below

Put both files in the same folder (e.g. Desktop).


THE SCRIPT (flash.sh)
----------------------
Create a file named "flash.sh" with this exact content:

#!/bin/bash
# usage: ./flash.sh filename.hex

HEXFILE="$1"
PORT=$(ls /dev/cu.usbmodem* 2>/dev/null | head -n 1)

if [ -z "$PORT" ]; then
  echo "Arduino not found. Plug it in and try again."
  exit 1
fi

echo "Found port: $PORT - sending 1200 baud touch..."
stty -f "$PORT" 1200
sleep 1

echo "Waiting for bootloader port to reappear..."
NEWPORT=""
for i in $(seq 1 20); do
  sleep 0.5
  NEWPORT=$(ls /dev/cu.usbmodem* 2>/dev/null | head -n 1)
  if [ -n "$NEWPORT" ]; then
    break
  fi
done

if [ -z "$NEWPORT" ]; then
  echo "Bootloader not found, please try again."
  exit 1
fi

echo "Flashing $NEWPORT ..."
avrdude -p atmega32u4 -c avr109 -P "$NEWPORT" -b 57600 -D -U flash:w:"$HEXFILE":i


HOW TO FLASH
------------
1. Open Terminal and go to the folder with both files:

   cd ~/Desktop

2. Make the script executable (only needed once):

   chmod +x flash.sh

3. Plug in the Arduino Pro Micro via USB.

4. Run the script (replace with your actual .hex filename):

   ./flash.sh myfile.hex

5. If it finishes with "avrdude done. Thank you." the upload was successful.


TROUBLESHOOTING
----------------
- "Arduino not found": make sure the board is plugged in and check
  it shows up by running: ls /dev/cu.usbmodem*
- If you have other USB serial devices connected, unplug them
  during flashing so the script picks the right port.
- If it fails with "not in sync" or similar, just run the
  ./flash.sh command again - no need to touch any button.
