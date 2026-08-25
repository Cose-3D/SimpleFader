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