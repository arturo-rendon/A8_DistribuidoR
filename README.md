# Banco Distribuido en R

Simulación de un sistema bancario distribuido con tres sucursales y una terminal central que coordina transferencias globales usando un flujo tipo Two-Phase Commit (2PC).

## Objetivo

Este proyecto muestra, de forma didáctica, cómo modelar:

- Operaciones locales por sucursal (depósito y retiro).
- Estado distribuido entre nodos (S1, S2, S3).
- Coordinación central para transacciones entre sucursales.
- Validaciones previas al compromiso de cambios (fase Prepare) y aplicación de cambios (fase Commit).

## Estructura del proyecto

- Banco_Distribuido.R: Script principal con la simulación completa.
- README.md: Documentación del proyecto.
- LICENSE: Licencia del repositorio.

## Requisitos

- R 4.0 o superior (recomendado usar la versión instalada localmente).
- No requiere paquetes externos para ejecutar la simulación.

## Modelo de datos

Cada sucursal mantiene su propia base local como data.frame con:

- cuenta_id: Identificador de cuenta con prefijo de sucursal.
- saldo: Monto disponible.

Sucursales iniciales:

- S1: cuentas S1-001, S1-002.
- S2: cuentas S2-001, S2-002.
- S3: cuentas S3-001, S3-002.

## Funcionalidades

### 1. Operaciones locales por sucursal

Se implementan funciones de terminal para cada sucursal:

- terminal_S1_deposito, terminal_S1_retiro
- terminal_S2_deposito, terminal_S2_retiro
- terminal_S3_deposito, terminal_S3_retiro

Comportamiento:

- Depósito: incrementa saldo de la cuenta local.
- Retiro: valida fondos suficientes; en caso contrario, lanza error.

### 2. Transferencia global entre sucursales

La función transferencia_global(origen, cuenta_origen, destino, cuenta_destino, monto) simula una transacción distribuida con dos fases:

1. PREPARE:
	- Verifica existencia de cuenta origen y destino.
	- Verifica fondos suficientes en la cuenta origen.
2. COMMIT:
	- Debita el monto en origen.
	- Acredita el monto en destino.
	- Persiste cambios en las sucursales globales.

## Flujo de ejecución del script

El script realiza automáticamente:

1. Un depósito en S1-001.
2. Un retiro en S2-001.
3. Un depósito en S3-002.
4. Una transferencia global de S1-002 hacia S3-001.
5. Impresión de saldos finales de S1, S2 y S3.

## Cómo ejecutar

Desde terminal, en la raíz del proyecto:

```powershell
Rscript Banco_Distribuido.R
```

Alternativa desde sesión interactiva de R:

```r
source("Banco_Distribuido.R")
```

## Salida esperada (resumen)

Durante la ejecución se muestran mensajes como:

- [S1] Depósito de ...
- [S2] Retiro de ...
- [PREPARE] Validando saldos y cuentas...
- [COMMIT] Ejecutando transferencia...
- --- Saldos finales ---

## Alcance y limitaciones

Este proyecto es una simulación educativa. No implementa:

- Persistencia a disco o base de datos real.
- Concurrencia real entre procesos/nodos.
- Manejo de fallos parciales de red o recuperación tras caída.
- Seguridad, autenticación o auditoría transaccional.

## Posibles mejoras

- Generalizar funciones de terminal para evitar duplicación por sucursal.
- Añadir bitácora de transacciones y rollback explícito.
- Incorporar pruebas unitarias (por ejemplo con testthat).
- Separar lógica en módulos para facilitar mantenimiento.

## Licencia

Ver archivo LICENSE.