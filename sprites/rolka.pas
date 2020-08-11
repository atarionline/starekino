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
     ($7, $1F, $3E, $7C, $7E, $FF, $E7, $C2, $C2, $E7, $FF, $7E, $7C, $3E, $1F, $F7, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);

p0Frame2 : array[0.._HEIGHT - 1] of byte = 
    ($7, $1F, $3F, $73, $61, $E1, $F3, $FE, $FE, $F3, $E1, $61, $73, $3F, $1F, $7, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);

p0Frame3 : array[0.._HEIGHT - 1] of byte = 
    ($7, $1F, $3E, $7C, $7E, $FF, $E7, $C2, $C2, $E7, $FF, $7E, $7C, $3E, $1F, $7, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);

p0Frame4 : array[0.._HEIGHT - 1] of byte = 
    ($87, $9F, $BF, $F3, $61, $E1, $F3, $FE, $FE, $F3, $E1, $61, $73, $3F, $1F, $7, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);

// Player 1 data
p1Frame1 : array[0.._HEIGHT - 1] of byte = 
    ($E0, $F8, $7C, $3E, $7E, $FF, $E7, $43, $43, $E7, $FF, $7E, $3E, $7C, $F8, $E0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);


p1Frame2 : array[0.._HEIGHT - 1] of byte = 
    ($E0, $F8, $FC, $CE, $86, $87, $CF, $7F, $7F, $CF, $87, $86, $CF, $FD, $F9, $E1, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);

p1Frame3 : array[0.._HEIGHT - 1] of byte = 
    ($EF, $F8, $7C, $3E, $7E, $FF, $E7, $43, $43, $E7, $FF, $7E, $3E, $7C, $F8, $E0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);

p1Frame4 : array[0.._HEIGHT - 1] of byte = 
    ($E0, $F8, $FC, $CE, $86, $87, $CF, $7F, $7F, $CF, $87, $86, $CE, $FC, $F8, $E0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);

pos_rolka: array[0..79] of byte =
    (0,20,28,32,40,32,28,20,0,20,28,32,40,32,28,20,0,20,28,32,40,32,28,20,0,10,14,16,20,16,14,10,0,10,14,16,20,16,14,10,0,10,14,16,20,16,14,10,0,5,7,8,10,8,7,5,0,5,7,8,10,8,7,5,0,5,7,8,10,8,7,5,0,5,7,8,10,8,7,5);

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
    Dec(px0,3); Dec(px1,3);
    NextFrame;
    Inc(frame);
    if frame > 4 then frame := 1;
    Pause(5);
  end;

  repeat until keypressed;
end.
