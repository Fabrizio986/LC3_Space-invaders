# LC3_Space-invaders

Este programa emula el clásico juego de Space Invaders en la plataforma LC-3. Puedes mover la nave a la izquierda o a la derecha usando las teclas 'A' y 'D', y presionar la barra espaciadora para disparar un láser.

Cuando un laser colisiona con un alien, cambia de color, esto significa que se elimino. El juego finaliza cuando se eliminan a todos los aliens.

<image src="/Media/game.jpg" alt="Descripción">


| Teclas   | Resultado                   |
|----------|-----------------------------|
| a        | Mover a la izquierda        |
| d        | Mover a la derecha          |
| space    | Disparar                    |
| q        | Salir del juego             |

Para correrlo:

```bash
cd ~/PATH/TO/LC3_Space-invaders/
java -jar ../LC3sim.jar
```  

Dentro del simulador:

```bash
load lc3os.obj
load space_invaders.obj
```