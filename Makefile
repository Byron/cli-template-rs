docker_image = docker_developer_environment

.PHONY : help

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


always:

target/debug/foobar: always
	cargo build

target/release/foobar: always
	cargo build --release

##@ Development

lint: ## Run cargo clippy
	cargo clippy

unit-test: ## Run the library's unit-tests
	cargo test

test: lint unit-test journey-tests

profile: target/release/foobar ## Profile the program using callgrind, needs linux or `make interactive-developer-environment-in-docker`
	valgrind --callgrind-out-file=callgrind.profile --tool=callgrind  $< >/dev/null
	callgrind_annotate --auto=yes callgrind.profile

benchmark: target/release/foobar ## Run CLI benchmarks with hyperfine
	hyperfine '$<'

journey-tests: target/debug/foobar ## Run journey-tests
	./tests/stateless-journey.sh $<

continuous-journey-tests: ## Run journey-tests, continuously
	watchexec $(MAKE) journey-tests
