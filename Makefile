.PHONY: test
test:
	nvim --headless --noplugin -u tests/mininit.lua -c "lua require('plenary.test_harness').test_directory('tests/jo-tree/', {minimal_init='tests/mininit.lua',sequential=true})"

.PHONY: test-docker
test-docker:
	docker build -t jo-tree .
	docker run --rm jo-tree make test

.PHONY: format
format:
	stylua --glob '*.lua' --glob '!defaults.lua' .
