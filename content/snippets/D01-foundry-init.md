# D01 — 在 contracts/ 中 forge init + SimpleBank 最小可测试闭环

## 今日交付（Deliverable）

* 将 Foundry 作为子项目初始化在 `contracts/`（workspace 仓库结构：根目录放文档/内容/课程入口）。
* 移除 Foundry 默认 Counter 示例（含 script 引用），避免 `forge build` 因依赖缺失失败。
* 新增 `SimpleBank` 合约与最小单测，跑通 `make test`（可复现）。

## 关键决策（Why）

* 将合约工程隔离在 `contracts/`，使仓库根目录可以长期承载 `docs/`、`content/`、`course/` 等资产，同时不被 `out/ cache/ lib/` 等构建产物污染；后续扩展 indexer/sdk 也更自然。

## 可复现证据（Proof-of-Work）

* 复现命令（在仓库根目录执行）：

  * `make build`
  * `make test`
  * `make deploy`
  * `make fmt`


```bash
zhangyuting@MacBook-Pro-2 lst-vault-orchestrator % make build 
cd contracts && forge build
Compiling 3 files with Solc 0.8.33
Solc 0.8.33 finished in 451.06ms
Compiler run successful with warnings:
Warning (2424): Natspec memory-safe-assembly special comment for inline assembly is deprecated and scheduled for removal. Use the memory-safe block annotation instead.
   --> lib/forge-std/src/StdStorage.sol:297:13:
    |
297 |             assembly {
    |             ^ (Relevant source part starts here and spans across multiple lines).
  ```

```bash
zhangyuting@MacBook-Pro-2 lst-vault-orchestrator % make test
cd contracts && forge test -vvv
[⠊] Compiling...
No files changed, compilation skipped

Ran 2 tests for test/bank/SimpleBank.t.sol:SimpleBankTest
[PASS] test_Deposit_IncreasesBalance() (gas: 41982)
[PASS] test_Withdraw_DecreasesBalanceAndSendsETH() (gas: 37666)
Suite result: ok. 2 passed; 0 failed; 0 skipped; finished in 6.18ms (1.29ms CPU time)

Ran 1 test suite in 152.18ms (6.18ms CPU time): 2 tests passed, 0 failed, 0 skipped (2 total tests)
```
```bash
zhangyuting@MacBook-Pro-2 lst-vault-orchestrator % make deploy
cd contracts && forge script script/SimpleBank.s.sol
[⠊] Compiling...
No files changed, compilation skipped
Script ran successfully.
Gas used: 349164

If you wish to simulate on-chain transactions pass a RPC URL.
```
```bash
zhangyuting@MacBook-Pro-2 lst-vault-orchestrator % make fmt
cd contracts && forge fmt
Formatted lst-vault-orchestrator/contracts/test/bank/SimpleBank.t.sol
Formatted lst-vault-orchestrator/contracts/src/bank/SimpleBank.sol
```
```bash
zhangyuting@MacBook-Pro-2 lst-vault-orchestrator % make clean
cd contracts && forge clean
```


* 关键文件：

  * `contracts/src/bank/SimpleBank.sol`
  * `contracts/test/bank/SimpleBank.t.sol`
  * `contracts/script/SimpleBank.s.sol`
* 版本/提交（完成后补填）：

  * commit: {commit-hash}
  * tag: {本周五 release 后填写 v0.1.0}

## 摩擦点记录

* 如果删除 `Counter.sol` 后 `forge build` 失败，优先检查是否仍存在 `contracts/script/Counter.s.sol`（脚本引用导致编译失败）。
* 遇到 forge-lint 提示 unaliased-plain-import，已统一改为 named import 以减少命名冲突。
