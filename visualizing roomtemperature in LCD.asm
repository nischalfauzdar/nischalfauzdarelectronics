;110MICROSECOND F=1/(1.1RC)
;1^C=10mV			 (0V)
	;				   ;	
	;				   ;
;206^C= 2560mV		 (5V)

ORG 0000H
READ BIT P2.0 ; bit addressable
WRITE BIT P2.1 ; adc 0804
INTR BIT P2.2

MOV A,#38H ; init. LCD 2 lines, 5x7 matrix
ACALL COMMWRT ; call command write(COMMWRT) subroutine
MOV A,#0CH ; display on, cursor off
ACALL COMMWRT ; call command write(COMMWRT) subroutine
MOV A,#01H ; clear LCD
ACALL COMMWRT ; call command write(COMMWRT) subroutine
MOV A,#06H ; shift cursor right
ACALL COMMWRT ; call command write(COMMWRT) subroutine
MOV A,#80H ; cursor at line1, position0
ACALL COMMWRT ; call command write(COMMWRT) subroutine

MOV A,#'T'
ACALL DATAWRT ; call data write(DATAWRT) subroutine
MOV A,#'E'
ACALL DATAWRT ; call data write(DATAWRT) subroutine
MOV A,#'M'
ACALL DATAWRT ; call data write(DATAWRT) subroutine
MOV A,#'P'
ACALL DATAWRT ; call data write(DATAWRT) subroutine
MOV A,#':'
ACALL DATAWRT ; call data write(DATAWRT) subroutine

START: CLR WRITE
SETB WRITE
SETB READ
//ACALL DELAY
 rep: JB INTR, rep 

CLR READ

ACALL CONV_ION
ACALL DISPLAY

SJMP START

CONV_ION:MOV A,P3 ;
MOV B,#10
DIV AB ; quoient A; reminder B
MOV R7,B ; 3; 12 ; 1; 2
MOV B,#10
DIV AB
MOV R6,B
MOV R5,A ;123= 1=r5 2=r6 3= r7
RET

DISPLAY:MOV A,#85H ; cursor at line1, position5 80 to 8f
ACALL COMMWRT ; call command write(COMMWRT) subroutine

MOV A,R5
ADD A,#30H
ACALL DATAWRT ; call data write(DATAWRT) subroutine
MOV A,R6
ADD A,#30H
ACALL DATAWRT ; call data write(DATAWRT) subroutine
MOV A,R7
ADD A,#30H
ACALL DATAWRT ; call data write(DATAWRT) subroutine	
MOV A,#'^'
ACALL DATAWRT
MOV A,#'C'
ACALL DATAWRT
RET

COMMWRT:ACALL DELAY
CLR P2.5
CLR P2.6
SETB P2.7
MOV P1,A
CLR P2.7
RET

DATAWRT:ACALL DELAY
SETB P2.5
CLR P2.6
SETB P2.7
MOV P1,A
CLR P2.7
RET

DELAY: MOV R0,#2
OUT3: MOV R1,#254; feh
OUT2: MOV R2,#255 ; ffh
OUT1: DJNZ R2,OUT1
DJNZ R1,OUT2
DJNZ R0,OUT3
RET
END