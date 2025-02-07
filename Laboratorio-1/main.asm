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

//  
