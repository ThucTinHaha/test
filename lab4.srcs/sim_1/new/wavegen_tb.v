`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2025 07:52:34 AM
// Design Name: 
// Module Name: wavegen_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module wavegen_tb;

  //==================================================
  // Inputs
  //==================================================
  reg clk_pin;
  reg rst_pin;
  reg lb_sel_pin;
  reg rxd_pin;

  //==================================================
  // Outputs
  //==================================================
  wire txd_pin;
  wire spi_clk_pin;
  wire spi_mosi_pin;
  wire dac_cs_n_pin;
  wire dac_clr_n_pin;
  wire [7:0] led_pins;

  //==================================================
  // DUT
  //==================================================
  wave_gen dut (
    .clk_pin(clk_pin),
    .rst_pin(rst_pin),
    .lb_sel_pin(lb_sel_pin),
    .rxd_pin(rxd_pin),
    .txd_pin(txd_pin),
    .spi_clk_pin(spi_clk_pin),
    .spi_mosi_pin(spi_mosi_pin),
    .dac_cs_n_pin(dac_cs_n_pin),
    .dac_clr_n_pin(dac_clr_n_pin),
    .led_pins(led_pins)
  );
    
  //==================================================
  // Clock generation (125 MHz ~ 8ns period)
  //==================================================
  always begin
     #4 clk_pin = ~clk_pin;
  end
  
    //==================================================
  // Task: UART transmitter model (8N1, 115200 bps)
  //==================================================
  parameter real t_bit = 1e9/115200; // ~8680.(5) ns per bit
  
  task send_uart_char;
    input [7:0] ch;
    integer i;
  begin
    // start bit (0)
    rxd_pin = 0;
    #(t_bit);
    
    // data bits (LSB first)
    for (i=0; i<8; i=i+1) begin
      rxd_pin = ch[i];
      #(t_bit);
    end
    // stop bit (1)
    rxd_pin = 1;
    #(t_bit);
  end
  endtask
  
  //==================================================
  // Stimulus
  //==================================================
  initial begin
    // Initialize
    clk_pin = 0;
    rxd_pin = 1;
    rst_pin = 1;
    lb_sel_pin = 1;
    
    #50;
    rst_pin = 0;
    #50;
    
    // Send UART
    send_uart_char("*"); 
    send_uart_char("P");
    send_uart_char("0"); 
    send_uart_char("0");
    send_uart_char("2"); 
    send_uart_char("0"); 
    
    send_uart_char("*"); 
    send_uart_char("S");
    send_uart_char("0"); 
    send_uart_char("0");
    send_uart_char("1"); 
    send_uart_char("0"); 
    
    send_uart_char("*"); 
    send_uart_char("N");
    send_uart_char("0"); 
    send_uart_char("0");
    send_uart_char("0"); 
    send_uart_char("2");
    
    
    send_uart_char("*"); 
    send_uart_char("W"); 
    send_uart_char("0"); 
    send_uart_char("0");
    send_uart_char("0"); 
    send_uart_char("0");
    send_uart_char("A"); 
    send_uart_char("B");
    send_uart_char("0"); 
    send_uart_char("0");
    
    send_uart_char("*"); 
    send_uart_char("W"); 
    send_uart_char("0"); 
    send_uart_char("0");
    send_uart_char("0"); 
    send_uart_char("1");
    send_uart_char("1"); 
    send_uart_char("2");
    send_uart_char("0"); 
    send_uart_char("0");
    
    
    send_uart_char("*"); 
    send_uart_char("G");
    #10000;
    
    
    send_uart_char("*"); 
    send_uart_char("C");
    #10000;
    send_uart_char("*"); 
    send_uart_char("H");
    
  end
  
endmodule
