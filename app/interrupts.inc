(* declare your interrupt routines here *)

procedure dli1;assembler;interrupt;
asm {
    phr ; store registers

;   *** example test routine
;    lda #64 ; wait this number of lines
;@   cmp vcount
;    bpl @-
    mva #$4f atari.colbk ; change backgroung color to white

    mwa #dli2 __dlivec
    plr ; restore registers
};
end;

procedure dli2;assembler;interrupt;
asm {
    phr ; store registers

;   *** example test routine
;    lda #64 ; wait this number of lines
;@   cmp vcount
;    bpl @-
    mva #$8f atari.colbk ; change backgroung color to white

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
