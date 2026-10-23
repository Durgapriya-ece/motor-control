
module two_motor_pwm (
    // Motor A
    (* iopad_external_pin *) output wire AIN1,
    (* iopad_external_pin *) output wire AIN2,
    (* iopad_external_pin *) output wire PWMA,

    // Motor B
    (* iopad_external_pin *) output wire BIN1,
    (* iopad_external_pin *) output wire BIN2,
    (* iopad_external_pin *) output wire PWMB,

    // Standby
    (* iopad_external_pin *) output wire STBY,

    // Motor A output enables
    (* iopad_external_pin *) output wire AIN1_OE,
    (* iopad_external_pin *) output wire AIN2_OE,
    (* iopad_external_pin *) output wire PWMA_OE,

    // Motor B output enables
    (* iopad_external_pin *) output wire BIN1_OE,
    (* iopad_external_pin *) output wire BIN2_OE,
    (* iopad_external_pin *) output wire PWMB_OE,

    // Standby output enable
    (* iopad_external_pin *) output wire STBY_OE,

    // Oscillator
    (* iopad_external_pin, clkbuf_inhibit *) input wire osc_clk,
    (* iopad_external_pin *) input wire osc_ready,
    (* iopad_external_pin *) output wire osc_en,

    // From button_controller
    input wire motor_enable
);

// Motor directions
assign AIN1 = 1'b0;
assign AIN2 = 1'b1;

assign BIN1 = 1'b1;
assign BIN2 = 1'b0;

// Enable motor driver
assign STBY = 1'b1;

// Output enables
assign AIN1_OE = 1'b1;
assign AIN2_OE = 1'b1;
assign PWMA_OE = 1'b1;

assign BIN1_OE = 1'b1;
assign BIN2_OE = 1'b1;
assign PWMB_OE = 1'b1;

assign STBY_OE = 1'b1;

// Enable oscillator
assign osc_en = 1'b1;

// PWM counter: 50 MHz / 2500 = 20 kHz
reg [11:0] pwm_counter;

always @(posedge osc_clk) begin
    if (!osc_ready)
        pwm_counter <= 12'd0;
    else if (pwm_counter >= 12'd2499)
        pwm_counter <= 12'd0;
    else
        pwm_counter <= pwm_counter + 1'b1;
end

// 25% duty cycle: 625 / 2500
assign PWMA = motor_enable && (pwm_counter < 12'd625);
assign PWMB = motor_enable && (pwm_counter < 12'd625);

endmodule
