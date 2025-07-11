#import "@preview/mitex:0.2.5" : *
#import "@preview/zebraw:0.5.5": *
#import "@preview/showybox:2.0.4": showybox

= Desarrollo
La arquitectura de Von Neumann es el paradigma que rige el diseño de la inmensa mayoría de computadoras (ya que existe su contraparte de arquitectura Harvard) que usamos hoy en día. Su característica definitoria es la existencia de una memoria única y compartida para almacenar tanto instrucciones del programa como los datos que ese programa va a manipular. Esta memoria está interconectada con la Unidad Central de Procesamiento (CPU), que es el "cerebro" de la computadora. La CPU, a su vez, se compone de varias partes, incluyendo la Unidad de Control (CU), los registros y, centralmente, la Unidad Lógico-Aritmética (ALU).

Esta última, la ALU, es de forma análoga el corazón operacional de la CPU, el componente encargado de realizar todas las operaciones aritméticas (como suma, resta, multiplicación y división) y lógicas (como AND, OR, XOR, NOT). Su función es procesar los datos a nivel más básico, el de los bits binarios. De hecho, independientemente de cómo se ingresen los datos (ya sea un número decimal, hexadecimal, un carácter de texto, una imagen o un archivo completo), la ALU los recibe y los manipula internamente como secuencias de ceros y unos. Este proceso de transformación de datos de alto nivel a bits ocurre en microsegundos, o incluso nanosegundos, permitiendo que la ALU ejecute millones de operaciones por segundo y brinde respuestas casi instantáneas a las complejas interacciones digitales.

Dada su particularidad discreta, este componente guarda una estrecha relación conceptual con la Máquina de Turing Universal (UTM). Una UTM es un modelo teórico de máquina de Turing que tiene la capacidad extraordinaria de simular el comportamiento de cualquier otra Máquina de Turing. Esto lo logra leyendo en su cinta tanto la descripción de la máquina a simular (que sería análoga al "programa" o conjunto de instrucciones) como los datos de entrada para esa simulación. Esta capacidad de una sola máquina abstracta para ejecutar cualquier algoritmo es el análogo conceptual directo del computador de propósito general propuesto por Von Neumann.

En particular, dentro de la arquitectura Von Neumann, la ALU procesa datos binarios gobernada por instrucciones que están almacenadas en la memoria#footnote[*Las flags (o banderas)*: Estas instrucciones son códigos de operación que le indican a la ALU qué función aritmético-lógica específica debe realizar; siendo que, estos son registros especiales que indican el resultado de estas operaciones, como si hubo un cero o un desbordamiento. De acuerdo con teóricos como Sipser, estas operaciones (adición, sustracción, disyunción, conjunción, etc.) pueden definirse como funciones que, a partir de un dominio de entradas, producen un codominio o rango determinado.]. Esta es una materialización directa de la noción de que la Máquina de Turing cambia de estado y manipula su cinta de acuerdo con un conjunto de reglas de transición (#mi("\delta")) que también pueden verse como una forma de "información almacenada" que dirige su comportamiento. La intersección de estos dos niveles, el teórico y el de *hardware*, es profunda: la Máquina de Turing no es solo un modelo abstracto, sino que provee el fundamento formal sobre el cual se entiende qué puede calcular un procesador. Dado que "cada algoritmo conocido" puede implementarse en una Máquina de Turing, esta máquina abstracta sirve como el modelo ideal de cualquier CPU real y, por extensión, de su ALU. En este sentido, los resultados teóricos de la computabilidad (por ejemplo, que ciertos problemas son inherentemente imposibles de resolver algorítmicamente) aplican directamente al diseño de chips y al desarrollo de software: *si algo no es computable por una Máquina de Turing, no lo es por ningún circuito ni por ningún programa informático*.

#show table.cell.where(y: 0): strong
#set table(
  stroke: (x, y) => if y == 0 {
    (bottom: 0.7pt + black)
  },
  align: (x, y) => (
    if x > 0 { left }
    else { left }
  )
)


== Proceso de Modelamiento
Para modelar las operaciones lógicas de la Unidad Lógico-Aritmética (ALU) —específicamente AND — utilizando una Máquina de Turing, el primer paso fue identificar el alfabeto de la cinta (#mi("\Gamma")) elevante. Este incluye los dígitos binarios  0' y '1', un símbolo especial para delimitar los números binarios de entrada (usaremos '\#'), los símbolos para indicar la operación a realizar ('A' para AND, 'O' para OR, 'X' para XOR), un símbolo para el espacio en blanco (' '), y marcadores temporales para los bits ya procesados (como 'X' e 'Y'). A partir de esto, se definieron las unidades lógicas básicas que la máquina manipularía: cada bit individual '0' o '1' y los delimitadores/marcadores.

#showybox(
  frame: (
    border-color: black,
    title-color: black
  ),
  title-style: (
    color: white,
    weight: "regular",
    align: left
  ),
  title: "Operación AND 'A#1000000000#0000000001'",
  [
    Siguiendo la teoría clásica de la computación, que establece las Máquinas de Turing como el modelo universal para la computabilidad, formalizamos la MT como una 7-tupla estándar: #mitex("M=(Q, \Sigma, \Gamma, \delta, q_{0}, q_{accept}, q_{reject})")

    Asegura que la función de transición #mi("\delta") sea determinista, con cada estado y símbolo de la cinta teniendo una única transición definida. De esta manera, integrando la casuística de un ejemplo de entrada para la operación AND, determinaremos el flujo de estados de nuestra Máquina de Turing:

    1. *Estado Inicial*: La máquina comienza en el estado #mi("q_{read-operation}") con el cabezal sobre el primer símbolo 'A'. Al leer 'A', la máquina reconoce la operación de AND. La 'A' es borrada (o marcada) y el cabezal se mueve a la derecha, pasando al siguiente estado. El propósito es posicionar el cabezal para comenzar el procesamiento bit a bit desde el final de los números.

    2. *Preparación del Procesamiento Bit a Bit*: Desde #mi("q_{find-end-of-num2-for-and"), el cabezal se desplaza hacia la derecha, saltando los bits del primer número, el delimitador '\#' y los bits del segundo número, hasta encontrar un espacio en blanco (' '). Este espacio indica el final del segundo número. Una vez encontrado, el cabezal retrocede un paso a la izquierda (#mi("L")), posicionándose sobre el último bit.

    3. *Lectura y Procesamiento de Bits*:
      - Al estar sobre el último '1' del segundo número, la máquina entra en el estado #mi("q_{read-num2-bit-and}"). Este '1' es leído y marcado (por ejemplo, como 'Y' o 'X' para indicar que ya fue procesado), y la máquina transita a un estado intermedio (como #mi("q_{find-num1-bit-and-1}")) para buscar el bit correspondiente del primer número.
      - El cabezal se mueve hacia la izquierda, pasando por el resto de los bits del segundo número (ahora marcados), el '\#', y los bits del primer número (ahora $1000000000$) hasta encontrar su último bit. En este caso, el último bit de $1000000000$ es '0'.
      - En este punto, la máquina ha identificado los últimos bits de ambos operandos: '0' del primer número y '1' del segundo. Entra en un estado que aplica la lógica AND: $0$ AND $1 = 0$. Este estado escribe el resultado '0' en una sección de la cinta dedicada al resultado.
      - el cabezal retrocede para encontrar el siguiente bit sin procesar del segundo número, lo marca, luego retrocede para encontrar el bit correspondiente del primer número (o asume un '0' implícito si el número es más corto), aplica la lógica AND, escribe el resultado, y avanza para el siguiente par de bits. Este proceso continúa hasta que ambos números se agotan.
    4. *Procesamiento de Dígitos Restantes y Limpieza*:
      - Una vez que se han procesado todos los pares de bits, puede que queden bits sin procesar del operando más largo (en este caso, no aplica porque la operación es bit a bit y se asumen ceros implícitos).
      - La máquina entonces procede a reordenar el resultado y a limpiar los ceros a la izquierda. Para $0000000000$, La máquina escaneará desde la izquierda, reemplazando cada '0' con un espacio en blanco, hasta que solo quede un único '0' (si el resultado es cero) o hasta que encuentre un '1'.
    5. *Estado de Aceptación*: Al llegar al final de la línea después de procesar todos los tokens y limpiar el resultado, si la máquina se encuentra en un estado que representa una secuencia válida, transita al estado de aceptación.
  ],
)

Cabe mencionar que, para el diseño del autómata, se definió una transición para cada combinación de estado y símbolo de la cinta. Esto incluye la detección de errores mediante transiciones a un estado de rechazo explícito (#mi("q_{reject}") o #mi("q_{reject-invalid-operation}")). Por ejemplo, si la máquina en #mi("q_{read-operation}") recibe un símbolo no válido para una operación ('Z' en lugar de 'A'), transitaría a #mi("q_{reject-invalid-operation}"). De manera similar, si durante el procesamiento de bits se encuentra con un símbolo inesperado en una posición donde solo se esperan '0's o '1's, el autómata transitaría a #mi("q_{reject}"). Una vez en cualquier estado de rechazo, la máquina permanece allí para cualquier entrada adicional, indicando que la cadena o la operación son inválidas. En otras palabras, la Máquina de Turing recorrerá la cadena caracter por caracter, cambiando de estados según los bits, delimitadores y símbolos de operación, y detectará estructuras inválidas o entradas malformadas al transitar a un estado trampa.

== Diagramas de Estados y Transiciones
Para comprender a fondo la lógica de la operación AND en una Unidad Aritmético Lógica (ALU), es necesario visualizar su comportamiento mediante un diagrama de estados y transiciones. Aunque una ALU realiza operaciones a nivel de bits, la lógica subyacente puede representarse como un autómata que procesa la entrada y genera una salida. En nuestro caso, la ALU opera con bits binarios ($0$ y $1$), así como con delimitadores ($\#$) y marcadores temporales ($X$, $Y$) para realizar el cálculo. El símbolo de la operación ($A$ para AND) también forma parte de nuestro alfabeto de entrada.

La secuencia correcta de bits de entrada es fundamental para que el autómata alcance un estado de aceptación y produzca el resultado esperado de la operación AND. Cualquier combinación o secuencia de símbolos que no siga las reglas definidas llevará la entrada directamente a un estado de rechazo.

#figure(
  image("../../../../src/images/FD/Captura desde 2025-06-22 15-55-12.png"),
  caption: "Diagrama de Estados y Transiciones para la Operación AND. Nota. Este diagrama muestra los estados y transiciones de la Máquina de Turing diseñada para simular la operación lógica AND. Elaboración propia en turingmachine.io."
)

A partir del diagrama anteriormente mostrado, podemos determinar que este grafica el flujo de control de nuestra Máquina de Turing, diseñada para ejecutar la operación AND bit a bit en una Unidad Aritmético Lógica (ALU). La máquina inicia en el estado #text(mi("q_{read-operation}"), size: 8pt), donde se identifica la operación a realizar. Al detectar el símbolo 'A', la máquina transita a #text(mi("q_{find-end-of-num2-for-and}"), size: 8pt), preparando el proceso para leer los bits de los números de entrada.

Desde #text(mi("q_{find-end-of-num2-for-and}"), size: 8pt), la máquina se mueve hacia el final del segundo número (num2) para procesar sus bits de derecha a izquierda, es decir, del menos significativo al más significativo. Durante esta fase, los bits leídos de num2 se marcan temporalmente con el símbolo 'Y' a medida que la máquina avanza. Posteriormente, la máquina busca el bit correspondiente del primer número (num1), que se encuentra antes del delimitador \#. Aquí, los bits de num1 se marcan con 'X', y el resultado de la operación AND entre el par de bits se determina y se escribe en una sección designada de la cinta.

Una vez que todos los pares de bits han sido procesados y sus resultados intermedios escritos, la máquina entra en una fase de limpieza. Durante esta fase, se eliminan los marcadores temporales 'X' e 'Y', se reorganiza el resultado final al inicio de la cinta, y se eliminan los ceros a la izquierda para presentar la salida de forma concisa. El comportamiento exacto y todas las transiciones entre estos estados se detallan en la tabla de transiciones de estados a continuación.

#table(
  columns: (3fr, auto, auto, auto, 3fr),
  table.header(
    [Estado Actual],
    [Símbolo \ Leído],
    [Símbolo a \ Escribir],
    [Movimiento \ Cabezal],
    [Siguiente Estado]
  ),
  [#text(mi("q_{read-operation}"), size: 8pt)],[S],[S],[R],[#text(mi("q_{sum-start}"), size: 8pt)],
  [#text(mi("q_{read-operation}"), size: 8pt)],[A],[ ],[R],[#text(mi("q_{find-end-of-num2-for-and}"), size: 8pt)],
  [#text(mi("q_{read-operation}"), size: 8pt)],[OTHER],[ ],[R],[#text(mi("q_{reject-invalid-operation}"), size: 8pt)],
  [#text(mi("q_{find-end-of-num2-for-and}"), size: 8pt)],[0],[0],[R],[#text(mi("q_{find-end-of-num2-for-and}"), size: 8pt)],
  [#text(mi("q_{find-end-of-num2-for-and}"), size: 8pt)],[1],[1],[R],[#text(mi("q_{find-end-of-num2-for-and}"), size: 8pt)],
  [#text(mi("q_{find-end-of-num2-for-and}"), size: 8pt)],[\#],[\#],[R],[#text(mi("q_{find-end-of-num2-for-and}"), size: 8pt)],
  [#text(mi("q_{find-end-of-num2-for-and}"), size: 8pt)],[ ],[ ],[L],[#text(mi("q_{read-num2-bit-and}"), size: 8pt)],
  [#text(mi("q_{find-end-of-num2-for-and}"), size: 8pt)],[OTHER],[ ],[R],[#text(mi("q_{reject}"), size: 8pt)],
  [#text(mi("q_{read-num2-bit-and}"), size: 8pt)],[0],[Y],[L],[#text(mi("q_{find-num1-bit-and-0}"), size: 8pt)],
  [#text(mi("q_{read-num2-bit-and}"), size: 8pt)],[1],[Y],[L],[#text(mi("q_{find-num1-bit-and-1}"), size: 8pt)],
  [#text(mi("q_{read-num2-bit-and}"), size: 8pt)],[\#],[\#],[L],[#text(mi("q_{process-remaining-num1-and}"), size: 8pt)],
  [#text(mi("q_{read-num2-bit-and}"), size: 8pt)],[ ],[ ],[L],[#text(mi("q_{process-remaining-num1-and}"), size: 8pt)],
  [#text(mi("q_{read-num2-bit-and}"), size: 8pt)],[X],[X],[L],[#text(mi("q_{read-num2-bit-and}"), size: 8pt)],
  [#text(mi("q_{read-num2-bit-and}"), size: 8pt)],[Y],[Y],[L],[#text(mi("q_{read-num2-bit-and}"), size: 8pt)],
  [#text(mi("q_{read-num2-bit-and}"), size: 8pt)],[OTHER],[ ],[L],[#text(mi("q_{read-num2-bit-and}"), size: 8pt)],
  [#text(mi("q_{find-num1-bit-and-0}"), size: 8pt)],[0],[0],[L],[#text(mi("q_{find-num1-bit-and-0}"), size: 8pt)],
  [#text(mi("q_{find-num1-bit-and-0}"), size: 8pt)],[1],[1],[L],[#text(mi("q_{find-num1-bit-and-0}"), size: 8pt)],
  [#text(mi("q_{find-num1-bit-and-0}"), size: 8pt)],[\#],[\#],[L],[#text(mi("q_{read-num1-bit-and-0}"), size: 8pt)],
  [#text(mi("q_{find-num1-bit-and-0}"), size: 8pt)],[X],[X],[L],[#text(mi("q_{find-num1-bit-and-0}"), size: 8pt)],
  [#text(mi("q_{find-num1-bit-and-0}"), size: 8pt)],[Y],[Y],[L],[#text(mi("q_{find-num1-bit-and-0}"), size: 8pt)],
  [#text(mi("q_{find-num1-bit-and-0}"), size: 8pt)],[ ],[ ],[R],[#text(mi("q_{move-to-result-and-0}"), size: 8pt)],
  [#text(mi("q_{find-num1-bit-and-0}"), size: 8pt)],[S],[S],[R],[#text(mi("q_{move-to-result-and-0}"), size: 8pt)],
  [#text(mi("q_{find-num1-bit-and-0}"), size: 8pt)],[A],[A],[R],[#text(mi("q_{move-to-result-and-0}"), size: 8pt)],
  [#text(mi("q_{find-num1-bit-and-0}"), size: 8pt)],[OTHER],[ ],[R],[#text(mi("q_{reject}"), size: 8pt)],
  [#text(mi("q_{find-num1-bit-and-1}"), size: 8pt)],[0],[0],[L],[#text(mi("q_{find-num1-bit-and-1}"), size: 8pt)],
  [#text(mi("q_{find-num1-bit-and-1}"), size: 8pt)],[1],[1],[L],[#text(mi("q_{find-num1-bit-and-1}"), size: 8pt)],
  [#text(mi("q_{find-num1-bit-and-1}"), size: 8pt)],[\#],[\#],[L],[#text(mi("q_{read-num1-bit-and-1}"), size: 8pt)],
  [#text(mi("q_{find-num1-bit-and-1}"), size: 8pt)],[X],[X],[L],[#text(mi("q_{find-num1-bit-and-1}"), size: 8pt)],
  [#text(mi("q_{find-num1-bit-and-1}"), size: 8pt)],[Y],[Y],[L],[#text(mi("q_{find-num1-bit-and-1}"), size: 8pt)],
  [#text(mi("q_{find-num1-bit-and-1}"), size: 8pt)],[ ],[ ],[R],[#text(mi("q_{move-to-result-and-0}"), size: 8pt)],
  [#text(mi("q_{find-num1-bit-and-1}"), size: 8pt)],[S],[S],[R],[#text(mi("q_{move-to-result-and-0}"), size: 8pt)],
  [#text(mi("q_{find-num1-bit-and-1}"), size: 8pt)],[A],[A],[R],[#text(mi("q_{move-to-result-and-0}"), size: 8pt)],
  [#text(mi("q_{find-num1-bit-and-1}"), size: 8pt)],[OTHER],[ ],[R],[#text(mi("q_{reject}"), size: 8pt)],
  [#text(mi("q_{read-num1-bit-and-0}"), size: 8pt)],[0],[X],[R],[#text(mi("q_{move-to-result-and-0}"), size: 8pt)],
  [#text(mi("q_{read-num1-bit-and-0}"), size: 8pt)],[1],[X],[R],[#text(mi("q_{move-to-result-and-0}"), size: 8pt)],
  [#text(mi("q_{read-num1-bit-and-0}"), size: 8pt)],[S],[ ],[R],[#text(mi("q_{move-to-result-and-0}"), size: 8pt)],
  [#text(mi("q_{read-num1-bit-and-0}"), size: 8pt)],[A],[ ],[R],[#text(mi("q_{move-to-result-and-0}"), size: 8pt)],
  [#text(mi("q_{read-num1-bit-and-0}"), size: 8pt)],[ ],[ ],[R],[#text(mi("q_{move-to-result-and-0}"), size: 8pt)],
  [#text(mi("q_{read-num1-bit-and-0}"), size: 8pt)],[X],[X],[L],[#text(mi("q_{read-num1-bit-and-0}"), size: 8pt)],
  [#text(mi("q_{read-num1-bit-and-0}"), size: 8pt)],[Y],[Y],[L],[#text(mi("q_{read-num1-bit-and-0}"), size: 8pt)],
  [#text(mi("q_{read-num1-bit-and-0}"), size: 8pt)],[\#],[\#],[R],[#text(mi("q_{move-to-result-and-0}"), size: 8pt)],
  [#text(mi("q_{read-num1-bit-and-0}"), size: 8pt)],[OTHER],[ ],[R],[#text(mi("q_{reject}"), size: 8pt)],
  [#text(mi("q_{read-num1-bit-and-1}"), size: 8pt)],[0],[X],[R],[#text(mi("q_{move-to-result-and-0}"), size: 8pt)],
  [#text(mi("q_{read-num1-bit-and-1}"), size: 8pt)],[1],[X],[R],[#text(mi("q_{move-to-result-and-1}"), size: 8pt)],
  [#text(mi("q_{read-num1-bit-and-1}"), size: 8pt)],[S],[ ],[R],[#text(mi("q_{move-to-result-and-0}"), size: 8pt)],
  [#text(mi("q_{read-num1-bit-and-1}"), size: 8pt)],[A],[ ],[R],[#text(mi("q_{move-to-result-and-0}"), size: 8pt)],
  [#text(mi("q_{read-num1-bit-and-1}"), size: 8pt)],[ ],[ ],[R],[#text(mi("q_{move-to-result-and-0}"), size: 8pt)],
  [#text(mi("q_{read-num1-bit-and-1}"), size: 8pt)],[X],[X],[L],[#text(mi("q_{read-num1-bit-and-1}"), size: 8pt)],
  [#text(mi("q_{read-num1-bit-and-1}"), size: 8pt)],[Y],[Y],[L],[#text(mi("q_{read-num1-bit-and-1}"), size: 8pt)],
  [#text(mi("q_{read-num1-bit-and-1}"), size: 8pt)],[\#],[\#],[R],[#text(mi("q_{move-to-result-and-0}"), size: 8pt)],
  [#text(mi("q_{read-num1-bit-and-1}"), size: 8pt)],[OTHER],[ ],[R],[#text(mi("q_{reject}"), size: 8pt)],
  [#text(mi("q_{move-to-result-and-0}"), size: 8pt)],[0],[0],[R],[#text(mi("q_{move-to-result-and-0}"), size: 8pt)],
  [#text(mi("q_{move-to-result-and-0}"), size: 8pt)],[1],[1],[R],[#text(mi("q_{move-to-result-and-0}"), size: 8pt)],
  [#text(mi("q_{move-to-result-and-0}"), size: 8pt)],[\#],[\#],[R],[#text(mi("q_{move-to-result-and-0}"), size: 8pt)],
  [#text(mi("q_{move-to-result-and-0}"), size: 8pt)],[X],[X],[R],[#text(mi("q_{move-to-result-and-0}"), size: 8pt)],
  [#text(mi("q_{move-to-result-and-0}"), size: 8pt)],[Y],[Y],[R],[#text(mi("q_{move-to-result-and-0}"), size: 8pt)],
  [#text(mi("q_{move-to-result-and-0}"), size: 8pt)],[S],[S],[R],[#text(mi("q_{move-to-result-and-0}"), size: 8pt)],
  [#text(mi("q_{move-to-result-and-0}"), size: 8pt)],[A],[A],[R],[#text(mi("q_{move-to-result-and-0}"), size: 8pt)],
  [#text(mi("q_{move-to-result-and-0}"), size: 8pt)],[ ],[0],[L],[#text(mi("q_{return-to-num2-for-next-and}"), size: 8pt)],
  [#text(mi("q_{move-to-result-and-0}"), size: 8pt)],[OTHER],[ ],[R],[#text(mi("q_{reject}"), size: 8pt)],
  [#text(mi("q_{move-to-result-and-1}"), size: 8pt)],[0],[0],[R],[#text(mi("q_{move-to-result-and-1}"), size: 8pt)],
  [#text(mi("q_{move-to-result-and-1}"), size: 8pt)],[1],[1],[R],[#text(mi("q_{move-to-result-and-1}"), size: 8pt)],
  [#text(mi("q_{move-to-result-and-1}"), size: 8pt)],[\#],[\#],[R],[#text(mi("q_{move-to-result-and-1}"), size: 8pt)],
  [#text(mi("q_{move-to-result-and-1}"), size: 8pt)],[X],[X],[R],[#text(mi("q_{move-to-result-and-1}"), size: 8pt)],
  [#text(mi("q_{move-to-result-and-1}"), size: 8pt)],[Y],[Y],[R],[#text(mi("q_{move-to-result-and-1}"), size: 8pt)],
  [#text(mi("q_{move-to-result-and-1}"), size: 8pt)],[S],[S],[R],[#text(mi("q_{move-to-result-and-1}"), size: 8pt)],
  [#text(mi("q_{move-to-result-and-1}"), size: 8pt)],[A],[A],[R],[#text(mi("q_{move-to-result-and-1}"), size: 8pt)],
  [#text(mi("q_{move-to-result-and-1}"), size: 8pt)],[ ],[1],[L],[#text(mi("q_{return-to-num2-for-next-and}"), size: 8pt)],
  [#text(mi("q_{move-to-result-and-1}"), size: 8pt)],[OTHER],[ ],[R],[#text(mi("q_{reject}"), size: 8pt)],
  [#text(mi("q_{return-to-num2-for-next-and}"), size: 8pt)],[0],[0],[L],[#text(mi("q_{return-to-num2-for-next-and}"), size: 8pt)],
  [#text(mi("q_{return-to-num2-for-next-and}"), size: 8pt)],[1],[1],[L],[#text(mi("q_{return-to-num2-for-next-and}"), size: 8pt)],
  [#text(mi("q_{return-to-num2-for-next-and}"), size: 8pt)],[\#],[\#],[L],[#text(mi("q_{return-to-num2-for-next-and}"), size: 8pt)],
  [#text(mi("q_{return-to-num2-for-next-and}"), size: 8pt)],[X],[X],[L],[#text(mi("q_{return-to-num2-for-next-and}"), size: 8pt)],
  [#text(mi("q_{return-to-num2-for-next-and}"), size: 8pt)],[Y],[Y],[L],[#text(mi("q_{read-num2-bit-and}"), size: 8pt)],
  [#text(mi("q_{return-to-num2-for-next-and}"), size: 8pt)],[S],[S],[R],[#text(mi("q_{process-remaining-num1-and}"), size: 8pt)],
  [#text(mi("q_{return-to-num2-for-next-and}"), size: 8pt)],[A],[A],[R],[#text(mi("q_{process-remaining-num1-and}"), size: 8pt)],
  [#text(mi("q_{return-to-num2-for-next-and}"), size: 8pt)],[ ],[ ],[R],[#text(mi("q_{process-remaining-num1-and}"), size: 8pt)],
  [#text(mi("q_{return-to-num2-for-next-and}"), size: 8pt)],[OTHER],[ ],[R],[#text(mi("q_{reject}"), size: 8pt)],
  [#text(mi("q_{process-remaining-num1-and}"), size: 8pt)],[\#],[\#],[L],[#text(mi("q_{process-remaining-num1-and-after-hash}"), size: 8pt)],
  [#text(mi("q_{process-remaining-num1-and}"), size: 8pt)],[X],[X],[L],[#text(mi("q_{process-remaining-num1-and}"), size: 8pt)],
  [#text(mi("q_{process-remaining-num1-and}"), size: 8pt)],[Y],[Y],[L],[#text(mi("q_{process-remaining-num1-and}"), size: 8pt)],
  [#text(mi("q_{process-remaining-num1-and}"), size: 8pt)],[0],[0],[L],[#text(mi("q_{process-remaining-num1-and}"), size: 8pt)],
  [#text(mi("q_{process-remaining-num1-and}"), size: 8pt)],[1],[1],[L],[#text(mi("q_{process-remaining-num1-and}"), size: 8pt)],
  [#text(mi("q_{process-remaining-num1-and}"), size: 8pt)],[S],[S],[R],[#text(mi("q_{move-result-to-start-and}"), size: 8pt)],
  [#text(mi("q_{process-remaining-num1-and}"), size: 8pt)],[A],[A],[R],[#text(mi("q_{move-result-to-start-and}"), size: 8pt)],
  [#text(mi("q_{process-remaining-num1-and}"), size: 8pt)],[ ],[ ],[R],[#text(mi("q_{move-result-to-start-and}"), size: 8pt)],
  [#text(mi("q_{process-remaining-num1-and}"), size: 8pt)],[OTHER],[ ],[R],[#text(mi("q_{reject}"), size: 8pt)],
  [#text(mi("q_{process-remaining-num1-and-after-hash}"), size: 8pt)],[0],[X],[R],[#text(mi("q_{move-to-result-and-0}"), size: 8pt)],
  [#text(mi("q_{process-remaining-num1-and-after-hash}"), size: 8pt)],[1],[X],[R],[#text(mi("q_{move-to-result-and-0}"), size: 8pt)],
  [#text(mi("q_{process-remaining-num1-and-after-hash}"), size: 8pt)],[S],[S],[R],[#text(mi("q_{move-result-to-start-and}"), size: 8pt)],
  [#text(mi("q_{process-remaining-num1-and-after-hash}"), size: 8pt)],[A],[A],[R],[#text(mi("q_{move-to-result-and-and}"), size: 8pt)],
  [#text(mi("q_{process-remaining-num1-and-after-hash}"), size: 8pt)],[ ],[ ],[R],[#text(mi("q_{move-result-to-start-and}"), size: 8pt)],
  [#text(mi("q_{process-remaining-num1-and-after-hash}"), size: 8pt)],[X],[X],[L],[#text(mi("q_{process-remaining-num1-and-after-hash}"), size: 8pt)],
  [#text(mi("q_{process-remaining-num1-and-after-hash}"), size: 8pt)],[OTHER],[ ],[R],[#text(mi("q_{reject}"), size: 8pt)],
  [#text(mi("q_{move-result-to-start-and}"), size: 8pt)],[0],[0],[L],[#text(mi("q_{move-result-to-start-and}"), size: 8pt)],
  [#text(mi("q_{move-result-to-start-and}"), size: 8pt)],[1],[1],[L],[#text(mi("q_{move-result-to-start-and}"), size: 8pt)],
  [#text(mi("q_{move-result-to-start-and}"), size: 8pt)],[\#],[\#],[L],[#text(mi("q_{move-result-to-start-and}"), size: 8pt)],
  [#text(mi("q_{move-result-to-start-and}"), size: 8pt)],[X],[X],[L],[#text(mi("q_{move-result-to-start-and}"), size: 8pt)],
  [#text(mi("q_{move-to-result-to-start-and}"), size: 8pt)],[Y],[Y],[L],[#text(mi("q_{move-to-result-to-start-and}"), size: 8pt)],
  [#text(mi("q_{move-to-result-to-start-and}"), size: 8pt)],[S],[S],[L],[#text(mi("q_{move-to-result-to-start-and}"), size: 8pt)],
  [#text(mi("q_{move-to-result-to-start-and}"), size: 8pt)],[A],[A],[L],[#text(mi("q_{move-to-result-to-start-and}"), size: 8pt)],
  [#text(mi("q_{move-to-result-to-start-and}"), size: 8pt)],[ ],[ ],[R],[#text(mi("q_{erase-prefix-and}"), size: 8pt)],
  [#text(mi("q_{move-to-result-to-start-and}"), size: 8pt)],[OTHER],[ ],[R],[#text(mi("q_{reject}"), size: 8pt)],
  [#text(mi("q_{erase-prefix-and}"), size: 8pt)],[\#],[ ],[R],[#text(mi("q_{erase-prefix-and}"), size: 8pt)],
  [#text(mi("q_{erase-prefix-and}"), size: 8pt)],[S],[ ],[R],[#text(mi("q_{erase-prefix-and}"), size: 8pt)],
  [#text(mi("q_{erase-prefix-and}"), size: 8pt)],[A],[ ],[R],[#text(mi("q_{erase-prefix-and}"), size: 8pt)],
  [#text(mi("q_{erase-prefix-and}"), size: 8pt)],[X],[ ],[R],[#text(mi("q_{erase-prefix-and}"), size: 8pt)],
  [#text(mi("q_{erase-prefix-and}"), size: 8pt)],[Y],[ ],[R],[#text(mi("q_{erase-prefix-and}"), size: 8pt)],
  [#text(mi("q_{erase-prefix-and}"), size: 8pt)],[0],[0],[R],[#text(mi("q_{find-end-of-result-and}"), size: 8pt)],
  [#text(mi("q_{erase-prefix-and}"), size: 8pt)],[1],[1],[R],[#text(mi("q_{find-end-of-result-and}"), size: 8pt)],
  [#text(mi("q_{erase-prefix-and}"), size: 8pt)],[ ],[ ],[R],[#text(mi("q_{erase-prefix-and}"), size: 8pt)],
  [#text(mi("q_{erase-prefix-and}"), size: 8pt)],[OTHER],[ ],[R],[#text(mi("q_{reject}"), size: 8pt)],
  [#text(mi("q_{find-end-of-result-and}"), size: 8pt)],[0],[0],[R],[#text(mi("q_{find-end-of-result-and}"), size: 8pt)],
  [#text(mi("q_{find-end-of-result-and}"), size: 8pt)],[1],[1],[R],[#text(mi("q_{find-end-of-result-and}"), size: 8pt)],
  [#text(mi("q_{find-end-of-result-and}"), size: 8pt)],[ ],[ ],[L],[#text(mi("q_{trim-leading-zeros-and}"), size: 8pt)],
  [#text(mi("q_{find-end-of-result-and}"), size: 8pt)],[OTHER],[ ],[R],[#text(mi("q_{reject}"), size: 8pt)],
  [#text(mi("q_{trim-leading-zeros-and}"), size: 8pt)],[0],[ ],[L],[#text(mi("q_{check-for-only-zero-and}"), size: 8pt)],
  [#text(mi("q_{trim-leading-zeros-and}"), size: 8pt)],[1],[1],[R],[#text(mi("q_{accept}"), size: 8pt)],
  [#text(mi("q_{trim-leading-zeros-and}"), size: 8pt)],[ ],[ ],[L],[#text(mi("q_{trim-leading-zeros-and}"), size: 8pt)],
  [#text(mi("q_{trim-leading-zeros-and}"), size: 8pt)],[OTHER],[ ],[R],[#text(mi("q_{reject}"), size: 8pt)],
  [#text(mi("q_{check-for-only-zero-and}"), size: 8pt)],[ ],[0],[R],[#text(mi("q_{accept}"), size: 8pt)],
  [#text(mi("q_{check-for-only-zero-and}"), size: 8pt)],[0],[ ],[L],[#text(mi("q_{check-for-only-zero-and}"), size: 8pt)],
  [#text(mi("q_{check-for-only-zero-and}"), size: 8pt)],[1],[1],[R],[#text(mi("q_{accept}"), size: 8pt)],
  [#text(mi("q_{check-for-only-zero-and}"), size: 8pt)],[OTHER],[ ],[R],[#text(mi("q_{reject}"), size: 8pt)],
  [#text(mi("q_{sum-start}"), size: 8pt)],[OTHER],[ ],[R],[#text(mi("q_{reject}"), size: 8pt)],
  [#text(mi("q_{sum-start}"), size: 8pt)],[ ],[ ],[R],[#text(mi("q_{reject}"), size: 8pt)]
)



== Implementación del MT
Para la implementación de nuestra Máquina de Turing (MT), que simula el comportamiento de la ALU en la operación AND, hemos utilizado la sintaxis YAML/YML. Este formato declarativo nos permite definir explícitamente los estados de la máquina y su función de transición determinista de una manera clara y estructurada, tal como se requiere en la plataforma turingmachine.io.

Cada símbolo leído de la cinta (bits '0', '1', delimitadores '\#', o marcadores temporales 'X', 'Y') se clasifica, y la MT busca la transición correspondiente definida en el archivo YAML. Si en algún estado no existe una transición válida para el símbolo actual, la entrada es rechazada automáticamente por la plataforma, indicando una secuencia de entrada inválida para la operación y deteniendo el procesamiento.

#show: zebraw

```YAML
input: 'A#1000000000#0000000001' 
blank: ' '
start state: q_read_operation
input-alphabet: ['0', '1', '#', 'S', 'A']
tape-alphabet: ['0', '1', '#', ' ', 'S', 'A', 'X', 'Y']

table:
  q_accept:

  q_reject:
  
  q_reject_invalid_operation:

  q_read_operation:
    'S': {R: q_sum_start}
    'A': {write: ' ', R: q_find_end_of_num2_for_and}
    OTHER: {R: q_reject_invalid_operation} 

  q_find_end_of_num2_for_and:
    '0': {R: q_find_end_of_num2_for_and}
    '1': {R: q_find_end_of_num2_for_and}
    '#': {R: q_find_end_of_num2_for_and}
    ' ': {L: q_read_num2_bit_and}
    OTHER: {R: q_reject} 

  q_read_num2_bit_and:
    '0': {write: 'Y', L: q_find_num1_bit_and_0}
    '1': {write: 'Y', L: q_find_num1_bit_and_1}
    '#': {L: q_process_remaining_num1_and}
    ' ': {L: q_process_remaining_num1_and}
    'X': {L: q_read_num2_bit_and}
    'Y': {L: q_read_num2_bit_and}
    OTHER: {L: q_read_num2_bit_and} 

  q_find_num1_bit_and_0:
    '0': {L: q_find_num1_bit_and_0}
    '1': {L: q_find_num1_bit_and_0}
    '#': {L: q_read_num1_bit_and_0}
    'X': {L: q_find_num1_bit_and_0}
    'Y': {L: q_find_num1_bit_and_0}
    ' ': {R: q_move_to_result_and_0}
    'S': {R: q_move_to_result_and_0}
    'A': {R: q_move_to_result_and_0} 
    OTHER: {R: q_reject}
    
  q_find_num1_bit_and_1:
    '0': {L: q_find_num1_bit_and_1}
    '1': {L: q_find_num1_bit_and_1}
    '#': {L: q_read_num1_bit_and_1}
    'X': {L: q_find_num1_bit_and_1}
    'Y': {L: q_find_num1_bit_and_1}
    ' ': {R: q_move_to_result_and_0}
    'S': {R: q_move_to_result_and_0}
    'A': {R: q_move_to_result_and_0}
    OTHER: {R: q_reject}

  q_read_num1_bit_and_0: 
    '0': {write: 'X', R: q_move_to_result_and_0}
    '1': {write: 'X', R: q_move_to_result_and_0}
    'S': {write: ' ', R: q_move_to_result_and_0}
    'A': {write: ' ', R: q_move_to_result_and_0}
    ' ': {write: ' ', R: q_move_to_result_and_0}
    'X': {L: q_read_num1_bit_and_0} 
    'Y': {L: q_read_num1_bit_and_0}
    '#': {R: q_move_to_result_and_0} 
    OTHER: {R: q_reject}
    
  q_read_num1_bit_and_1:
    '0': {write: 'X', R: q_move_to_result_and_0}
    '1': {write: 'X', R: q_move_to_result_and_1}
    'S': {write: ' ', R: q_move_to_result_and_0}
    'A': {write: ' ', R: q_move_to_result_and_0}
    ' ': {write: ' ', R: q_move_to_result_and_0}
    'X': {L: q_read_num1_bit_and_1}
    'Y': {L: q_read_num1_bit_and_1}
    '#': {R: q_move_to_result_and_0}
    OTHER: {R: q_reject}

  q_move_to_result_and_0: 
    '0': {R: q_move_to_result_and_0}
    '1': {R: q_move_to_result_and_0}
    '#': {R: q_move_to_result_and_0}
    'X': {R: q_move_to_result_and_0}
    'Y': {R: q_move_to_result_and_0}
    'S': {R: q_move_to_result_and_0}
    'A': {R: q_move_to_result_and_0}
    ' ': {write: '0', L: q_return_to_num2_for_next_and} 
    OTHER: {R: q_reject}
    
  q_move_to_result_and_1:
    '0': {R: q_move_to_result_and_1}
    '1': {R: q_move_to_result_and_1}
    '#': {R: q_move_to_result_and_1}
    'X': {R: q_move_to_result_and_1}
    'Y': {R: q_move_to_result_and_1}
    'S': {R: q_move_to_result_and_1}
    'A': {R: q_move_to_result_and_1}
    ' ': {write: '1', L: q_return_to_num2_for_next_and} 
    OTHER: {R: q_reject}

  q_return_to_num2_for_next_and:
    '0': {L: q_return_to_num2_for_next_and}
    '1': {L: q_return_to_num2_for_next_and}
    '#': {L: q_return_to_num2_for_next_and}
    'X': {L: q_return_to_num2_for_next_and}
    'Y': {L: q_read_num2_bit_and} 
    'S': {R: q_process_remaining_num1_and} 
    'A': {R: q_process_remaining_num1_and}
    ' ': {R: q_process_remaining_num1_and} 
    OTHER: {R: q_reject}

  q_process_remaining_num1_and:
    '#': {L: q_process_remaining_num1_and_after_hash}
    'X': {L: q_process_remaining_num1_and}
    'Y': {L: q_process_remaining_num1_and}
    '0': {L: q_process_remaining_num1_and}
    '1': {L: q_process_remaining_num1_and}
    'S': {R: q_move_result_to_start_and} 
    'A': {R: q_move_result_to_start_and}
    ' ': {R: q_move_result_to_start_and} 
    OTHER: {R: q_reject}

  q_process_remaining_num1_and_after_hash:
    '0': {write: 'X', R: q_move_to_result_and_0}
    '1': {write: 'X', R: q_move_to_result_and_0} 
    'S': {R: q_move_result_to_start_and}
    'A': {R: q_move_result_to_start_and}
    ' ': {R: q_move_result_to_start_and}
    'X': {L: q_process_remaining_num1_and_after_hash} 
    OTHER: {R: q_reject}

  q_move_result_to_start_and:
    '0': {L: q_move_result_to_start_and}
    '1': {L: q_move_result_to_start_and}
    '#': {L: q_move_result_to_start_and}
    'X': {L: q_move_result_to_start_and}
    'Y': {L: q_move_result_to_start_and}
    'S': {L: q_move_result_to_start_and}
    'A': {L: q_move_result_to_start_and}
    ' ': {R: q_erase_prefix_and}
    OTHER: {R: q_reject}

  q_erase_prefix_and:
    '#': {write: ' ', R: q_erase_prefix_and}
    'S': {write: ' ', R: q_erase_prefix_and}
    'A': {write: ' ', R: q_erase_prefix_and}
    'X': {write: ' ', R: q_erase_prefix_and}
    'Y': {write: ' ', R: q_erase_prefix_and}
    '0': {R: q_find_end_of_result_and} 
    '1': {R: q_find_end_of_result_and} 
    ' ': {R: q_erase_prefix_and} 
    OTHER: {R: q_reject}

  q_find_end_of_result_and:
    '0': {R: q_find_end_of_result_and}
    '1': {R: q_find_end_of_result_and}
    ' ': {L: q_trim_leading_zeros_and}
    OTHER: {R: q_reject}

  q_trim_leading_zeros_and:
    '0': {write: ' ', L: q_check_for_only_zero_and}
    '1': {R: q_accept}
    ' ': {L: q_trim_leading_zeros_and} 
    OTHER: {R: q_reject}

  q_check_for_only_zero_and:
    ' ': {write: '0', R: q_accept} 
    '0': {write: ' ', L: q_check_for_only_zero_and} 
    '1': {R: q_accept}
    OTHER: {R: q_reject} 
    
  q_sum_start:
    OTHER: {R: q_reject}
    ' ': {R: q_reject}
```

El código YAML que define la Máquina de Turing para la operación AND se encuentra directamente integrado en el documento, visible en el primer cuadro de código que se proporcionó. Se puede copiar y pegar directamente en la plataforma https://turingmachine.io (luego presionar 'RUN') para visualizar el autómata. Si se necesita consultar el código fuente del proyecto relacionado al entorno de ejecución más ampliamente (no directamente de la MT YAML), este se encontrará en el siguiente enlace: https://colab.research.google.com/drive/1hOLEn0QB3mw89MhxmANA5gKoz-22-xES?usp=sharing. No obstante, para la Máquina de Turing en sí, el YAML es lo que se necesita.

== Pruebas de Ingreso
Para asegurar la robustez y precisión de nuestra Máquina de Turing de la ALU, hemos diseñado un conjunto de pruebas de ingreso probadas dentro de https://turingmachine.io. Estas pruebas cubren diversas combinaciones de números binarios, incluyendo casos simples, números con diferentes longitudes y entradas más complejas. 

#table(
columns: (auto, 1fr, 0.25fr),
table.header(
[Entrada],
[Descripción],
[Estado Final Esperado],
),
[A\#0101\#1010],
[Realiza la operación AND entre 0101 y 1010. Este es un caso de prueba estándar con bits mixtos para validar la lógica bit a bit. El resultado esperado es 0000.],
[#text(mi("q_{accept}"), size: 10pt)],
[A\#1111\#1111],
[Comprueba la operación AND de dos números donde todos los bits son 1. El resultado esperado es 1111, lo que valida la capacidad de la máquina para mantener los 1s cuando ambos bits son 1.],
[#text(mi("q_{accept}"), size: 10pt)],
[A\#110\#001],
[Evalúa la operación AND con números de diferente longitud efectiva (aunque rellenados, la lógica de la MT maneja el desajuste). El resultado esperado es 000. Esto prueba la robustez ante la alineación de bits.
],
[#text(mi("q_{accept}"), size: 10pt)],
[A\#1\#0],
[Caso simple de AND entre 1 y 0. El resultado esperado es 0. Valida la operación con entradas mínimas.],
[#text(mi("q_{accept}"), size: 10pt)],
[A\#0\#1],
[Otro caso simple de AND entre 0 y 1. El resultado esperado es 0. Confirma el manejo correcto de la conmutatividad en casos simples.],
[#text(mi("q_{accept}"), size: 10pt)],
[A\#1000000000\#0000000001],
[Prueba la operación AND con números binarios largos, incluyendo ceros iniciales y finales. El resultado esperado es 0000000000. Esto verifica la eficiencia y precisión en entradas de mayor escala.],
[#text(mi("q_{accept}"), size: 10pt)],
)
#pagebreak()