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
    i : byte;
    frame : byte;

    pcolr : array[0..3] of byte absolute $D012;   // Player color
    hposp : array[0..3] of byte absolute $D000;  // Player horizontal position
    sizep : array[0..3] of byte absolute $D008;  // Player size
    hposm : array[0..3] of byte absolute $D004;  // Missile horizontal position


    // Player data
    bike_p0 : array [0.._HEIGHT - 1] of byte =
        ($00, $00, $00, $00, $00, $00, $18, $C, $8, $1E, $2C, $4A, $4A, $91, $91, $91, $81, $81, $42, $42, $24, $18, $00, $00, $00, $00, $00, $00, $00, $00);
    bike_p1 : array [0.._HEIGHT - 1] of byte =
        ($00, $00, $00, $00, $00, $00, $00, $00, $00, $88, $70, $20, $10, $8, $8, $4, $4, $E, $15, $15, $11, $E, $00, $00, $00, $00, $00, $00, $00, $00);

    // Player 0 data
    bat_p0Frame1 : array[0.._HEIGHT - 1] of byte = 
        ($00, $00, $00, $00, $00, $00, $00, $00, $2, $2, $3, $F, $3E, $7F, $7F, $F3, $C3, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);

    bat_p0Frame2 : array[0.._HEIGHT - 1] of byte = 
        ($00, $00, $00, $00, $00, $00, $00, $00, $00, $2, $C2, $73, $7B, $3E, $3F, $1F, $17, $3, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);

    // Player 1 data
    bat_p1Frame1 : array[0.._HEIGHT - 1] of byte = 
        ($00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $C0, $F0, $BC, $FE, $FE, $CF, $C3, $1, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);

    bat_p1Frame2 : array[0.._HEIGHT - 1] of byte = 
        ($00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $43, $CE, $DE, $BC, $FC, $F8, $E8, $C0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);

    bat_pos: array[0.._SIZE - 1] of byte =
        (0,2,6,10,14,16,18,16,18,16,14,10,6,2,0,2,6,10,14,16,18,16,18,16,14,10,6,2,0,2,6,10,14,16,18,16,18,16,14,10,6,2,0,2,6,10,14,16,18,16,18,16,14,10,6,2,0,2,6,10,14,16,18,16,18,16,14,10,6,2,0,2,6,10,14,16,18,16,18,16,14,10,6,2);
        
    // Player position
    bike_px0 : byte = 180; bike_py0 : byte = 80;
    bike_px1 : byte = 187; bike_py1 : byte = 80;
    
    bat_px0 : byte = 80; bat_py0 : byte = 20;
    bat_px1 : byte = 88; bat_py1 : byte = 20;

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

procedure NextFrame;
begin
  if frame = 1 then begin
    Move(bat_p0Frame1, Pointer(PMGBASE + 512 + (128 * 2) + bat_py0 + bat_pos[i]), _HEIGHT);
    Move(bat_p1Frame1, Pointer(PMGBASE + 512 + (128 * 3) + bat_py1 + bat_pos[i]), _HEIGHT);
  end
  else if frame = 2 then begin
    Move(bat_p0Frame2, Pointer(PMGBASE + 512 + (128 * 2) + bat_py0 + bat_pos[i]), _HEIGHT);
    Move(bat_p1Frame2, Pointer(PMGBASE + 512 + (128 * 3) + bat_py1 + bat_pos[i]), _HEIGHT);
  end;
end;

begin
    SystemOff;

    msx.player := pointer(RMT_PLAYER_ADDRESS);
    msx.modul := pointer(RMT_MODULE_ADDRESS);
    msx.Init(0);

    WaitFrame;
    EnableVBLI(@vbl);


    DLISTL := DISPLAY_LIST_ADDRESS;

    colbk:=$c;
    colpf1:=$0;
    colpf2:=$c;
    colpf3:=$c;
    gractl:=3; // Turn on P/M graphics
    pmbase:=Hi(PMGBASE);

    // P/M graphics double resolution
    dmactl := 46;

    // Clear player memory
    FillByte(Pointer(PMGBASE + 384), 512 + 128, 0);


    // Priority register
    // - Players and missiles in front of playfield
    // - Multiple color players
    gprior := 16;
    sizep[0] := 0;  // Player 0 normal size
    sizep[1] := 0;  // Player 1 normal size
    sizep[2] := 0;
    sizep[3] := 0;  

    // Player/missile color
    pcolr[0] := $0;
    pcolr[1] := $0;
    pcolr[2] := $06;
    pcolr[3] := $06;

    // Player horizontal position
    hposp[0] := bike_px0;
    hposp[1] := bike_px1;
    hposp[2] := bat_px0;
    hposp[3] := bat_px1;

    // Draw player 0 and set vertical position
    Move(bike_p0, Pointer(PMGBASE + 512 + (128 * 0) + bike_py0), _HEIGHT);
    // Draw player 1 and set vertical position
    Move(bike_p1, Pointer(PMGBASE + 512 + (128 * 1) + bike_py1), _HEIGHT);

    gractl := 3;

    music:=false;

    i:=1;
    repeat
        // for hpos:=0 to 339 do begin 
        //     waitframe;
        //     setBackgroundOffset(hpos);
        // end;
        // for hpos:=338 downto 1 do begin 
        //     waitframe;
        //     setBackgroundOffset(hpos);
        // end;
        
        Nextframe;

        hposp[0]:=bike_px0;
        hposp[1]:=bike_px1;
        hposp[2]:=bat_px0;
        hposp[3]:=bat_px1;
        
        Dec(bike_px0); Dec(bike_px1);
        Inc(bat_px0,3); Inc(bat_px1,3);
        Inc(frame);
        if frame > 2 then frame := 1;
        Inc(i);
        if i = _SIZE then i:=1;
     
        waitframe;waitframe;waitframe;
    until false;

    music:= false;
    msx.stop;
    // waitframe;
    // DisableDLI;
    // DisableVBLI;
    nmien:=0;
    Dmactl:= 0;
    
end.
