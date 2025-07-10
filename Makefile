# GetTor Makefile
# Provides convenient commands for building, deploying, and managing GetTor

PYTHON = python
PIP = pip
GETTOR_DIR = $(PWD)

.PHONY: help install clean setup deploy start stop status test lint

help:
	@echo "GetTor Makefile"
	@echo "Available commands:"
	@echo "  install    - Install dependencies"
	@echo "  setup      - Set up GetTor (run deploy script)"
	@echo "  deploy     - Deploy GetTor completely"
	@echo "  start      - Start all GetTor services"
	@echo "  stop       - Stop all GetTor services"
	@echo "  status     - Check status of GetTor services"
	@echo "  clean      - Clean up generated files"
	@echo "  test       - Run tests (if available)"
	@echo "  lint       - Check code style"

install:
	@echo "Installing dependencies..."
	$(PIP) install -r requirements.txt

setup:
	@echo "Setting up GetTor..."
	chmod +x deploy.sh
	./deploy.sh

deploy: install setup
	@echo "GetTor deployment complete!"

start:
	@echo "Starting GetTor services..."
	$(PYTHON) run_gettor.py all &
	@echo "GetTor services started in background"

stop:
	@echo "Stopping GetTor services..."
	pkill -f "run_gettor.py" || true
	@echo "GetTor services stopped"

status:
	@echo "Checking GetTor service status..."
	@pgrep -f "run_gettor.py" > /dev/null && echo "GetTor services are running" || echo "GetTor services are not running"

clean:
	@echo "Cleaning up..."
	find . -name "*.pyc" -delete
	find . -name "__pycache__" -delete
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info/
	@echo "Cleanup complete"

test:
	@echo "Running tests..."
	@if [ -d "tests" ]; then \
		$(PYTHON) -m unittest discover tests; \
	else \
		echo "No tests directory found"; \
	fi

lint:
	@echo "Checking code style..."
	@if command -v flake8 > /dev/null; then \
		flake8 gettor/ --max-line-length=88; \
	else \
		echo "flake8 not installed. Install with: pip install flake8"; \
	fi

# Development commands
dev-install:
	$(PIP) install -e .
	$(PIP) install flake8 pytest

dev-test:
	pytest tests/ -v

# Production commands
prod-start:
	nohup $(PYTHON) run_gettor.py all > log/gettor.log 2>&1 &
	@echo "GetTor started in production mode"

prod-stop:
	pkill -f "run_gettor.py" || true
	@echo "GetTor stopped"

# Docker commands (if using Docker)
docker-build:
	docker build -t gettor .

docker-run:
	docker run -d --name gettor -p 8080:8080 gettor

docker-stop:
	docker stop gettor || true
	docker rm gettor || true