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

\begin{document}

\begin{figure}[p]
    \centering
    
    % --- 1. Top-Level Module Diagram (from image_3290f3.png) ---
    \begin{tikzpicture}[
        block/.style={draw, rectangle, minimum width=4cm, minimum height=3.5cm, text centered, fill=blue!5},
        arrow/.style={-Stealth, thick}
    ]
        \node[block] (top) {};
        \node[above=0.2cm of top, font=\bfseries] {Top Module};

        % Inputs (Top side)
        \draw[arrow] ([xshift=-1.2cm]top.north) -- ++(0, 0.8) node[above] {\texttt{Data\_in [15:0]}};
        \draw[arrow] ([xshift=-0.3cm]top.north) -- ++(0, 0.8) node[above] {\texttt{rst\_n}};
        \draw[arrow] ([xshift=0.9cm]top.north) -- ++(0, 0.8) node[above] {\texttt{valid\_in}};

        % Clock (Left side)
        \draw[arrow] ([yshift=0.5cm]top.west) -- ++(-1.0, 0) node[left] {\texttt{clk}};

        % Outputs (Bottom side)
        \draw[arrow] ([xshift=-0.5cm]top.south) -- ++(0, -0.8) node[below] {\texttt{Data\_Mac\_Out}};
        \draw[arrow] ([xshift=0.8cm]top.south) -- ++(0, -0.8) node[below] {\texttt{valid\_out}};
    \end{tikzpicture}

    \vspace{1cm}

    % --- 2. Shift Register Block Diagram (from image_3290b7.png) ---
    \begin{tikzpicture}[
        block/.style={draw, rectangle, minimum width=4cm, minimum height=3cm, text centered, fill=orange!5},
        arrow/.style={-Stealth, thick}
    ]
        \node[block] (shift) {};
        \node[above=0.2cm of shift, font=\bfseries] {Shift\_Reg (Depth Control Line)};

        % Inputs
        \draw[arrow] ([xshift=-1.2cm]shift.north) -- ++(0, 0.8) node[above] {\texttt{Data\_in}};
        \draw[arrow] ([xshift=-0.3cm]shift.north) -- ++(0, 0.8) node[above] {\texttt{valid\_in}};
        \draw[arrow] ([xshift=0.9cm]shift.north) -- ++(0, 0.8) node[above] {\texttt{rst\_n}};
        \draw[arrow] ([yshift=0.8cm]shift.west) -- ++(-1.0, 0) node[left] {\texttt{clk}};

        % Output
        \draw[arrow] (shift.south) -- ++(0, -0.8) node[below] {\texttt{data\_out\_shift}};
    \end{tikzpicture}

    \vspace{1cm}

    % --- 3. MAC Unit Block Diagram (from image_3290d6.png) ---
    \begin{tikzpicture}[
        block/.style={draw, rectangle, minimum width=6.5cm, minimum height=4.5cm, rounded corners, text centered, fill=green!5},
        mult/.style={draw, rectangle, minimum width=0.8cm, minimum height=0.6cm, fill=yellow!20, text centered},
        adder/.style={draw, circle, minimum size=1cm, fill=purple!20, text centered},
        arrow/.style={-Stealth, thick}
    ]
        \node[block] (mac) {};
        \node[above=0.2cm of mac, font=\bfseries] {MAC Unit \& Counter Pipeline};

        % Internal Multipliers
        \node[mult] (m0) at ([xshift=-2.0cm, yshift=0.8cm]mac.center) {$\times$};
        \node[mult] (m1) at ([xshift=-0.7cm, yshift=0.8cm]mac.center) {$\times$};
        \node at ([xshift=0.35cm, yshift=0.8cm]mac.center) {$\dots$};
        \node[mult] (m7) at ([xshift=1.5cm, yshift=0.8cm]mac.center) {$\times$};

        % Central Adder
        \node[adder] (sum) at ([yshift=-0.4cm]mac.center) {$\sum$};

        % Connecting Multipliers to Adder
        \draw[arrow] (m0) -- (sum);
        \draw[arrow] (m1) -- (sum);
        \draw[arrow] (m7) -- (sum);

        % External connections
        \draw[arrow] ([xshift=-1.5cm]mac.north) -- ++(0, 0.8) node[above] {\texttt{Data\_Mac\_in}};
        \draw[arrow] ([yshift=1.2cm]mac.west) -- ++(-1.2, 0) node[left] {\texttt{clk} / \texttt{rst\_n}};
        
        \node[right=0.25cm of mac.east, font=\footnotesize] {if \texttt{counter $\ge$ 8} / \texttt{valid\_count}};

        \draw[arrow] (sum.south) -- ++(0, -1.0) node[below] {\texttt{Data\_Mac\_Out}};
    \end{tikzpicture}

    \caption{Complete Digital System Architecture Reconstructed from Paper Sketches.}
    \label{fig:paper_diagrams}
\end{figure}

\end{document}
