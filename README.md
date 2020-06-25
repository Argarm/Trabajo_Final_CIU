# Kinect Torres de Hanoi
## Propuesta
Tras una semana inicial pensando en la idea en la que se basaría nuestro proyecto concluimos en una idea general: una aplicación que usará físicas y una interacción que se fundamenta en la detección de las manos o del cuerpo del usuario. Esto junto con la intención de tomar como ejemplo algo «sencillo» de implementar, dio a lugar a la idea de generar una versión del problema de las torres de hanoi que permitiera la interacción sin el uso del ratón para su resolución.
## Torres de Hanoi
El problema de las Torres de Hanoi es un rompecabezas que consiste en un número de discos de radio creciente que han de apilarse en la misma posición que en el estado inicial, en otro poste de los que presenta el tablero, tal como se muestra en la Ilustración 1. Esta situación de victoria debe crearse moviendo los discos de uno en uno, con la condición de que sólo se pueden mover aquellos en la cima de cada poste (es por esto que los discos están perforados para colocarse en el poste) y que un disco de mayor radio no puede colocarse sobre uno menor.

![](https://cdn.kastatic.org/ka-perseus-images/5b5fb2670c9a185b2666637461e40c805fcc9ea5.png)

**Ilustración 1** - Estructura inicial Torres de Hanoi

## Fuentes y tecnologías
Para la creación de la aplicación se ha utilizado un componente hardware adicional, un sensor Kinect v1 para Xbox 360. Usando un sistema operativo Windows, tras instalar los drivers necesarios ([Kinect for Windows SDK v1.8](https://www.microsoft.com/en-us/download/details.aspx?id=40278) y [Kinect for Windows Developer Toolkit v1.8](https://www.microsoft.com/en-us/download/details.aspx?id=40276)) pudimos hacer uso de sus capacidades de detección de gestos para interactuar con el juego.
En cuanto al uso de librerías externas, hemos integrado:
- [Box2D for processing](https://github.com/shiffman/Box2D-for-Processing) - Librería que implementa las físicas que rigen cómo interactúan las piezas en el entorno creado.
- [ControlP5](http://www.sojamo.de/libraries/controlP5/) - Librería que implementa las físicas de gravedad y colisiones.
- [SoundCipher](http://explodingart.com/soundcipher/) - Creación de sonidos para colisiones.
- [Kinect4WinSDK](https://github.com/chungbwc/Kinect4WinSDK) - Integración de Kinect.
- [Sound - Processing](https://processing.org/reference/libraries/sound/index.html) - Para la reproducción de sonido de victoria.