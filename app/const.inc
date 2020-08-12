//
// ;*** define your project wide constants here
// 
// ;*** I like to keep memory locations at top of this file
//
PMGBASE = $4000;
FREE_BOTTOM = $6000;  // and sometimes I like to do some relative addressing
DISPLAY_LIST_ADDRESS = FREE_BOTTOM - $200; 
BACKGROUND_MEM = $6000;

RMT_MODULE_ADDRESS = $A000;
RMT_PLAYER_ADDRESS = $A600;

// ;*** and here goes all other stuff

NONE = $ff;
_HEIGHT = 30;
_SIZE = 84;


