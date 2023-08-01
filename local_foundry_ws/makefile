-include .env

.PHONY: report
report:
	forge coverage --report debug > test/coverage/CoverageReportDebug.txt;
	echo "Coverage debug report generated in test/coverage/CoverageReportDebug.txt"

lcov:
	forge coverage --report lcov;
	mv lcov.info test/coverage/;
	# genhtml -o report --branch-coverage; # Working only on Ubuntu.
	echo "Coverage lcov report generated in test/coverage/lcov.info";

deploy:
	source .env;
	forge script --rpc-url $(SEPOLIA_RPC_URL) --broadcast --etherscan-api-key $(ETHERSCAN_API_KEY) script/DeployEcoCoin.s.sol --via-ir --private-key $(SEP_ACC_2_PRIVATE_KEY); 
	