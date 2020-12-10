/*
    Created by Jorge Muñoz Taylor
    Carné A53863
    IE0424
    Laboratory 8
    II-2020
*/

#include <stdint.h>

#define LED_REGISTERS_MEMORY_ADD 0x10000000
#define GET_SELECTION    		 0x10000008
#define GET_CLICK                0x1000000C
#define GET_RANDOM               0x20000000
#define LOOP_WAIT_LIMIT          5000000
#define SELECT_WAIT_TIME         3000000

#define PAPER    2
#define SCISSORS 3
#define ROCK     4
#define YOU_WON  6
#define YOU_LOST 7
#define TIE      8


/* Store a value in a memory position */
static void putuint(uint32_t i) {
	*((volatile uint32_t *)LED_REGISTERS_MEMORY_ADD) = i;
}

/* A simple delay function */
void Delay ( uint32_t TIME)
{
	uint32_t counter;

	counter = 0;
	while (counter < TIME) 
	{
		counter++;
	}
}

/**/
void main() 
{
	uint32_t text;
	uint32_t click;
	uint32_t selection;
	uint32_t user_selection;


	while (1) 
	{
		// Start text
		text = 0;
		putuint ( text );
		Delay(LOOP_WAIT_LIMIT);

		// Select text
		text = 1;
		putuint ( text );
		Delay(LOOP_WAIT_LIMIT);

		text = PAPER; 
		click = 0;

		while ( click == 0 )
		{
			// Get option selected by the user
			selection = *((volatile uint32_t *) GET_SELECTION);

			if (selection==1) 
			{
				if ( text != ROCK )
					text = text+1;
				else
					text = PAPER;
			}
		
			putuint ( text );

			click = *((volatile uint32_t *) GET_CLICK  );
		}

		// Store the user selection
		user_selection = text;
		Delay (SELECT_WAIT_TIME);

		// Rival text
		text = 5;
		putuint ( text );
		Delay (LOOP_WAIT_LIMIT);

		// Rival selection
		text = *((volatile uint32_t *) GET_RANDOM);
		text = text + PAPER;
		putuint ( text );
		Delay(LOOP_WAIT_LIMIT);

		// Who won?
		if      ( user_selection == PAPER && text == PAPER       ) text = TIE;
		else if ( user_selection == PAPER && text == SCISSORS    ) text = YOU_LOST;
		else if ( user_selection == PAPER && text == ROCK        ) text = YOU_WON;
		else if ( user_selection == SCISSORS && text == PAPER    ) text = YOU_WON;
		else if ( user_selection == SCISSORS && text == SCISSORS ) text = TIE;
		else if ( user_selection == SCISSORS && text == ROCK     ) text = YOU_LOST;
		else if ( user_selection == ROCK && text == PAPER        ) text = YOU_LOST;
		else if ( user_selection == ROCK && text == SCISSORS     ) text = YOU_WON;
		else if ( user_selection == ROCK && text == ROCK         ) text = TIE;

		putuint ( text );
		Delay (LOOP_WAIT_LIMIT);
		Delay (LOOP_WAIT_LIMIT);
	}
}//Main end