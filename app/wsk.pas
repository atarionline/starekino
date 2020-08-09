program wsk;
{ $librarypath '../blibs/'}
{$librarypath '../../MADS/blibs/'}
uses atari, crt, rmt, b_system;

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
    (*  save vbl and dli *)
    // GetIntVec(iVBL, old_vbl);
    // GetIntVec(iDLI, old_dli);
    // SystemOff;

    (*  initialize RMT player  *)
    msx.player := pointer(RMT_PLAYER_ADDRESS);
    msx.modul := pointer(RMT_MODULE_ADDRESS);
    msx.Init(0);

    (*  set and run vbl interrupt *)
    SetIntVec(iVBL, @vbl);
    // SetIntVec(iDLI, @dli);
    // EnableVBLI(@vbl);

    pause;
    // waitframe;
    SDLSTL := DISPLAY_LIST_ADDRESS;
    // DLISTL := DISPLAY_LIST_ADDRESS;
    color4:=$f;
    color1:=$f;
    color2:=0;

    music:=false;

    for hpos:=0 to 339 do begin 
        setBackgroundOffset(hpos);
        pause;
    end;
    ReadKey;

    music:= false;
    msx.stop;
    // waitframe;
    // DisableDLI;
    // DisableVBLI;
    nmien:=0;
    Dmactl:= 0;
end.
