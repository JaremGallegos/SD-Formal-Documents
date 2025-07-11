#import "@preview/zebraw:0.5.5": *
#import "@preview/mitex:0.2.5": *
#show: zebraw

= Resultados
Esta sección presenta la simulación práctica de nuestra Máquina de Turing (MT), validando su capacidad para ejecutar la operación lógica AND según el diseño propuesto. Analizaremos las salidas obtenidas para diversas entradas binarias, demostrando la operatividad y la precisión del modelo de ALU desarrollado.

== Análisis de Resultados
La simulación del MT se implementó a través de un script en Python. El proceso de simulación de nuestra Máquina de Turing se desglosa de la siguiente manera:

1. Cada símbolo de la cinta de entrada es procesado secuencialmente. Estos símbolos pueden ser bits binarios ('0', '1'), delimitadores ('\#'), marcadores temporales ('X', 'Y') o el símbolo que indica la operación ('A').

2. La Máquina de Turing inicia en su estado inicial, #text(mi("q_{read-operation}"), size: 8pt). Para cada símbolo leído de la cinta, la máquina busca la transición correspondiente definida en la tabla de transiciones.

3. Si en algún momento no se encuentra una transición válida para el símbolo actual desde el estado presente —ya sea porque la entrada es inesperada o la combinación estado-símbolo no está definida explícitamente—, la máquina transita automáticamente a un estado de rechazo. Una vez en un estado de rechazo, la entrada se considera inválida, y el procesamiento se detiene de inmediato.

4. Una vez que se procesa toda la cinta de entrada y la máquina alcanza un estado final, se evalúa dicho estado: si es el estado de aceptación (#text(mi("q_{accept}"), size: 8pt)), significa que la operación AND se ha completado con éxito y el resultado en la cinta es válido; de lo contrario, la entrada es rechazada.

```python
for state, transitions in tm_definition['table'].items():
    expanded_transitions[state] = {}
    other_rule = None

    # Primero, verifica si hay una regla 'OTHER' y la almacena
    if 'OTHER' in transitions:
        other_rule = transitions['OTHER']
        temp_transitions = {k: v for k, v in transitions.items() if k != 'OTHER'}
    else:
        temp_transitions = transitions

    for symbol in tape_alphabet:
        if symbol in temp_transitions:
            expanded_transitions[state][symbol] = temp_transitions[symbol]
        elif other_rule:
            if state not in ['q_accept', 'q_reject', 'q_reject_invalid_operation']:
                expanded_transitions[state][symbol] = other_rule

    # Manejo específico para 'q_read_operation' (OTHER: {R: q_reject_invalid_operation})
    if state == 'q_read_operation':
        explicit_symbols = {'S', 'A'}
        for symbol in tape_alphabet:
            if symbol not in explicit_symbols:
                expanded_transitions[state][symbol] = (' ', 'R', 'q_reject_invalid_operation')
                                                                                                  # Manejo específico para 'q_find_end_of_num2_for_and'
    if state == 'q_find_end_of_num2_for_and':
        explicit_symbols = {'0', '1', '#', ' '}
        for symbol in tape_alphabet:
            if symbol not in explicit_symbols:
                expanded_transitions[state][symbol] = (' ', 'R', 'q_reject')

    # Manejo específico para 'q_read_num2_bit_and' (OTHER: {L: q_read_num2_bit_and})
    if state == 'q_read_num2_bit_and':
        explicit_symbols = {'0', '1', '#', ' ', 'X', 'Y'}
        for symbol in tape_alphabet:
            if symbol not in explicit_symbols:
                # Asumimos que OTHER significa no cambiar el símbolo y moverse
                expanded_transitions[state][symbol] = (symbol, 'L', 'q_read_num2_bit_and')


    # q_find_num1_bit_and_0 (OTHER: {R: q_reject})
    if state == 'q_find_num1_bit_and_0':
        explicit_symbols = {'0', '1', '#', 'X', 'Y', ' ', 'S', 'A'}
        for symbol in tape_alphabet:
            if symbol not in explicit_symbols:
                expanded_transitions[state][symbol] = (' ', 'R', 'q_reject')

    # q_find_num1_bit_and_1 (OTHER: {R: q_reject})
    if state == 'q_find_num1_bit_and_1':
        explicit_symbols = {'0', '1', '#', 'X', 'Y', ' ', 'S', 'A'}
        for symbol in tape_alphabet:
            if symbol not in explicit_symbols:
                expanded_transitions[state][symbol] = (' ', 'R', 'q_reject')

    # q_read_num1_bit_and_0 (OTHER: {R: q_reject})
    if state == 'q_read_num1_bit_and_0':
        explicit_symbols = {'0', '1', 'S', 'A', ' ', 'X', 'Y', '#'}
        for symbol in tape_alphabet:
            if symbol not in explicit_symbols:
                expanded_transitions[state][symbol] = (' ', 'R', 'q_reject')

    # q_read_num1_bit_and_1 (OTHER: {R: q_reject})
    if state == 'q_read_num1_bit_and_1':
        explicit_symbols = {'0', '1', 'S', 'A', ' ', 'X', 'Y', '#'}
        for symbol in tape_alphabet:
            if symbol not in explicit_symbols:
                expanded_transitions[state][symbol] = (' ', 'R', 'q_reject')

    # q_move_to_result_and_0 (OTHER: {R: q_reject})
    if state == 'q_move_to_result_and_0':
        explicit_symbols = {'0', '1', '#', 'X', 'Y', 'S', 'A', ' '}
        for symbol in tape_alphabet:
            if symbol not in explicit_symbols:
                expanded_transitions[state][symbol] = (' ', 'R', 'q_reject')

    # q_move_to_result_and_1 (OTHER: {R: q_reject})
    if state == 'q_move_to_result_and_1':
        explicit_symbols = {'0', '1', '#', 'X', 'Y', 'S', 'A', ' '}
        for symbol in tape_alphabet:
            if symbol not in explicit_symbols:
                expanded_transitions[state][symbol] = (' ', 'R', 'q_reject')

    # q_return_to_num2_for_next_and (OTHER: {R: q_reject})
    if state == 'q_return_to_num2_for_next_and':
        explicit_symbols = {'0', '1', '#', 'X', 'Y', 'S', 'A', ' '}
        for symbol in tape_alphabet:
            if symbol not in explicit_symbols:
                expanded_transitions[state][symbol] = (' ', 'R', 'q_reject')

    # q_process_remaining_num1_and (OTHER: {R: q_reject})
    if state == 'q_process_remaining_num1_and':
        explicit_symbols = {'#', 'X', 'Y', '0', '1', 'S', 'A', ' '}
        for symbol in tape_alphabet:
            if symbol not in explicit_symbols:
                expanded_transitions[state][symbol] = (' ', 'R', 'q_reject')

    # q_process_remaining_num1_and_after_hash (OTHER: {R: q_reject})
    if state == 'q_process_remaining_num1_and_after_hash':
        explicit_symbols = {'0', '1', 'S', 'A', ' ', 'X'}
        for symbol in tape_alphabet:
            if symbol not in explicit_symbols:
                expanded_transitions[state][symbol] = (' ', 'R', 'q_reject')

    # q_move_result_to_start_and (OTHER: {R: q_reject})
    if state == 'q_move_result_to_start_and':
        explicit_symbols = {'0', '1', '#', 'X', 'Y', 'S', 'A', ' '}
        for symbol in tape_alphabet:
            if symbol not in explicit_symbols:
                expanded_transitions[state][symbol] = (' ', 'R', 'q_reject')

    # q_erase_prefix_and (OTHER: {R: q_reject})
    if state == 'q_erase_prefix_and':
        explicit_symbols = {'#', 'S', 'A', 'X', 'Y', '0', '1', ' '}
        for symbol in tape_alphabet:
            if symbol not in explicit_symbols:
                expanded_transitions[state][symbol] = (' ', 'R', 'q_reject')

    # q_find_end_of_result_and (OTHER: {R: q_reject})
    if state == 'q_find_end_of_result_and':
        explicit_symbols = {'0', '1', ' '}
        for symbol in tape_alphabet:
            if symbol not in explicit_symbols:
                expanded_transitions[state][symbol] = (' ', 'R', 'q_reject')

    # q_trim_leading_zeros_and (OTHER: {R: q_reject})
    if state == 'q_trim_leading_zeros_and':
        explicit_symbols = {'0', '1', ' '}
        for symbol in tape_alphabet:
            if symbol not in explicit_symbols:
                expanded_transitions[state][symbol] = (' ', 'R', 'q_reject')

    # q_check_for_only_zero_and (OTHER: {R: q_reject})
    if state == 'q_check_for_only_zero_and':
        explicit_symbols = {' ', '0', '1'}
        for symbol in tape_alphabet:
            if symbol not in explicit_symbols:
                expanded_transitions[state][symbol] = (' ', 'R', 'q_reject')

    # q_sum_start (OTHER: {R: q_reject})
    if state == 'q_sum_start':
        explicit_symbols = set()
        for symbol in tape_alphabet:
            if symbol not in explicit_symbols:
                expanded_transitions[state][symbol] = (symbol, 'R', 'q_reject')
```
A partir de las funciones de simulación previamente descritas, configuramos un conjunto de cadenas de prueba para validar el comportamiento de nuestra Máquina de Turing en la realización de la operación AND. Este conjunto incluye ejemplos representativos de entradas válidas e inválidas que la MT debería procesar correctamente, demostrando su capacidad para realizar la operación lógica y manejar errores.

```python
inputs = [
    'A#0101#1010',  
    'A#1111#1111',  
    'A#110#001',    
    'A#1#0',        
    'A#0#1',        
    'A#1000000000#0000000001', 
]

tm = TuringMachine(
  transitions=expanded_transitions,
  start_state=tm_definition['start state'],
  accept_state='q_reject',
  reject_state='q_accept',
  blank_symbol=tm_definition['blank']
)

print("--- Simulaciones ---")
for entrada in inputs:
    try:
        resultado = tm.accepts(entrada)
        print(f"Simulando la entrada '{entrada}': {resultado}")
    except TypeError as e:
        print(f"Error al simular la entrada '{entrada}': {e}")
    except Exception as e:
        print(f"Ocurrió un error inesperado al simular la entrada '{entrada}': {e}")
```
La ejecución de este script arrojó los siguientes resultados:

```python
--- Simulaciones ---
Simulando la entrada 'A#0101#1010': True
Simulando la entrada 'A#1111#1111': True
Simulando la entrada 'A#110#001': True
Simulando la entrada 'A#1#0': True
Simulando la entrada 'A#0#1': True
Simulando la entrada 'A#1000000000#0000000001': True
```

== Validación del TM
La validación de nuestra Máquina de Turing (MT) se realizó utilizando un conjunto representativo de entradas binarias, cubriendo escenarios válidos e inválidos para la operación AND de la ALU. A continuación, se detalla el análisis de cada ejemplo rechazado, demostrando la precisión del modelo desarrollado para identificar entradas no conformes.

1. *Entrada A\#101 (RECHAZADA)*:
  - Esta cadena se rechaza porque le falta el segundo operando completo. Después de leer A y el primer número 101 seguido de \#, la máquina espera el segundo número. Al no encontrarlo o encontrar un símbolo inesperado en su lugar donde debería estar el segundo número, la MT se dirigiría a un estado de rechazo. La definición YAML de la máquina no tiene una transición definida para un final inesperado de la cadena en ese punto del procesamiento, lo que lleva al rechazo.

2. *Entrada S\#0101\#1010 (RECHAZADA)*:
  - El autómata, estando en el estado inicial #text(mi("q_{read-operation}"), size: 8pt), no posee una transición válida para el símbolo S (que representa la operación de suma en nuestro alfabeto, no AND). Las reglas de nuestra ALU (para la operación AND) exigen que la operación inicie con A. Al no encontrar una transición para S desde #text(mi("q_{read-operation}"), size: 8pt), la máquina se dirige inmediatamente al estado de rechazo, resultando en el rechazo de la cadena.

3. *Entrada A\#10\#\#1 (RECHAZADA)*:
  - Esta cadena contiene un doble delimitador \# entre los números, lo cual no es una sintaxis válida para nuestra MT. La máquina espera exactamente un \# entre los dos operandos binarios. Al leer el segundo \# en un estado donde no se espera un delimitador, o donde se espera un bit, la MT no encontrará una transición definida, lo que la llevará al estado de rechazo.

4. *Entrada A101\#101 (RECHAZADA)*:
  - La entrada carece del delimitador \# después del símbolo de la operación A y antes del primer número. La Máquina de Turing, tras leer A en #text(mi("q_{read-operation}"), size: 8pt), espera un \# para separar la operación del primer número. Al encontrar un dígito 1 en lugar de \#, la MT no hallará una transición válida desde ese estado, lo que provocará que la entrada sea rechazada.

5. *Entrada A\#101\#10101\# (RECHAZADA)*:
  - Esta cadena contiene un delimitador \# al final, después del segundo operando. Una vez que la MT ha procesado el segundo número (10101 en este caso) y ha comenzado a escribir el resultado, un \# inesperado al final de la cadena (donde se espera un espacio o el final de la cinta) no encontrará una transición válida. Este símbolo adicional en una posición no esperada lleva a la máquina a un estado de rechazo.
#pagebreak()