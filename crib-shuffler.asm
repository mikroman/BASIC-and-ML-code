

*=$0813



        LDA #$FF
        STA $D40F       ;Voice #3 frequency (hi byte)
        LDA #$81
        STA $D412       ;Voice #3 control register(noise)
        LDA #$36
        TAY

loop1   STA $0340,Y     ;clear deck storage
        DEY
        BPL loop1
        LDX #$00

getrnd  LDA $D41B       ;get a (RND?) byte
        BEQ getrnd
        CMP #$35
        BCS getrnd      ;if not <53?
        STA $FE         ; store it
        TXA 
        TAY
lookat  LDA $0340,Y
        CMP $FE
        BEQ getrnd      ;already picked?
        DEY
        BPL lookat      ;no? check rest of deck
        LDA $FE
        STA $0340,X     ; load and store origianl card
        INX
        CPX #$34
        BNE getrnd      ;done yet?
        RTS