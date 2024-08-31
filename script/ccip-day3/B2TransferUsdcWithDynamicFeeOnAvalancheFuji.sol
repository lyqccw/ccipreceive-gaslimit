// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Script.sol";
import "../Helper.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {IERC20} from "@chainlink/contracts-ccip/src/v0.8/vendor/openzeppelin-solidity/v4.8.3/contracts/token/ERC20/IERC20.sol";

import "../../src/ccip-master-class-4/TransferUSDC.sol";

import {TransferUSDCTest} from "../../test/TransferUSDC.t.sol";

contract TransferUsdcWithDynamicFeeOnAvalancheFuji is Script, Helper {
    function run() external {
        uint256 amount = 1e4;
        uint64 receiveGasLimit = estimateReceiveGas(amount);

        uint256 senderPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(senderPrivateKey);

        IERC20 usdc = IERC20(usdcAvalancheFuji);

        usdc.approve(0xF23C461dE16f42C88c6dCe6AC645a87EFad1a7Cc, amount);

        TransferUSDC transferUSDC = TransferUSDC(
            0xF23C461dE16f42C88c6dCe6AC645a87EFad1a7Cc
        );

        // UsdcReceiver
        address transferReceiver = 0xDD0329bD4A67d8180a154637426c52E1DC839D04;

        transferUSDC.transferUsdc(
            chainIdEthereumSepolia,
            transferReceiver,
            amount,
            receiveGasLimit
        );
        vm.stopBroadcast();
    }

    function estimateReceiveGas(uint256 usdcAmount) public returns (uint64) {
        TransferUSDCTest tt = new TransferUSDCTest();
        tt.setUp();
        return (110 * tt.transferUsdcEstimate(usdcAmount)) / 100;
    }
}

// forge script ./script/ccip-master-class-4/B2TransferUsdcWithDynamicFeeOnAvalancheFuji.sol --rpc-url $AVALANCHE_FUJI_RPC_URL --broadcast
// https://testnet.avascan.info/blockchain/c/tx

/*
##### fuji
✅  [Success]Hash: 0x18cce0e29b72d03f018f1f2ab8d1d9dd5ab9b080d3b2453e7d5602a9eb182276
Block: 35402738
Paid: 0.0015241875 ETH (55425 gas * 27.5 gwei)


##### fuji
✅  [Success]Hash: 0x5be6cfe317c1aa48a06e331140679efcd1acaf6b5a629cf8692492b78a6e8ca7
Block: 35402739
Paid: 0.011406395 ETH (414778 gas * 27.5 gwei)
*/
