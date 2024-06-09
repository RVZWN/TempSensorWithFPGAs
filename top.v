`timescale 1ns / 1ps

module top(
    input         CLK100MHZ,        // nexys clk signal
    inout         TMP_SDA,          // i2c sda on temp sensor - bidirectional
    output        TMP_SCL,          // i2c scl on temp sensor
    output [6:0]  SEG,              // 7 segments of each display
    output [7:0]  AN,               // 8 anodes of 8 displays
    output [15:0] LED               // nexys leds = binary temp in deg C or deg F
    );
    
    wire w_200KHz;                  // 200kHz SCL
    wire [7:0] c_data;              // 8 bits of Celsius temperature data
    wire [7:0] f_data;              // 8 bits of Fahrenheit temperature data

    // Instantiate i2c master
    i2c_master i2cmaster(
        .clk_200KHz(w_200KHz),
        .temp_data(c_data),
        .SDA(TMP_SDA),
        .SCL(TMP_SCL)
    );
    
    // Instantiate 200kHz clock generator
    clkgen_200KHz clkgen(
        .clk_100MHz(CLK100MHZ),
        .clk_200KHz(w_200KHz)
    );
    
    seg7c segcontrol(
        .clk_100MHz(CLK100MHZ),
        .c_data(c_data),
        .f_data(f_data),
        .SEG(SEG),
        .AN(AN)
    );
    
    temp_converter tempconv(
        .c(c_data),
        .f(f_data)
    );
    
    // Set LED values for temperature data
    assign LED[15:8] = f_data;
    assign LED[7:0]  = c_data;

endmodule
