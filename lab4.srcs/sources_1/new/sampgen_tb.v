`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2025 08:31:11 AM
// Design Name: 
// Module Name: sampgen_tb
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


module sampgen_tb;

  //==========================================================================
  // Parameters
  //==========================================================================
  parameter NSAMP_WID = 10;
  parameter NSAMP = 16; // số lượng mẫu sóng trong RAM

  //==========================================================================
  // DUT I/O
  //==========================================================================
  reg clk_tx;
  reg clk_samp;
  reg rst_clk_tx;
  reg rst_clk_samp;
  reg en_clk_samp;
  reg samp_gen_go_clk_rx;
  reg [NSAMP_WID:0] nsamp_clk_tx;
  reg [15:0] spd_clk_tx;
  wire [NSAMP_WID-1:0] samp_gen_samp_ram_addr;
  reg  [15:0] samp_gen_samp_ram_dout;
  wire [15:0] samp;
  wire samp_val;
  wire [7:0] led_o;

  //==========================================================================
  // Instantiate DUT
  //==========================================================================
  samp_gen #(
    .NSAMP_WID(NSAMP_WID)
  ) dut (
    .clk_tx(clk_tx),
    .rst_clk_tx(rst_clk_tx),
    .clk_samp(clk_samp),
    .rst_clk_samp(rst_clk_samp),
    .en_clk_samp(en_clk_samp),
    .samp_gen_go_clk_rx(samp_gen_go_clk_rx),
    .nsamp_clk_tx(nsamp_clk_tx),
    .spd_clk_tx(spd_clk_tx),
    .samp_gen_samp_ram_addr(samp_gen_samp_ram_addr),
    .samp_gen_samp_ram_dout(samp_gen_samp_ram_dout),
    .samp(samp),
    .samp_val(samp_val),
    .led_o(led_o)
  );

  //==========================================================================
  // Clock generation
  //==========================================================================
  initial begin
    clk_tx = 0;
    forever #10 clk_tx = ~clk_tx; // 100 MHz
  end

  initial begin
    clk_samp = 0;
    forever #16 clk_samp = ~clk_samp; // ~62.5 MHz
  end

  //==========================================================================
  // Generate en_clk_samp (đồng bộ phase giữa 2 clock)
  //==========================================================================
  always @(posedge clk_tx)
    en_clk_samp <= (clk_tx && clk_samp); // mô phỏng đơn giản

  //==========================================================================
  // Stimulus
  //==========================================================================
  //integer i;
  initial begin
    // Khởi tạo tín hiệu
    rst_clk_tx = 1;
    rst_clk_samp = 1;
    samp_gen_go_clk_rx = 0;
    nsamp_clk_tx = NSAMP;
    spd_clk_tx = 5; // khoảng cách 5 chu kỳ clk_samp giữa các mẫu
    en_clk_samp = 0;
    samp_gen_samp_ram_dout = 16'h0000;

    // Reset trong 100 ns
    #100;
    rst_clk_tx = 0;
    rst_clk_samp = 0;

    // Sau reset 50 ns, kích hoạt start
    #50;
    samp_gen_go_clk_rx = 1;
    #20;
    samp_gen_go_clk_rx = 0;

    // Mô phỏng dữ liệu trong RAM (sóng sin mẫu)
    // (ở thực tế, RAM là block RAM, ở đây chỉ tạo mẫu theo địa chỉ)
    forever begin
      @(posedge clk_samp);
samp_gen_samp_ram_dout <= (samp_gen_samp_ram_addr * 16'h0100) + 16'h0010;
    end
  end

  
endmodule
