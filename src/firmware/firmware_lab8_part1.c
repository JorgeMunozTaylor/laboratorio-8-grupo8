/*
    Created by Jorge Muñoz Taylor
    Carné A53863
    IE0424
    Laboratory 8
    II-2020
*/

#include <stdint.h>

#define LED_REGISTERS_MEMORY_ADD 0x10000000
#define LOOP_WAIT_LIMIT 4000000

static void putuint(uint32_t i) {
	*((volatile uint32_t *)LED_REGISTERS_MEMORY_ADD) = i;
}

void main() 
{
	uint32_t counter;
	uint32_t text;

	// Put the code 0 and sum 1 after a delay time for show all
	// texts on the displays
	
	text = 0;
	
	while (1) 
	{
		putuint ( text );
		
		counter = 0;
		while (counter < LOOP_WAIT_LIMIT) 
		{
			counter++;
		}

		if ( text==8 )
			text = 0;
		else
			text++;
	}
}//Main end