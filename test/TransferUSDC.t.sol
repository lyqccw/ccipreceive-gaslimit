// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

// Importing necessary components from the Chainlink and Forge Standard libraries for testing.
import {Test, console, Vm} from "forge-std/Test.sol";
import {BurnMintERC677} from "@chainlink/contracts-ccip/src/v0.8/shared/token/ERC677/BurnMintERC677.sol";
import {MockCCIPRouter} from "@chainlink/contracts-ccip/src/v0.8/ccip/test/mocks/MockRouter.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import "../src/ccip-master-class-4/TransferUSDC.sol";
import "../src/ccip-master-class-4/UsdcReceiver.sol";

import "../script/Helper.sol";
import "./MockUsdc.sol";

/// @title A test suite for Sender and Receiver contracts to estimate ccipReceive gas usage.
contract TransferUSDCTest is Test, Helper {
    // Declaration of contracts and variables used in the tests.
    TransferUSDC public sender;
    UsdcReceiver public receiver;
    BurnMintERC677 public link;
    MockCCIPRouter public router;
    MockUsdc public usdcToken;

    address eoaaa = address(0x123);
    // A specific chain selector for identifying the chain.

    // chainIdEthereumSepolia = 16015286601757825753
    /// @dev Sets up the testing environment by deploying necessary contracts and configuring their states.
    function setUp() public {
        // Mock router and LINK token contracts are deployed to simulate the network environment.
        usdcToken = new MockUsdc(10000 * 1e18);
        usdcToken.transfer(eoaaa, 100 * 1e18);
        vm.startPrank(eoaaa);

        router = new MockCCIPRouter();
        link = new BurnMintERC677("ChainLink Token", "LINK", 18, 10 ** 27);
        // Sender and Receiver contracts are deployed with references to the router and LINK token.
        sender = new TransferUSDC(
            address(router),
            address(link),
            address(usdcToken)
        );
        usdcToken.approve(address(sender), 100 * 1e18);

        receiver = new UsdcReceiver(address(router));
        // Configuring allowlist settings for testing cross-chain interactions.
        sender.allowlistDestinationChain(chainIdEthereumSepolia, true);

        vm.stopPrank();
    }

    function test_transferUsdc() public {
        transferUsdcEstimate(1e3);
    }

    /// @dev Helper function to simulate sending a message from Sender to Receiver.
    ///
    function transferUsdcEstimate(uint256 usdcAmount) public returns (uint64) {
        vm.startPrank(eoaaa);

        vm.recordLogs(); // Starts recording logs to capture events.

        sender.transferUsdc(
            chainIdEthereumSepolia,
            address(receiver),
            usdcAmount,
            500000
        );

        // Fetches recorded logs to check for specific events and their outcomes.
        Vm.Log[] memory logs = vm.getRecordedLogs();
        bytes32 msgExecutedSignature = keccak256(
            "MsgExecuted(bool,bytes,uint256)"
        );

        console.log(
            "receiver balance:",
            usdcToken.balanceOf(address(receiver))
        );

        for (uint i = 0; i < logs.length; i++) {
            if (logs[i].topics[0] == msgExecutedSignature) {
                (, , uint256 gasUsed) = abi.decode(
                    logs[i].data,
                    (bool, bytes, uint256)
                );
                console.log("transferUsdc - Gas used: %d", gasUsed);
                vm.stopPrank();
                return uint64(gasUsed);
            }
        }

        vm.stopPrank();
        return 0;
    }
}
