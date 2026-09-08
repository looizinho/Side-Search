.PHONY: build run

# Build the project for iOS device
build:
	@./scripts/dev.sh build

# Build, install, and run on a connected physical device
run:
	@./scripts/dev.sh run
