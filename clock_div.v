`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2021 08:49:09 PM
// Design Name: 
// Module Name: clock_div
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

/*
To make any clock divider just put your mod and the number of bits of the counter
and modify the duty cycle by observing the MSB from the truth table
 * if you need to make a half clock cycle delay use Q_intermadiate3 if you don't need it remove it from the code
 * if you need to make a one clock cycle delay use Q_intermadiate2 if you don't need it remove it from the code
 * if you won't use the duty cycle cct your output will be Q_intermediate1
*/

module clock_div #(parameter modN = 5, parameter n = 3)(  // n for counter bits
    input clk,
    input rst,
    output clk_out
    );

reg [n-1:0] count;
reg Q_intermadiate1;
reg Q_intermadiate2;
reg Q_intermadiate3;

always @(posedge clk or negedge rst)
    begin
        if(!rst)
            begin
                count           <= 3'd0;                           //
                Q_intermadiate1 <= 1'b0;  
            end
        else 
            begin
                if(count[n-1] == 1'b1 || count == modN-1) // this condition will be modified when changing the modN, write the truth table for the counter and alwyas take the MSB
                    begin
                        if(count == modN-1)
                            count <= 3'd0;             //
                        else 
                            count <= count + 1'b1;
                        Q_intermadiate1 <= 1'b1;
                    end
                else begin
                    count           <= count + 1'b1;
                    Q_intermadiate1 <= 1'b0;
                    end
            end
    end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////// to make the duty cycle = 50 % ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////
//////// Delay by one clock cycle /////////
///////////////////////////////////////////
always @(posedge clk or negedge rst)
    begin
        if(!rst)
            Q_intermadiate2 <= 1'b0;
        else    
            Q_intermadiate2 <= Q_intermadiate1;
    end
////////////////////////////////////////////
//////// Delay by half clock cycle /////////
////////////////////////////////////////////
always @(negedge clk or negedge rst)
    begin
        if(!rst)
            Q_intermadiate3 <= 1'b0;
        else    
            Q_intermadiate3 <= Q_intermadiate2;
    end
 assign clk_out = Q_intermadiate1 | Q_intermadiate2 | Q_intermadiate3;
endmodule
