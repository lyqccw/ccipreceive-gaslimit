// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Script.sol";
import "../Helper.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {IERC20} from "@chainlink/contracts-ccip/src/v0.8/vendor/openzeppelin-solidity/v4.8.3/contracts/token/ERC20/IERC20.sol";

import "../../src/ccip-master-class-4/TransferUSDC.sol";

contract CallAllowlistDestinationChainOnAvalancheFuji is Script, Helper {
    function run() external {
        uint256 senderPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(senderPrivateKey);

        TransferUSDC tu = TransferUSDC(
            0xF23C461dE16f42C88c6dCe6AC645a87EFad1a7Cc
        );

        tu.allowlistDestinationChain(chainIdEthereumSepolia, true);

        vm.stopBroadcast();
    }
}

// 调用之后向该合约充值 3 link

// forge script ./script/ccip-master-class-4/A2CallAllowlistDestinationChainOnAvalancheFuji.sol --rpc-url $AVALANCHE_FUJI_RPC_URL --broadcast
// https://testnet.avascan.info/blockchain/c/tx/0xdc6c937c79e2a4031dc7d28bce226ff228ec4712a4f2d4e1f823496935c27cfa
