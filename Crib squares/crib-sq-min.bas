!--------------------------------------------------
!- December-27-20 3:30:31 PM
!- Import of :
!- c:\users\mike\desktop\p\personal\cribbage.prg
!- Commodore 64
!--------------------------------------------------
1 SYS2067:GOTO5
2 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
3 DATA0,1,2,3,0,1,2,4,0,2,3,4,1,2,3,4,0,1,3,4,0,1,2,0,1,3,0,1,4,0,2,3,0,2,4
4 DATA0,3,4,1,2,3,1,2,4,1,3,4,2,3,4,0,1,0,2,0,3,0,4,1,2,1,3,1,4,2,3,2,4,3,4
5 CLR:GOSUB7:GOTO9
6 GOSUB7:GOTO14
7 X=.:Y=.:T=.:A=.:B=.:C=.:D=.:SX=.:SY=.
8 O=1192:RETURN
9 DIMR(5,5),S(4,4),F(5,5),Z(52),T(6)
10 B$="UCCCCI{down}{left*6}B{space*4}B{down}{left*6}B{space*4}B{down}{left*6}B{space*4}B{down}{left*6}B{space*4}B{down}{left*6}JCCCCK
11 BL$="{home}{space*39}{home}":Y$="{down*3}"
12 AL$="{home}{right*2}{down*5}{space*2}{down*3}{space*2}"
13 S$="ASXZ":C$="a23456789tjqk":K$="{black}{red}{black}{red}":D$="{down*10}
14 PRINT"{clear}1] play":PRINT"2] quit{dark gray}
15 GETA$:IFA$="2"THENEND
16 IFA$<>"1"THEN15
17 SYS2087:FORX=0TO5:FORY=0TO5:R(X,Y)=0:NEXT:NEXT
18 CT=(INT(RND(1)*36)+17)
19 POKE53281,8:PRINT"{clear}{home}{down*4}{red} "B$:PRINT"{black} "B$
20 GOSUB36:GOSUB39:PRINT"{home}{down*4}{right*8}{dark gray}>":PRINTBL$
21 V=1:Q=Z(CT)
22 IFQ-13>0THENQ=Q-13:V=V+1:GOTO22
23 P=Q:H=Q:IFP>10THENP=10
24 FORT=0TO3:F(T,4)=V:F(4,T)=V:R(T,4)=Q:R(4,T)=Q:S(T,4)=P:S(4,T)=P:NEXT:P=0
25 IFH=11ORH=24ORH=37ORH=50THENP=P+16
26 FORJ=1TO16:Q=Z(J):A=1:PRINT"{home}{right*2}{down*5}";:L=0
27 IFQ-13>0THENQ=Q-13:A=A+1:GOTO27
28 GOSUB59
29 GOSUB40
30 IFZA$="b"THEN29
31 GOSUB53:NEXT:PRINTBL$"score"P"-cont ?
32 GETZA$:IFZA$="n"THENEND
33 IFZA$<>"y"THEN32
34 WAIT197,13:POKE198,0
35 GOSUB7:GOTO17
36 PRINT"{home}":FORX=1TO3:PRINT"{right*9}";:FORY=1TO4
37 PRINTB$"{up*5}{right*2}";:NEXT:PRINT"{down*4}":NEXT
38 PRINT"{right*9}";:FORY=1TO3:PRINTB$"{up*5}{right*2}";:NEXT:PRINTB$"{home}":RETURN
39 FORX=1TO52:Z(X)=PEEK(831+X):NEXT:RETURN
40 LB=B:GETZA$:IFLB=BANDZA$=""THENLB=0:GOTO40
41 IFZA$="z"THENSY=SY+1:IFSY=4THENSY=0
42 IFZA$="s"THENSX=SX+1:IFSX=4THENSX=0
43 IFZA$=" "THEN45
44 M=O:O=1192+SY*240+SX*8:POKEM,32:POKEO,62:GOTO40
45 IFR(SY,SX)>0THEN40
46 R(SY,SX)=Q:F(SY,SX)=A
47 IFR(SY,SX)>10THENS(SY,SX)=10:GOTO49
48 S(SY,SX)=R(SY,SX)
49 POKE198,0:GOSUB58:GOSUB59
50 GETZA$:IFZA$=""THEN50
51 IFZA$="b"THENGOSUB58:PRINT"{space*2}{down*3}{space*2}":R(SY,SX)=0:RETURN
52 R(5,SX)=R(5,SX)+1:R(SY,5)=R(SY,5)+1:RETURN
53 IFJ<16THEN55
54 A=F(0,4):Q=H:PRINT"{home}{right*2}{down*11}";:POKE198,0:GOSUB59
55 IFR(SY,5)=4THENT=SY:R(SY,5)=0:PRINTAL$:GOSUB60
56 IFR(5,SX)=4THENT=SX:R(5,SX)=0:PRINTAL$:GOSUB89
57 RETURN
58 PRINT"{home}{down*2}{right*10}";SPC(SX*8);:POKE214,SY*6+2:SYS58732:RETURN
59 PRINTMID$(K$,A,1)MID$(C$,Q,1)MID$(S$,A,1)Y$MID$(C$,Q,1)MID$(S$,A,1):RETURN
60 RESTORE-2:C=0:FORX=1TO4:IFF(T,0)=F(T,X)THENC=C+1:IFC=3ANDX=3THENP=P+4
61 NEXT:IFC=4THENP=P+1
62 FORY=0TO3:IFR(T,Y)=11ANDF(T,Y)=VTHENP=P+1
63 NEXT
64 FORY=0TO2:FORX=Y+1TO4:IFR(T,Y)=R(T,X)THENP=P+2
65 NEXT:NEXT:IFR(T,3)=HTHENP=P+2
66 IFS(T,0)+S(T,1)+S(T,2)+S(T,3)+H=15THENP=P+2:GOTO73
67 FORY=0TO4:READA,B,C,D:IFS(T,A)+S(T,B)+S(T,C)+S(T,D)=15THENP=P+2
68 NEXT
69 FORY=0TO9:READA,B,C:IFS(T,A)+S(T,B)+S(T,C)=15THENP=P+2
70 NEXT
71 FORY=0TO9:READA,B:IFS(T,A)+S(T,B)=15THENP=P+2
72 NEXT
73 RESTORE
74 FORY=0TO4:S(T,Y)=R(T,Y):NEXT
75 FORX=0TO3:FORY=X+1TO4
76 IFS(T,X)>S(T,Y)THENK=S(T,X):S(T,X)=S(T,Y):S(T,Y)=K
77 NEXT:NEXT
78 K=S(T,0)+1
79 IFK=S(T,1)ANDK+1=S(T,2)ANDK+2=S(T,3)ANDK+3=S(T,4)THENP=P+5:GOTO86
80 RESTORE-2:FORY=0TO4:READA,B,C,D:K=S(T,A)+1
81 IFK=S(T,B)ANDK+1=S(T,C)ANDK+2=S(T,D)THENP=P+4:L=1
82 NEXT:IFLTHEN86
83 FORY=0TO9:READA,B,C:K=S(T,A)+1
84 IFK=S(T,B)ANDK+1=S(T,C)THENP=P+3
85 NEXT
86 FORX=0TO4:IFR(T,X)>10THENS(T,X)=10:GOTO88
87 S(T,X)=R(T,X)
88 NEXT:RETURN
89 RESTORE-2:C=0:FORX=1TO4:IFF(0,T)=F(X,T)THENC=C+1:IFC=3ANDX=3THENP=P+4
90 NEXT:IFC=4THENP=P+1
91 FORY=0TO3:IFR(Y,T)=11ANDF(Y,T)=VTHENP=P+1
92 NEXT
93 FORY=0TO2:FORX=Y+1TO4:IFR(Y,T)=R(X,T)THENP=P+2
94 NEXT:NEXT:IFR(3,T)=HTHENP=P+2
95 IFS(0,T)+S(1,T)+S(2,T)+S(3,T)+H=15THENP=P+2:GOTO102
96 FORY=0TO4:READA,B,C,D:IFS(A,T)+S(B,T)+S(C,T)+S(D,T)=15THENP=P+2
97 NEXT
98 FORY=0TO9:READA,B,C:IFS(A,T)+S(B,T)+S(C,T)=15THENP=P+2
99 NEXT
100 FORY=0TO9:READA,B:IFS(A,T)+S(B,T)=15THENP=P+2
101 NEXT
102 RESTORE
103 FORY=0TO4:S(Y,T)=R(Y,T):NEXT
104 FORX=0TO3:FORY=X+1TO4
105 IFS(X,T)>S(Y,T)THENK=S(X,T):S(X,T)=S(Y,T):S(Y,T)=K
106 NEXT:NEXT
107 K=S(0,T)+1
108 IFK=S(1,T)ANDK+1=S(2,T)ANDK+2=S(3,T)ANDK+3=S(4,T)THENP=P+5:GOTO115
109 RESTORE-2:FORY=0TO4:READA,B,C,D:K=S(A,T)+1
110 IFK=S(B,T)ANDK+1=S(C,T)ANDK+2=S(D,T)THENP=P+4:L=1
111 NEXT:IFLTHEN115
112 FORY=0TO9:READA,B,C:K=S(A,T)+1
113 IFK=S(B,T)ANDK+1=S(C,T)THENP=P+3
114 NEXT
115 FORX=0TO4:IFR(X,T)>10THENS(X,T)=10:GOTO117
116 S(X,T)=R(X,T)
117 NEXT:RETURN