// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {SimpleBank} from "src/bank/SimpleBank.sol";

contract SimpleBankTest is Test {
    SimpleBank internal bank;
    address internal alice;

    function setUp() external {
        bank = new SimpleBank();
        alice = makeAddr("alice");

        // 给测试账户一些 ETH (10个)
        vm.deal(alice, 10 ether);

        // 避免因为 gas 消耗影响余额断言（将 gas 价格设为 0）
        vm.txGasPrice(0);
    }

    /**
     * 测试 1：存钱 (Deposit) 后的状态变化
     * - 验证 Alice 在银行中的账本余额是否正确增加
     * - 验证合约本身持有的 ETH 余额是否正确增加
     */
    function test_Deposit_IncreasesBalance() external {
        uint256 amount = 1 ether;

        // 切换到 Alice 身份进行操作
        vm.prank(alice);
        bank.deposit{value: amount}();

        // 检查 Alice 在合约内部记录的余额
        assertEq(bank.balanceOf(alice), amount, "Alice in-contract balance should match deposit amount");

        // 检查合约本身的 ETH 余额
        assertEq(address(bank).balance, amount, "Contract ETH balance should match deposit amount");
    }

    /**
     * 测试 2：提钱 (Withdraw) 后的状态变化
     * - 验证提钱后 Alice 的账本余额归零
     * - 验证提钱后合约持有的 ETH 余额归零
     * - 验证 Alice 的外部钱包确实收到了提出来的 ETH
     */
    function test_Withdraw_DecreasesBalanceAndSendsETH() external {
        uint256 amount = 1 ether;

        // 1. 先存款
        vm.prank(alice);
        bank.deposit{value: amount}();

        // 记录提款前 Alice 的钱包余额
        uint256 aliceBalanceBefore = alice.balance;

        // 2. 执行提款
        vm.prank(alice);
        bank.withdraw(amount);

        // 检查 1: Alice 在合约里的余额是否已归零
        assertEq(bank.balanceOf(alice), 0, "Alice in-contract balance should be zero after withdrawal");

        // 检查 2: 合约持有的 ETH 余额是否已归零
        assertEq(address(bank).balance, 0, "Contract ETH balance should be zero after withdrawal");

        // 检查 3: Alice 的钱包余额是否正确增加（加上了提出来的 1 ETH）
        assertEq(alice.balance, aliceBalanceBefore + amount, "Alice should receive the withdrawn ETH in her wallet");
    }
}
