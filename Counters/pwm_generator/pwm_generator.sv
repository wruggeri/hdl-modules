`begin_keywords "1800-2017"

module pwm_generator
	#(parameter n_bit = 8)
	(input clock, enable, reset, load, 
	input [n_bit - 1:0] threshold, 
	output [n_bit - 1:0] count, 
	output pwm);
    
	timeunit 1ns/1ps;
	
    reg[n_bit - 1:0] threshold_register;
    reg[n_bit - 1:0] count_register;
    
    assign pwm = (count_register > threshold_register);
    assign count = count_register;
    
    always_ff@(posedge clock, posedge reset)
    begin
        if (reset == 1)
        begin
            threshold_register <= 'd0;
            count_register <= 'd0;
        end
        else 
        begin
            if (load == 1)
                threshold_register <= threshold;
            else if (enable == 1)
                count_register <= count_register + 1;        
        end
    end
endmodule

`end_keywords
