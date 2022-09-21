ligo_compiler?=docker run --rm -v "$$PWD":"$$PWD" -w "$$PWD" ligolang/ligo:stable
PROTOCOL_OPT?=
JSON_OPT?=--michelson-format json

help:
	@echo  'Usage:'
	@echo  '  all             - Remove generated Michelson files, recompile smart contracts and lauch all tests'
	@echo  '  clean           - Remove generated Michelson files'
	@echo  '  compile         - Compiles smart contract Shifumi'
	@echo  '  test            - Run integration tests (written in Ligo)'
	@echo  '  deploy          - Deploy smart contract Shifumi (typescript using Taquito)'
	@echo  '  sandbox-start   - Run a local sandbox node'
	@echo  ''

all: clean compile test

compile: shifumi

shifumi: shifumi.tz shifumi.json

shifumi.tz: contracts/main.mligo
	@echo "Compiling smart contract to Michelson"
	@mkdir -p compiled
	@$(ligo_compiler) compile contract $^ -e main $(PROTOCOL_OPT) > compiled/$@

shifumi.json: contracts/main.mligo
	@echo "Compiling smart contract to Michelson in JSON format"
	@mkdir -p compiled
	@$(ligo_compiler) compile contract $^ $(JSON_OPT) -e main $(PROTOCOL_OPT) > compiled/$@

clean:
	@echo "Removing Michelson files"
	@rm -f compiled/*.tz compiled/*.json

test: test_ligo

test_ligo: test/test.mligo
	@echo "Running integration tests"
	@$(ligo_compiler) run test $^ $(PROTOCOL_OPT)

deploy: node_modules
	@echo "Deploying contract"
	@if [ ! -f ./deploy/metadata.json ]; then cp deploy/metadata.json.dist \
        deploy/metadata.json ; fi
	@cd ./deploy \
        && npx ts-node deploy.ts \
        && cd -

node_modules:
	@echo "Install node modules"
	@cd deploy && npm install

sandbox-start:
	@./scripts/run-sandbox
