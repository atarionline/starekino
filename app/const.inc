//
// ;*** define your project wide constants here
// 
// ;*** I like to keep memory locations at top of this file
//
PMGBASE = $4000;
FREE_BOTTOM = $6000;  // and sometimes I like to do some relative addressing
DISPLAY_LIST_ADDRESS = FREE_BOTTOM - $200;
TITLE_LIST_ADDRESS = DISPLAY_LIST_ADDRESS - $200;

BACKGROUND_MEM = $6000;

RMT_PLAYER_ADDRESS = $A400;
RMT_MODULE_ADDRESS = $AC00;

GUYBACK_MEM = $B000;
GUY1_MEM = GUYBACK_MEM + $118;
GUY2_MEM = GUY1_MEM + $118;
GUY3_MEM = GUY2_MEM + $118;
GUY4_MEM = GUY3_MEM + $118;

TITLEBACK_MEM = $B600;
TITLE_MEM = TITLEBACK_MEM + $F00;

// ;*** and here goes all other stuff

NONE = $ff;

// sprite size
_HEIGHT = 18;
// moves table size
_SIZE = 84;

// player size
_GUY_WIDTH = 32;
_GUY_HEIGHT = 70;

joy_none	= 15;
joy_up		= 14;
joy_down	= 13;
joy_left	= 11;
joy_left_up	= 10;
joy_left_down	= 9;
joy_right	= 7;
joy_right_up	= 6;
joy_right_down	= 5;

