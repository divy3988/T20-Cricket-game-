# T20-Cricket-game-
This project implements a T20 cricket game on a DE10 Lite FPGA board using Verilog. Key features include a pseudorandom number generator (LFSR) to simulate realistic cricket outcomes, user input through buttons, and a seven-segment LED display for scorekeeping. It covers button debouncing, clock management, and logic integration for digital design.
This project simulates a T20 cricket match using an FPGA board (DE10 Lite). Developed in Verilog, it demonstrates core digital design principles while providing an engaging and interactive game experience.

Features
Realistic Cricket Gameplay: Outcomes determined using a pseudorandom number generator (LFSR) to mimic real match probabilities.
Interactive Inputs: User inputs through push buttons to simulate game actions.
Score Display: Runs, wickets, and match status displayed on a seven-segment LED interface.
Modular Design: Clock management, debouncing, and data conversion modules for efficient operation.
Components Required
DE10 Lite FPGA Board
Push Buttons
Seven-Segment LED Display
Setup
Hardware Connections:
Connect push buttons for user input to the DE10 Lite board.
Use onboard LEDs and seven-segment displays for output.
Programming Environment:
Install Quartus Prime to compile and upload Verilog code.
Use the DE10 Lite programmer to load the design onto the FPGA board.
Code Modules
Clock Module: Adjusts the system clock frequency for precise operations.
Debounce Module: Ensures stable button inputs.
Game Logic: Implements cricket match rules, including score updates, wickets, and team switching.
Display Control: Converts binary data into a seven-segment display format.
Game Flow
Start the game with initial inputs.
Press the button for each delivery to simulate scoring or dismissals.
Switch teams after an inning.
View the final result on the display.
Results
The game accurately tracks scores, wickets, and match status, simulating a realistic cricket match.

References
LFSR Explained
Debouncing Techniques
FPGA Basics
License
This project is for educational purposes and demonstrates basic digital design principles.
