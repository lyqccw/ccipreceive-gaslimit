// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Script.sol";
import "../Helper.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {IERC20} from "@chainlink/contracts-ccip/src/v0.8/vendor/openzeppelin-solidity/v4.8.3/contracts/token/ERC20/IERC20.sol";

import "../../src/ccip-master-class-4/TransferUSDC.sol";

contract DeployTransferUSDC2AvalancheFuji is Script, Helper {
    function run() external {
        uint256 senderPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(senderPrivateKey);

        (
            address ccipRouter,
            address linkToken,
            address wrappedNative,
            uint64 chainId
        ) = getConfigFromNetwork(SupportedNetworks.AVALANCHE_FUJI);

        console.log("ccipRouter:", ccipRouter);
        console.log("linkToken:", linkToken);
        console.log("wrappedNative:", wrappedNative);
        console.log("chainId:", chainId);

        TransferUSDC tu = new TransferUSDC(
            ccipRouter,
            linkToken,
            usdcAvalancheFuji
        );

        vm.stopBroadcast();
    }
}

// forge script ./script/ccip-master-class-4/A1DeployTransferUSDC2AvalancheFuji.sol:DeployTransferUSDC2AvalancheFuji --rpc-url $AVALANCHE_FUJI_RPC_URL --broadcast

// ✅  [Success]Hash: 0x33e0593f52ffdd336aa6e0bd4c86207bc9b4114a3a2cb67a2b1f69fdc4759f04
// Contract Address: 0xF23C461dE16f42C88c6dCe6AC645a87EFad1a7Cc
// https://testnet.avascan.info/blockchain/c/tx/0x33e0593f52ffdd336aa6e0bd4c86207bc9b4114a3a2cb67a2b1f69fdc4759f04
