//
// ;*** define your project wide constants here
// 
// ;*** I like to keep memory locations at top of this file
//
PMGBASE = $4000;
FREE_BOTTOM = $6000;  // and sometimes I like to do some relative addressing
DISPLAY_LIST_ADDRESS = FREE_BOTTOM - $200; 
BACKGROUND_MEM = $6000;

RMT_PLAYER_ADDRESS = $A400;
RMT_MODULE_ADDRESS = $AC00;


// ;*** and here goes all other stuff

NONE = $ff;
_HEIGHT = 22;
_SIZE = 84;


	joy_none	= 15;
	joy_up		= 14;
	joy_down	= 13;
	joy_left	= 11;
	joy_left_up	= 10;
	joy_left_down	= 9;
	joy_right	= 7;
	joy_right_up	= 6;
	joy_right_down	= 5;

