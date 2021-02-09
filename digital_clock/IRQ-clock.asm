screen_ram = $fb        ;screenram pointer to plot segment
CINV = $0314            ;IRQ vector
clock = $c000           ;where the IRQ routine is moved to
getinput = $abf9        ;ROM=print ? and input into buffer area ($0200)
IRQnormal = $ea31       ;usual c64 IRQ address
HIBASE = $0288          ;page number of screen
inputbuffer = $0200     ;input buffer location
movebase = $0900        ;code that gets relocated
movefrom = $fb          ;zero page addresses for
moveto = $fd            ;indexed addressing mode
printstring = $ab1e     ;ROM=print string ending in zero byte



*=$0801                 ; 10 SYS2560 (BASIC LOADER) $0A00

        BYTE $0B,$08,$0A,$00,$9E,$32,$35,$36,$30,$00,$00,$00



*=$0900         ;this is our main code that gets moved to $c000

relocate $c000  ;assembles object code for $C000 slot/not $0900

jiffy           ;clock decimal digit storage
        byte0
second
        byte0
seconds
        byte0
minute
        byte0
minutes
        byte0
hour
        byte0
hours
        byte0


entry
        jsr intialize_clock
        rts             ;set IRQ to point to our routine



intialize_clock         ;reroute IRQ to our routine
        sei             ;1st we disable any interrupts
        lda #<updateclock
        sta CINV        ;set new IRQ vector
        lda #>updateclock
        sta CINV+1      ;set new IRQ vector to 'updateclock'
        rts


updateclock             ;new IRQ entry is here
        inc jiffy       ;increase our jiffy
        lda jiffy
        cmp#$3C         ;is it 60?
        bne display     ;no? we're done

        lda#$00         ;yes
        sta jiffy       ;reset jiffy and

        inc second      ;increase seconds
        lda second
        cmp#$0A         ;is it 10?
        bne display     ;no? we're done

        lda#$00         ;reset second and
        sta second      ;store it then

        inc seconds     ;increase seconds
        lda seconds
        cmp#$06         ;60 seconds?
        bne display     ;no? we're done

        lda#$00         ;reset seconds and
        sta seconds     ;store it then

        inc minute      ;increase minute
        lda minute
        cmp#$0A         ;10 minutes?
        bne display

        lda#$00         ;reset
        sta minute

        inc minutes
        lda minutes
        cmp#$06         ;60 minutes?
        bne display

        lda#$00         ;reset
        sta minutes

        inc hour
        lda hour
        cmp#$0A         ;10 hours?
        bne display

        lda#$00         ;reset
        sta hour

        inc hours
        lda hours
        cmp#$18         ;24 hours yet?
        bne display     ;no

        lda#$00         ;reset hours
        sta hours

display
        lda HIBASE       ;current screen page number
        sta screen_ram+1 ;intitialize screen ptr into ($FB)
        lda #$00
        sta screen_ram
        sta work3       ;and reset work index3

        ldx #$06        ;outer loop from 6 to 1 digits
l1
        stx work2       ;current_get
        clc             ;clear carry before adding
        lda jiffy,x     ;current digit
        asl             ;X2
        sta work1       ;store intermediate value
        asl             ;X4
        adc work1       ;add to 6X now
        sta work1       ;store it
        tax             ;move to x index
        ldy#$06         ;inner loop 6 times
l2
        sty work3       ;save inner loop index
        ldy #$00        ;index to current tile
        lda clocktab,x  ;get a segment
        sta (screen_ram),y
        inx             ;print it and increase index
        lda clocktab,x  ;get next segment
        iny
        sta (screen_ram),y;print it
        clc
        lda screen_ram
        adc #$28        ;add forty to screen pointer
        sta screen_ram  ;and store it
        lda screen_ram+1
        adc #$00        ;must add the carry bit
        sta screen_ram+1
        inx             ;inc char index
        ldy work3       ;inner loop
        dey
        dey
        bne l2          ;more? branch to l2
        tya             ;Y is now #$00
        sta work1       ;reset store
        sec
        lda screen_ram  ;move the pointer
        sbc #$76        ;back to top of screen
        sta screen_ram  ;into the next column
        lda screen_ram+1
        sbc #$00
        sta screen_ram+1
        ldx work2       ;outer loop
        dex
        bne l1          ;more digits? jump to l1
        jmp IRQnormal   ;done/resume IRQ






*=$0a00


locate                  ;memory move $0900... to $C000...
        lda #>clock
        sta moveto+1    ;to address HB
        lda #>movebase
        sta movefrom+1  ;from address HB
        lda #<movebase
        sta movefrom    ;to address LB
        lda #<clock
        sta moveto      ;from address LB
        ldx #$01        ;we will move two pages
        ldy #$00        ;loop variable

l3
        lda(movefrom),y ;from address
        sta(moveto),y   ;to address
        iny
        bne l3          ;inner loop
        inc moveto      ;increase High Bytes
        inc movefrom
        dex             ;decrease page loop
        bpl l3          ;move another page if positive


get_time_input          ;ask user for the time
        ldy #>time      ;default time string
        lda #<time
        jsr printstring ;print default time
        jsr getinput    ;ROM=receive input into buffer

        ldx#$00         ;verify the time
        lda inputbuffer,x       ;H
        bmi get_time_input      ;is it <0
        cmp #$33                ;legal 1st digit?
        bcs get_time_input      ;BSC branch if >=

        inx
        lda inputbuffer,x       ;h
        bmi get_time_input
        cmp #$3a                ; is it > 9?
        bcs get_time_input

        inx
        lda inputbuffer,x       ;M
        bmi get_time_input
        cmp #$36                ;< 6
        bcs get_time_input
        cmp #$3a                ; is it > 9?
        bcs get_time_input

        inx
        lda inputbuffer,x       ;m
        bmi get_time_input
        cmp #$3a                ; is it > 9?
        bcs get_time_input

        inx
        lda inputbuffer,x       ;S
        bmi get_time_input
        cmp #$36                ;< 6
        bcs get_time_input
        cmp #$3a                ; is it > 9?
        bcs get_time_input

        inx
        lda inputbuffer,x       ;s
        bmi get_time_input
        cmp #$3a                ; is it > 9?
        bcs get_time_input

        ldx #$00
        lda inputbuffer,x       ;verify hours are <24
        cmp #$32
        bcc isok
        inx
        lda inputbuffer,x
        cmp #$34
        bcs get_time_input
isok                    ;input is OK
        ldx #$00
        ldy #$06
getdigit
        lda inputbuffer,x
        and #$0f        ;get digit/mask off PETSCII to obtain number
        sta clock,y     ;store into clock storage area
        inx
        dey             ;more?
        bne getdigit    ;get more if y>0
        jmp entry       ;else initialize the clock

time                    ;default time string (142700)
        byte $20,$20,$31,$34,$32,$37,$30,$30,$9D,$9D,$9D,$9D,$9D,$9D,$9D,$9D,$00


work1                   ;temp storage area
        byte0
work2
        byte0
work3
        byte0

clocktab                ;6 each, segment screencodes for digits 0-9
                        ;placed left to right/top to bottom
        byte 100,32,101,101,76,101
        byte 32,32,32,101,32,101
        byte 100,32,100,101,76,32
        byte 100,32,100,101,100,101
        byte 32,32,76,101,32,101
        byte 100,32,76,32,100,101
        byte 100,32,76,32,76,101
        byte 100,32,101,101,32,101
        byte 100,32,76,101,76,101
        byte 100,32,76,101,100,101
