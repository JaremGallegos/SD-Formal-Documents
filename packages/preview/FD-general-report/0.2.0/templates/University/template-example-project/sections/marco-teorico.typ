#import "@preview/mitex:0.2.5": *

= Marco Teórico
En esta sección, profundizaremos en la definición de los conceptos referentes a la teoría de la computación, específicamente en los autómatas de tipo 0 dentro de la jerarquía de Chomsky, así como su relación con el pilar de la decidibilidad.

== Las Máquinas de Turing: Definición Formal y Componentes
Una Máquina de Turing (MT), propuesta por Alan M. Turing en 1936, es un modelo matemático hipotético que proporciona una definición operacional y formal de la noción intuitiva de computabilidad en el ámbito discreto. Este modelo abstracto se define como el conjunto de componentes, los cuales son la unidad de control (autómata finito que representa la máquina en un momento dado), la cinta (con extensión indefinida; cada celda contiene un símbolo de #mi("\Gamma")) y el cabezal. La MT “reconoce” un lenguaje formal en el sentido de que admite cadenas como entrada y decide los estados subsecuentes para obtener un resultado.

En este sentido, los lenguajes aceptados por MT se denominan recursivamente enumerables, ya que opera con una cinta infinita hacia la derecha (y eventualmente hacia la izquierda) dividida en celdas. El cabezal de lectura/escritura se mueve paso a paso sobre la cinta. En cada paso, la MT lee el símbolo de la celda actual, consulta la función #mi("\delta") según el estado actual y el símbolo leído, escribe un nuevo símbolo en esa celda, cambia de estado y mueve el cabezal a la Izquierda o Derecha. El proceso continúa hasta que la MT entra a un estado de parada (aceptación o rechazo). Al terminar, el contenido de la cinta y/o el estado final determinan la salida o la decisión sobre la entrada.

Por otra parte, formalmente una Máquina de Turing determinista de una sola cinta se define como una 7-tupla: #mitex("M=(Q, \Sigma, \Gamma, \delta, q_{0}, q_{accept}, q_{reject})")
Los componentes de esta tupla son: 
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

#table(
  columns: (0.5fr, 0.5fr, 1fr),
  table.header(
    [Componente],
    [Símbolo Matemático],
    [Descripción],
  ),
  [Estados],[#mi("Q")], [Conjunto finito y no vacío de estados de la máquina.],
  [Alfabeto de Entrada],[#mi("\Sigma")], [Conjunto finito de símbolos que la máquina puede recibir como entrada. Este alfabeto no incluye el símbolo de blanco.],
  [Alfabeto de Cinta],[#mi("\Gamma")], [Conjunto finito de símbolos que incluye todos los símbolos de #mi("\Sigma") y un símbolo especial de blanco, denotado comúnmente como #mi("B") o #mi("⊔"), donde #mi("B ∉ \Sigma").],
  [Función de Transición],[#mi("\delta")], [Se define como #mi("𝛿:Q×𝛤→Q×𝛤×\{L,R\}"). Esta función mapea un par (estado actual, símbolo leído por el cabezal) a una nueva tupla (nuevo estado, símbolo a escribir en la celda actual, dirección de movimiento del cabezal).],
  [Estado Inicial],[#mi("q_{0} \in Q")], [Estado en el cual comienza la computación.],
  [Estado de Aceptación],[#mi("q_{accept} \in Q")], [Si la máquina entra en este estado, la computación se detiene y la entrada se considera aceptada.],
  [Estado de Rechazo],[#mi("q_{reject} \in Q")], [Si la máquina entra en este estado, la computación se detiene y la entrada se considera rechazada. Por lo que, #mi("q_{accept} ≠ q_{reject}").],
)

== La Tesis de Church-Turing
La Tesis de Church-Turing (CTT) establece un vínculo entre la noción intuitiva de "computabilidad efectiva" y las definiciones formales de computabilidad proporcionadas por diversos modelos matemáticos, siendo la Máquina de Turing el más prominente. Es decir, cualquier procedimiento efectivo (algoritmo) concebible puede implementarse en una Máquina de Turing. En palabras de D’Andrea (2019), “una función es efectivamente calculable si y solo si es computable por una Máquina de Turing”. Esta no es una afirmación demostrable matemáticamente, sino una definición convencional o hipótesis de trabajo.

La relevancia de la tesis radica en que fija el límite formal de la computabilidad: si un problema no puede resolverse con una MT, entonces no puede resolverse mediante ningún algoritmo realista. A partir de esta teoría, las dos prominencias plantearon:

-   *Tesis de Turing:* Alan Turing propuso que cualquier proceso que pudiera ser "razonablemente dicho que es computado por un computador humano utilizando un procedimiento fijo" o, más generalmente, "un "procedimiento efectivo", puede ser computado por una Máquina de Turing. Turing articuló su tesis en términos de "máquinas de computación lógicas" (sus Máquinas de Turing) que serían capaces de realizar "cualquier cosa que pudiera describirse como... 'puramente mecánica'".

-   *Tesis de Church:* Por su parte, Alonzo Church expresó su tesis en el contexto de su cálculo lambda (#mi("\lambda$")-cálculo). Él identificó las funciones "efectivamente calculables" con las funciones #mi("\lambda")-definibles.

=== Formas Modernas y sus Implicaciones
La Tesis de Church-Turing original se refería específicamente a la computación realizada por un ser humano idealizado. Sin embargo, en la ciencia de la computación moderna, el término ha evolucionado y se utiliza para referirse a múltiples interpretaciones y extensiones:

-   *CTT-Algorithm (CTT-A):* Orientada a los programas, establece que "todo algoritmo puede ser expresado por un programa en algún lenguaje de programación equivalente a Turing". Por lo que, cualquier algoritmo que se desarrolle para una ALU, incluyendo las operaciones lógicas, puede ser, en principio, simulado por una Máquina de Turing. Esta tesis requiere que todos los algoritmos estén acotados por la computabilidad de Turing.

-   *Extended Church-Turing Thesis (CTT-E):* Utilizada predominantemente en la teoría de la complejidad, postula que "cualquier modelo computacional 'razonable' puede ser simulado eficientemente en una Máquina de Turing probabilística". Siendo relevante para el análisis de eficiencia y complejidad.

-   *Physical Church-Turing Theses (CTT-P, CTDW):* Estas formas extienden la CTT al ámbito del mundo físico, afirmando que los sistemas físicos están limitados por la computabilidad de Turing, o que todo sistema físico finito puede ser simulado por una Máquina de Turing universal. Estas tesis fueron refutadas con posibles contraejemplos teóricos que incluyen la computación cuántica y la computación relativista.

Es importante destacar que la CTT no es un teorema matemático que pueda ser probado formalmente, ya que la noción de "computabilidad efectiva" es, por definición, informal. Su amplia aceptación se fundamenta en la ausencia de contraejemplos que la refuten y en la confluencia de diversos modelos de computación que han demostrado ser equivalentes en su poder computacional.

=== Equivalencia de Modelos de Computabilidad
Para el propósito actual, el enfoque es una ALU clásica que opera bajo los principios de la computación algorítmica tradicional, ya que las operaciones realizadas por una ALU son procedimientos algorítmicos bien definidos y, por ende, "efectivamente calculables". Si la CTT es verdadera, lo cual es una suposición fundamental en la computación clásica, entonces cualquier operación que una ALU pueda realizar es, en principio, simulable por una Máquina de Turing.

Aunque existen extensiones de la CTT, como las CTT-P, que son objeto de debate y sugieren modelos teóricos más granulados para el desarrollo pragmático de una arquitectura de computadora, muchos de esos principios son difícilmente comprobables o tienen una determinación completa (muchas veces llegando hasta la indecidibilidad teórica). De esta manera, estos límites teóricos no pueden lograr trascender la computación de Turing clásica en términos de eficiencia o incluso computabilidad. Por nuestra parte, al explorar los fundamentos de la ALU con MTs, se podrá tener una comprensión sólida dentro del marco bien establecido de la computación clásica.

== Lenguajes Turing-Reconocibles y Decidibilidad
En el ámbito de la teoría de la computabilidad, la Máquina de Turing se emplea como una herramienta para clasificar lenguajes, es decir, conjuntos de cadenas, basándose en la capacidad de una MT para procesarlos. Esta clasificación distingue entre lo que es computable y lo que no lo es, y dentro de lo computable, entre lo que siempre termina y lo que podría no hacerlo.

=== Definiciones Formales
Una Máquina de Turing $M$ define un lenguaje #mi("L(M)\subseteq \Sigma^*") que consiste en todas las cadenas que $M$ acepta. Se dice que un lenguaje $L$ es reconocible (recursivamente enumerable) si existe una MT que acepta precisamente las cadenas en $L$. Formalmente, $L$ es recursivamente enumerable si #mi("\exists M : L=L(M)"). En tal caso, $M$ se detiene y acepta cualquier #mi("w \in L") pero si #mi("w ∉ L") la MT puede rechazar o incluso entrar en un bucle infinito sin detenerse. Este es el nivel más general de expresividad en la jerarquía de Chomsky (lenguajes de tipo 0): los lenguajes recursivamente enumerables son justamente aquellos reconocibles por alguna MT.

Un lenguaje $L$ se considera Turing-decidible (o recursivo) si existe una MT que decide el lenguaje, es decir, se detiene sobre todas las entradas dando un veredicto definitivo (“sí” si #mi("w\in L"), "no" si #mi("w ∉ L")). En otras palabras, $L$ es decidible si una MT siempre alcanza un estado de aceptación o rechazo para cualquier cadena de entrada. En particular, todo lenguaje decidible es recursivamente enumerable, pero el recíproco no vale salvo que tanto $L$ como su complemento sean recursivamente enumerables. Por ejemplo, el lenguaje de las cadenas que representan números primos (en binario) es recursivamente enumerable: una MT puede verificar la primalidad y aceptar si el número es primo. Pero para decidir la primalidad se requeriría que la MT se detenga también cuando el número no es primo, lo cual no es evidente en un modelo sin límites de tiempo (no se logró en la simulación simple antes de la síntesis formal de la MT). En contraste, el lenguaje de cadenas bien formadas (por ejemplo, de paréntesis balanceados) es decidible porque existe un algoritmo que siempre detiene y comprueba la propiedad.

=== Implicaciones en la Teoría de la Computación
Para ilustrar el modelado, consideremos un ejemplo de MT que realice la operación lógica AND sobre dos bits. Supongamos que la entrada en la cinta son dos símbolos consecutivos que representan los bits (por ejemplo, ‘0’ o ‘1’), seguidos de blancos. Podemos definir $M$ con estados $q_0$ y $q_1$ tal que: si está en $q_0$ y lee ‘0’ (el primer bit es 0), entonces la MT escribe ‘0’ en su lugar y entra al estado de parada #mi("q_{acep}") (ya que 0 AND \* = 0). Si en $q_0$ lee ‘1’, entonces pasa al estado $q_1$ y mueve el cabezal a la derecha (para leer el segundo bit). Entonces, en estado $q_1$, si lee ‘0’ escribe ‘0’ y termina, o si lee ‘1’ escribe ‘1’ y termina. En símbolo, algunas transiciones serían:

#mitex("\delta \ ( q_{0} ,0) =( q_{acep} ,0,S) ,\ \delta ( q_{0} ,1) =( q_{1} ,1,R) ,")
#mitex("\delta ( q_{1} ,0) =( q_{acep} ,0,S) ,\ \delta ( q_{1} ,1) =( q_{acep} ,1,S) ")

Aquí $S$ denota “detenerse” (estado de aceptación). De este modo, la MT deja en la cinta el bit resultado (0 o 1) que corresponde al AND de los dos bits de entrada. Este esquema puede formalizarse con notación #mi("\delta") y transiciones definidas explícitamente en LaTeX, ejemplificando cómo el cálculo booleano se traduce a la ejecución paso a paso de la MT.

Por lo tanto, dado que la Máquina de Turing diseñada para implementar estas operaciones siempre finalizará y producirá un resultado definido para cualquier par de entradas binarias, las funciones computadas se clasifican como "totalmente computables". En consecuencia, el lenguaje que representa la relación entre las entradas y las salidas de estas operaciones es decidible. Este hecho contrasta con problemas más complejos que pueden ser Turing-reconocibles pero no decidibles, como el ya mencionado problema de la parada.
#pagebreak()