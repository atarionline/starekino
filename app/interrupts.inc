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

procedure vbl_title; interrupt;
begin
    asm {
        phr ; store registers

        mva #1 dli_title.cnt

        mva adr.fntTable chbase
        mva adr.fntTable+1 dli_title.chbs

        mva adr.c0Table colpf0
        mva adr.c0Table+1 dli_title.col0
        mva adr.c1Table colpf1
        mva adr.c1Table+1 dli_title.col1
        mva adr.c2Table colpf2
        mva adr.c2Table+1 dli_title.col2
        mva adr.c3Table colpf3
        mva adr.c3Table+1 dli_title.col3

        mva #$00 colbak
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


procedure dli_title; assembler; interrupt;
asm
{
	sta rA
	stx rX
	sty rY

	lda #0
chbs	equ *-1

	ldx #0
col0	equ *-1

	ldy #0
col1	equ *-1

	;sta wsync

	sta chbase
	lda #0
col2	equ *-1
	stx colpf0
	ldx #0
col3	equ *-1
	sty colpf1
	sta colpf2
	stx colpf3

	inc cnt

	ldx #0
cnt	equ *-1

	lda adr.fntTable,x
	sta chbs

	lda adr.c0Table,x
	sta col0

	lda adr.c1Table,x
	sta col1

	lda adr.c2Table,x
	sta col2

	lda adr.c3Table,x
	sta col3

	lda #0
rA	equ *-1
	ldx #0
rX	equ *-1
	ldy #0
rY	equ *-1
};
	end;