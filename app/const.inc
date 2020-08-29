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
GUY1_MEM = GUYBACK_MEM + $104;
GUY2_MEM = GUY1_MEM + $104;
GUY3_MEM = GUY2_MEM + $104;
GUY4_MEM = GUY3_MEM + $104;
GUY5_MEM = GUY4_MEM + $104;
GUY6_MEM = GUY5_MEM + $104;

TITLEBACK_MEM = $B900;
TITLE1_SCREEN = TITLEBACK_MEM + $3E8; //$3E8;
TITLE2_SCREEN = TITLE1_SCREEN + $280;

TITLE1_FONT1 = $C400;
TITLE1_FONT2 = TITLE1_FONT1 + $400;
TITLE2_FONT1 = TITLE1_FONT2 + $400;

CHARSET_FONT = $D800;



// ;*** and here goes all other stuff
NONE = $ff;

// sprite size
_HEIGHT = 18;
// moves table size
_SIZE = 84;

// player size
_GUY_WIDTH = 32;
_GUY_HEIGHT = 60;

joy_none	= 15;
joy_up		= 14;
joy_down	= 13;
joy_left	= 11;
joy_left_up	= 10;
joy_left_down	= 9;
joy_right	= 7;
joy_right_up	= 6;
joy_right_down	= 5;

