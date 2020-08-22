program wsk;
{$librarypath '../../blibs/'}
{$librarypath '../../MADS/blibs/'}
uses atari, rmt, b_system, b_crt, b_pmg;

const
{$i const.inc}
{$r resources.rc}

var
    hpos : word;
    music : boolean;
    msx : TRMT;
    old_vbl,old_dli : Pointer;
    i : byte;
    d : shortint;
    frame : byte;

    pcolr : array[0..3] of byte absolute $D012;   // Player color
    hposp : array[0..3] of byte absolute $D000;  // Player horizontal position
    sizep : array[0..3] of byte absolute $D008;  // Player size
    hposm : array[0..3] of byte absolute $D004;  // Missile horizontal position
    gtiactl	: byte absolute	$D01B;
    vsc : byte absolute $14;

    joy_1 : byte absolute $D300;
    strig0 : byte absolute $D010;

    // Player data
    bike_p0 : array [0.._HEIGHT - 1] of byte =
        ($18, $C, $8, $1E, $2C, $4A, $4A, $91, $91, $91, $81, $81, $42, $42, $24, $18, $00, $00);
    bike_p1 : array [0.._HEIGHT - 1] of byte =
        ($00, $00, $00, $88, $70, $20, $10, $8, $8, $4, $4, $E, $15, $15, $11, $E, $00, $00);

    // Player 0 data
    bat_p0Frame1 : array[0.._HEIGHT - 1] of byte = 
        ($00, $00, $2, $2, $3, $F, $3E, $7F, $7F, $F3, $C3, $80, $00, $00, $00, $00, $00, $00);
    bat_p0Frame2 : array[0.._HEIGHT - 1] of byte = 
        ($00, $00, $00, $2, $C2, $73, $7B, $3E, $3F, $1F, $17, $3, $00, $00, $00, $00, $00, $00);
    bat_p0Frame3 : array[0.._HEIGHT - 1] of byte = 
        ($00, $00, $2, $2, $3, $F, $3E, $7F, $7F, $F3, $C3, $80, $00, $00, $00, $00, $00, $00);
    bat_p0Frame4 : array[0.._HEIGHT - 1] of byte = 
        ($00, $00, $00, $2, $C2, $73, $7B, $3E, $3F, $1F, $17, $3, $00, $00, $00, $00, $00, $00);

    // Player 1 data
    bat_p1Frame1 : array[0.._HEIGHT - 1] of byte = 
        ($00, $00, $40, $40, $C0, $F0, $BC, $FE, $FE, $CF, $C3, $1, $00, $00, $00, $00, $00, $00);
    bat_p1Frame2 : array[0.._HEIGHT - 1] of byte = 
        ($00, $00, $00, $40, $43, $CE, $DE, $BC, $FC, $F8, $E8, $C0, $00, $00, $00, $00, $00, $00);
    bat_p1Frame3 : array[0.._HEIGHT - 1] of byte = 
        ($00, $00, $40, $40, $C0, $F0, $BC, $FE, $FE, $CF, $C3, $1, $00, $00, $00, $00, $00, $00);
    bat_p1Frame4 : array[0.._HEIGHT - 1] of byte = 
        ($00, $00, $00, $40, $43, $CE, $DE, $BC, $FC, $F8, $E8, $C0, $00, $00, $00, $00, $00, $00);

    bat_pos: array[0.._SIZE - 1] of byte =
        (0,0,0,0,0,0,0,0,0,2,2,2,4,4,4,6,6,6,8,8,8,9,9,10,9,9,8,8,8,6,6,6,4,4,4,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,4,4,4,6,6,6,8,8,8,9,9,10,9,9,8,8,8,6,6,6,4,4,4,0,0,0,0,0,0,0,0);

    // Player 0 data
    sreel_p0Frame1 : array[0.._HEIGHT - 1] of byte = 
        ($00, $00, $00, $3, $F, $1B, $11, $3B, $3E, $3E, $3B, $11, $1B, $F, $33, $00, $00, $00);
    sreel_p0Frame2 : array[0.._HEIGHT - 1] of byte = 
        ($00, $00, $00, $3, $F, $1E, $1F, $37, $22, $36, $3F, $1E, $1C, $E, $3, $00, $00, $00);

    sreel_p0Frame3 : array[0.._HEIGHT - 1] of byte = 
        ($00, $00, $00, $3, $F, $1B, $11, $3B, $3E, $3E, $3B, $11, $1B, $F, $3, $00, $00, $00);

    sreel_p0Frame4 : array[0.._HEIGHT - 1] of byte = 
        ($00, $00, $00, $23, $2F, $3E, $1F, $37, $22, $36, $3F, $1E, $1C, $E, $3, $00, $00, $00);

    // Player 1 data
    sreel_p1Frame1 : array[0.._HEIGHT - 1] of byte = 
        ($00, $00, $00, $E0, $F0, $D8, $88, $DC, $7C, $7C, $DC, $88, $D8, $F0, $E0, $00, $00, $00);

    sreel_p1Frame2 : array[0.._HEIGHT - 1] of byte = 
        ($00, $00, $00, $C0, $70, $38, $78, $FC, $6C, $44, $EC, $F8, $78, $F4, $C4, $00, $00, $00);

    sreel_p1Frame3 : array[0.._HEIGHT - 1] of byte = 
        ($00, $00, $00, $EC, $F0, $D8, $88, $DC, $7C, $7C, $DC, $88, $D8, $F0, $E0, $00, $00, $00);

    sreel_p1Frame4 : array[0.._HEIGHT - 1] of byte = 
        ($00, $00, $00, $C0, $70, $38, $78, $FC, $6C, $44, $EC, $F8, $78, $F0, $C0, $00, $00, $00);

    sreel_pos: array[0.._SIZE - 1] of byte =
        (0,0,0,0,0,2,2,2,4,4,4,6,6,6,8,8,8,9,9,9,10,10,10,9,9,9,8,8,8,6,6,6,4,4,4,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,4,4,4,6,6,6,8,8,8,9,9,9,10,10,10,9,9,9,8,8,8,6,6,6,4,4,4,0,0,0,0);

    // Player position
    bike_px0 : byte = 240; bike_py0 : byte = 90;
    bike_px1 : byte = 247; bike_py1 : byte = 90;
    
    bat_px0 : byte = 80; bat_py0 : byte = 24;
    bat_px1 : byte = 88; bat_py1 : byte = 24;

    sreel_px0 : byte = 100; sreel_py0 : byte = 71;
    sreel_px1 : byte = 107; sreel_py1 : byte = 71;

    guy_x : byte = 10; guy_y : byte = 57;
    guy_oldx : byte; guy_oldy : byte;

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
    // bike
    Move(bike_p0, Pointer(PMGBASE + 512 + (128 * 0) + bike_py0), _HEIGHT);
    Move(bike_p1, Pointer(PMGBASE + 512 + (128 * 1) + bike_py1), _HEIGHT);

    // bat
    Move(bat_p0Frame1, Pointer(PMGBASE + 512 + (128 * 0) + bat_py0 + bat_pos[i]), _HEIGHT);
    Move(bat_p1Frame1, Pointer(PMGBASE + 512 + (128 * 1) + bat_py1 + bat_pos[i]), _HEIGHT);

    // small reel
    Move(sreel_p0Frame1, Pointer(PMGBASE + 512 + (128 * 0) + sreel_py0 - sreel_pos[i]), _HEIGHT);
    Move(sreel_p1Frame1, Pointer(PMGBASE + 512 + (128 * 1) + sreel_py1 - sreel_pos[i]), _HEIGHT);
  end
  else if frame = 2 then begin
    //bike
    // Move(bike_p0, Pointer(PMGBASE + 512 + (128 * 0) + bike_py0), _HEIGHT);
    // Move(bike_p1, Pointer(PMGBASE + 512 + (128 * 1) + bike_py1), _HEIGHT);

    // bat
    Move(bat_p0Frame2, Pointer(PMGBASE + 512 + (128 * 0) + bat_py0 + bat_pos[i]), _HEIGHT);
    Move(bat_p1Frame2, Pointer(PMGBASE + 512 + (128 * 1) + bat_py1 + bat_pos[i]), _HEIGHT);

    //small reel
    Move(sreel_p0Frame2, Pointer(PMGBASE + 512 + (128 * 0) + sreel_py0 - sreel_pos[i]), _HEIGHT);
    Move(sreel_p1Frame2, Pointer(PMGBASE + 512 + (128 * 1) + sreel_py1 - sreel_pos[i]), _HEIGHT);
  end
  else if frame = 3 then begin
    // Move(bike_p0, Pointer(PMGBASE + 512 + (128 * 0) + bike_py0), _HEIGHT);
    // Move(bike_p1, Pointer(PMGBASE + 512 + (128 * 1) + bike_py1), _HEIGHT);

    Move(bat_p0Frame3, Pointer(PMGBASE + 512 + (128 * 0) + bat_py0 + bat_pos[i]), _HEIGHT);
    Move(bat_p1Frame3, Pointer(PMGBASE + 512 + (128 * 1) + bat_py1 + bat_pos[i]), _HEIGHT);

    Move(sreel_p0Frame3, Pointer(PMGBASE + 512 + (128 * 0) + sreel_py0 - sreel_pos[i]), _HEIGHT);
    Move(sreel_p1Frame3, Pointer(PMGBASE + 512 + (128 * 1) + sreel_py1 - sreel_pos[i]), _HEIGHT);
  end
  else if frame = 4 then begin
    // Move(bike_p0, Pointer(PMGBASE + 512 + (128 * 0) + bike_py0), _HEIGHT);
    // Move(bike_p1, Pointer(PMGBASE + 512 + (128 * 1) + bike_py1), _HEIGHT);

    Move(bat_p0Frame4, Pointer(PMGBASE + 512 + (128 * 0) + bat_py0 + bat_pos[i]), _HEIGHT);
    Move(bat_p1Frame4, Pointer(PMGBASE + 512 + (128 * 1) + bat_py1 + bat_pos[i]), _HEIGHT);

    Move(sreel_p0Frame4, Pointer(PMGBASE + 512 + (128 * 0) + sreel_py0 - sreel_pos[i]), _HEIGHT);
    Move(sreel_p1Frame4, Pointer(PMGBASE + 512 + (128 * 1) + sreel_py1 - sreel_pos[i]), _HEIGHT);
  end;

end;

procedure Joystick_Move;
begin
    guy_oldx:=guy_x;
    guy_oldy:=guy_y;
    // mask to read only 4 youngest bits
    case joy_1 and 15 of
        joy_left:   begin
                        if (hpos > 0) then begin
                            Inc(bike_px0); Inc(bike_px1);
                            Inc(bat_px0); Inc(bat_px1);
                            Inc(sreel_px0); Inc(sreel_px1);
                            dec(hpos);
                        end;
                        if guy_x > 4 then begin
                            Dec(guy_x);
                        end;
                    end;
        joy_right:  begin
                        if (hpos < 339) then begin
                            Dec(bike_px0); Dec(bike_px1);
                            Dec(bat_px0); Dec(bat_px1);
                            Dec(sreel_px0); Dec(sreel_px1);
                            inc(hpos);
                        end;
                        if guy_x < 128 then begin
                            Inc(guy_x);
                        end;
                    end;
    end;
end;

procedure Guy_BackSet;
// Set remembered back into background 
begin
    for i:=0 to _GUY_HEIGHT - 1 do
    begin
        Move(Pointer(GUYBACK_MEM + (4 * i)), Pointer(BACKGROUND_MEM + (128 * i) + (128 * guy_oldy) + guy_oldx), 4);
    end;
end;

procedure Guy_BackGet;
// Get backgrount into memory
begin
    for i:=0 to _GUY_HEIGHT - 1 do
    begin
        Move(Pointer(BACKGROUND_MEM + (128 * i) + (128 * guy_y) + guy_x), Pointer(GUYBACK_MEM + (4 * i)), 4);
    end;
end;

procedure Guy_Anim;
begin
    // Guy_BackSet;
    // Guy_BackGet;
    
    for i:=0 to _GUY_HEIGHT - 1 do
    begin
        Move(Pointer(GUY1_MEM + (4 * i)), Pointer(BACKGROUND_MEM + (128 * i) + (128 * guy_y) + guy_x), 4);
        // waitframe;
    end;
end;



begin
    SystemOff;

    msx.player := pointer(RMT_PLAYER_ADDRESS);
    msx.modul := pointer(RMT_MODULE_ADDRESS);
    msx.Init(0);

    WaitFrame;
    EnableVBLI(@vbl);
    EnableDLI(@dli1);


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
    // FillByte(Pointer(PMGBASE + 384), 512 + 128, 0);
    FillByte(Pointer(PMGBASE + 384), 512 + 128 * 3, 0);
    // PMG_Clear;


    // Priority register
    // - Players and missiles in front of playfield
    // - Multiple color players

    gtiactl := 1;

    sizep[0] := 0;  // Player 0 normal size
    sizep[1] := 0;  // Player 1 normal size
    sizep[2] := 0;
    sizep[3] := 0;  

    // Player/missile color
    pcolr[0] := $0;
    pcolr[1] := $0;
    pcolr[2] := $E0;
    pcolr[3] := $E0;

    // Player horizontal position
    // hposp[0] := bike_px0;
    // hposp[1] := bike_px1;
    // hposp[2] := bat_px0;
    // hposp[3] := bat_px1;

    // Draw player 0 and set vertical position
    // Move(bike_p0, Pointer(PMGBASE + 512 + (128 * 0) + bike_py0), _HEIGHT);
    // Draw player 1 and set vertical position
    // Move(bike_p1, Pointer(PMGBASE + 512 + (128 * 1) + bike_py1), _HEIGHT);
    
    // remember backgroud at start at initial player position 
    guy_oldx:= guy_x;
    guy_oldy:= guy_y;

    music:=false;

    i:=1;
    repeat
        Joystick_Move;

        setBackgroundOffset(hpos);
        if strig0 = 0 then 
        begin
            msx.stop;
            music:= not music;
        end;
        
        Nextframe;

        // hposp[0]:=bike_px0;
        // hposp[1]:=bike_px1;
        // hposp[2]:=bat_px0;
        // hposp[3]:=bat_px1;
        
        Dec(bike_px0); Dec(bike_px1);
        Inc(bat_px0); Inc(bat_px1);
        Dec(sreel_px0); Dec(sreel_px1);
        // sreel_px0:=sreel_px0 + d; sreel_px1:=sreel_px1 + d;
        // if (vsc mod 10) = 0 then Inc(frame);
        if (vsc and 7) = 0 then Inc(frame);
        if frame > 4 then frame := 1;
        Inc(i);
        if i = _SIZE then i:=1;
        // Guy_Anim;
        waitframe;

    until false;

    music:= false;
    msx.stop;
    // waitframe;
    // DisableDLI;
    // DisableVBLI;
    nmien:=0;
    Dmactl:= 0;
    
end.
