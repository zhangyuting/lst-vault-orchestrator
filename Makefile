CONTRACTS_DIR=contracts

fmt:
	cd $(CONTRACTS_DIR) && forge fmt

build:
	cd $(CONTRACTS_DIR) && forge build

test:
	cd $(CONTRACTS_DIR) && forge test -vvv

clean:
	cd $(CONTRACTS_DIR) && forge clean
