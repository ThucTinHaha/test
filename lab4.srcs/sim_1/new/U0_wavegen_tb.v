`timescale 1ns/1ps

module wave_gen_tb;

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
  // Clock generation (100 MHz ~ 10ns period)
  //==================================================
  initial begin
    clk_pin = 0;
    forever #5 clk_pin = ~clk_pin;
  end

  //==================================================
  // Stimulus
  //==================================================
  initial begin
    // reset
    rst_pin = 1;
    lb_sel_pin = 0;
    rxd_pin = 1; // idle state của UART là mức '1'
    #100;
    rst_pin = 0;

    // ví dụ gửi ký tự '*N000A' qua UART RX
    /*
    send_uart_char("*");
    send_uart_char("N");
    send_uart_char("0");
    send_uart_char("0");
    send_uart_char("0");
    send_uart_char("A");*/
    send_uart_char(8'h2A); // '*'
    send_uart_char(8'h4E); // 'N'
    send_uart_char(8'h30); // '0'
    send_uart_char(8'h30); // '0'
    send_uart_char(8'h30); // '0'
    send_uart_char(8'h41); // 'A'

    // đợi vài us
    #5000;

    // bật loopback
    lb_sel_pin = 1;
    #2000;

    // gửi tiếp lệnh *G (GO)
    send_uart_char("*");
    send_uart_char("G");

    #10000;
    $stop;
  end

  //==================================================
  // Task: UART transmitter model (8N1, 115200 bps)
  //==================================================
  task send_uart_char;
    input [7:0] ch;
    integer i;
    real bit_time;
  begin
    bit_time = 1e9/115200; // ns per bit
    // start bit (0)
    rxd_pin = 0;
    #(bit_time);
    // data bits (LSB first)
    for (i=0; i<8; i=i+1) begin
      rxd_pin = ch[i];
      #(bit_time);
    end
    // stop bit (1)
    rxd_pin = 1;
    #(bit_time);
  end
  endtask

endmodule