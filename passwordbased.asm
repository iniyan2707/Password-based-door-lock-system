org 0h

MAIN:
ACALL LCD_INIT
MOV DPTR,#MYDATA
ACALL SEND_DAT
ACALL DELAY
ACALL READ_KEYPRESS
ACALL DELAY
ACALL CHECK_PASSWORD  

Stay_here:SJMP Stay_here 
	


READ_KEYPRESS:
MOV R0,#5D
MOV R1,#160D
ROTATE:ACALL KEY_SCAN
MOV @R1,A
ACALL DATAWRT
ACALL DELAY2
INC R1
DJNZ R0,ROTATE
RET

CHECK_PASSWORD:MOV R0,#5D
MOV R1,#160D
MOV DPTR,#PASSWORD
RPT:CLR A
MOVC A,@A+DPTR
XRL A,@R1
JNZ FAIL
INC R1
INC DPTR
DJNZ R0,RPT
ACALL LCD_INIT
MOV DPTR,#TEXT_S1
ACALL SEND_DAT
ACALL DELAY
SETB P2.3
CLR P2.4
SJMP GOBACK
FAIL:ACALL LCD_INIT
MOV DPTR,#TEXT_F1
ACALL SEND_DAT
ACALL DELAY
CLR P2.3
CLR P2.4
ACALL MAIN
GOBACK:RET

LCD_INIT:MOV DPTR,#MYCOM
C1:CLR A
MOVC A,@A+DPTR
ACALL COMNWRT
ACALL  DELAY
INC DPTR
JZ DAT
SJMP C1
DAT:RET

SEND_DAT:  
CLR A
MOVC A,@A+DPTR
ACALL DATAWRT
ACALL DELAY
INC DPTR
JZ AGAIN
SJMP SEND_DAT
AGAIN: RET



KEY_SCAN:MOV P1,#11111111B 
CLR P1.0 
JB P1.4, NEXT1 
MOV A,#55D
RET

NEXT1:JB P1.5,NEXT2
MOV A,#56D
RET

NEXT2: JB P1.6,NEXT3
MOV A,#57D 		  
RET

NEXT3: JB P1.7,NEXT4
MOV A,#47D 
RET

NEXT4:SETB P1.0
CLR P1.1 
JB P1.4, NEXT5 
MOV A,#52D 
RET

NEXT5:JB P1.5,NEXT6
MOV A,#53D	
RET

NEXT6: JB P1.6,NEXT7
MOV A,#54D
RET

NEXT7: JB P1.7,NEXT8
MOV A,#42D
RET

NEXT8:SETB P1.1
CLR P1.2
JB P1.4, NEXT9 
MOV A,#49D 
RET

NEXT9:JB P1.5,NEXT10
MOV A,#50D 
RET

NEXT10: JB P1.6,NEXT11
MOV A,#51D	 
RET

NEXT11: JB P1.7,NEXT12
MOV A,#45D 
RET

NEXT12:SETB P1.2
CLR P1.3
JB P1.4, NEXT13 
MOV A,#67D
RET

NEXT13:JB P1.5,NEXT14
MOV A,#48D 
RET

NEXT14: JB P1.6,NEXT15
MOV A,#61D	
RET

NEXT15: JB P1.7,NEXT16
MOV A,#43D
RET
NEXT16:LJMP KEY_SCAN


COMNWRT:MOV P3,A
CLR P2.0
CLR P2.1
SETB P2.2
ACALL DELAY
CLR P2.2
RET

DATAWRT: MOV P3,A
SETB P2.0
CLR P2.1
SETB P2.2
ACALL DELAY
CLR P2.2
RET

DELAY: MOV R3,#50
HERE2: MOV R4,#255
HERE: DJNZ R4,HERE
DJNZ R3,HERE2
RET

DELAY2:	MOV R3,#250D
         MOV TMOD,#01
BACK2:   MOV TH0,#0FCH 
        MOV TL0,#018H 
        SETB TR0 
HERE5:  JNB TF0,HERE5
        CLR TR0 
        CLR TF0 
        DJNZ R3,BACK2
        RET       

CLRSCR: MOV A,#01H
ACALL COMNWRT
RET

ORG 500H
MYCOM: DB 38H,0EH,01,06,80H,0
MYDATA: DB "Password-",0
PASSWORD:DB 49D,50D,51D,52D,53D,0
TEXT_F1: DB "INCORRECT",0
TEXT_S1: DB "CORRECT",0
END