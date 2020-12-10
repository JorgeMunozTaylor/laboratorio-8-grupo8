/*
    Created by Jorge Muñoz Taylor
    Carné A53863
    IE0424
    Laboratory 8
    II-2020
*/

/* Define the code of the letter that will be used in the program */
`define A 8'b1010_0000
`define C 8'b1010_0111
`define E 8'b1000_0110 
`define I 8'b1110_1110
`define K 8'b1000_1010
`define L 8'b1100_0111
`define N 8'b1010_1011
`define O 8'b1010_0011
`define P 8'b1000_1100
`define R 8'b1010_1111
`define S 8'b1101_0010
`define T 8'b1000_0111
`define U 8'b1110_0011
`define V 8'b1101_0101
`define W 8'b1001_0101
`define Y 8'b1001_0001


// Delay for refresh the 7 segment displays.
`define LIMIT 100000

/*
    Module that displays text on the 7 segment displays.
*/
module text_display
(
    input        CLK,
    input        RESET,
    input        enable,
    input  [3:0] text,

    output reg [7:0] catodes,
    output reg [7:0] anodes
);
    reg [2:0] counter     = 0; // Used to refresh every display, ie: if 0 then the display 0 is on, etc.
    integer   num_counter = 0; // Counter used to activate every display, one by one.

    /**/
    always @( posedge CLK )
    begin
        if ( RESET==1 )
        begin
            if ( enable == 1 )
            begin
                if ( num_counter == `LIMIT )
                begin

                    // Start
                    if ( text == 0 )
                    begin   
                        
                        case (counter)
                            3'b000: 
                            begin
                                anodes  = 8'b1111_1110;
                                catodes = `T;
                            end
                            3'b001:
                            begin
                                anodes  = 8'b1111_1101;
                                catodes = `R;
                            end
                            3'b010:
                            begin
                                anodes  = 8'b1111_1011;
                                catodes = `A;
                            end
                            3'b011:
                            begin
                                anodes  = 8'b1111_0111;
                                catodes = `T;
                            end
                            3'b100:
                            begin
                                anodes  = 8'b1110_1111;
                                catodes = `S;
                            end
                            3'b101: anodes  = 8'b1111_1111;  
                            3'b110: anodes  = 8'b1111_1111;
                            3'b111: anodes  = 8'b1111_1111;
                            default: anodes  = 8'b1000_0000;
                        endcase

                        if (counter !=7 ) counter = counter+1;
                        else              counter = 0;

                    end

                    // Select:
                    else if ( text == 1 )
                    begin
                        case (counter)
                            3'b000: 
                            begin
                                anodes  = 8'b1111_1110;
                                catodes = 8'b0000_0111;
                            end
                            3'b001:
                            begin
                                anodes  = 8'b1111_1101;
                                catodes = `C;
                            end
                            3'b010:
                            begin
                                anodes  = 8'b1111_1011;
                                catodes = `E;
                            end
                            3'b011:
                            begin
                                anodes  = 8'b1111_0111;
                                catodes = `L;
                            end
                            3'b100:
                            begin
                                anodes  = 8'b1110_1111;
                                catodes = `E;
                            end
                            3'b101:
                            begin
                                anodes  = 8'b1101_1111;
                                catodes = `S;
                            end 
                            3'b110: anodes  = 8'b1111_1111;
                            3'b111: anodes  = 8'b1111_1111; 
                            default: anodes  = 8'b1000_0000;
                        endcase

                        if (counter !=7 ) counter = counter+1;
                        else              counter = 0;                
                    end
        
                    // Paper
                    else if ( text == 2 )
                    begin
                        case (counter)
                            3'b000: 
                            begin
                                anodes  = 8'b1111_1110;
                                catodes = `R;
                            end
                            3'b001:
                            begin
                                anodes  = 8'b1111_1101;
                                catodes = `E;
                            end
                            3'b010:
                            begin
                                anodes  = 8'b1111_1011;
                                catodes = `P;
                            end
                            3'b011:
                            begin
                                anodes  = 8'b1111_0111;
                                catodes = `A;
                            end
                            3'b100:
                            begin
                                anodes  = 8'b1110_1111;
                                catodes = `P;
                            end
                            3'b101: anodes  = 8'b1111_1111;
                            3'b110: anodes  = 8'b1111_1111;
                            3'b111: anodes  = 8'b1111_1111;
                            default: anodes  = 8'b1000_0000;
                        endcase

                        if (counter !=7 ) counter = counter+1;
                        else              counter = 0;                       
                    end
        
                    // Scissors
                    else if ( text == 3 )
                    begin
                        case (counter)
                            3'b000: 
                            begin
                                anodes  = 8'b1111_1110;
                                catodes = `S;
                            end
                            3'b001:
                            begin
                                anodes  = 8'b1111_1101;
                                catodes = `R;
                            end
                            3'b010:
                            begin
                                anodes  = 8'b1111_1011;
                                catodes = `O;
                            end
                            3'b011:
                            begin
                                anodes  = 8'b1111_0111;
                                catodes = `S;
                            end
                            3'b100:
                            begin
                                anodes  = 8'b1110_1111;
                                catodes = `S;
                            end
                            3'b101: 
                            begin
                                anodes  = 8'b1101_1111;
                                catodes = `I;
                            end
                            3'b110: 
                            begin
                                anodes  = 8'b1011_1111;
                                catodes = `C;
                            end
                            3'b111: 
                            begin
                                anodes  = 8'b0111_1111;
                                catodes = `S;
                            end
                            default: anodes  = 8'b1000_0000;
                        endcase

                        if (counter !=7 ) counter = counter+1;
                        else              counter = 0;         
                    end
        
                    // Rock
                    else if ( text == 4 )
                    begin
                        case (counter)
                            3'b000: 
                            begin
                                anodes  = 8'b1111_1110;
                                catodes = `K;
                            end
                            3'b001:
                            begin
                                anodes  = 8'b1111_1101;
                                catodes = `C;
                            end
                            3'b010:
                            begin
                                anodes  = 8'b1111_1011;
                                catodes = `O;
                            end
                            3'b011:
                            begin
                                anodes  = 8'b1111_0111;
                                catodes = `R;
                            end
                            3'b100: anodes  = 8'b1111_1111;
                            3'b101: anodes  = 8'b1111_1111;
                            3'b110: anodes  = 8'b1111_1111;
                            3'b111: anodes  = 8'b1111_1111;
                            default: anodes  = 8'b1000_0000;
                        endcase

                        if (counter !=7 ) counter = counter+1;
                        else              counter = 0;       
                    end
        
                    // Rival
                    else if ( text == 5 )
                    begin
                        case (counter)
                            3'b000: 
                            begin
                                anodes  = 8'b1111_1110;
                                catodes = 8'b0100_0111;
                            end
                            3'b001:
                            begin
                                anodes  = 8'b1111_1101;
                                catodes = `A;
                            end
                            3'b010:
                            begin
                                anodes  = 8'b1111_1011;
                                catodes = `V;
                            end
                            3'b011:
                            begin
                                anodes  = 8'b1111_0111;
                                catodes = `I;
                            end
                            3'b100:
                            begin
                                anodes  = 8'b1110_1111;
                                catodes = `R;
                            end
                            3'b101: anodes  = 8'b1111_1111;
                            3'b110: anodes  = 8'b1111_1111;
                            3'b111: anodes  = 8'b1111_1111;
                            default: anodes  = 8'b1000_0000;
                        endcase

                        if (counter !=7 ) counter = counter+1;
                        else              counter = 0;             
                    end
        
                    // You won
                    else if ( text == 6 )
                    begin
                        case (counter)
                            3'b000: 
                            begin
                                anodes  = 8'b1111_1110;
                                catodes = `N;
                            end
                            3'b001:
                            begin
                                anodes  = 8'b1111_1101;
                                catodes = `O;
                            end
                            3'b010:
                            begin
                                anodes  = 8'b1111_1011;
                                catodes = `W;
                            end
                            3'b011: anodes  = 8'b1111_1111;

                            3'b100:
                            begin
                                anodes  = 8'b1110_1111;
                                catodes = `U;
                            end
                            3'b101: 
                            begin
                                anodes  = 8'b1101_1111;
                                catodes = `O;
                            end
                            3'b110: 
                            begin
                                anodes  = 8'b1011_1111;
                                catodes = `Y;
                            end
                            3'b111: anodes  = 8'b1111_1111;
                            default: anodes  = 8'b1000_0000;
                        endcase

                        if (counter !=7 ) counter = counter+1;
                        else              counter = 0;             
                    end
        
                    // You lost
                    else if ( text == 7 )
                    begin
                        case (counter)
                            3'b000: 
                            begin
                                anodes  = 8'b1111_1110;
                                catodes = `T;
                            end
                            3'b001:
                            begin
                                anodes  = 8'b1111_1101;
                                catodes = `S;
                            end
                            3'b010:
                            begin
                                anodes  = 8'b1111_1011;
                                catodes = `O;
                            end
                            3'b011:
                            begin
                                anodes  = 8'b1111_0111;
                                catodes = `L;
                            end

                            3'b100: anodes  = 8'b1111_1111;

                            3'b101:
                            begin
                                anodes  = 8'b1101_1111;
                                catodes = `U;
                            end
                            3'b110: 
                            begin
                                anodes  = 8'b1011_1111;
                                catodes = `O;
                            end
                            3'b111: 
                            begin
                                anodes  = 8'b0111_1111;
                                catodes = `Y;
                            end
                            
                            default: anodes = 8'b1000_0000;
                        endcase

                        if (counter !=7 ) counter = counter+1;
                        else              counter = 0;           
                    end
        
                    // Tie
                    else if ( text == 8 )
                    begin
                        case (counter)
                            3'b000: 
                            begin
                                anodes  = 8'b1111_1110;
                                catodes = `E;
                            end
                            3'b001:
                            begin
                                anodes  = 8'b1111_1101;
                                catodes = `I;
                            end
                            3'b010:
                            begin
                                anodes  = 8'b1111_1011;
                                catodes = `T;
                            end
                            3'b011: anodes  = 8'b1111_1111;
                            3'b100: anodes  = 8'b1111_1111;
                            3'b101: anodes  = 8'b1111_1111; 
                            3'b110: anodes  = 8'b1111_1111;
                            3'b111: anodes  = 8'b1111_1111;
                            default: anodes  = 8'b1000_0000;
                        endcase

                        if (counter !=7 ) counter = counter+1;
                        else              counter = 0;                    
                    end

                    // Re-init the num_counter (delay).
                    num_counter = 0;

                end
                else 
                    num_counter = num_counter+1;
            end
        end

        // When reset only the first display is on, and it shows a 0.
        else
        begin
            anodes  = 8'b1111_1110;
            catodes = 8'b1100_0000;
        end

    end // Always end

endmodule