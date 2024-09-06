.ORIG x3000
    LD R0, rect_pos       
    LD R1, white          
    LD R2, negro          
    LD R3, row_width      
    LD R4, rect_width     
    LD R5, rect_height    
    LEA R6, current_pos   
    STR R0, R6, #0        
    
MAIN_LOOP
    LDR R0, R6, #0        
    JSR DRAW_RECTANGLE    
    JSR READ_INPUT        
    JSR MOVE_RECTANGLE    
    BR MAIN_LOOP         

DRAW_RECTANGLE
    ST R7, return_address
DRAW_RECTANGLE_RETUR
    LD R7, rect_width     
DRAW_RECTANGLE_ROW
    STR R1, R0, #0        ; Dibujar el píxel
    ADD R0, R0, #1        ; Mover a la derecha
    ADD R7, R7, #-1       ; Decrementar el contador de píxeles en la fila
    BRp DRAW_RECTANGLE_ROW ; Continuar dibujando en la misma fila

    ; Mover a la siguiente fila
    ADD R0, R0, #-10      ; Volver al primer píxel de la fila
    ADD R0, R0, R3        ; Mover a la siguiente fila
    ADD R5, R5, #-1       ; Decrementar el contador de filas
    BRp DRAW_RECTANGLE_RETUR    ; Si quedan filas por dibujar, repetir
    LD R7, return_address
    RET                   ; Regresar al bucle principal

READ_INPUT
    LD R2, KBD_BUF        
    RET                   

MOVE_RECTANGLE
    ST R7, return_address
    LD R2, KBD_BUF        
    LDR R1, R6, #0        
    ; Borrar el rectángulilo en la posición actual antes de moverlo
    LD R2, negro
    JSR DRAW_RECTANGLE
    
    ; Mover el rectángulo en función de la tecla presionada
    LD R7, left_key       ; Cargar la tecla 'A'
    BRz MOVE_LEFT
    LD R7, right_key      ; Cargar la tecla 'D'
    BRz MOVE_RIGHT
    LD R7, return_address
    RET                   ; Si no es una tecla de movimiento, regresar

MOVE_LEFT
    ADD R1, R1, #-1       
    BR MOVE_END
    
MOVE_RIGHT
    ADD R1, R1, #1     
    BR MOVE_END

MOVE_END
    STR R1, R6, #0        ; Guardar la nueva posición del rectángulo
    LD R1, white          ; Cargar el color blanco para dibujar el rectángulo
    JSR DRAW_RECTANGLE    ; Dibujar el rectángulo en la nueva posición
    RET                   ; Regresar al bucle principal

; Constantes y datos
return_address .FILL xFFFF 
white .FILL xFFFF         
negro .FILL x0000         
rect_pos .FILL xF43C      
row_width .FILL #128      
rect_width .FILL #10      
rect_height .FILL #4      
left_key .FILL x61        ; Tecla 'A' para mover a la izquierda
right_key .FILL x64       ; Tecla 'D' para mover a la derecha
KBD_BUF .FILL xFE02           ; Buffer para almacenar la tecla presionada
current_pos .BLKW 1       ; Posición actual del rectángulo
.END
