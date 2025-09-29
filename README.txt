# KipuBank

## Descripción
**KipuBank** es un contrato inteligente educativo en Solidity que simula un banco simple en Ethereum.  
Permite a los usuarios depositar y retirar Ether, mientras se aplican límites máximos de capacidad del banco y de retiro por transacción.  

El contrato incluye:  
- Control de saldos individuales de los usuarios.  
- Registro del número total de depósitos y retiros realizados.  
- Eventos para monitorear depósitos y retiros exitosos.  
- Manejo de errores para operaciones fallidas, fondos insuficientes y exceder límites.  
- Funciones de consulta de fondos totales en el banco.  

------

## Despliegue
Para desplegar `KipuBank` en una testnet Ethereum (como Sepolia):
1. Clona o descarga el proyecto.  
2. Utiliza un entorno de desarrollo Ethereum listo, como **Remix**.  
3. Configura los parámetros del constructor:
   - `_bankCap`: Capacidad máxima del banco (en ETH).  
   - `_maxWithdrawal`: Monto máximo permitido por retiro (en ETH).  
4. Compila y despliega el contrato en la red deseada.
5. Una vez desplegado, copia la dirección del contrato para interactuar con él.


------


##Interacción con el contrato
Funciones principales:
1. Depositar Ether: deposit() external payable
    → Envía Ether al contrato desde la cuenta que llama a la función.
2. Retirar Ether: withdrawal(uint256 amount) external
    → amount: Cantidad de Ether a retirar.
    → Requiere que el monto sea menor al límite máximo y que el usuario tenga saldo suficiente.
    → Emite el evento KipuBank_SuccessfulWithdrawal si es exitoso.
3. Consultar saldo total del banco: consultKipuBankFounds() public view returns (uint256)
    → Retorna el total de Ether actualmente almacenado en el contrato.

Eventos importantes:
1. KipuBank_SuccessfulDeposit(address receiver, uint256 amount) → Emitido cuando un depósito se realiza correctamente.
2. KipuBank_SuccessfulWithdrawal(address receiver, uint256 amount) → Emitido cuando un retiro se realiza correctamente.

Manejo de errores:
1. KipuBank_FailedWithdrawal(bytes error) → Cuando un retiro falla.
2. KipuBank_FailedDeposit(bytes error) → Cuando un depósito excede la capacidad máxima.
3. KipuBank_InsufficientFounds(bytes error) → Cuando no hay saldo suficiente.
4. KipuBank_FailedOperation(bytes error) → Cuando se llama a una función inexistente o incorrecta.

