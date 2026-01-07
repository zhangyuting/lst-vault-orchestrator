// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {SimpleBank} from "src/bank/SimpleBank.sol";

contract SimpleBankScript is Script {
    function run() external {
        vm.startBroadcast();
        new SimpleBank();
        vm.stopBroadcast();
    }
}
