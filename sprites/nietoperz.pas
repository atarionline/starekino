uses
  SysUtils, FastGraph, Crt;

const
  _HEIGHT = 30;

var
  // Colors for players
  p0Color : array[0..1] of byte = (28, 28);
  p1Color : array[0..1] of byte = (28, 28);

// Player 0 data
p0Frame1 : array[0.._HEIGHT - 1] of byte = 
    ($2, $2, $3, $F, $3E, $7F, $7F, $F3, $C3, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);

p0Frame2 : array[0.._HEIGHT - 1] of byte = 
    ($00, $2, $C2, $73, $7B, $3E, $3F, $1F, $17, $3, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);

// Player 1 data
p1Frame1 : array[0.._HEIGHT - 1] of byte = 
    ($40, $40, $C0, $F0, $BC, $FE, $FE, $CF, $C3, $1, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);


p1Frame2 : array[0.._HEIGHT - 1] of byte = 
    ($00, $40, $43, $CE, $DE, $BC, $FC, $F8, $E8, $C0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);

  PMGMEM : word;
  px0, py0 : byte;
  px1, py1 : byte;
  frame : byte;
  i : byte;

procedure NextFrame;
begin
  if frame = 1 then begin
    Move(p0Frame1, Pointer(PMGMEM + 512 + py0), _HEIGHT);
    Move(p1Frame1, Pointer(PMGMEM + 512 + 128 + py1), _HEIGHT);
  end
  else if frame = 2 then begin
    Move(p0Frame2, Pointer(PMGMEM + 512 + PY0), _HEIGHT);
    Move(p1Frame2, Pointer(PMGMEM + 512 + 128 + PY1), _HEIGHT);
  end;
end;

begin
  // Player position
  px0 := 80; py0 := 40;
  px1 := 88; py1 := 40;

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

  for i := 1 to 50 do begin
    NextFrame;
    Poke(704, p0Color[0]);
    Poke(705, p1Color[0]);
    Pause(5);
    Inc(frame);
    if frame > 2 then frame := 1;
  end;

  repeat until keypressed;
end.
