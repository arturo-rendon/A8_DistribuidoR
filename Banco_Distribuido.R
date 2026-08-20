############################################################
# BANCO DISTRIBUIDO - AUTOMATIZACIÓN DEL PROCESO DE NEGOCIO
############################################################

# -----------------------------
# 1. Bases de datos locales por sucursal
# -----------------------------

S1 <- data.frame(cuenta_id = c("S1-001", "S1-002"),
                 saldo = c(5000, 12000),
                 stringsAsFactors = FALSE)

S2 <- data.frame(cuenta_id = c("S2-001", "S2-002"),
                 saldo = c(8000, 3000),
                 stringsAsFactors = FALSE)

S3 <- data.frame(cuenta_id = c("S3-001", "S3-002"),
                 saldo = c(15000, 7000),
                 stringsAsFactors = FALSE)


# -----------------------------
# 2. Terminal S1 (Sucursal 1)
# -----------------------------

terminal_S1_deposito <- function(cuenta, monto) {
  idx <- which(S1$cuenta_id == cuenta)
  S1$saldo[idx] <<- S1$saldo[idx] + monto
  cat("[S1] Depósito de", monto, "a", cuenta, "\n")
}

terminal_S1_retiro <- function(cuenta, monto) {
  idx <- which(S1$cuenta_id == cuenta)
  if (S1$saldo[idx] < monto) stop("[S1] Fondos insuficientes")
  S1$saldo[idx] <<- S1$saldo[idx] - monto
  cat("[S1] Retiro de", monto, "de", cuenta, "\n")
}


# -----------------------------
# 3. Terminal S2 (Sucursal 2)
# -----------------------------

terminal_S2_deposito <- function(cuenta, monto) {
  idx <- which(S2$cuenta_id == cuenta)
  S2$saldo[idx] <<- S2$saldo[idx] + monto
  cat("[S2] Depósito de", monto, "a", cuenta, "\n")
}

terminal_S2_retiro <- function(cuenta, monto) {
  idx <- which(S2$cuenta_id == cuenta)
  if (S2$saldo[idx] < monto) stop("[S2] Fondos insuficientes")
  S2$saldo[idx] <<- S2$saldo[idx] - monto
  cat("[S2] Retiro de", monto, "de", cuenta, "\n")
}


# -----------------------------
# 4. Terminal S3 (Sucursal 3)
# -----------------------------

terminal_S3_deposito <- function(cuenta, monto) {
  idx <- which(S3$cuenta_id == cuenta)
  S3$saldo[idx] <<- S3$saldo[idx] + monto
  cat("[S3] Depósito de", monto, "a", cuenta, "\n")
}

terminal_S3_retiro <- function(cuenta, monto) {
  idx <- which(S3$cuenta_id == cuenta)
  if (S3$saldo[idx] < monto) stop("[S3] Fondos insuficientes")
  S3$saldo[idx] <<- S3$saldo[idx] - monto
  cat("[S3] Retiro de", monto, "de", cuenta, "\n")
}


# -----------------------------
# 5. Terminal Central (Transacción Global con 2PC)
# -----------------------------

transferencia_global <- function(origen, cuenta_origen,
                                 destino, cuenta_destino,
                                 monto) {

  cat("\n=== TRANSACCIÓN GLOBAL INICIADA ===\n")

  # Selección de sucursal origen
  sucO <- switch(origen, S1 = S1, S2 = S2, S3 = S3)
  idxO <- which(sucO$cuenta_id == cuenta_origen)

  # Selección de sucursal destino
  sucD <- switch(destino, S1 = S1, S2 = S2, S3 = S3)
  idxD <- which(sucD$cuenta_id == cuenta_destino)

  # -------- FASE 1: PREPARE --------
  cat("[PREPARE] Validando saldos y cuentas...\n")

  if (length(idxO) == 0) stop("Cuenta origen no existe")
  if (length(idxD) == 0) stop("Cuenta destino no existe")
  if (sucO$saldo[idxO] < monto) stop("Fondos insuficientes en origen")

  cat("[PREPARE] Validación exitosa. Listo para COMMIT.\n")

  # -------- FASE 2: COMMIT --------
  cat("[COMMIT] Ejecutando transferencia...\n")

  sucO$saldo[idxO] <- sucO$saldo[idxO] - monto
  sucD$saldo[idxD] <- sucD$saldo[idxD] + monto

  # Guardar cambios globales
  if (origen == "S1") S1 <<- sucO
  if (origen == "S2") S2 <<- sucO
  if (origen == "S3") S3 <<- sucO

  if (destino == "S1") S1 <<- sucD
  if (destino == "S2") S2 <<- sucD
  if (destino == "S3") S3 <<- sucD

  cat("[COMMIT] Transferencia completada.\n")
  cat("=== TRANSACCIÓN GLOBAL FINALIZADA ===\n")
}


# -----------------------------
# 6. Ejecución del sistema automatizado
# -----------------------------

# Operaciones locales
terminal_S1_deposito("S1-001", 1000)
terminal_S2_retiro("S2-001", 500)
terminal_S3_deposito("S3-002", 2000)

# Transacción global
transferencia_global("S1", "S1-002", "S3", "S3-001", 3000)

# Mostrar estados finales
cat("\n--- Saldos finales ---\n")
print(S1); print(S2); print(S3)
