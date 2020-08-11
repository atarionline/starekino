uses
  SysUtils, FastGraph, Crt;

const
  _HEIGHT = 30;

var
  // Colors for players
  p0Color : array[0..3] of byte = (29, 29, 29, 29);
  p1Color : array[0..3] of byte = (29, 29, 29, 29);

// Player 0 data
p0Frame1 : array[0.._HEIGHT - 1] of byte = 
    ($00, $00, $00, $00, $00, $00, $00, $00, $3, $F, $1B, $11, $3B, $3E, $3E, $3B, $11, $1B, $F, $33, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);
p0Frame2 : array[0.._HEIGHT - 1] of byte = 
   ($00, $00, $00, $00, $00, $00, $00, $00, $3, $F, $1E, $1F, $37, $22, $36, $3F, $1E, $1C, $E, $3, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);

p0Frame3 : array[0.._HEIGHT - 1] of byte = 
    ($00, $00, $00, $00, $00, $00, $00, $00, $3, $F, $1B, $11, $3B, $3E, $3E, $3B, $11, $1B, $F, $3, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);

p0Frame4 : array[0.._HEIGHT - 1] of byte = 
    ($00, $00, $00, $00, $00, $00, $00, $00, $23, $2F, $3E, $1F, $37, $22, $36, $3F, $1E, $1C, $E, $3, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);

// Player 1 data
p1Frame1 : array[0.._HEIGHT - 1] of byte = 
    ($00, $00, $00, $00, $00, $00, $00, $00, $E0, $F0, $D8, $88, $DC, $7C, $7C, $DC, $88, $D8, $F0, $E0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);

p1Frame2 : array[0.._HEIGHT - 1] of byte = 
    ($00, $00, $00, $00, $00, $00, $00, $00, $C0, $70, $38, $78, $FC, $6C, $44, $EC, $F8, $78, $F4, $C4, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);

p1Frame3 : array[0.._HEIGHT - 1] of byte = 
    ($00, $00, $00, $00, $00, $00, $00, $00, $EC, $F0, $D8, $88, $DC, $7C, $7C, $DC, $88, $D8, $F0, $E0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);

p1Frame4 : array[0.._HEIGHT - 1] of byte = 
   ($00, $00, $00, $00, $00, $00, $00, $00, $C0, $70, $38, $78, $FC, $6C, $44, $EC, $F8, $78, $F0, $C0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);

pos_rolka: array[0..79] of byte =
    
    (0,4,12,20,28,32,36,32,28,20,12,4,0,4,12,20,28,32,36,32,28,20,12,4,0,2,6,10,14,16,18,16,14,10,6,2,0,2,6,10,14,16,18,16,14,10,6,2,0,1,3,5,7,8,9,8,7,5,3,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
  
  
  PMGMEM : word;
  px0, py0 : byte;
  px1, py1 : byte;
  frame : byte;
  i : byte;

procedure NextFrame;
begin
  if frame = 1 then begin
    Move(p0Frame1, Pointer(PMGMEM + 512 + py0 - pos_rolka[i]), _HEIGHT);
    Move(p1Frame1, Pointer(PMGMEM + 512 + 128 + py1 - pos_rolka[i]), _HEIGHT);
  end
  else if frame = 2 then begin
    Move(p0Frame2, Pointer(PMGMEM + 512 + py0 - pos_rolka[i]), _HEIGHT);
    Move(p1Frame2, Pointer(PMGMEM + 512 + 128 + py1 - pos_rolka[i]), _HEIGHT);
  end
  else if frame = 3 then begin
    Move(p0Frame3, Pointer(PMGMEM + 512 + py0 - pos_rolka[i]), _HEIGHT);
    Move(p1Frame3, Pointer(PMGMEM + 512 + 128 + py1 - pos_rolka[i]), _HEIGHT);
  end
  else if frame = 4 then begin
    Move(p0Frame4, Pointer(PMGMEM + 512 + py0 - pos_rolka[i]), _HEIGHT);
    Move(p1Frame4, Pointer(PMGMEM + 512 + 128 + py1 - pos_rolka[i]), _HEIGHT);
  end;
end;

begin
  // Player position
  px0 := 180; py0 := 60;
  px1 := 188; py1 := 60;

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
  Poke(53248, px0); Poke(53249, px1);

  for i := 1 to 80 do begin
    Poke(53248, px0); Poke(53249, px1);
    Poke(704, p0Color[0]);
    Poke(705, p1Color[0]);
    // Poke(53248, px0); Poke(53249, px1);
    Dec(px0,2); Dec(px1,2);
    NextFrame;
    Inc(frame);
    if frame > 4 then frame := 1;
    Pause(5);
  end;

  repeat until keypressed;
end.
