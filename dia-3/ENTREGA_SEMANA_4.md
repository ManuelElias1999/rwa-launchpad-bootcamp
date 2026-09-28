# Entregable semana 4: inversión mínima de 500

Esta carpeta agrega `AmountTooLow` (error de contrato `#7`). En `invest`, una cantidad positiva menor que 500 falla antes de transferir el token de pago. La prueba `test_minimum_investment` comprueba que 100 falla sin cambiar los balances y que 500 transfiere el pago y entrega 5 unidades RWA (precio por unidad: 100).

## 1. Descargar este repositorio en tu Mac

Los cambios de esta tarea ya están incluidos en este fork. Ejecuta los siguientes comandos en Terminal:

```bash
git clone https://github.com/ManuelElias1999/rwa-launchpad-bootcamp.git
cd rwa-launchpad-bootcamp
cd dia-3
stellar --version
cargo --version
cargo test
stellar contract build
```

Necesitas Rust con `wasm32v1-none` y Stellar CLI instalados. Si falta el target, ejecuta `rustup target add wasm32v1-none`. El contrato compilado debe aparecer en `target/wasm32v1-none/release/rwa_launchpad_dia_3.wasm` (en algunas versiones la carpeta `target` se genera en la raíz del repositorio; confirma la ruta con `find . .. -name 'rwa_launchpad_dia_3.wasm'`).

## 2. Preparar cuentas y token de prueba

Usa identidades de prueba, nunca claves de mainnet. Puedes usar las cuentas existentes si ya están financiadas. Si necesitas crearlas:

```bash
stellar keys generate rwa-admin --network testnet
stellar keys generate rwa-user --network testnet
stellar keys fund rwa-admin --network testnet
stellar keys fund rwa-user --network testnet
export ADMIN_KEY=rwa-admin
export USER_KEY=rwa-user
export INVESTOR="$(stellar keys address "$USER_KEY")"
```

Usa el ID del contrato del token de pago entregado por el instructor y asegúrate de que `INVESTOR` tenga al menos 500 unidades de ese token. Si quieres probar el flujo de forma independiente con XLM, puedes usar su contrato SAC en testnet:

```bash
export PAYMENT_TOKEN="$(stellar contract id asset --network testnet --asset native)"
```

En ese caso, `500` son **500 stroops**, no 500 XLM. El límite en el contrato usa unidades enteras del token. Para cumplir la tarea con el token del curso, sustituye `PAYMENT_TOKEN` por el ID que te dieron y confirma sus decimales.

## 3. Desplegar e inicializar

Desde `dia-3`, apunta `--wasm` al archivo que realmente generó el build:

```bash
export CONTRACT_ID="$(stellar contract deploy \
  --wasm target/wasm32v1-none/release/rwa_launchpad_dia_3.wasm \
  --source "$ADMIN_KEY" --network testnet)"
echo "$CONTRACT_ID"
export INVESTOR="$(stellar keys address "$USER_KEY")"
bash scripts/admin-tool.sh
```

`admin-tool.sh` inicializa el contrato y añade a `INVESTOR` a la whitelist. **Ejecuta la inicialización una sola vez por contrato recién desplegado.** Si compilaste en otro directorio, cambia la ruta de `--wasm`.

## 4. Demostrar el flujo

```bash
bash scripts/user-tool.sh
```

El script intenta invertir 100 (debe mostrar `AmountTooLow` o el error `#7`), luego invierte 500 (debe devolver `5`) y consulta `balance` (debe devolver `5` si el contrato es nuevo). Si la segunda inversión falla por saldo, consigue primero tokens de pago para la cuenta `INVESTOR`.

La inversión fallida se rechaza antes de enviar la transacción y puede no tener hash en el explorador. Busca **la inversión exitosa** en `https://stellar.expert/explorer/testnet/contract/TU_CONTRACT_ID`, abre la transacción `invest` de 500 y copia su enlace directo. En el video o en las capturas muestra el error de 100, el resultado de 500, el balance y la transacción en el explorador.

## 5. Entregar

En el formulario entrega: enlace a tu fork, `CONTRACT_ID`, enlace directo de la inversión exitosa en Stellar Expert y un video de hasta **2 minutos** o capturas del fallo y del éxito.
