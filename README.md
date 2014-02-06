# CPU32

A tiny MIPS implementation for Terasic DE0/DEx and other Altera FPGA boards

## Demo
* Calculating Fibonacci numbers: [video](https://plus.google.com/u/0/+KazunoriSato/posts/AfJxuCjYNbS)

## Instruction Set

* MIPS I architecture
* Supports [basic arithmetic ops](https://github.com/kazunori279/CPU32/blob/master/src/alu.v), [branches](https://github.com/kazunori279/CPU32/blob/master/src/program_counter.v) and [other ops](https://github.com/kazunori279/CPU32/blob/master/src/decoder.v)
* Does not support floating points, exceptions and etc

## Features

* Single clocked design (no pipeline)
* 32KB RAM (with Block RAM of Cyclone III)
* I/O: 7-seg LEDs for output, sw3 - sw0 for input
* Runs MIPS I binary code generated from basic C program
* No bus/cache/MMU support
* May have some bugs :)

## Getting Started

### Prerequisites
* Terasic DE0/DEx or Altera FPGA development environment, including Altera Quartus II Web edition on Windows
* (Alternatively, you could use ModelSim for simulation only purpose)
* Experience of basic Altera FPGA development

### Build
* Create a Quartus project named CPU32
* Copy /src and /conf folders under the project folder and add .v files to the project. 
* Start Analysis & Elaboration for initial check. You would have errors on some .v files. Open property dialog and set language to "SystemVerilog"
* Use Pin Planner for pin assignment for CPU32.v for LEDs, switches and buttons
* Start Compilation for full build. This may takes several minutes

### Run Fibonacci
* Use Programmer for loading to DE0
* You will see fibonacci numbers displayed on the LED

## Run your own C code on CPU32

### Compile C code and generate MIF file
* Prepare for MIPS gcc toolchain on any Linux environment. Add mips-gcc/bin directory to your PATH
* Install Python runtime
* Use [c2mif.py](https://github.com/kazunori279/CPU32/blob/master/conf/c2mif.py) to compile .c file and generate .mif file

`> python c2mif.py fib.c`

### Run the binary on CPU32
* Copy the mif file from the Linux to /conf folder in the Quartus project
* Edit [bram.v](https://github.com/kazunori279/CPU32/blob/master/src/bram.v) file and replace "conf/fib.mif" with the path of your mif file
* Start Compilation on Quartus II and load it to the board

## Memory Mappings and I/O access

### Memory map

    0x0000 ->        : text
           <- 0x7efc : stack
    0x7f00 -- 0x7fff : global

              0x7f00 : to display a value on LED 
              0x7ff0 : to input params from sw3 - sw0

### 7-seg LED display modes

The 7-seg LED displays $7f00, PC or registers, based on switch setting:

    sw9:   off = $7f00      on = PC or registers
    sw8:   off = PC         on = reg
    sw7:   off = low bytes  on = high bytes
    sw6-5: not used
    sw4-0: register address

## License

* Apache License v2.0

