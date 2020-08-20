(* declare your interrupt routines here *)

procedure dli1;interrupt;
begin
    asm {
        phr ; store registers

    ;   *** example test routine
    ;    lda #64 ; wait this number of lines
    ;@   cmp vcount
    ;    bpl @-
        mva #$4f atari.colbk ; change backgroung color to white
    };
        hposp[0] := bat_px0;
        hposp[1] := bat_px1;
    asm {
        mwa #dli2 __dlivec
        plr ; restore registers
    };
end;

procedure dli2;interrupt;
begin
    asm {
        phr ; store registers

    ;   *** example test routine
    ;    lda #64 ; wait this number of lines
    ;@   cmp vcount
    ;    bpl @-
         mva #$9f atari.colbk ; change backgroung color to white
    };
        hposp[0] := sreel_px0;
        hposp[1] := sreel_px1;
    asm {
        mwa #dli3 __dlivec
        plr ; restore registers
    };
end;

procedure dli3;interrupt;
begin
    asm {
        phr ; store registers

    ;   *** example test routine
    ;    lda #64 ; wait this number of lines
    ;@   cmp vcount
    ;    bpl @-
        mva #$df atari.colbk ; change backgroung color to white
    };
        hposp[0] := bike_px0;
        hposp[1] := bike_px1;
    asm {
        mwa #dli4 __dlivec

        plr ; restore registers
    };
end;

procedure dli4;interrupt;
begin
    asm {
        phr ; store registers

    ;   *** example test routine
    ;    lda #64 ; wait this number of lines
    ;@   cmp vcount
    ;    bpl @-
        mva #$ff atari.colbk ; change backgroung color to white
    };
        hposp[0] := 0;
        hposp[1] := 0;
    asm {
        mwa #dli1 __dlivec

        plr ; restore registers
    };
end;

procedure vbl;interrupt;
begin
    
    asm {
        phr ; store registers
    
        lda music 
        beq @+
        
        lda MSX
        ldy MSX+1
        jsr RMT.TRMT.PLAY
@

        plr ; restore registers
        rti
    };
    msx.play;
end;
