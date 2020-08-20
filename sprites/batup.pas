uses
  SysUtils, FastGraph, Crt;

const
  _HEIGHT = 16;

var
  // Colors for players
  p0Color : array[0..3] of byte = (29, 29, 29, 29);
  p1Color : array[0..3] of byte = (29, 29, 29, 29);


reel_p1Frame1 : array[0.._HEIGHT - 1] of byte = ($00,$06,$0E,$9C,$DC,$FC,$FC,$FC,$F8,$F0,$E0,$C0,$00,$00,$00,$00);
reel_p0Frame1 : array[0.._HEIGHT - 1] of byte = ($00,$30,$38,$1C,$1D,$1F,$1F,$1F,$0F,$07,$03,$01,$00,$00,$00,$00);
reel_p1Frame2 : array[0.._HEIGHT - 1] of byte = ($00,$00,$80,$C0,$FF,$FF,$FE,$FC,$F8,$E0,$E0,$E0,$C0,$00,$00,$00);
reel_p0Frame2 : array[0.._HEIGHT - 1] of byte = ($00,$00,$00,$01,$7F,$7F,$3F,$1F,$0F,$03,$03,$03,$01,$00,$00,$00);
reel_p1Frame3 : array[0.._HEIGHT - 1] of byte = ($80,$C0,$E0,$F0,$F8,$FC,$FC,$FC,$FC,$FC,$EE,$C6,$00,$00,$00,$00);
reel_p0Frame3 : array[0.._HEIGHT - 1] of byte = ($00,$01,$03,$07,$0F,$1F,$1F,$1F,$1F,$1F,$3B,$31,$00,$00,$00,$00);
reel_p1Frame4 : array[0.._HEIGHT - 1] of byte = ($00,$00,$80,$C0,$FF,$FF,$FE,$FC,$F8,$E0,$E0,$E0,$C0,$00,$00,$00);
reel_p0Frame4 : array[0.._HEIGHT - 1] of byte = ($00,$00,$00,$01,$7F,$7F,$3F,$1F,$0F,$03,$03,$03,$01,$00,$00,$00);
 


   

reel_pos: array[0..79] of byte =
    (0,4,12,20,28,32,36,32,28,20,12,4,0,4,12,20,28,32,36,32,28,20,12,4,0,2,6,10,14,16,18,16,14,10,6,2,0,2,6,10,14,16,18,16,14,10,6,2,0,1,3,5,7,8,9,8,7,5,3,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
  
  
  PMGMEM : word;
  reel_px0, reel_py0 : byte;
  reel_px1, reel_py1 : byte;
  frame : byte;
  i : byte;

procedure NextFrame;
begin
  if frame = 1 then begin
    Move(reel_p0Frame1, Pointer(PMGMEM + 512 + reel_py0 - reel_pos[i]), _HEIGHT);
    Move(reel_p1Frame1, Pointer(PMGMEM + 512 + 128 + reel_py1 - reel_pos[i]), _HEIGHT);
  end
  else if frame = 2 then begin
    Move(reel_p0Frame2, Pointer(PMGMEM + 512 + reel_py0 - reel_pos[i]), _HEIGHT);
    Move(reel_p1Frame2, Pointer(PMGMEM + 512 + 128 + reel_py1 - reel_pos[i]), _HEIGHT);
  end
  else if frame = 3 then begin
    Move(reel_p0Frame3, Pointer(PMGMEM + 512 + reel_py0 - reel_pos[i]), _HEIGHT);
    Move(reel_p1Frame3, Pointer(PMGMEM + 512 + 128 + reel_py1 - reel_pos[i]), _HEIGHT);
  end
  else if frame = 4 then begin
    Move(reel_p0Frame4, Pointer(PMGMEM + 512 + reel_py0 - reel_pos[i]), _HEIGHT);
    Move(reel_p1Frame4, Pointer(PMGMEM + 512 + 128 + reel_py1 - reel_pos[i]), _HEIGHT);
  end;
end;

begin
  // Player position
  reel_px0 := 210; reel_py0 := 60;
  reel_px1 := 218; reel_py1 := 60;

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
  Poke(53248, reel_px0); Poke(53249, reel_px1);

  for i := 1 to 80 do begin
    Poke(53248, reel_px0); Poke(53249, reel_px1);
    Poke(704, p0Color[0]);
    Poke(705, p1Color[0]);
    // Poke(53248, reel_px0); Poke(53249, reel_px1);
    Dec(reel_px0,3); Dec(reel_px1,3);
    NextFrame;
    Inc(frame);
    if frame > 4 then frame := 1;
    Pause(5);
  end;

  repeat until keypressed;
end.
