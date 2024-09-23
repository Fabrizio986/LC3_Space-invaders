.ORIG x3000

MAIN	JSR	LIMPIAR_PANTALLA
	JSR	SETUP_DATA
	JSR	REDIBUJAR_PANTALLA
	JSR	GAME_LOOP
	PUTS
	HALT

;; no tiene input
SETUP_DATA	ST	R0, SD_R0
		ST	R0, SD_R1
		ST	R0, SD_R2
		ST	R0, SD_R3
		ST	R0, SD_R4
		ST	R7, SD_R7
		LEA	R0, ALIEN0 ; configurar valores de alien		
		LD	R1, ALIEN_START
		LD	R2, SD_AZUL
		LD	R3, ALIEN_OFFSET
		AND	R4, R4 ,#0
		ADD	R4, R4 ,#4 ; contador		
INIT_ALIENS	STR	R2, R0 ,#0 ; setear color
		ADD	R0, R0 ,#1 ; incrementar puntero
		STR	R1, R0 ,#0 ; setear posicion
		ADD	R1, R1, R3 ; incrementar posicion
		ADD	R0, R0 ,#1 ; incrementar puntero
		ADD	R4, R4 ,#-1	; decrementar contador
		BRp	INIT_ALIENS
		LEA	R0, NAVE
		LD	R1, NAVE_START
		LD	R2, SD_ROJO
		STR	R2, R0 ,#0 ; guardar color de nave
		ADD	R0, R0 ,#1 ; incrementar puntero	
		STR	R1, R0 ,#0 ; guardar posicion de nave
		LEA	R0, LASER
		AND	R1, R1 ,#0
		STR	R1, R0 ,#0 ; setear laser en inactivo			
		ADD	R0, R0 ,#1
		ADD	R1, R1 ,#1
		STR	R1, R0 ,#0 ; iniciar laser en posicion 0	
		LD	R0, SD_R0
		LD	R0, SD_R1
		LD	R0, SD_R2
		LD	R0, SD_R3
		LD	R0, SD_R4
		LD	R7, SD_R7
		RET
SD_R0	.BLKW 1
SD_R1	.BLKW 1
SD_R2	.BLKW 1
SD_R3	.BLKW 1
SD_R4	.BLKW 1
SD_R7	.BLKW 1
ALIEN_START	.FILL xC18A
NAVE_START	.FILL xF3B3
ALIEN_OFFSET	.FILL #30
SD_AZUL		.FILL x001F
SD_ROJO		.FILL x7C00

;; dibujar nave 
;; dibujar/actualizar nave
    ;; input: R1: direccion de inicio R2: color 
DIBUJAR_NAVE	ST	R0, DSH_R0
		ST	R3, DSH_R3
		ST	R4, DSH_R4
		ST	R7, DSH_R7
		AND	R4, R4 ,#0 ;; limpiar R4
		ADD	R4, R2 ,#0	;; setear R4 a R2
		LD	R2, NAVE_ANCHO
		LD	R3, NAVE_LARGO
		JSR	DIBUJAR_CUADRADO ;; dibujar nueva posicion de nave (R1 seteado por input)	
		LD	R0, DSH_R0
		LD	R3, DSH_R3
		LD	R4, DSH_R4
		LD	R7, DSH_R7
		RET
DSH_R0		.FILL 1
DSH_R3		.FILL 1
DSH_R4		.FILL 1
DSH_R7		.FILL 1
NAVE_ANCHO	.FILL #24
NAVE_LARGO	.FILL #12

;; no toma input
;;dibuja/acutaliza los aliens basados en el color en sus arrays
DIBUJAR_ALIENS	ST	R0, DA_R0
		ST	R1, DA_R1
		ST	R2, DA_R2
		ST	R3, DA_R3
		ST	R4, DA_R4
		ST	R5, DA_R5
		ST	R7, DA_R7
		AND	R0, R0 ,#0 ;; limpiar R0	
		ADD	R0, R0 ,#4 ;; setear R0 para ser contador	
		LEA	R5, ALIEN0	;; leer posicion del primer alien	
DIBUJAR_ALIEN	LDR	R4, R5 ,#0 ;; cargar color en R4	
		ADD 	R5, R5 ,#1	;; incrementar puntero	
		LDR 	R1, R5 ,#0 ;; cargar direccion de inicio de alien en R1
		LD	R2, ALIEN_DIM ;; cargar ancho de alien	
		LD	R3, ALIEN_DIM ; cargar alto de alien	
		JSR	DIBUJAR_CUADRADO ;; dibujar primer alien	
		ADD	R5, R5 ,#1	;; incrementar puntero	
		ADD	R0, R0 ,#-1	;; decrementar contador	
		BRp	DIBUJAR_ALIEN
		LD	R0, DA_R0
		LD	R1, DA_R1
		LD	R2, DA_R2
		LD	R3, DA_R3
		LD	R4, DA_R4
		LD	R5, DA_R5
		LD	R7, DA_R7
		RET

DA_R0		.BLKW 1
DA_R1		.BLKW 1
DA_R2		.BLKW 1
DA_R3		.BLKW 1
DA_R4		.BLKW 1
DA_R5		.BLKW 1
DA_R7		.BLKW 1
ALIEN_DIM	.FILL #14

;; dibuja/actualiza el laser basado en inputs
    ;; input: R1: direccion inicio R2: color
DIBUJAR_LASER	ST	R3, DL_R3
		ST	R4, DL_R4
		ST	R7, DL_R7
		AND	R4, R4 ,#0
		ADD	R4, R2 ,#0
		LD	R2, ANCHO_LASER
		LD	R3, LARGO_LASER
		JSR	DIBUJAR_CUADRADO ;; dibujar cuadrado laser (R1 es input)	
		LD	R3, DL_R3
		LD	R4, DL_R4
		LD	R7, DL_R7
		RET

ANCHO_LASER	.FILL #2
LARGO_LASER	.FILL #12
DL_R3		.BLKW 1
DL_R4		.BLKW 1
DL_R7		.BLKW 1

;; no toma inputs
;; 
REDIBUJAR_PANTALLA	ST	R0, SS_R0
		ST	R1, SS_R1
		ST	R2, SS_R2
		ST	R3, SS_R3
		ST	R4, SS_R4
		ST	R5, SS_R5
		ST	R7, SS_R7
		JSR	LIMPIAR_PANTALLA	
		JSR	DIBUJAR_ALIENS
		LEA	R5, NAVE
		LDR	R2, R5 ,#0	;; setea color para dibujar nave
		ADD	R5, R5 ,#1	;; incrementa puntero nave	
		LDR R1, R5 ,#0	;;	setear posicion de nave
		JSR	DIBUJAR_NAVE ;; dibuja nave inicial		
		LD	R0, SS_R0
		LD	R1, SS_R1
		LD	R2, SS_R2
		LD	R3, SS_R3
		LD	R4, SS_R4
		LD	R5, SS_R5
		LD	R7, SS_R7
		RET
		
SS_R0	.BLKW 1
SS_R1	.BLKW 1
SS_R2	.BLKW 1
SS_R3	.BLKW 1
SS_R4	.BLKW 1
SS_R5	.BLKW 1
SS_R7	.BLKW 1

;; no toma inputs
;; loop principal del juego
GAME_LOOP	ST	R7, GL_R7
GAME		JSR	TIMED_INPUT 
   
SKIP_WHITE	LD	R1, N97        
		ADD	R1, R0, R1    
		BRnp	SKIP_LEFT     
		AND	R0, R0 ,#0
		ADD	R1, R1 ,#-4
		JSR	MOVE_NAVE ;; mover izquierda
		
SKIP_LEFT	LD	R1, N100       
		ADD	R1, R0, R1    
		BRnp	SKIP_RIGHT    
		AND	R0, R0 ,#0
		ADD	R1, R1 ,#4	
		JSR	MOVE_NAVE ;; mover derecha
				
SKIP_RIGHT	LD	R1, N32        
		ADD	R1, R0, R1    
		BRnp	SKIP_QUIT
		JSR	SHOOT	;; disparar laser	
			
SKIP_QUIT	JSR 	ANIMAR_LASER
		BRnzp	GAME        
		  
QUIT		LD	R7, GL_R7     
			RET

			
N97	.FILL #-97	; a
N100	.FILL #-100	; d
N32	.FILL #-32	; espacio
GL_R7	.BLKW 1
ROJO	.FILL x7C00
GREEN	.FILL x03E0
AZUL	.FILL x001F
NEGRO	.FILL x0000

; Objetos del juego
ALIEN0	.BLKW 2	
ALIEN1	.BLKW 2
ALIEN2	.BLKW 2
ALIEN3	.BLKW 2
NAVE	.BLKW 2 
LASER	.BLKW 2 

;; Mover la nave
;; cambia la posicion de la nave y redibuja la nave
;; inputs: R1: offset (-4 o +4)
MOVE_NAVE	ST	R0, MS_R0
		ST	R2, MS_R2
		ST	R3, MS_R3
		ST	R4, MS_R4
		ST	R5, MS_R5
		ST	R7, MS_R7
		LEA	R0, NAVE
		ADD	R0, R0 ,#1	;; incrementa direccion de nave	
		LDR	R4, R0 ,#0	;; cargar posicion de nave a R4	
		ADD	R5, R1, R4	;; computa offset a R5	
		LD	R3, NAVE_MIN
		ADD	R3, R5, R3	;; checkea si se esta moviendo pasando la pantalla (izquierda)	
		BRn	NO_MOVE
		LD	R3, NAVE_MAX
		ADD	R3, R5, R3	;; checkea si se esta moviendo pasando la pantalla ()	
		BRp	NO_MOVE
		STR	R5, R0 ,#0	;; guarda nueva posicion	
		AND	R1, R1 ,#0	;; limpia R1	
		ADD	R1, R4 ,#0	;; setea R1 a R4	
		LD	R2, MS_NEGRO ;; setea color a negro	
		JSR	DIBUJAR_NAVE
		AND	R1, R1 ,#0		
		ADD	R1, R5 ,#0		
		ADD	R0, R0 ,#-1	;; decrementa puntero de nave	
		LDR	R2, R0 ,#0 ;; setea color nave	
		JSR	DIBUJAR_NAVE
		
NO_MOVE		LD	R0, MS_R0
		LD	R2, MS_R2
		LD	R3, MS_R3
		LD	R4, MS_R4
		LD	R5, MS_R5
		LD	R7, MS_R7
		RET
		
MS_R0	.BLKW 1
MS_R2	.BLKW 1
MS_R3	.BLKW 1
MS_R4	.BLKW 1
MS_R5	.BLKW 1
MS_R7	.BLKW 1
NAVE_MAX	.FILL x0C19 
NAVE_MIN	.FILL x0C7D 
MS_NEGRO	.FILL x0000

;; no tiene input

SHOOT	ST	R0, S_R0
	ST	R1, S_R1
	ST	R2, S_R2
	ST	R3, S_R3
	ST	R4, S_R4
	ST	R7, S_R7
	LEA	R0, LASER
	LDR	R1, R0 ,#0 
	BRp	NOSHOOT
	AND	R1, R1 ,#0
	ADD	R1, R1 ,#1
	STR	R1, R0 ,#0	
	LEA	R2, NAVE
	LDR	R2, R2 ,#1	
	ADD	R2, R2 ,#11	
	LD	R3, NLASER_Y
	ADD	R2, R2, R3	
	AND	R1, R1 ,#0
	ADD	R1, R2 ,#0	
	STR	R1, R0 ,#1	
	JSR	DIBUJAR_LASER
	
NOSHOOT	LD	R0, S_R0
	LD	R1, S_R1
	LD	R2, S_R2
	LD	R3, S_R3
	LD	R4, S_R4
	LD	R7, S_R7
	RET

S_R0	.BLKW 1
S_R1	.BLKW 1
S_R2	.BLKW 1
S_R3	.BLKW 1
S_R4	.BLKW 1
S_R7	.BLKW 1
NLASER_Y	.FILL xFA00 
CSH_R0		.BLKW 1
CSH_R1		.BLKW 1
CSH_R2		.BLKW 1
CSH_R3		.BLKW 1
CSH_R4		.BLKW 1
CSH_R6		.BLKW 1
CSH_R7		.BLKW 1
NALIEN		.FILL #-17	
NNAVE0_0	.FILL #-9	
NNAVE0_1	.FILL #-24	
NNAVE1_0	.FILL #-39	
NNAVE1_1	.FILL #-54	
NNAVE2_0	.FILL #-69	
NNAVE2_1	.FILL #-84	
NNAVE3_0	.FILL #-99	
NNAVE3_1	.FILL #-114
CSH_ROJO	.FILL x7C00

;; Animar Laser
ANIMAR_LASER	ST	R0, AL_R0
		ST	R1, AL_R1
		ST	R2, AL_R2
		ST	R3, AL_R3
		ST	R4, AL_R4
		ST	R5, AL_R5
		ST	R7, AL_R7
		LEA	R0, LASER
		LDR	R1, R0 ,#0
		BRnz	END_ANIMATE			
		LDR	R1, R0 ,#1			
		LD	R2, NLASER_OFFSET
		ADD	R2, R1, R2			
		JSR	CONVERTIR_TO_XY		
		ADD	R4, R4 ,#0
		BRnz	CLEAR_LASER			
		ADD	R5, R5 ,#0			
		BRnz	ANIMATE

CLEAR_LASER	LD	R2, AL_NEGRO
		JSR	DIBUJAR_LASER
		AND	R1, R1 ,#0			
		STR	R1, R0 ,#0			
		BRnzp	END_ANIMATE
		
ANIMATE		AND	R6, R6 ,#0
		ADD	R6, R2 ,#0			
		LD	R2, AL_NEGRO
		JSR	DIBUJAR_LASER			
		AND	R1, R1 ,#0			
		ADD	R1, R6 ,#0			
		STR	R1, R0 ,#1			
		JSR	DIBUJAR_LASER		

END_ANIMATE	LD	R0, AL_R0
		LD	R1, AL_R1
		LD	R2, AL_R2
		LD	R3, AL_R3
		LD	R4, AL_R4
		LD	R5, AL_R5
		LD	R7, AL_R7
		RET

AL_R0	.BLKW 1
AL_R1	.BLKW 1
AL_R2	.BLKW 1
AL_R3	.BLKW 1
AL_R4	.BLKW 1
AL_R5	.BLKW 1
AL_R7	.BLKW 1
NLASER_OFFSET	.FILL #-768 
AL_NEGRO		.FILL x0000

;; Volver pantalla a negro
LIMPIAR_PANTALLA	ST	R7, CS_R7
		LD	R0, PIXELS
		LD	R1, SCREEN_START
		LD	R2, CS_NEGRO
		
CLEAR_LOOP	STR	R2, R1 ,#0
		ADD	R1, R1 ,#1
		ADD	R0, R0 ,#-1
		BRp	CLEAR_LOOP
		LD	R7, CS_R7
		RET

CS_NEGRO	.FILL x0000
SCREEN_START	.FILL xC000
PIXELS		.FILL #15872
CS_R7		.BLKW 1


;; Convertir los pixeles a coordenadas x e y
CONVERTIR_TO_XY	ST	R0, CTXY_R0
		ST	R1, CTXY_R1
		ST	R2, CTXY_R2
		ST	R5, CTXY_R5
		ST	R7, CTXY_R7
		LD	R3, PX_OFFSET
		ADD	R2, R2, R3
		AND	R3, R3 ,#0
		AND	R4, R4 ,#0
		LD	R0, N128
		
CONVERTIR_LOOP	ADD	R5, R2, R0
		BRn	END_CONVERTIR
		ADD	R4, R4 ,#1		
		ADD	R2, R2, R0
		BRnzp	CONVERTIR_LOOP
		
END_CONVERTIR	ADD	R3, R2 ,#0		
		LD	R0, CTXY_R0
		LD	R1, CTXY_R1
		LD	R2, CTXY_R2
		LD	R5, CTXY_R5
		LD	R7, CTXY_R7
		RET
		
CTXY_R0		.BLKW 1
CTXY_R1		.BLKW 1
CTXY_R2		.BLKW 1
CTXY_R5		.BLKW 1
CTXY_R7		.BLKW 1
PX_OFFSET	.FILL #16384
N128		.FILL #-128 

;; TIMED_INPUT
TIMED_INPUT	ST	R1, TI_R0
		ST	R2, TI_R2
		ST	R3, TI_R3
		ST	R7, TI_R7
		AND	R0, R0 ,#0
		LD	R2, TICKS
		STI	R2, TMI
POLL		LDI	R3, TMR
		BRn	EXIT_INPUT
		LDI	R1, KBSR
		BRzp	POLL
		LDI	R0, KBDR
		LD	R1, TI_R0
		LD	R2, TI_R2
		LD	R3, TI_R3
		LD	R7, TI_R7
EXIT_INPUT	RET

TI_R0	.BLKW 1
TI_R2	.BLKW 1
TI_R3	.BLKW 1
TI_R7	.BLKW 1
KBSR	.FILL xFE00 
KBDR	.FILL xFE02 
TMR	.FILL xFE08	
TMI	.FILL xFE0A 
TICKS	.FILL x00C8 

;; Dibujar alien
DIBUJAR_CUADRADO	ST	R0, DS_R0
		ST	R5, DS_R5
		ST	R6, DS_R6
		ST	R7, DS_R7
		LD	R5, ROW_OFFSET
		NOT	R2, R2
		ADD	R2, R2 ,#1
		ST	R2, NANCHO	
		NOT	R3, R3
		ADD	R3, R3 ,#1
		ST	R3, NLARGO	
		AND 	R0, R0 ,#0
		
COL	ST	R0, DS_I
	LD	R3, NLARGO
	ADD	R0, R0, R3	
	BRzp	END_COL
	AND 	R0, R0 ,#0
	
ROW	ST	R0, DS_J
	LD	R3, NANCHO
	ADD	R0, R0, R3	
	BRzp	END_ROW
	LD	R0, DS_J
	AND	R6, R6 ,#0	
	ADD	R6, R1, R0	
	STR	R4, R6 ,#0	
	ADD	R0, R0 ,#1	
	BR	ROW
	
END_ROW	ADD	R1, R1, R5	
	LD	R0, DS_I
	ADD	R0, R0 ,#1	
	BR	COL
	
END_COL	LD	R0, DS_R0
	LD	R5, DS_R5
	LD	R6, DS_R6
	LD	R7, DS_R7
	RET

DS_R0		.FILL 1
DS_R5		.FILL 1
DS_R6		.FILL 1
DS_R7		.FILL 1
ROW_OFFSET	.FILL x0080
DS_I		.BLKW 1
DS_J		.BLKW 1
NANCHO		.BLKW 1
NLARGO		.BLKW 1

.END
