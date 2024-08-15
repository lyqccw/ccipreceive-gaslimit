// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Script.sol";
import "../Helper.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {IERC20} from "@chainlink/contracts-ccip/src/v0.8/vendor/openzeppelin-solidity/v4.8.3/contracts/token/ERC20/IERC20.sol";

import "../../src/ccip-master-class-4/TransferUSDC.sol";

contract CallUsdcApproveAndTransferUsdcOnAvalancheFuji is Script, Helper {
    function run() external {
        uint256 senderPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(senderPrivateKey);

        IERC20 usdc = IERC20(usdcAvalancheFuji);

        usdc.approve(0xF23C461dE16f42C88c6dCe6AC645a87EFad1a7Cc, 1 * 1e6);

        TransferUSDC transferUSDC = TransferUSDC(
            0xF23C461dE16f42C88c6dCe6AC645a87EFad1a7Cc
        );

        address eoaAddr = vm.addr(senderPrivateKey);

        transferUSDC.transferUsdc(chainIdEthereumSepolia, eoaAddr, 1e6, 0);
        vm.stopBroadcast();
    }
}

// forge script ./script/ccip-master-class-4/A4CallUsdcApproveAndTransferUsdcOnAvalancheFuji.sol --rpc-url $AVALANCHE_FUJI_RPC_URL --broadcast
// https://testnet.avascan.info/blockchain/c/tx

/*
##### fuji
✅  [Success]Hash: 0x4c426f4263fbef9e5c468466c5cba1240bad52755436f66ce7edfca2ef2f4b8c
Block: 35400628
Paid: 0.00166311 ETH (55437 gas * 30 gwei)


##### fuji
✅  [Success]Hash: 0x98fd7cfd994a6a8fd24e631ede36c13850ee8f17bf9c03fcc61cd9dbf6d7bf35
Block: 35400629
Paid: 0.01295685 ETH (431895 gas * 30 gwei)
*/
