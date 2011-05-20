
.PHONY: test
test:
	$(MAKE) -C ./unit_tests;
	$(MAKE) -C ./unit_tests check;
