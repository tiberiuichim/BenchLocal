.PHONY: help web-dev web-build web-start web-clean install typecheck

PORT ?= 4300

help:
	@echo "BenchLocal Makefile targets:"
	@echo ""
	@echo "  make install       Install npm dependencies"
	@echo "  make typecheck     Run TypeScript type checking"
	@echo "  make web-dev       Start web app in development mode (hot reload)"
	@echo "  make web-build     Build web app for production"
	@echo "  make web-start     Start production web server"
	@echo "  make web-clean     Remove web build artifacts"
	@echo ""
	@echo "  PORT=8080 make web-dev   Start on custom port"

install:
	npm install

typecheck:
	npm run typecheck

web-dev:
	@echo "Starting BenchLocal web app in development mode on port $(PORT)..."
	@echo "  Server: http://localhost:$(PORT)"
	@echo "  Renderer: http://localhost:4300 (Vite dev server)"
	@echo ""
	BENCHLOCAL_PORT=$(PORT) npm run web:dev --workspace app

web-build:
	@echo "Building BenchLocal web app..."
	npm run build:compile
	cd app && vite build --config vite.config.web.ts
	cd app && esbuild src/server/index.ts --bundle --platform=node --target=node20 --format=esm --outdir=../dist/server --external:@benchlocal/*
	@echo "Build complete. Artifacts in dist/server/ and app/out/renderer-out/"

web-start:
	@echo "Starting BenchLocal web server on port $(PORT)..."
	@echo "  http://localhost:$(PORT)"
	@echo ""
	BENCHLOCAL_PORT=$(PORT) node dist/server/index.js

web-clean:
	rm -rf dist/server
	rm -rf app/out/renderer-out
