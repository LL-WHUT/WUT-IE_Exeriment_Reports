module counter_en (
    input clk,  //时钟
    input reset_p,  //复位，高电平有效
    input EN,  //使能，高电平有效

    input [4-1:0] A,  //加计数最大值
    input [4-1:0] B,  //减计数最大值
    input D,  //方向，0左1右
    output [4-1:0] Q,  //计数输出
    output Z_carry    //进位标志，高有效。注意这里不能用Z，Z在Verilog有其他含义，表示高阻 
);

  reg [4-1:0] temp_A;
  reg [4-1:0] temp_B;

  reg temp_Z;
  always @(posedge clk or posedge reset_p) begin

    if (reset_p) begin
      temp_A <= 0;
      temp_B <= B;
      temp_Z <= 0;
    end else begin
      if (EN) begin
        if (D == 1'b1) begin
          if (temp_A < A) begin
            temp_A <= temp_A + 1'b1;
            temp_Z <= 1'b0;
          end else begin
            temp_A <= 4'b0;
            temp_Z <= 1'b1;
          end
        end else if (D == 1'b0) begin
          if (temp_B > 0) begin
            temp_B = temp_B - 1'b1;
            temp_Z <= 1'b0;
          end else begin
            temp_B <= B;
            temp_Z <= 1'b1;
          end
        end
      end
    end

  end

  assign Q = (D == 1'b1) ? temp_A : temp_B;
  assign Z_carry = temp_Z;
endmodule