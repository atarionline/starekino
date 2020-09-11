program wsk;
{$librarypath '../../blibs/'}
{$librarypath '../../MADS/blibs/'}
uses atari, rmt, b_system, b_crt;

const

{$i const.inc}
{$i types.inc}
{$r resources.rc}
const 
dlist_title: array [0..34] of byte = (
		$70,$70,$70,$70,$70,$70,$70,$C2,lo(TITLEBACK_MEM),hi(TITLEBACK_MEM),
		$82,$82,$82,$82,$82,$82,$82,$82,
		$82,$82,$82,$82,$82,$82,$82,$02,
		$02,$02,$02,$02,$02,$00,
		$41,lo(word(@dlist_title)),hi(word(@dlist_title))
	);
var
    hpos : word;
    music : boolean;
    msx : TRMT;
    old_vbl,old_dli : Pointer;
    i : byte;
    frame: byte;
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

    guy_x : byte = 10; guy_y : byte = 67;
    guy_oldx : byte; guy_oldy : byte;
    guy_frame: byte;
    guy_dir: dirs;

    guy_frames: array [0..1,0..3] of word = (
        (GUY1_MEM, GUY2_MEM, GUY3_MEM, GUY2_MEM),
        (GUY4_MEM, GUY5_MEM, GUY6_MEM, GUY5_MEM)
    );


	fntTable: array [0..29] of byte;

	c0Table: array [0..29] of byte = (
		$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,
		$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,
		$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,
		$0E,$0E,$0E,$0E,$0E,$0E
	);

	c1Table: array [0..29] of byte = (
		$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,
		$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,
		$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,
		$0E,$0E,$0E,$0E,$0E,$0E
	);

	c2Table: array [0..29] of byte = (
		$00,$00,$00,$00,$00,$00,$00,$00,
		$00,$00,$00,$00,$00,$00,$00,$00,
		$00,$00,$00,$00,$00,$00,$00,$00,
		$00,$00,$00,$00,$00,$00
	);

	c3Table: array [0..29] of byte = (
		$00,$00,$00,$00,$00,$00,$00,$00,
		$00,$00,$00,$00,$00,$00,$00,$00,
		$00,$00,$00,$00,$00,$00,$00,$00,
		$00,$00,$00,$00,$00,$00
	);



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

procedure GetGuyBackground;
// Get backgrount into memory
var  bg_src:word;
begin
    bg_src := BACKGROUND_MEM + (guy_y shl 7) + guy_x;
    for i:=0 to _GUY_HEIGHT - 1 do
    begin
        Move(Pointer(bg_src), Pointer(GUYBACK_MEM + (i shl 2)), 4);
        Inc(bg_src,128);
    end;
end;

procedure DrawGuy;
var tile_addr,buff_addr:word;
    guy_dest:word;
    bg_dest:word;
    offset_y:word;
begin

    tile_addr := guy_frames[guy_dir, guy_frame];
    buff_addr := GUYBACK_MEM;
    offset_y := BACKGROUND_MEM + (guy_y shl 7);
    bg_dest := offset_y + guy_oldx;
    guy_dest := offset_y + guy_x;
    
    for i:=0 to _GUY_HEIGHT - 1 do
    begin
      
        if guy_x <> guy_oldx then begin
            Move(Pointer(buff_addr), Pointer(bg_dest), 4);
            Move(Pointer(guy_dest), Pointer(buff_addr), 4);
        end;
        
        Poke(guy_dest    , peek(tile_addr    ) or peek(buff_addr    ));
        Poke(guy_dest + 1, peek(tile_addr + 1) or peek(buff_addr + 1));
        Poke(guy_dest + 2, peek(tile_addr + 2) or peek(buff_addr + 2));
        Poke(guy_dest + 3, peek(tile_addr + 3) or peek(buff_addr + 3));

        Inc(guy_dest,128);
        Inc(bg_dest,128);
        Inc(tile_addr,4);
        Inc(buff_addr,4);
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
    // mask to read only 4 youngest bits
    guy_oldx:=guy_x;
    case joy_1 and 15 of
        joy_left:   begin
                        guy_dir := left;
                        guy_frame := (guy_frame - 1) and 3;
                        if guy_frame = 3 then begin
                            Dec(guy_x);
                        end;
                        if (hpos > 0) then begin
                            Inc(bike_px0); Inc(bike_px1);
                            Inc(bat_px0); Inc(bat_px1);
                            Inc(sreel_px0); Inc(sreel_px1);
                            // Inc(i);
                            dec(hpos);
                        end;
                        DrawGuy;
                    end;
        joy_right:  begin
                        guy_dir := right;
                        guy_frame := (guy_frame + 1) and 3;
                        if guy_frame = 0 then begin
                            Inc(guy_x);
                        end;

                        if (hpos < 339) then begin
                            Dec(bike_px0); Dec(bike_px1);
                            Dec(bat_px0); Dec(bat_px1);
                            Dec(sreel_px0); Dec(sreel_px1);
                            inc(hpos);
                            // Inc(i);
                        end;
                        DrawGuy;
                    end;
    end;

end;



procedure startgame;
begin
    EnableVBLI(@vbl);
    EnableDLI(@dli1);

    DLISTL := DISPLAY_LIST_ADDRESS;

    colbk:=$c;
    colpf1:=$0;
    colpf2:=$c;
    colpf3:=$c;

    // remember backgroud at start at initial player position 
    guy_x:=10;
    
    guy_oldx := guy_x;
    guy_oldy := guy_y;
    
    guy_frame := 0;
    guy_dir := right;
    
    waitframe;

    GetGuyBackground;
    DrawGuy;

    hpos:=7;

    setBackgroundOffset(hpos);

    i:=1;
    repeat
        Joystick_Move;
        
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
        setBackgroundOffset(hpos);
        waitframe;

    until gamestatus <> 1;
end;

procedure title;
begin

    Move(Pointer(TITLE1_SCREEN), Pointer(TITLEBACK_MEM),$280);
    for i:=0 to 9 do
        fntTable[i]:=hi(TITLE1_FONT1);
    // end;
    for i:=10 to 13 do
        fntTable[i]:=hi(TITLE1_FONT2);
    // end;
    for i:=14 to 15 do
        fntTable[i]:=hi(TITLE1_FONT1);
    // end;
    for i:=16 to 29 do
        fntTable[i]:=hi(CHARSET_FONT);
    // end;

    // DLISTL := TITLE_LIST_ADDRESS;
    DLISTL:=Word(@dlist_title);

    EnableVBLI(@vbl_title);
    EnableDLI(@dli_title);
    // nmien := $c0;	

    CRT_WriteCentered(17,' Wystepuja '~);

    repeat
       waitframe; 
    until (strig0 = 0);

    gamestatus:= 1;
end;

procedure endgame;
begin
    
    CRT_Clear;
    Move(Pointer(TITLE2_SCREEN), Pointer(TITLEBACK_MEM),$280);
    
    for i:=0 to 15 do
        fntTable[i]:=hi(TITLE2_FONT1);
    // end;
    for i:=16 to 29 do
        fntTable[i]:=hi(CHARSET_FONT);
    // end;

    // DLISTL := TITLE_LIST_ADDRESS;
    DLISTL:=Word(@dlist_title);

    EnableVBLI(@vbl_title);
    EnableDLI(@dli_title);
    // nmien := $c0;	

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
    SetCharset (Hi(CHARSET_FONT)); // when system is off
    CRT_Init(TITLEBACK_MEM);
    CRT_Clear;


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
    
    music:=false;

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
