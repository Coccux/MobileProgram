# ═══════════════════════════════════════════════════════════════════
# Russify Android - Makefile
# Build automation for development and production
# ═══════════════════════════════════════════════════════════════════

.PHONY: help
.DEFAULT_GOAL := help

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

# Build output paths
BUILD_DIR := app/build/outputs/apk
DEV_DEBUG_APK := $(BUILD_DIR)/dev/debug/app-dev-debug.apk
DEV_RELEASE_APK := $(BUILD_DIR)/dev/release/app-dev-release.apk
PROD_DEBUG_APK := $(BUILD_DIR)/prod/debug/app-prod-debug.apk
PROD_RELEASE_APK := $(BUILD_DIR)/prod/release/app-prod-release.apk

# ═══════════════════════════════════════════════════════════════════
# Help
# ═══════════════════════════════════════════════════════════════════

help: ## Show this help message
	@echo ""
	@echo "$(BLUE)═══════════════════════════════════════════════════════════════$(NC)"
	@echo "$(BLUE)  Russify Android Build System$(NC)"
	@echo "$(BLUE)═══════════════════════════════════════════════════════════════$(NC)"
	@echo ""
	@echo "$(GREEN)Development (Local Wi-Fi Backend):$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; /^dev/ {printf "  $(YELLOW)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(GREEN)Production:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; /^prod/ {printf "  $(YELLOW)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(GREEN)Docker Build:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; /^docker/ {printf "  $(YELLOW)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(GREEN)Testing & QA:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; /^test|^lint|^check/ {printf "  $(YELLOW)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(GREEN)Device Management:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; /^install|^uninstall|^device|^logs/ {printf "  $(YELLOW)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(GREEN)Utilities:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; /^clean|^version|^deps/ {printf "  $(YELLOW)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""

# ═══════════════════════════════════════════════════════════════════
# Development Builds (Local Backend: 192.168.0.49:8080)
# ═══════════════════════════════════════════════════════════════════

dev-debug: ## Build development debug APK (local backend)
	@echo "$(GREEN)Building dev-debug APK...$(NC)"
	./gradlew assembleDevDebug
	@echo "$(GREEN)✓ APK: $(DEV_DEBUG_APK)$(NC)"

dev-release: ## Build development release APK (local backend)
	@echo "$(GREEN)Building dev-release APK...$(NC)"
	./gradlew assembleDevRelease
	@echo "$(GREEN)✓ APK: $(DEV_RELEASE_APK)$(NC)"

dev-install: dev-debug ## Build and install dev-debug APK to connected device
	@echo "$(GREEN)Installing dev-debug APK to device...$(NC)"
	./gradlew installDevDebug
	@echo "$(GREEN)✓ App installed!$(NC)"

dev-run: dev-install ## Build, install and run dev app
	@echo "$(GREEN)Launching app...$(NC)"
	adb shell am start -n com.example.Russify.dev.debug/com.example.Russify.MainActivity
	@echo "$(GREEN)✓ App launched!$(NC)"

# ═══════════════════════════════════════════════════════════════════
# Production Builds
# ═══════════════════════════════════════════════════════════════════

prod-debug: ## Build production debug APK
	@echo "$(GREEN)Building prod-debug APK...$(NC)"
	./gradlew assembleProdDebug
	@echo "$(GREEN)✓ APK: $(PROD_DEBUG_APK)$(NC)"

prod-release: ## Build production release APK
	@echo "$(GREEN)Building prod-release APK...$(NC)"
	./gradlew assembleProdRelease
	@echo "$(GREEN)✓ APK: $(PROD_RELEASE_APK)$(NC)"

prod-install: prod-debug ## Build and install prod-debug APK to connected device
	@echo "$(GREEN)Installing prod-debug APK to device...$(NC)"
	./gradlew installProdDebug
	@echo "$(GREEN)✓ App installed!$(NC)"

# ═══════════════════════════════════════════════════════════════════
# Docker Builds
# ═══════════════════════════════════════════════════════════════════

docker-dev-debug: ## Build dev-debug APK in Docker
	@echo "$(GREEN)Building dev-debug in Docker...$(NC)"
	docker compose up --build build-dev-debug

docker-dev-release: ## Build dev-release APK in Docker
	@echo "$(GREEN)Building dev-release in Docker...$(NC)"
	docker compose up --build build-dev-release

docker-prod-release: ## Build prod-release APK in Docker
	@echo "$(GREEN)Building prod-release in Docker...$(NC)"
	docker compose up --build build-prod-release

docker-test: ## Run tests in Docker
	@echo "$(GREEN)Running tests in Docker...$(NC)"
	docker compose up --build test-dev

docker-shell: ## Open interactive shell in Docker
	@echo "$(GREEN)Opening Docker shell...$(NC)"
	docker compose run --rm shell

# ═══════════════════════════════════════════════════════════════════
# Testing & Quality Assurance
# ═══════════════════════════════════════════════════════════════════

test-dev: ## Run unit tests for dev flavor
	./gradlew testDevDebugUnitTest

test-prod: ## Run unit tests for prod flavor
	./gradlew testProdDebugUnitTest

test-all: ## Run all unit tests
	./gradlew test

lint-dev: ## Run lint checks for dev
	./gradlew lintDevDebug

lint-prod: ## Run lint checks for prod
	./gradlew lintProdDebug

lint: ## Run all lint checks
	./gradlew lint

check: ## Run all checks (lint + test)
	./gradlew check

# ═══════════════════════════════════════════════════════════════════
# Device Management
# ═══════════════════════════════════════════════════════════════════

devices: ## List connected Android devices
	@echo "$(BLUE)Connected devices:$(NC)"
	@adb devices -l

device-info: ## Show detailed device information
	@echo "$(BLUE)Device Information:$(NC)"
	@adb shell getprop ro.product.model
	@adb shell getprop ro.build.version.release
	@adb shell getprop ro.build.version.sdk

install-dev-debug: ## Install dev-debug APK via ADB
	@echo "$(GREEN)Installing $(DEV_DEBUG_APK)...$(NC)"
	adb install -r $(DEV_DEBUG_APK)

install-dev-release: ## Install dev-release APK via ADB
	@echo "$(GREEN)Installing $(DEV_RELEASE_APK)...$(NC)"
	adb install -r $(DEV_RELEASE_APK)

install-prod-debug: ## Install prod-debug APK via ADB
	@echo "$(GREEN)Installing $(PROD_DEBUG_APK)...$(NC)"
	adb install -r $(PROD_DEBUG_APK)

install-prod-release: ## Install prod-release APK via ADB
	@echo "$(GREEN)Installing $(PROD_RELEASE_APK)...$(NC)"
	adb install -r $(PROD_RELEASE_APK)

uninstall-dev: ## Uninstall dev app from device
	adb uninstall com.example.Russify.dev

uninstall-prod: ## Uninstall prod app from device
	adb uninstall com.example.Russify

logs: ## Show real-time logcat filtered for Russify
	adb logcat | grep -i russify

logs-dev: ## Show logs for dev app
	adb logcat | grep -i "com.example.Russify.dev"

logs-crash: ## Show crash logs
	adb logcat *:E

# ═══════════════════════════════════════════════════════════════════
# Utilities
# ═══════════════════════════════════════════════════════════════════

clean: ## Clean build artifacts
	@echo "$(YELLOW)Cleaning build artifacts...$(NC)"
	./gradlew clean
	@echo "$(GREEN)✓ Clean complete$(NC)"

fix-permissions: ## Fix file permissions (run if you get 'Permission denied')
	@echo "$(GREEN)Fixing file permissions...$(NC)"
	@chmod +x gradlew
	@chmod +x scripts/*.sh 2>/dev/null || true
	@echo "$(GREEN)✓ Permissions fixed$(NC)"

precheck: ## Check environment before build
	@echo "$(BLUE)Checking build environment...$(NC)"
	@echo ""
	@echo "$(YELLOW)1. Checking gradlew permissions...$(NC)"
	@if [ -x ./gradlew ]; then \
		echo "$(GREEN)   ✓ gradlew is executable$(NC)"; \
	else \
		echo "$(RED)   ✗ gradlew is not executable$(NC)"; \
		echo "$(YELLOW)   Run: make fix-permissions$(NC)"; \
		exit 1; \
	fi
	@echo ""
	@echo "$(YELLOW)2. Checking ADB...$(NC)"
	@if command -v adb >/dev/null 2>&1; then \
		echo "$(GREEN)   ✓ ADB found$(NC)"; \
	else \
		echo "$(RED)   ✗ ADB not found$(NC)"; \
		echo "$(YELLOW)   Install Android SDK Platform Tools$(NC)"; \
	fi
	@echo ""
	@echo "$(YELLOW)3. Checking connected devices...$(NC)"
	@if [ $$(adb devices | grep -v "List" | grep "device$$" | wc -l | tr -d ' ') -gt 0 ]; then \
		echo "$(GREEN)   ✓ Device connected$(NC)"; \
		adb devices | grep "device$$"; \
	else \
		echo "$(YELLOW)   ⚠ No devices connected$(NC)"; \
		echo "$(YELLOW)   Connect device for installation$(NC)"; \
	fi
	@echo ""
	@echo "$(GREEN)✓ Environment check complete$(NC)"

version: ## Show version information
	@echo "$(BLUE)Version Information:$(NC)"
	@./gradlew -q printVersion || echo "Version: Check version.gradle.kts"

deps: ## Show dependency tree
	./gradlew dependencies

deps-updates: ## Check for dependency updates
	./gradlew dependencyUpdates

gradle-sync: ## Sync Gradle dependencies
	./gradlew --refresh-dependencies

build-all: ## Build all variants
	@echo "$(GREEN)Building all variants...$(NC)"
	./gradlew assembleDevDebug assembleDevRelease assembleProdDebug assembleProdRelease

# ═══════════════════════════════════════════════════════════════════
# Quick Commands (aliases)
# ═══════════════════════════════════════════════════════════════════

build: dev-debug ## Quick build (alias for dev-debug)

install: dev-install ## Quick install (alias for dev-install)

run: dev-run ## Quick run (alias for dev-run)

# ═══════════════════════════════════════════════════════════════════
# Release Management
# ═══════════════════════════════════════════════════════════════════

release-tag: ## Create a new release tag (usage: make release-tag VERSION=1.2.3)
	@if [ -z "$(VERSION)" ]; then \
		echo "$(RED)ERROR: VERSION is required. Usage: make release-tag VERSION=1.2.3$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)Creating release tag v$(VERSION)...$(NC)"
	git tag -a v$(VERSION) -m "Release v$(VERSION)"
	git push origin v$(VERSION)
	@echo "$(GREEN)✓ Tag v$(VERSION) created and pushed$(NC)"

release-build: prod-release ## Build production release APK for distribution

# ═══════════════════════════════════════════════════════════════════
# CI/CD Helpers
# ═══════════════════════════════════════════════════════════════════

ci-test: ## Run CI tests
	./gradlew clean test lint --stacktrace

ci-build: ## Run CI build
	./gradlew clean assembleRelease --stacktrace

ci-all: ## Run full CI pipeline
	./gradlew clean test lint assembleRelease --stacktrace
