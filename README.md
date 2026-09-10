# RIF-with-MAC-unit-Verilog-Project_NTI
Project Overview
This repository features a hardware implementation of a Finite Impulse Response (FIR) digital filter written in Verilog HDL, paired with a complete automated verification framework. The system is architected around a modular design consisting of a configurable shift register delay line, a high-performance Multiply-Accumulate (MAC) arithmetic core, and a top-level integration wrapper.

To ensure design accuracy, the workflow integrates a software-based Python golden model. The Python reference script processes input datasets using software-equivalent math to compute precise expected outputs and filter coefficients. These parameters are exported into hexadecimal files (input_samples.hex and expected_output.hex), which are read directly by the Verilog testbench via $readmemh. This hardware-software co-design flow enables cycle-accurate regression testing, allowing developers to immediately contrast low-level hardware simulation behavior against theoretical software calculations.

Architecture & Module Breakdown
Parameterized Shift Register (Shift_Reg): Configurable via depth (number of taps) and width (data precision bits). It sequentially captures incoming streaming data samples under control signals, creating a parallel window of historical data for the filter pipeline.

Multiply-Accumulate Unit (MAC_unit): Houses fixed signed filter coefficients and instantiates parallel multipliers using generate loops. It computes the dot product between the delayed input vector and the filter coefficients, accumulating partial products into a wider precision output register (35-bit) to prevent arithmetic overflow.

Top-Level Integration (Top_Module): Unifies the shift register data-path with the MAC computational core, exposing a clean interface for clock, asynchronous reset, data input, valid qualifiers, and filter results.

Automated Self-Checking Testbench (Full_tb): Streams input stimuli from external hex files, checks hardware outputs against the Python golden model expectations on a cycle-by-cycle basis, and logs pass/fail validation results directly to the simulation console.
\documentclass[11pt,a4paper]{article}
\usepackage{tikz}
\usetikzlibrary{shapes.geometric, arrows.meta, positioning, calc}

