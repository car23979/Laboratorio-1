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

