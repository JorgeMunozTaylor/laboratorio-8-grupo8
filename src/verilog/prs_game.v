/*
    Created by Jorge Muñoz Taylor
    Carné A53863
    IE0424
    Laboratory 8
    II-2020
*/

/*
Module for the game rock, sissors and paper.
*/
module prs_game
(
    input       CLK,
    input       RESET,
    input       enable,
    input       data_PS2,
    input       CLK_PS2,
    input [3:0] text,

    output reg   transfer_ready,
    output reg   selection,
    output reg   click,
    output [7:0] catodes,
    output [7:0] anodes
);
    assign ready = 0;
	/**/
	text_display TEXT_DISPLAY
	(
		.CLK     ( CLK     ),
		.RESET   ( RESET   ),
		.enable  ( enable  ),
		.text    ( text    ),
		.catodes ( catodes ),
		.anodes  ( anodes  )
	);

    initial selection      = 0; // 1 If the scrool wheel has been moved
    initial transfer_ready = 0; // 1 if the mouse end the bits transfer

    reg [3:0] clk_counter    = 0; // Count the mouse CLK negedge clocks
    reg [1:0] byte_counter   = 0; // Count the bytes that has been transfered

    reg [7:0] byte_0 = 0; // Store the first byte that contain the right click data
    reg [7:0] byte_3 = 0; // Store the last byte that contain the scroll wheel data

    

    /**/
    always @( negedge CLK_PS2 )
    begin
        // Start bit
        if ( clk_counter == 0 && data_PS2 == 0)
        begin
            clk_counter    <= clk_counter + 1;
            transfer_ready = 0;
        end

        // Stop bit
        else if ( clk_counter == 10 && data_PS2 == 1 )
        begin
            clk_counter <= 0;

            if ( byte_counter == 3 )
            begin
                byte_counter   = 0;
                transfer_ready = 1;
            end
            else    
                byte_counter = byte_counter + 1;
        end

        // Parity bit
        else if ( clk_counter == 9 )
        begin
            clk_counter <= clk_counter + 1;
        end

        // Byte store in the registers
        else
        begin

            if ( byte_counter == 0 )
            begin
                case ( clk_counter )
                4'b0001: byte_0 [0] = data_PS2;
                4'b0010: byte_0 [1] = data_PS2;
                4'b0011: byte_0 [2] = data_PS2;
                4'b0100: byte_0 [3] = data_PS2;
                4'b0101: byte_0 [4] = data_PS2;
                4'b0110: byte_0 [5] = data_PS2;
                4'b0111: byte_0 [6] = data_PS2;
                4'b1000: byte_0 [7] = data_PS2;
                default: byte_0 = 8'b0;
                endcase    
            end

            else if ( byte_counter == 3 )
            begin
                case ( clk_counter )
                4'b0001: byte_3 [0] = data_PS2;
                4'b0010: byte_3 [1] = data_PS2;
                4'b0011: byte_3 [2] = data_PS2;
                4'b0100: byte_3 [3] = data_PS2;
                4'b0101: byte_3 [4] = data_PS2;
                4'b0110: byte_3 [5] = data_PS2;
                4'b0111: byte_3 [6] = data_PS2;
                4'b1000: byte_3 [7] = data_PS2;
                default: byte_3 = 8'b0;
                endcase                
            end

            clk_counter <= clk_counter + 1;
        end

    end //Always end

    


    // Right click
    always @( posedge CLK )
    begin
        if ( transfer_ready == 1 )
        begin
            // The right click state is store in the byte_0[1] position
            if ( byte_0 [1] == 1 ) 
                click <= 1;
            else
                click <= 0;  
        end      
    end // Always end


    // Scroll wheel
    always @( posedge CLK )
    begin

        // The move of the wheel is stored in the first 4 bits o the 4 byte
        // trasmitted by the mouse, that bits was stored in byte_3[3:0] position.
        if ( transfer_ready == 1 )
        begin
            if ( byte_3 [3:0] != 0 ) 
                selection = 1;                     
        end
        else 
            selection = 0;
        
    end //Always end

endmodule