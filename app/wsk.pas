program wsk;
{ $librarypath '../blibs/'}
uses atari, crt, rmt; // b_utils;

const
{$i const.inc}
{$r resources.rc}

var
    hpos:word;
    music:boolean;
    msx:TRMT;
    old_vbl,old_dli:Pointer;

{$i interrupts.inc}

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
(*  set and run vbl interrupt *)
    GetIntVec(iVBL, old_vbl);
    GetIntVec(iDLI, old_dli);

    music:=false;
    (*  initialize RMT player  *)
    msx.player := pointer(RMT_PLAYER_ADDRESS);
    msx.modul := pointer(RMT_MODULE_ADDRESS);
    msx.Init(0);

    SetIntVec(iVBL, @vbl);
    SetIntVec(iDLI, @dli);

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
