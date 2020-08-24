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
    frame, guyframe : byte;
    offset_x : Word;
    offset_y : Word;
    gamestatus : Byte = 0;
    tab: array [0..127] of byte; 


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

// procedure Guy_BackSet;
// // Set remembered back into background 
// begin
//     offset_x:=0;
//     offset_y:=guy_oldy shl 7;
//     for i:=0 to _GUY_HEIGHT - 1 do
//     begin
//         Inc(offset_x,128);
//         Move(Pointer(GUYBACK_MEM + (i shl 2)), Pointer(BACKGROUND_MEM + offset_x + offset_y + guy_oldx), 4);
//     end;
// end;

procedure Guy_BackGet;
// Get backgrount into memory
begin
    offset_x:=0;
    offset_y:=guy_y shl 7;
    for i:=0 to _GUY_HEIGHT - 1 do
    begin
        Inc(offset_x,128);
        Move(Pointer(BACKGROUND_MEM + offset_x + offset_y + guy_x), Pointer(GUYBACK_MEM + (i shl 2)), 4);
    end;
end;

procedure Guy_Anim(f : byte);
begin
    // Guy_BackSet;
    // Guy_BackGet;


    offset_x:=0;
    offset_y:=guy_y shl 7;
    for i:=0 to _GUY_HEIGHT - 1 do
    begin
        Inc(offset_x,128);

        Move(Pointer(GUYBACK_MEM + (i shl 2)), Pointer(BACKGROUND_MEM + offset_x + offset_y + guy_oldx), 4);
        Move(Pointer(BACKGROUND_MEM + offset_x + offset_y + guy_x), Pointer(GUYBACK_MEM + (i shl 2)), 4);
        if f = 1 then
            Move(Pointer(GUY1_MEM + (i shl 2)), Pointer(BACKGROUND_MEM + offset_x + offset_y + guy_x), 4);
        if f = 2 then
            Move(Pointer(GUY2_MEM + (i shl 2)), Pointer(BACKGROUND_MEM + offset_x + offset_y + guy_x), 4);    
        if f = 3 then
            Move(Pointer(GUY3_MEM + (i shl 2)), Pointer(BACKGROUND_MEM + offset_x + offset_y + guy_x), 4);
        if f = 4 then
            Move(Pointer(GUY4_MEM + (i shl 2)), Pointer(BACKGROUND_MEM + offset_x + offset_y + guy_x), 4);
        if f = 5 then
            Move(Pointer(GUY5_MEM + (i shl 2)), Pointer(BACKGROUND_MEM + offset_x + offset_y + guy_x), 4);
        if f = 6 then
            Move(Pointer(GUY6_MEM + (i shl 2)), Pointer(BACKGROUND_MEM + offset_x + offset_y + guy_x), 4);
        
    end;
end;

procedure NextFrame;
begin
  if frame = 1 then begin
    (* bike
        + 512 + (128 * 0) player0
        + 512 + (128 * 1) player1
    *)
    Move(bike_p0, Pointer(PMGBASE + 512 + bike_py0), _HEIGHT);
    Move(bike_p1, Pointer(PMGBASE + 512 + 128 + bike_py1), _HEIGHT);

    // bat
    Move(bat_p0Frame1, Pointer(PMGBASE + 512 + bat_py0 + bat_pos[i]), _HEIGHT);
    Move(bat_p1Frame1, Pointer(PMGBASE + 512 + 128 + bat_py1 + bat_pos[i]), _HEIGHT);

    // small reel
    Move(sreel_p0Frame1, Pointer(PMGBASE + 512 + sreel_py0 - sreel_pos[i]), _HEIGHT);
    Move(sreel_p1Frame1, Pointer(PMGBASE + 512 + 128 + sreel_py1 - sreel_pos[i]), _HEIGHT);
  end
  else if frame = 2 then begin
    //bike
    // Move(bike_p0, Pointer(PMGBASE + 512 + (128 * 0) + bike_py0), _HEIGHT);
    // Move(bike_p1, Pointer(PMGBASE + 512 + (128 * 1) + bike_py1), _HEIGHT);

    // bat
    Move(bat_p0Frame2, Pointer(PMGBASE + 512 + bat_py0 + bat_pos[i]), _HEIGHT);
    Move(bat_p1Frame2, Pointer(PMGBASE + 512 + 128 + bat_py1 + bat_pos[i]), _HEIGHT);

    //small reel
    Move(sreel_p0Frame2, Pointer(PMGBASE + 512 + sreel_py0 - sreel_pos[i]), _HEIGHT);
    Move(sreel_p1Frame2, Pointer(PMGBASE + 512 + 128 + sreel_py1 - sreel_pos[i]), _HEIGHT);
  end
  else if frame = 3 then begin
    // Move(bike_p0, Pointer(PMGBASE + 512 + (128 * 0) + bike_py0), _HEIGHT);
    // Move(bike_p1, Pointer(PMGBASE + 512 + (128 * 1) + bike_py1), _HEIGHT);

    Move(bat_p0Frame3, Pointer(PMGBASE + 512 + bat_py0 + bat_pos[i]), _HEIGHT);
    Move(bat_p1Frame3, Pointer(PMGBASE + 512 + 128 + bat_py1 + bat_pos[i]), _HEIGHT);

    Move(sreel_p0Frame3, Pointer(PMGBASE + 512 + sreel_py0 - sreel_pos[i]), _HEIGHT);
    Move(sreel_p1Frame3, Pointer(PMGBASE + 512 + 128 + sreel_py1 - sreel_pos[i]), _HEIGHT);
  end
  else if frame = 4 then begin
    // Move(bike_p0, Pointer(PMGBASE + 512 + (128 * 0) + bike_py0), _HEIGHT);
    // Move(bike_p1, Pointer(PMGBASE + 512 + (128 * 1) + bike_py1), _HEIGHT);

    Move(bat_p0Frame4, Pointer(PMGBASE + 512 + bat_py0 + bat_pos[i]), _HEIGHT);
    Move(bat_p1Frame4, Pointer(PMGBASE + 512 + 128 + bat_py1 + bat_pos[i]), _HEIGHT);

    Move(sreel_p0Frame4, Pointer(PMGBASE + 512 + sreel_py0 - sreel_pos[i]), _HEIGHT);
    Move(sreel_p1Frame4, Pointer(PMGBASE + 512 + 128 + sreel_py1 - sreel_pos[i]), _HEIGHT);
  end;

end;

procedure Joystick_Move;
begin
    guy_oldx:=guy_x;
    guy_oldy:=guy_y;
    // mask to read only 4 youngest bits
    case joy_1 and 15 of
        joy_left:   begin
                        guyframe:=4;
                        if (hpos > 0) then begin
                            Inc(bike_px0); Inc(bike_px1);
                            Inc(bat_px0); Inc(bat_px1);
                            Inc(sreel_px0); Inc(sreel_px1);
                            dec(hpos);
                        end;
                        if guy_x > 4 then begin
                            Dec(guy_x);
                        end;
                        Guy_Anim(guyframe);
                        Inc(guyframe);
                        if guyframe = 7 then guyframe:=4;
                    end;
        joy_right:  begin
                        guyframe:=1;
                        if (hpos < 339) then begin
                            Dec(bike_px0); Dec(bike_px1);
                            Dec(bat_px0); Dec(bat_px1);
                            Dec(sreel_px0); Dec(sreel_px1);
                            inc(hpos);
                        end;
                        if guy_x < 128 then begin
                            Inc(guy_x);
                        end;
                        Guy_Anim(guyframe);
                        Inc(guyframe);
                        if guyframe = 4 then guyframe:=1;
                    end;
    end;

end;



procedure startgame;
begin
    EnableDLI(@dli1);
    DLISTL := DISPLAY_LIST_ADDRESS;

    colbk:=$c;
    colpf1:=$0;
    colpf2:=$c;
    colpf3:=$c;

    // remember backgroud at start at initial player position 
    guy_oldx:= guy_x;
    guy_oldy:= guy_y;
    
    guyframe:=1;
    waitframe;

    Guy_BackGet;
    Guy_Anim(guyframe);

    i:=1;
    repeat
        Joystick_Move;

        setBackgroundOffset(hpos);
        
        Nextframe;

        // hposp[0]:=bike_px0;
        // hposp[1]:=bike_px1;
        // hposp[2]:=bat_px0;
        // hposp[3]:=bat_px1;
        
        Dec(bike_px0); Dec(bike_px1);
        Inc(bat_px0); Inc(bat_px1);
        Dec(sreel_px0); Dec(sreel_px1);

        if (vsc and 7) = 0 then Inc(frame);
        // if (vsc and 2) = 0 then Guy_Anim;
        if frame > 4 then frame := 1;
        Inc(i);
        if i = _SIZE then i:=1;
    
        if (strig0 = 0) then gamestatus:= 2;
        waitframe;

    until gamestatus <> 1;
end;

procedure title;
begin
    DisableDLI;
    DLISTL := TITLE_LIST_ADDRESS;

    offset_x:=0;
    offset_y:=(50 shl 4) + 1;
    for i:=0 to 82 do
    begin
        Inc(offset_x,40);
        Move(Pointer(TITLE_MEM + (i shl 4) + i), Pointer(TITLEBACK_MEM + offset_x + offset_y + 10), 17);
        // Move(Pointer(GUY1_MEM + (i shl 2)), Pointer(TITLEBACK_MEM + offset_x + offset_y + 44), 4);
    end;


    colbk:=$0;
    colpf1:=$0;
    colpf2:=$c;
    colpf3:=$c;

    repeat

       waitframe; 
    until (strig0 = 0);
    gamestatus:= 1;
end;

procedure endgame;
begin
    DisableDLI;
    DLISTL := TITLE_LIST_ADDRESS;

    offset_x:=0;
    // offset_y:=20 shl 5 + 8;
    offset_y:=(50 shl 4) + 1;
    for i:=0 to 82 do
    begin
        Inc(offset_x,40);
        Move(Pointer(TITLEEND_MEM + (i shl 4) + i), Pointer(TITLEBACK_MEM + offset_x + offset_y + 10), 17);
        // Move(Pointer(GUY1_MEM + (i shl 2)), Pointer(TITLEBACK_MEM + offset_x + offset_y + 44), 4);
    end;



    colbk:=$0;
    colpf1:=$0;
    colpf2:=$c;
    colpf3:=$c;

    repeat
    
       waitframe; 
    until (strig0 = 0);
    gamestatus:= 0;
end;


begin
    SystemOff;

    msx.player := pointer(RMT_PLAYER_ADDRESS);
    msx.modul := pointer(RMT_MODULE_ADDRESS);
    msx.Init(0);

    WaitFrame;
    EnableVBLI(@vbl);


    gractl:=3; // Turn on P/M graphics
    pmbase:=Hi(PMGBASE);

    // P/M graphics double resolution
    dmactl := 46;

    // Clear player memory
    // FillByte(Pointer(PMGBASE + 384), 512 + 128, 0);
    FillByte(Pointer(PMGBASE + 384), 512 + 128, 0);
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
    
    music:=true;

    repeat
        case gamestatus of
            0: title;
            1: startgame;
            2: endgame;
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
