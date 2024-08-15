// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Script.sol";
import "../Helper.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {IERC20} from "@chainlink/contracts-ccip/src/v0.8/vendor/openzeppelin-solidity/v4.8.3/contracts/token/ERC20/IERC20.sol";

import "../../src/ccip-master-class-4/TransferUSDC.sol";
import "../../src/ccip-master-class-4/UsdcReceiver.sol";

contract B1DeployUSDCReceiver2EthSepolia is Script, Helper {
    function run() external {
        uint256 senderPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(senderPrivateKey);

        (
            address ccipRouter,
            address linkToken,
            address wrappedNative,
            uint64 chainId
        ) = getConfigFromNetwork(SupportedNetworks.ETHEREUM_SEPOLIA);

        console.log("ccipRouter:", ccipRouter);
        console.log("linkToken:", linkToken);
        console.log("wrappedNative:", wrappedNative);
        console.log("chainId:", chainId);

        UsdcReceiver ur = new UsdcReceiver(ccipRouter);

        vm.stopBroadcast();
    }
}

// forge script ./script/ccip-master-class-4/B1DeployUSDCReceiver2EthSepolia.sol --rpc-url $ETHEREUM_SEPOLIA_RPC_URL --broadcast

// ✅  [Success]Hash: 0x9fb395d37e324f49f56190c1a74b97ba9d111440aa348fb72151d468b66abc45
// Contract Address: 0xDD0329bD4A67d8180a154637426c52E1DC839D04
