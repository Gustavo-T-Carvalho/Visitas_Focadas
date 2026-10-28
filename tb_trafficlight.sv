`timescale 1ns / 1ps

module tb_traffic_light;

    logic clk;
    logic rst;
    logic button;
    logic carGreen;
    logic carYellow;
    logic carRed;
    logic pedestrianGreen;
    logic pedestrianRed;

    // DUT instance
    traffic_light dut (
        .clk(clk),
        .rst(rst),
        .button(button),
        .carGreen(carGreen),
        .carYellow(carYellow),
        .carRed(carRed),
        .pedestrianGreen(pedestrianGreen),
        .pedestrianRed(pedestrianRed)
    );

    // Clock generation (10 ns)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Waveform dump
    initial begin
      $dumpfile("traffic_light.vcd");
      $dumpvars(0, tb_traffic_light);
    end

    // Testbench
    initial begin
        // Initialization
        rst = 0;
        button = 0;
        #10;

        // Reset release
        rst = 1;
      
      	// Wait for a complete cycle (8 cycles = 80 ns)
      	#80
      
        // Wait for CAR_RED (3 cycles = 30 ns)
        #30;

        // Wait for the transition to CAR_GREEN
        // Click button during CAR_GREEN to show the anticipated transition
        #10;  // Wait1 cycle in CAR_GREEN
        button = 1;
        #10;  // One cycle with the button activated (force transition to CAR_YELLOW)
        button = 0;

        // Some cycles more to see the full cycle
        #100;

        $finish;
    end

endmodule
