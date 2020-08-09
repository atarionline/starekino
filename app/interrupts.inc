(* declare your interrupt routines here *)

procedure dli;assembler;interrupt;
asm {
    phr ; store registers

;   *** example test routine
;    lda #64 ; wait this number of lines
;@   cmp vcount
;    bpl @-
;    mva #$0f atari.colbk ; change backgroung color to white
    
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
