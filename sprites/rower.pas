{
  Player/missile graphics demonstration
}
uses crt, graph, atari;

var
  ramtop : byte absolute $6A;    // Top of RAM in 256-byte pages

  pcolr : array[0..3] of byte absolute $2C0;   // Player color
  hposp : array[0..3] of byte absolute $D000;  // Player horizontal position
  sizep : array[0..3] of byte absolute $D008;  // Player size
  hposm : array[0..3] of byte absolute $D004;  // Missile horizontal position
  pmgmem : word;

  // Player data
  player0 : array [0..29] of byte =
    (0, 0, 0, 0, 0, 24, 12, 8, 30, 44, 74, 74, 144, 144, 144, 128, 128, 66, 66, 36, 24, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  player1 : array [0..29] of byte =
    (0, 0, 0, 0, 0, 0, 0, 0, 136, 112, 32, 16, 136, 136, 132, 132, 142, 21, 21, 17, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0);

  // Player position
  px0 : byte = 81; py0 : byte = 40;
  px1 : byte = 88; py1 : byte = 40;

begin
  // Initialize P/M graphics
  InitGraph(0);
  gractl := 0;
  color2 := 0; color4 := 0;

  // Set P/M graphics
  pmgmem := ramtop - 8;
  pmbase := pmgmem;
  pmgmem := pmgmem shl 8;

  // P/M graphics double resolution
  sdmctl := 46;

  // Clear player memory
  FillByte(Pointer(pmgmem + 384), 512 + 128, 0);

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
  Move(player0, Pointer(pmgmem + 512 + 128*0 + py0), 29);
  // Draw player 1 and set vertical position
  Move(player1, Pointer(pmgmem + 512 + 128*1 + py1), 29);

  gractl := 3;

  repeat until keypressed;

  // Reset P/M graphics
  gractl := 0;
end.