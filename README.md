# CPU32

Tiny MIPS implementation for Terasic DE0/DEx and other Altera FPGA boards

## Demo
* Calculating Fibonacci numbers: [video](https://plus.google.com/u/0/+KazunoriSato/posts/AfJxuCjYNbS)

## Instruction Set

### MIPS I architecture
* Supports [basic arithmetic ops](https://github.com/kazunori279/CPU32/blob/master/src/alu.v), [branches](https://github.com/kazunori279/CPU32/blob/master/src/program_counter.v) and [other ops](https://github.com/kazunori279/CPU32/blob/master/src/decoder.v)
* Does not support floating points, exceptions and etc

## Features

* Single clocked design (no pipeline or stage)
* 32KB RAM (with Block RAM of Cyclone III)
* I/O: DE0 7-seg LEDs for output, sw3 - sw0 for input
* Runs MIPS I binary code generated from basic C program
* No bus/cache/MMU support
* May have some bugs :)

## Getting Started

### Prerequisites
* Terasic DE0/DEx or Altera FPGA development environment, including Altera Quartus II Web edition on Windows
* (Alternatively, you could use ModelSim for simulation only purpose)
* Experience of basic Altera FPGA development

### Build
* Create a Quartus project for CPU32
* Import files of /src and /conf folders. You may need to specify properties of .v files to "SystemVerilog"
* "Start Analysis & Elaboration" for initial compilation
* Use Pin Planner for pin assignment for CPU32.v inputs and outputs for LEDs, SWs and buttons
* Start Compilation for full build. This may takes several minutes

### Run Fibonacci
* Use Programmer for loading to DE0
* You will see fibonacci numbers displayed on the LED

## Run your own C code on CPU32

### GNU MIPS toolchain
* Prepare for GNU gcc and as (assembler) for MIPS architecture on Linux

### Write a C code (for example: [fib.c](https://github.com/kazunori279/CPU32/blob/master/conf/fib.c))
* If you want to use LED display and switch inputs, see Memory Mapping section
* You can not use any code that may generate exceptions (system calls, interupts etc)
* You only have 32KB for both binary and stack

### Compile the C code
* Compile the C code to generate .s (assembler) code

`> mips-gcc -S test.c`

* Edit the .s file to remove all assembler macros (lines starting with "."). Now the .s file may look like this: [fib.s](https://github.com/kazunori279/CPU32/blob/master/conf/fib.s)
* Assemble the .s file to generate a.out (binary) file. Use -O0 option to generate only MIPS I code

`> mips-as -O0 test.s`

### Package the binary into .mif file
* Extract hex strings by using readelf and [textdump.py](https://github.com/kazunori279/CPU32/blob/master/conf/textdump.py)

`> readelf -x .text a.out | python textdump.py`

* Use text editor or spreadsheet to convert the hex strings to .mif file format (for example: [fib.mif](https://github.com/kazunori279/CPU32/blob/master/conf/fib.mif))

### Run the binary on CPU32
* Place the mif file under /conf folder
* Edit [bram.v](https://github.com/kazunori279/CPU32/blob/master/src/bram.v) file and replace "conf/fib.mif" with the path of your mif file
* Start Compilation on Quartus II and load it to the board

## Memory Mappings and I/O access

### Memory map

    0x0000 ->        : text
           <- 0x7efc : stack
    0x7f00 -- 0x7fff : global

              0x7f00 : to display a value on LED 
              0x7ff0 : to input params from sw3 - sw0

### LED modes

LED display to show $7ff0, PC or registers

    sw9:   off = $7ff0,     on = PC or registers
    sw8:   off = PC,        on = reg
    sw7:   off = low bits,  on = high bits
    sw6-5: not used
    sw4-0: register address

## License

* Apache License v2.0

