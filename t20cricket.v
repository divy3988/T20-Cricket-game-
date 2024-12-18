module project( 
    input clk_fpga,    
    input reset,        
    input btnU,        
    input sw,     // switch between Team 1 and Team 2  
      
    output [0:6] segW, segO, segT, segH,   
    output [6:0] Y, 
    output [7:0] led  // drive the leds 
    ); 
   
  wire delivery;            // debounced up button press  
  wire [7:0] binaryRuns;    // runs from game  
  wire [3:0] binaryWickets; // wickets from game  
  wire inningOver;          // signal from match to bcd display to show 10 (inning over) on display  
  wire gameOver;            // signal from match to bcd display to lock in winner on display  
  wire winner;              // signal from match to bcd display to select winner to display 
   
  debounce d0(clk_fpga, btnU, delivery); 
  cricketGame g0(clk_fpga, reset, delivery, sw, binaryRuns, 
  binaryWickets, led, inningOver, gameOver, winner, Y);  
  bcdDisplay b0(clk_fpga, binaryRuns, binaryWickets, 
  inningOver, gameOver, winner, segW, segO, segT, segH); 
   
endmodule 

module debounce( 
    input clk_fpga,  
    input button,   
    output debounced_button 
    ); 
   
  wire Q1;  
  wire Q2;  
  wire Q2_bar; 
   
  slowClock_10Hz u1(clk_fpga, clk_10Hz); 
  D_FF d1(clk_10Hz, button, Q1);  
  D_FF d2(clk_10Hz, Q1, Q2);   
   
  assign Q2_bar = ~Q2;    
  assign debounced_button = Q1 & Q2_bar; 
endmodule 

module D_FF( 
    input clk, 
    input D,   
    output reg Q, 
    output reg Qbar 
    ); 
   
  always @ (posedge clk) begin 
    Q <= D; 
    Qbar <= !Q; 
  end 
endmodule 

module cricketGame( 
    input clk_fpga, 
    input reset, 
    input delivery, 
    input teamSwitch, 
    output [7:0] runs, 
    output [3:0] wickets, 
    output [7:0] leds, 
    output inningOver, 
    output gameOver, 
    output winner, 
    output [6:0] y 
    ); 
  wire clk_10; 
  wire [11:0] team1Data; 
  wire [11:0] team2Data; 
  wire [6:0] team1Balls; 
  wire [6:0] team2Balls; 
  wire [3:0] lfsr_out; 
   
  slowClock_10Hz(clk_fpga, clk_10); 
  lfsr g1(clk_10, reset, lfsr_out); 
  lab6(y, lfsr_out); 
  score_and_wickets g2(clk_10, reset, delivery, teamSwitch, 
  lfsr_out, gameOver, runs, wickets, team1Data, team2Data); 
  score_comparator g3(clk_10, reset, team1Data, team2Data, 
  team1Balls, team2Balls, wickets, leds, inningOver, gameOver, winner); 
  led_controller g4(clk_10, reset, teamSwitch, delivery, lfsr_out, 
  inningOver, gameOver, leds, team1Balls, team2Balls); 
endmodule 

module lfsr( 
    input clk_fpga,  
    input reset, 
    output [3:0] lfsr_out 
    ); 
   
  reg [5:0] shift; 
  wire xor_sum; 
   
  assign xor_sum = shift[1] ^ shift[4]; 
  always @ (posedge clk_fpga) begin 
    if(reset) 
      shift <= 6'b111111; 
    else 
      shift <= {xor_sum, shift[5:1]}; 
  end 
  assign lfsr_out = shift[3:0]; 
endmodule 

module score_and_wickets( 
    input clk_fpga, 
    input reset, 
    input delivery, 
    input teamSwitch, 
    input [3:0] lfsr_out, 
    input gameOver, 
    output reg [7:0] runs, 
    output reg [3:0] wickets, 
    output reg [11:0] team1Data, 
    output reg [11:0] team2Data  
    ); 
   
  localparam single = 16; 
  localparam double = 32; 
  localparam triple = 48; 
  localparam four = 64; 
  localparam six = 96; 
   
  always @ (posedge clk_fpga, posedge reset) begin 
    if (reset) begin 
      runs <= 0; 
      wickets <= 0; 
      team1Data <= 0; 
      team2Data <= 0; 
    end else if (gameOver) begin 
      runs <= runs; 
      wickets <= wickets; 
    end else if(delivery) begin 
      if((~teamSwitch) && (wickets < 10)) begin 
        case (lfsr_out) 
          0, 1, 2: team1Data <= team1Data;  
          3, 4, 5, 6: team1Data <= team1Data + single; 
          7, 8, 9: team1Data <= team1Data + double; 
          10: team1Data <= team1Data + triple; 
          11: team1Data <= team1Data + four; 
          12: team1Data <= team1Data + six; 
          15: team1Data <= team1Data + 1;  
        endcase 
        runs <= team1Data[11:4]; 
        wickets <= team1Data[3:0]; 
      end 
    end 
  end 
endmodule 
