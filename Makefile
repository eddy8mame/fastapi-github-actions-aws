setup:
	chmod +x aws/scripts/**/*.sh aws/scripts/*.sh
	uv sync

bootstrap:
	./aws/scripts/check-and-bootstrap.sh

teardown:
	./aws/scripts/teardown/teardown.sh
