/*
* Laboratorio-1.asm
*
* Created: 02-Feb-25 09:46:21 PM
* Author : David Carranza
*/
// Encabezado
.include "M328PDEF.inc"

.cseg
.org	0x0000

// Configuración de pila
LDI		R16, LOW(RAMEND)
OUT		SPL, R16
LDI		R16, HIGH(RAMEND)
OUT		SPL, R16

// Configurar el MCU
SETUP:
	// Configuración de los pines de entrada y salida (DDRx, PORTX, PINx)
	// PORTC se configura como la entrada con pull-up habilitado
	LDI R16, 0x00
	OUT DDRC, R16	// Se establece el puerto C como entrada
	LDI R16, 0xFF
	OUT PORTC, R16	// Se habilita los pull-ups en el puerto C

	// PORTB se configura como salida inicialmente apagado
	LDI R16, 0xFF
	OUT DDRB, R16	// Se establece el puerto B como salida
	LDI R16, 0X00
	OUT PORTB, R16	// Todos los bits del puerto B se encuentran apagados

	LDI R17, 0xFF	// Variable que guarda el estado de los botones
	LDI R18, 0x00	// Contador incialización en 0

// Loop Infinito
MAIN:
	IN R16, PINC	// Leer estadode botones
	CP R17, R16		// Comparar con estado previo
	BREQ MAIN		// Si no hay cambio, vuelve a leer
	
	RCALL DELAY		// Retardo para antirrebote

	MOV R19, R16	// Guardar copia de estado actual
	COM R19			// Invertir bits para detectar flancos (1 -> 0)
	AND R19, R17	// Detectar transición de 1 a 0 (botón presionado)
	SBRC R19, 2		// Si el botón de incremento (PC2) se presiono
	RCALL INCREMENT // Llamar subrutina de decremento
	SBRC R19, 3		// Si el bóton de decremento (PC3) se presiono
	RCALL DECREMENT	// Llamar subrutina de decremento

	MOV R17, R16	// Actualizar estado previo de botones
	OUT PORTB, R18	// Mostrar el contador en los LEDs
	RJMP MAIN		// Repetir el ciclo

// Subrutina para incrementar el contador
INCREMENT:
	INC R18			// Incrementra contador
	BRNE NO_CARRY	// Si no hubo overflow, continuar
	LDI	R18, 0x00	// Si hubo carry, reiniciar contador a 0

NO_CARRY:
	ANDI R18, 0x0F	// Mantener los 4 bits menos significativos
	RET

// Subrutina para decrementar el contador
DECREMENT:
	DEC R18			// Decrementar contador
	CPI R18, 0xFF	// Comprobar si se generó borrow
	BRNE NO_BORROW	// Si no hubo borrow

NO_BORROW:
	ANDI R18, 0x0F	// Mantener los 4 bits menos significativos
	RET

// Subrutina de retardo para antirrebote
DELAY:
	LDI R19, 0xFF
SUB_DELAY:
	DEC R19
	CPI R19, 0
	BRNE SUB_DELAY
	RET