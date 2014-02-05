/*

  led_decoder.v
  
  Decoder for 7-seg LED.
  
 */

module led_decoder (
	input  [3:0] dat_in,
	input  dot_in,
	input  en,
	output reg [7:0] led_n
);

wire [7:0] dp = dot_in ? 8'b00000000 : 8'b10000000;

always @* begin
  if (en) begin
    case (dat_in)
      4'h0: led_n = 8'b01000000 | dp;
      4'h1: led_n = 8'b01111001 | dp;
      4'h2: led_n = 8'b00100100 | dp;
      4'h3: led_n = 8'b00110000 | dp;
      4'h4: led_n = 8'b00011001 | dp;
      4'h5: led_n = 8'b00010010 | dp;
      4'h6: led_n = 8'b00000010 | dp;
      4'h7: led_n = 8'b01011000 | dp;
      4'h8: led_n = 8'b00000000 | dp;
      4'h9: led_n = 8'b00010000 | dp;
      4'ha: led_n = 8'b00001000 | dp;
      4'hb: led_n = 8'b00000011 | dp;
      4'hc: led_n = 8'b01000110 | dp;
      4'hd: led_n = 8'b00100001 | dp;
      4'he: led_n = 8'b00000110 | dp;
      4'hf: led_n = 8'b00001110 | dp;
		endcase
	end else
		led_n = 8'b11111111 | dp; 
end

endmodule