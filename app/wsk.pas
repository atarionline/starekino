program madStrap;
{ $librarypath '../blibs/'}
uses atari, crt, rmt; // b_utils;

const
{$i const.inc}
{$r resources.rc}

var
    hpos:word;

procedure setBackgroundOffset(x:word);
var vram:word;
    line:byte;
    dlist:word;
begin
    vram:=BACKGROUND_MEM + (x shr 2);
    dlist:=DISPLAY_LIST_ADDRESS + 7;
    for line:=0 to 127 do begin
        Dpoke(dlist,vram);
        inc(dlist,3);
        inc(vram,128);
    end;
    hscrol := (x and 3) xor 3;
end;

begin
    Pause;
    SDLSTL := DISPLAY_LIST_ADDRESS;
    color4:=$f;
    color1:=$f;
    color2:=0;

    for hpos:=0 to 339 do begin 
        setBackgroundOffset(hpos);
        pause;
    end;
    ReadKey;
end.
