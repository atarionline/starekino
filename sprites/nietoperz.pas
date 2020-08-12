uses
  SysUtils, FastGraph, Crt;

const
  _HEIGHT = 30;
  _SIZE = 84;

var
  // Colors for players
  p0Color : array[0..1] of byte = (28, 28);
  p1Color : array[0..1] of byte = (28, 28);

// Player 2 data
bat_p0Frame1 : array[0.._HEIGHT - 1] of byte = 
    ($00, $00, $00, $00, $00, $00, $00, $00, $2, $2, $3, $F, $3E, $7F, $7F, $F3, $C3, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);

bat_p0Frame2 : array[0.._HEIGHT - 1] of byte = 
    ($00, $00, $00, $00, $00, $00, $00, $00, $00, $2, $C2, $73, $7B, $3E, $3F, $1F, $17, $3, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);

// Player 3 data
bat_p1Frame1 : array[0.._HEIGHT - 1] of byte = 
    ($00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $C0, $F0, $BC, $FE, $FE, $CF, $C3, $1, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);

bat_p1Frame2 : array[0.._HEIGHT - 1] of byte = 
    ($00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $43, $CE, $DE, $BC, $FC, $F8, $E8, $C0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);

bat_pos: array[0.._SIZE - 1] of byte =
    // (0,4,12,20,28,32,36,32,28,20,12,4,0,4,12,20,28,32,36,32,28,20,12,4,0,2,6,10,14,16,18,16,14,10,6,2,0,2,6,10,14,16,18,16,14,10,6,2,0,1,3,5,7,8,9,8,7,5,3,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    // (0,1,3,5,7,8,9,8,7,5,3,1,0,1,3,5,7,8,9,8,7,5,3,1,0,1,3,5,7,8,9,8,7,5,3,1,0,1,3,5,7,8,9,8,7,5,3,1,0,1,3,5,7,8,9,8,7,5,3,1,0,1,3,5,7,8,9,8,7,5,3,1,0,1,3,5,7,8,9,8);
    (0,2,6,10,14,16,18,16,14,10,6,2,0,1,3,5,7,8,9,8,7,5,3,1,0,2,6,10,14,16,18,16,14,10,6,2,0,1,3,5,7,8,9,8,7,5,3,1,0,2,6,10,14,16,18,16,14,10,6,2,0,1,3,5,7,8,9,8,7,5,3,1,0,2,6,10,14,16,18,16,14,10,6,2);



  PMGMEM : word;
  bat_px0, bat_py0 : byte;
  bat_px1, bat_py1 : byte;
  frame : byte;
  i : byte;

procedure NextFrame;
begin
  if frame = 1 then begin
    Move(bat_p0Frame1, Pointer(PMGMEM + 512 + bat_py0 + bat_pos[i]), _HEIGHT);
    Move(bat_p1Frame1, Pointer(PMGMEM + 512 + 128 + bat_py1 + bat_pos[i]), _HEIGHT);
  end
  else if frame = 2 then begin
    Move(bat_p0Frame2, Pointer(PMGMEM + 512 + bat_py0 + bat_pos[i]), _HEIGHT);
    Move(bat_p1Frame2, Pointer(PMGMEM + 512 + 128 + bat_py1 + bat_pos[i]), _HEIGHT);
  end;
end;

begin
  // Player position
  bat_px0 := 80; bat_py0 := 40;
  bat_px1 := 88; bat_py1 := 40;

  // Set environment
  InitGraph(0);
  Poke(710, 0); Poke(712, 0);

  // Set P/M graphics
  Poke(53277, 0);
  PMGMEM := Peek(106) - 8;
  Poke(54279, PMGMEM);
  PMGMEM := PMGMEM * 256;

  // P/M graphics double resolution
  Poke(559, 46);

  // Clear player memory
  FillByte(pointer(PMGMEM + 384), 512 - 1 + 128, 0);

  // Enable third color
  Poke(623, 33);

  // Player normal size
  Poke(53256, 0); Poke(53257, 0);

  // Turn on P/M graphics
  Poke(53277, 3);

  frame := 1;

  Writeln('Player animation');
  Poke(53248, bat_px0); Poke(53249, bat_px1);

  // for i := 1 to _SIZE do
  i:= 1;
  repeat 

    NextFrame;
    Poke(704, p0Color[0]);
    Poke(705, p1Color[0]);
    Pause(5);

    Inc(bat_px0,2); Inc(bat_px1,2);
    // Inc(bat_py0, bat_pos[i]); Inc(bat_py1, bat_pos[i]);
    Poke(53248, bat_px0); Poke(53249, bat_px1);
    Inc(frame);
    if frame > 2 then frame := 1;
    Inc(i);
    if i = _SIZE then i:=1;
  until false;
  

  repeat until keypressed;
end.
