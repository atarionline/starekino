program wsk;
{$librarypath '../../blibs/'}
{$librarypath '../../MADS/blibs/'}
uses atari, rmt, b_system, b_crt;

const
{$i const.inc}
{$r resources.rc}

var
    hpos:word;
    music:boolean;
    msx:TRMT;
    old_vbl,old_dli:Pointer;

    pcolr : array[0..3] of byte absolute $D012;   // Player color
    hposp : array[0..3] of byte absolute $D000;  // Player horizontal position
    sizep : array[0..3] of byte absolute $D008;  // Player size
    hposm : array[0..3] of byte absolute $D004;  // Missile horizontal position


    // Player data
    player0 : array [0..29] of byte =
        (0, 0, 0, 0, 0, 24, 12, 8, 30, 44, 74, 74, 144, 144, 144, 128, 128, 66, 66, 36, 24, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    player1 : array [0..29] of byte =
        (0, 0, 0, 0, 0, 0, 0, 0, 136, 112, 32, 16, 136, 136, 132, 132, 142, 21, 21, 17, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0);

    // Player position
    px0 : byte = 181; py0 : byte = 70;
    px1 : byte = 188; py1 : byte = 70;

{$i interrupts.inc}

procedure setBackgroundOffset(x:word);
var vram1,vram2:byte;
    line:byte;
    dlist:word;
begin
    vram1:= x shr 2;
    vram2:= vram1 or $80;
    dlist:=DISPLAY_LIST_ADDRESS + 7;
    line:=64;
    repeat
        poke(dlist,vram1);
        poke(dlist+3,vram2);
        inc(dlist,6);
        dec(line);
    until line = 0;
    hscrol := (x and 3) xor 3;
end;


begin
    SystemOff;

    msx.player := pointer(RMT_PLAYER_ADDRESS);
    msx.modul := pointer(RMT_MODULE_ADDRESS);
    msx.Init(0);

    WaitFrame;
    EnableVBLI(@vbl);


    DLISTL := DISPLAY_LIST_ADDRESS;

    colbk:=$f;
    colpf1:=$f;
    colpf2:=0;
    gractl:=3; // Turn on P/M graphics
    pmbase:=Hi(PMGBASE);

    // P/M graphics double resolution
    dmactl := 46;

    // Clear player memory
    FillByte(Pointer(PMGBASE + 384), 512 + 128, 0);


    // Priority register
    // - Players and missiles in front of playfield
    // - Multiple color players
    gprior := 33;
    sizep[0] := 0;  // Player 0 normal size
    sizep[1] := 0;  // Player 1 normal size

    // Player/missile color
    pcolr[0] := 29;
    pcolr[1] := 29;

    // Player horizontal position
    hposp[0] := px0;
    hposp[1] := px1;
    

    // Draw player 0 and set vertical position
    Move(player0, Pointer(PMGBASE + 512 + 128*0 + py0), 29);
    // Draw player 1 and set vertical position
    Move(player1, Pointer(PMGBASE + 512 + 128*1 + py1), 29);

    gractl := 3;

    music:=true;


    repeat
    for hpos:=0 to 339 do begin 
        waitframe;
        setBackgroundOffset(hpos);
    end;
    for hpos:=338 downto 1 do begin 
        waitframe;
        setBackgroundOffset(hpos);
    end;
    until false;

    music:= false;
    msx.stop;
    // waitframe;
    // DisableDLI;
    // DisableVBLI;
    nmien:=0;
    Dmactl:= 0;
    
end.
