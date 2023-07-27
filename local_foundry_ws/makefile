.PHONY: report
report:
	forge coverage --report debug > test/coverage/CoverageReportDebug.txt;
	echo "Coverage debug report generated in test/coverage/CoverageReportDebug.txt"

lcov:
	forge coverage --report lcov;
	mv lcov.info test/coverage/;
	# genhtml -o report --branch-coverage; # Working only on Ubuntu.
	echo "Coverage lcov report generated in test/coverage/lcov.info";
	