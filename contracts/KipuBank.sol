// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;


/*
@title KipuBank for ETHKipu's Ethereum Developer Pack
@author Micaela Rasso
@notice This contract is part of the second project of the Ethereum Developer Pack 
@custom:security this is an educative contract and should not be used in production
*/
contract KipuBank{
/*Type declararions*/
/*State variables*/
    mapping(address owner => uint256 balance) public s_balances; //puede ser publico porque el getter solo retorna un valor cuando la address es valida
    //registro de depositos y retiros (por cuenta? creeria que generales). Se recomienda publico por transparencia
    uint256 public s_totalDeposits;
    uint256 public s_totalWithdrawals;
    //límite global de depósitos (bankCap)
    uint256 public immutable bankCap;
    //umbral de retiro
    uint256 public immutable maxWithdrawal;

/*Events*/
    event KipuBank_SuccessfulTransaction(); //ob
    event KipuBank_FailedTransaction(); //ob
    //ver si hago algun otro

/*Errors*/
    //investigar más sobre revert, deben ser usados cuando ocurre un error

/*Modifiers*/
    //puedo utilizar para alguna verificación

/*Functions*/
//constructor
    constructor(uint256 _bankCap, uint256 _maxWithdrawl){
        bankCap = _bankCap;
        maxWithdrawal = _maxWithdrawl;
    }
//receive & fallback
//external

    //Los usuarios pueden depositar tokens nativos (ETH) en una bóveda personal.
    //Los usuarios pueden retirar fondos de su bóveda, pero solo hasta un umbral fijo por transacción, representado por una variable immutable.

//public
//internal
//private
//view & pure
}