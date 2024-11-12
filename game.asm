.ORIG x3000


;;Funcion que da inicio el juego
;;No tiene input ni output solo se encarga de setear datos y entrar el game loop
MAIN	JSR	LIMPIAR_PANTALLA
	JSR	SETUP_DATA
	JSR	DIBUJAR_PANTALLA
	JSR	GAME_LOOP
	LEA	R0, QUIT_STR
	PUTS
	HALT
	
QUIT_STR	.STRINGZ "Quit\n"

;;SETUP DATA se encarga de inicializar algunos datos de los objetos del juego para el comienzo y al final se restauran los valores de los registros
;; Esta funcion no tiene inputs definidos, sino que se tiene los registros iniciales
;; Tiene como salida:
;;-La posicion inicial de alien cargada
;;-Colores de los aliens
;;-Distancia entre aliens
;;-Cantidad de aliens
;;-Los demas datos de los objetos de la nave y el laser
SETUP_DATA	ST	R0, SD_R0
		ST	R0, SD_R1
		ST	R0, SD_R2
		ST	R0, SD_R3
		ST	R0, SD_R4
		ST	R7, SD_R7
		LEA	R0, ALIEN0 	;Configurar valores de alien	
		LD	R1, ALIEN_START ;Posicion inicial del alien
		LD	R2, SD_AZUL ;Color del alien
		LD	R3, ALIEN_OFFSET ;Distancia de separacion de los aliens
		AND	R4, R4 ,#0 
		ADD	R4, R4 ,#4 	;Contador para la cantidad de aliens
INIT_ALIENS	STR	R2, R0 ,#0	;Setear color
		ADD	R0, R0 ,#1 	;Incrementar puntero
		STR	R1, R0 ,#0 	;Setear posicion
		ADD	R1, R1, R3 	;Incrementar posicion
		ADD	R0, R0 ,#1 	;Incrementar puntero
		ADD	R4, R4 ,#-1	;Decrementar contador
		BRp	INIT_ALIENS
		LEA	R0, NAVE	;Inicializar la nave
		LD	R1, NAVE_START 	;Posicion inicial de la nave
		LD	R2, SD_ROJO	
		STR	R2, R0 ,#0 	;guardar color de nave
		ADD	R0, R0 ,#1 	;incrementar puntero	
		STR	R1, R0 ,#0 	;guardar posicion de nave
		LEA	R0, LASER	;Inicializar el laser
		AND	R1, R1 ,#0
		STR	R1, R0 ,#0 	;setear laser en inactivo			
		ADD	R0, R0 ,#1
		ADD	R1, R1 ,#1
		STR	R1, R0 ,#0 	;iniciar laser en posicion 0	
		LD	R0, SD_R0
		LD	R0, SD_R1
		LD	R0, SD_R2
		LD	R0, SD_R3
		LD	R0, SD_R4
		LD	R7, SD_R7
		RET

;;Aqui se encuentran los respaldos de los registros		
SD_R0	.BLKW 1
SD_R1	.BLKW 1
SD_R2	.BLKW 1
SD_R3	.BLKW 1
SD_R4	.BLKW 1
SD_R7	.BLKW 1
;;Datos
ALIEN_START	.FILL xC18A
NAVE_START	.FILL xF3B3
ALIEN_OFFSET	.FILL #30
SD_AZUL		.FILL x001F
SD_ROJO		.FILL x7C00

;; Esta funcion se encarga de dibujar nave 
;;Input: 
;;-R1:Direccion de inicio 
;;-R2:Color 
;;-Output:
;;-Como output para la siguiente funcion, se cargan los valores de ancho y largo de la nave
DIBUJAR_NAVE	ST	R0, DSH_R0	;;Respaldo de registros
		ST	R3, DSH_R3
		ST	R4, DSH_R4
		ST	R7, DSH_R7
		AND	R4, R4 ,#0 	;; Limpiar R4
		ADD	R4, R2 ,#0	;; Setear R4 a R2
		LD	R2, NAVE_ANCHO 	
		LD	R3, NAVE_LARGO
		JSR	DIBUJAR_CUADRADO ;; Dibujar nueva posicion de nave (R1 seteado por input)	
		LD	R0, DSH_R0	;;Vuelta atras de los registros
		LD	R3, DSH_R3
		LD	R4, DSH_R4
		LD	R7, DSH_R7
		RET

;;Respaldo de registros		
DSH_R0		.FILL 1
DSH_R3		.FILL 1
DSH_R4		.FILL 1
DSH_R7		.FILL 1
;;Datos
NAVE_ANCHO	.FILL #24
NAVE_LARGO	.FILL #12



;;Dibuja/Actualiza los aliens con los colores y la posicion en sus direcciones de memoria
;;Input: Esta funcion como tal toma los datos inicializados antes de los aliens
;;Output: Los aliens dibujadas
DIBUJAR_ALIENS	ST	R0, DA_R0	;; Respaldo de registros
		ST	R1, DA_R1
		ST	R2, DA_R2
		ST	R3, DA_R3
		ST	R4, DA_R4
		ST	R5, DA_R5
		ST	R7, DA_R7
		AND	R0, R0 ,#0 	;; Limpiar R0	
		ADD	R0, R0 ,#4 	;; Setear R0 para ser contador	
		LEA	R5, ALIEN0	;; Leer posicion del primer alien	

DIBUJAR_ALIEN	LDR	R4, R5 ,#0	;; Cargar color en R4	
		ADD 	R5, R5 ,#1	;; Incrementar puntero	
		LDR 	R1, R5 ,#0 	;; Cargar direccion de inicio de alien en R1
		LD	R2, ALIEN_DIM 	;; Cargar ancho de alien	
		LD	R3, ALIEN_DIM 	;; Cargar alto de alien	
		JSR	DIBUJAR_CUADRADO ;; Dibujar primer alien	
		ADD	R5, R5 ,#1	;; Incrementar puntero	
		ADD	R0, R0 ,#-1	;; Decrementar contador	
		BRp	DIBUJAR_ALIEN
		LD	R0, DA_R0
		LD	R1, DA_R1
		LD	R2, DA_R2
		LD	R3, DA_R3
		LD	R4, DA_R4
		LD	R5, DA_R5
		LD	R7, DA_R7
		RET

;;Respaldo de registros
DA_R0		.BLKW 1
DA_R1		.BLKW 1
DA_R2		.BLKW 1
DA_R3		.BLKW 1
DA_R4		.BLKW 1
DA_R5		.BLKW 1
DA_R7		.BLKW 1
;;Dimension del alien
ALIEN_DIM	.FILL #14

;;Borra los aliens con los colores y la posicion en sus direcciones de memoria
;;Input: Esta funcion como tal toma los datos inicializados antes de los aliens
;;Output: Los aliens dibujadas
BORRAR_ALIENS	ST	R0, DA_R0	;; Respaldo de registros
		ST	R1, DA_R1
		ST	R2, DA_R2
		ST	R3, DA_R3
		ST	R4, DA_R4
		ST	R5, DA_R5
		ST	R7, DA_R7
		AND	R0, R0 ,#0 	;; Limpiar R0	
		ADD	R0, R0 ,#4 	;; Setear R0 para ser contador	
		LEA	R5, ALIEN0	;; Leer posicion del primer alien	

BORRAR_ALIEN	LD	R4, NEGRO	;; Cargar color en R4	
		ADD 	R5, R5 ,#1	;; Incrementar puntero	
		LDR 	R1, R5 ,#0 	;; Cargar direccion de inicio de alien en R1
		LD	R2, ALIEN_DIM 	;; Cargar ancho de alien	
		LD	R3, ALIEN_DIM 	;; Cargar alto de alien	
		JSR	DIBUJAR_CUADRADO ;; Dibujar primer alien	
		ADD	R5, R5 ,#1	;; Incrementar puntero	
		ADD	R0, R0 ,#-1	;; Decrementar contador	
		BRp	BORRAR_ALIEN
		LD	R0, DA_R0
		LD	R1, DA_R1
		LD	R2, DA_R2
		LD	R3, DA_R3
		LD	R4, DA_R4
		LD	R5, DA_R5
		LD	R7, DA_R7
		RET



;;Dibuja/Actualiza el laser basado en inputs
;;Input: 
;;-R1: Direccion inicio
;;-R2: Color
;;Output: La salida de esta funcion es el laser dibujado
DIBUJAR_LASER	ST	R3, DL_R3	;;Respaldo de registros
		ST	R4, DL_R4
		ST	R7, DL_R7
		AND	R4, R4 ,#0
		ADD	R4, R2 ,#0	;;Color del laser
		LD	R2, ANCHO_LASER	;;Dimesiones
		LD	R3, LARGO_LASER	;;Dimensiones
		JSR	DIBUJAR_CUADRADO ;;Dibujar laser (R1 es input)	
		LD	R3, DL_R3
		LD	R4, DL_R4
		LD	R7, DL_R7
		RET

;;Respaldo y datos
ANCHO_LASER	.FILL #2
LARGO_LASER	.FILL #12
DL_R3		.BLKW 1
DL_R4		.BLKW 1
DL_R7		.BLKW 1

;; Se encarga de dibujar/redibujar la pantalla 
;; No toma inputs
DIBUJAR_PANTALLA	ST	R0, SS_R0
		ST	R1, SS_R1
		ST	R2, SS_R2
		ST	R3, SS_R3
		ST	R4, SS_R4
		ST	R5, SS_R5
		ST	R7, SS_R7
		JSR	LIMPIAR_PANTALLA	
		JSR	DIBUJAR_ALIENS
		LEA	R5, NAVE
		LDR	R2, R5 ,#0	;; Setea color para dibujar nave
		ADD	R5, R5 ,#1	;; Incrementa puntero nave	
		LDR R1, R5 ,#0		;; Setear posicion de nave
		JSR	DIBUJAR_NAVE 	;; Dibuja nave inicial		
		LD	R0, SS_R0
		LD	R1, SS_R1
		LD	R2, SS_R2
		LD	R3, SS_R3
		LD	R4, SS_R4
		LD	R5, SS_R5
		LD	R7, SS_R7
		RET
		
;;Respaldo de registros
SS_R0	.BLKW 1
SS_R1	.BLKW 1
SS_R2	.BLKW 1
SS_R3	.BLKW 1
SS_R4	.BLKW 1
SS_R5	.BLKW 1
SS_R7	.BLKW 1


;; Este es el loop principal del juego, donde en cada iteracion se corrobora si la letra tocada del teclado es la necesaria para moverse por la pantalla o para disparar
;; No toma inputs
GAME_LOOP      ST      R7, GL_R7                ; Guardar el valor de R7
GAME
              LD      R1, FRAME_COUNTER       ; Cargar el valor actual del contador de ciclos
              ADD     R1, R1, #1             ; Incrementar el contador
              ST      R1, FRAME_COUNTER     ; Guardar el nuevo valor del contador

              LD      R1, FRAME_COUNTER     ; Cargar el contador de ciclos
              AND     R2, R1, #7            ; Comprobar si hemos llegado a x ciclos
              BRp    SKIP_ALIEN_MOVE

              ; Si es múltiplo de 8, mover los alien
			  JSR	  BORRAR_ALIENS
              JSR     MOVER_ALIENS          ; Mover los aliens
			  JSR     DIBUJAR_ALIENS          ; Mover los aliens

              ; Reiniciar el contador de ciclos
              AND     R1, R1, #0            ; Restablecer el contador de ciclos a 0
              ST      R1, FRAME_COUNTER     ; Guardar el valor actualizado


SKIP_ALIEN_MOVE 
JSR		TIMED_INPUT
SKIP_WHITE    LD      R1, N97                ; Cargar la tecla 'a'
              ADD     R1, R0, R1
              BRnp    SKIP_LEFT
              AND     R0, R0, #0
              ADD     R1, R1, #-4
              JSR     MOVER_NAVE             ;; mover izquierda

SKIP_LEFT     LD      R1, N100               ; Cargar la tecla 'd'
              ADD     R1, R0, R1
              BRnp    SKIP_RIGHT
              AND     R0, R0, #0
              ADD     R1, R1, #4
              JSR     MOVER_NAVE             ;; mover derecha

SKIP_RIGHT    LD      R1, N32                ; Cargar la tecla espacio
              ADD     R1, R0, R1
              BRnp    SKIP_QUIT
              JSR     SHOOT                  ;; disparar laser

SKIP_QUIT     JSR     ANIMAR_LASER
              JSR     GAMEOVER_CHECK
              BRnzp   GAME
              
QUIT          LD      R7, GL_R7
              RET


; Guardado las teclas para moverse y disparar, además de los colores para la pantalla
N97            .FILL   #-97       ; a
N100           .FILL   #-100      ; d
N32            .FILL   #-32       ; espacio
GL_R7          .BLKW   1
ROJO           .FILL   x7C00
GREEN          .FILL   x03E0
AZUL           .FILL   x001F
NEGRO          .FILL   x0000
VAL256		   .FILL   #256
VALDELAY	   .FILL   #10000
FRAME_COUNTER  .FILL   #0        ; Inicializa el contador de ciclos en 0


; Objetos del juego
ALIEN0         .BLKW   2    
ALIEN1         .BLKW   2
ALIEN2         .BLKW   2
ALIEN3         .BLKW   2
NAVE           .BLKW   2 
LASER          .BLKW   2 

;; Mover aliens hacia abajo
MOVER_ALIENS	LEA     R0, ALIEN0
			  LDR     R1, R0, #1           ; Cargar la posición de Y de ALIEN0

			  ST 	  R2, SSS_R2
			  LD	  R2, VAL256				 ;cargar numero en R2
              ADD     R1, R1, R2            ; Sumar 1 a la posición Y (mover el alien hacia abajo)
              STR     R1, R0, #1             ; Guardar la nueva posición en ALIEN0

              LEA     R0, ALIEN1
              LDR     R1, R0, #1             ; Cargar la posición de Y de ALIEN1
              ADD     R1, R1, R2             ; Sumar 1 a la posición Y (mover el alien hacia abajo)
              STR     R1, R0, #1             ; Guardar la nueva posición en ALIEN1

              LEA     R0, ALIEN2
              LDR     R1, R0, #1             ; Cargar la posición de Y de ALIEN2
              ADD     R1, R1, R2             ; Sumar 1 a la posición Y (mover el alien hacia abajo)
              STR     R1, R0, #1             ; Guardar la nueva posición en ALIEN2

              LEA     R0, ALIEN3
              LDR     R1, R0, #1             ; Cargar la posición de Y de ALIEN3
              ADD     R1, R1, R2             ; Sumar 1 a la posición Y (mover el alien hacia abajo)
              STR     R1, R0, #1             ; Guardar la nueva posición en ALIEN3
			  
			  LD	  R2, SSS_R2		     ;recuperar  en R2

			  RET

SSS_R2	.BLKW 1



;; GAMEOVER
GAMEOVER_CHECK	ST		R0, G_R0
				ST		R1, G_R1
				ST		R2, G_R2
				ST		R3, G_R3
				ST		R4, G_R4
				ST		R7, G_R7
				LD		R2, COLOR_CHECK
				AND		R4, R4 ,#0
				ADD		R4, R4 ,#4
				LEA		R0, ALIEN0
CHECK_ALIEN		LDR		R1, R0 ,#0
				ADD		R3, R1, R2
				BRnp	CONTINUE
				ADD		R0, R0 ,#2
				ADD		R4, R4 ,#-1
				BRp		CHECK_ALIEN
				LEA		R0, GAMEOVER_STR
				PUTS
				HALT
CONTINUE		LD		R0, G_R0
				LD		R1, G_R1
				LD		R2, G_R2
				LD		R3, G_R3
				LD		R4, G_R4
				LD		R7, G_R7
				RET
G_R0			.BLKW 1
G_R1			.BLKW 1
G_R2			.BLKW 1
G_R3			.BLKW 1
G_R4			.BLKW 1
G_R7			.BLKW 1
COLOR_CHECK		.FILL #-31744
GAMEOVER_STR	.STRINGZ "GAMEOVER"







;; Mover la nave, cambiando la posicion y redibujandola
;; Inputs: 
;;-R1: offset (-4 o +4)
MOVER_NAVE	ST	R0, MS_R0
		ST	R2, MS_R2
		ST	R3, MS_R3
		ST	R4, MS_R4
		ST	R5, MS_R5
		ST	R7, MS_R7
		LEA	R0, NAVE
		ADD	R0, R0 ,#1	;; Incrementa direccion de nave	
		LDR	R4, R0 ,#0	;; Cargar posicion de nave a R4	
		ADD	R5, R1, R4	;; Computa offset a R5	
		LD	R3, NAVE_MIN
		ADD	R3, R5, R3	;; Checkea si se esta moviendo pasando la pantalla (izquierda)	
		BRn	NO_MOVE
		LD	R3, NAVE_MAX
		ADD	R3, R5, R3	;; Checkea si se esta moviendo pasando la pantalla ()	
		BRp	NO_MOVE
		STR	R5, R0 ,#0	;; Guarda nueva posicion	
		AND	R1, R1 ,#0	;; Limpia R1	
		ADD	R1, R4 ,#0	;; Setea R1 a R4	
		LD	R2, MS_NEGRO 	;; Setea color a negro	
		JSR	DIBUJAR_NAVE
		AND	R1, R1 ,#0		
		ADD	R1, R5 ,#0		
		ADD	R0, R0 ,#-1	;; Decrementa puntero de nave	
		LDR	R2, R0 ,#0 	;; Setea color nave	
		JSR	DIBUJAR_NAVE		
NO_MOVE		LD	R0, MS_R0
		LD	R2, MS_R2
		LD	R3, MS_R3
		LD	R4, MS_R4
		LD	R5, MS_R5
		LD	R7, MS_R7
		RET

;;Respaldo de registros y datos
MS_R0	.BLKW 1
MS_R2	.BLKW 1
MS_R3	.BLKW 1
MS_R4	.BLKW 1
MS_R5	.BLKW 1
MS_R7	.BLKW 1
NAVE_MAX	.FILL x0C19 
NAVE_MIN	.FILL x0C7D 
MS_NEGRO	.FILL x0000

;; Esta funcion se encarga del disparo de disparar el laser, hasta que la siguiente tecla no sea espacio y se vuelva al GAME_LOOP
;; No tiene input
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

; Comprueba si el láser ha impactado a una nave y actualiza su color respectivamente
; ENTRADAS: R3: posición x del láser
; R4; posición y del láser --> SALIDAS: R5: IMPACTO o NO IMPACTO
CHECK_DISPARO_NAVE		ST		R0, CSH_R0
				ST		R1, CSH_R1
				ST		R2, CSH_R2
				ST		R3, CSH_R3
				ST		R4, CSH_R4
				ST		R6, CSH_R6
				ST		R7, CSH_R7
				LD		R6, NALIEN
				AND		R5, R5 ,#0
				ADD		R6, R4, R6
				BRzp		END_CHECK
				AND		R5, R5 ,#0
				LEA		R0, ALIEN0
				LEA		R1, NNAVE0_0    ; cargar la primer variable para chequear  
				AND		R2, R2 ,#0
				ADD		R2, R2 ,#4
CHECK_NAVE		LDR		R6, R1 ,#0	; cargar el valor de min 	
				ADD		R6, R3, R6	; comprobar si x pos es mayor que min	
				BRn		NO_HIT
				LDR		R6, R1 ,#1	; cargar el valor de max	
				ADD		R6, R3, R6	; comprobar si x pos en menos que max 	
				BRp		NO_HIT
				LD		R6, CSH_ROJO   
				STR		R6, R0 ,#0	; guardar color rojo en la nave
				ADD		R1, R1 ,#1	; poner valor de disparo en la nave	
				ADD		R5, R5 ,#1	; setear el valor de retorno en true	
				BRnzp	  	UPDATE_ALIENS
NO_HIT			ADD		R0, R0 ,#2	; incrementar el puntero de memoria de la nave 
				ADD		R1, R1 ,#2	; incrementar valor de puntero	
				ADD		R2, R2 ,#-1	; decrementar contador	
				BRp		CHECK_NAVE
				BRnzp		END_CHECK
				
UPDATE_ALIENS			JSR		DIBUJAR_ALIENS

END_CHECK			LD		R0, CSH_R0
				LD		R1, CSH_R1
				LD		R2, CSH_R2
				LD		R3, CSH_R3
				LD		R4, CSH_R4
				LD		R6, CSH_R6
				LD		R7, CSH_R7
				RET

CSH_R0			.BLKW 1
CSH_R1			.BLKW 1
CSH_R2			.BLKW 1
CSH_R3			.BLKW 1
CSH_R4			.BLKW 1
CSH_R6			.BLKW 1
CSH_R7			.BLKW 1
NALIEN			.FILL #-17	; posicion de la nave 
NNAVE0_0		.FILL #-9 
NNAVE0_1		.FILL #-24	
NNAVE1_0		.FILL #-39	
NNAVE1_1		.FILL #-54	
NNAVE2_0		.FILL #-69	
NNAVE2_1		.FILL #-84	
NNAVE3_0		.FILL #-99	
NNAVE3_1		.FILL #-114
CSH_ROJO		.FILL x7C00




;; Cuando se dispara se ejecuta esta funcion para animar el laser por la pantalla, dibujandolo cada cierto espacio y borrando el anterior
;; no tiene input
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
		JSR	CHECK_DISPARO_NAVE			
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

;;Respaldo de registros
AL_R0	.BLKW 1
AL_R1	.BLKW 1
AL_R2	.BLKW 1
AL_R3	.BLKW 1
AL_R4	.BLKW 1
AL_R5	.BLKW 1
AL_R7	.BLKW 1
NLASER_OFFSET	.FILL #-768 ;;Espacio entre dibujo y dibujo de laser
AL_NEGRO	.FILL x0000

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

;; Esta funcion espera un tiempo para tomar el input del jugador
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

;;Respaldo de registros
TI_R0	.BLKW 1
TI_R2	.BLKW 1
TI_R3	.BLKW 1
TI_R7	.BLKW 1
;;Direcciones donde se encuentran lo ingresado por teclado por el usuario en FILL xFE02 y demas
KBSR	.FILL xFE00 
KBDR	.FILL xFE02 
TMR	.FILL xFE08	
TMI	.FILL xFE0A 
TICKS	.FILL x000A 

;; Esta funcion se encarga de dibujar lo que esta dentro del juego dependiendo de las medidas que le pasemos
;; Inputs
;;-Dimensiones de lo que se le indico dibujar, son distintas para la nave, para el laser y para el alien
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


;;Respaldo de registros
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