10 print"{clear}{down*2}current time"
20 input"  142700{left*8}";h$
25 iflen(h$)<>6then10
30 ifval(left$(h$,2))>23then10
50 forx=0to5
60 poke2310-x,val(mid$(h$,x+1,1))
70 next
80 sys2311