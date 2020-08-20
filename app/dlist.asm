; Here is place for your custom display list definition.
; Handy constants are defined first:

DL_BLANK1 = 0; // 1 blank line
DL_BLANK2 = %00010000; // 2 blank lines
DL_BLANK3 = %00100000; // 3 blank lines
DL_BLANK4 = %00110000; // 4 blank lines
DL_BLANK5 = %01000000; // 5 blank lines
DL_BLANK6 = %01010000; // 6 blank lines
DL_BLANK7 = %01100000; // 7 blank lines
DL_BLANK8 = %01110000; // 8 blank lines

DL_DLI = %10000000; // Order to run DLI
DL_LMS = %01000000; // Order to set new memory address
DL_VSCROLL = %00100000; // Turn on vertical scroll on this line
DL_HSCROLL = %00010000; // Turn on horizontal scroll on this line

DL_MODE_40x24T2 = 2; // Antic Modes
DL_MODE_40x24T5 = 4;
DL_MODE_40x12T5 = 5;
DL_MODE_20x24T5 = 6;
DL_MODE_20x12T5 = 7;
DL_MODE_40x24G4 = 8;
DL_MODE_80x48G2 = 9;
DL_MODE_80x48G4 = $A;
DL_MODE_160x96G2 = $B;
DL_MODE_160x192G2 = $C;
DL_MODE_160x96G4 = $D;
DL_MODE_160x192G4 = $E;
DL_MODE_320x192G2 = $F;

DL_JMP = %00000001; // Order to jump
DL_JVB = %01000001; // Jump to begining
    
; It's always useful to include you program global constants here
    icl 'const.inc'

; and declare display list itself

; example (BASIC mode 0 + display list interrupt at top):
dl_start
  dta $70, $70, $70, $70, $70, $70, $df, a($6000), $5f, a($6080)
  dta $5f, a($6100), $5f, a($6180), $5f, a($6200), $5f, a($6280), $5f, a($6300)
  dta $5f, a($6380), $5f, a($6400), $5f, a($6480), $5f, a($6500), $5f, a($6580)
  dta $5f, a($6600), $5f, a($6680), $5f, a($6700), $5f, a($6780), $5f, a($6800)
  dta $5f, a($6880), $5f, a($6900), $5f, a($6980), $5f, a($6a00), $5f, a($6a80)
  dta $5f, a($6b00), $5f, a($6b80), $5f, a($6c00), $5f, a($6c80), $5f, a($6d00)
  dta $5f, a($6d80), $5f, a($6e00), $5f, a($6e80), $5f, a($6f00), $5f, a($6f80)
  dta $5f, a($7000), $5f, a($7080), $5f, a($7100), $5f, a($7180), $5f, a($7200)
  dta $5f, a($7280), $5f, a($7300), $5f, a($7380), $5f, a($7400), $5f, a($7480)
  dta $5f, a($7500), $5f, a($7580), $5f, a($7600), $5f, a($7680), $5f, a($7700)
  dta $5f, a($7780), $5f, a($7800), $5f, a($7880), $5f, a($7900), $5f, a($7980)
  dta $5f, a($7a00), $5f, a($7a80), $5f, a($7b00), $5f, a($7b80), $5f, a($7c00)
  dta $5f, a($7c80), $5f, a($7d00), $5f, a($7d80), $5f, a($7e00), $5f, a($7e80)
  dta $5f, a($7f00), $5f, a($7f80), $5f, a($8000), $5f, a($8080), $5f, a($8100)
  dta $5f, a($8180), $5f, a($8200), $5f, a($8280), $5f, a($8300), $5f, a($8380)
  dta $5f, a($8400), $5f, a($8480), $5f, a($8500), $5f, a($8580), $5f, a($8600)
  dta $5f, a($8680), $5f, a($8700), $5f, a($8780), $5f, a($8800), $5f, a($8880)
  dta $5f, a($8900), $5f, a($8980), $5f, a($8a00), $5f, a($8a80), $5f, a($8b00)
  dta $5f, a($8b80), $5f, a($8c00), $5f, a($8c80), $5f, a($8d00), $5f, a($8d80)
  dta $5f, a($8e00), $5f, a($8e80), $5f, a($8f00), $5f, a($8f80), $5f, a($9000)
  dta $5f, a($9080), $5f, a($9100), $5f, a($9180), $5f, a($9200), $5f, a($9280)
  dta $5f, a($9300), $5f, a($9380), $5f, a($9400), $5f, a($9480), $5f, a($9500)
  dta $5f, a($9580), $5f, a($9600), $5f, a($9680), $5f, a($9700), $5f, a($9780)
  dta $5f, a($9800), $5f, a($9880), $df, a($9900), $5f, a($9980), $5f, a($9a00)
  dta $5f, a($9a80), $5f, a($9b00), $5f, a($9b80), $5f, a($9c00), $5f, a($9c80)
  dta $5f, a($9d00), $5f, a($9d80), $5f, a($9e00), $5f, a($9e80), $5f, a($9f00)
  dta $5f, a($9f80), $70, $70, $70, $70, $70, $70, $41, a(dl_start)
