# LC3_Space-Invaders

Este programa emula el clásico juego de Space Invaders en la plataforma LC-3. Puedes mover la nave a la izquierda o a la derecha usando las teclas 'A' y 'D', y presionar la barra espaciadora para disparar un láser. La lógica del juego se ha desarrollado para ofrecer una experiencia lo más similar posible al original, adaptada a las limitaciones del entorno LC-3.

### Características del juego:

- **Movimiento de la nave:** Puedes mover la nave espacial usando las teclas 'A' y 'D', permitiéndote desplazarte lateralmente para evitar los disparos de los enemigos y colocarte en la mejor posición para atacar.
- **Disparo láser:** Con la barra espaciadora, la nave dispara un láser hacia arriba. El láser colisiona con los alienígenas enemigos o las estructuras de protección, destruyendo a aquellos que impacta.
- **Estructuras de cobertura:** El jugador puede esconderse tras unas estructuras que se degradan con cada impacto, brindando protección temporal contra los disparos enemigos.

<image src="/Media/game.png" alt="Descripción">

### Problemas/Progreso

En versiones anteriores del proyecto, utilizábamos los 8 registros disponibles del LC-3 para almacenar valores y coordenadas. Sin embargo, esta estrategia demostró ser limitada, ya que el número de tareas que necesitábamos gestionar sobrepasaba la cantidad de registros. Por esta razón, decidimos implementar una solución más dinámica, guardando valores en memoria y cargándolos en los registros solo cuando eran necesarios. Para lograrlo, aumentamos las direcciones de memoria de forma dinámica en ciertos casos, facilitando la gestión de datos sin agotar los registros.

Dado que trabajamos con una pantalla de **128x128 píxeles**, implementamos una función llamada `CONVERT_TO_XY` para convertir posiciones en coordenadas XY. Esta función utiliza direcciones de memoria específicas para establecer las coordenadas de la pantalla, lo que nos permite mover objetos, como el láser disparado por la nave, por toda la superficie. Al mover el láser, también comparamos continuamente su posición con los límites de la pantalla para detectar si se encuentra fuera de los márgenes, momento en el que el láser se elimina de la pantalla.

### Funcionamiento del láser

El láser es controlado de manera independiente a la nave. Una vez disparado, se mueve en dirección vertical hacia arriba, comprobando en cada ciclo si ha alcanzado un alien o si ha salido de la pantalla. 

### Controles del juego:

| Teclas   | Acción                       |
|----------|-----------------------------|
| a        | Mover la nave a la izquierda |
| d        | Mover la nave a la derecha   |
| space    | Disparar el láser            |
| q        | Salir del juego              |

### Cómo ejecutar el juego

Para correr el juego, sigue los siguientes pasos:

1. 

    ```bash
    cd ~/PATH/TO/LC3_Space-invaders/
    ```

2. 

    ```bash
    java -jar LC3sim.jar
    ```

3. 

    ```bash
    load lc3os.obj
    load space_invaders.obj
    ```



