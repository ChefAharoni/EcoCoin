-include .env

.PHONY: report all test deploy

help:
	@echo "Usage:"
	@echo "  make deploy [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""


report:
	forge coverage --report debug > test/coverage/CoverageReportDebug.txt;
	echo "Coverage debug report generated in test/coverage/CoverageReportDebug.txt"

lcov:
	forge coverage --report lcov;
	mv lcov.info test/coverage/;
	# genhtml -o report --branch-coverage; # Working only on Ubuntu.
	echo "Coverage lcov report generated in test/coverage/lcov.info";



NETWORK := Anvil

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK := Sepolia
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --private-key $(SEP_ACC_2_PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv --chain-id 11155111
else 
	ifeq ($(findstring --network ganache,$(ARGS)),--network ganache)
		NETWORK := Ganache
		CONDITIONAL_TARGET := open-ganache
		NETWORK_ARGS := --rpc-url $(GANACHE_RPC_URL) --private-key $(GANACHE_PRIVATE_KEY) --broadcast --chain-id 5777
	else
		CONDITIONAL_TARGET := split-terminal
		NETWORK_ARGS := --rpc-url $(ANVIL_RPC_URL) --private-key $(ACC_9_PRIVATE_KEY) --broadcast

	endif
endif

# Splits the terminal in VSCode
split-terminal:
	../VS_Scripts/split-vscode-terminal.sh

# Opens Ganache application
open-ganache:
	../VS_Scripts/open-ganache.sh


# Deploys the contract 
# @ sign means it will not show the command in the terminal.
deploy: $(CONDITIONAL_TARGET)
	@echo "\n\n\nDeploying EcoCoin contract on $(NETWORK)... \n\n"
	@forge script script/DeployEcoCoin.s.sol $(NETWORK_ARGS)


anvil:
	 anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

# Install dependencies
install:
	forge install openzeppelin/openzeppelin-contracts@v4.9.2 --no-commit && forge install foundry-rs/forge-std@1.6.0 --no-commit

	