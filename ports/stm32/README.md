Platform Support: STM32F4x with ThreadX (ALPHA)
==========================================================

Overview
--------
The `ports/stm32` directory contains preliminary support for the STM32FR platform
with the ThreadX.  The serial driver is hard-coded to work with a single XBee module 
on UART instance `huart2`. The terminal port is attached to UART instance: `huart4`.
It does not support CTS and RTS signals, which are necessary for reliable communications 
and to avoid overflowing the serial buffer on the XBee module. 

From the `ports/stm32` directory, run `build.sh` to create 
`lib/xbee-stm32.zip`, or include `inc/src` from generated `lib` dir.


Building samples
----------------
Use the files in `samples/mbed-kl25` as the starting point for your 
project.  They demonstrate how to initialize the `xbee_dev_t` structure, 
send AT request and process AT responses.
