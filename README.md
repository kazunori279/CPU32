# CPU32

Tiny MIPS implementation for Terasic DE0/DEx and other Altera FPGA boards

## Instruction Set

- MIPS I architecture (excluding exceptions, FPs etc)

## Features

- Single clocked design (no pipeline or stage)
- 32KB RAM (with Block RAM of Cyclone III)
- I/O: DE0 7-seg LEDs for output, sw3 - sw0 for input
- No bus/cache/MMU support
- May have some bugs :)

## Getting Started

- Prerequisites
-- Terasic DE0/DEx or Altera FPGA development environment, including Altera Quartus II Web edition on Windows
-- Experience of basic Altera FPGA development

- Build
-- Create a Quartus project for CPU32
-- Import files under /src folder. You may need to specify properties of .v files to "SystemVerilog"
-- "Start Analysis & Elaboration" for initial compilation
-- Use Pin Planner for pin assignment for CPU32.v inputs and outputs for LEDs, SWs and buttons
-- Start Compilation for full build. This may takes several minutes

- Run Fibonacci
-- Use Programmer for loading to DE0
-- You will see fibonacci numbers displayed on the LED

## Run your own C program on CPU32

- GNU MIPS toolchain
-- Prepare for GNU gcc and as (assembler) for MIPS architecture on Linux



## License

- Apache License v2.0
