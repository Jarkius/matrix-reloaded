#!/bin/bash
# teleport.sh - Bootstrap The Matrix on a new macOS machine
#
# Usage: ./teleport.sh
#
# This script:
# 1. Checks macOS environment & architecture
# 2. Installs x86_64 Homebrew (for Piper compatibility on Apple Silicon)
# 3. Installs piper-tts via x86_64 pipx
# 4. Downloads voice models to ~/.claude/piper-voices/
# 5. Configures Claude integration
# 6. Runs health check
#
# IMPORTANT: On Apple Silicon Macs, Piper TTS requires x86_64 libraries.
# This script installs x86_64 Homebrew at /usr/local for Rosetta compatibility.

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${MAGENTA}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║    🔴 THE MATRIX - TELEPORTATION SEQUENCE                ║"
echo "║                                                           ║"
echo "║    \"Welcome to the real world.\"                          ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# ============================================
# Phase 1: Environment Check
# ============================================
echo -e "${CYAN}[1/6] Checking environment...${NC}"

# Check macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo -e "${RED}Error: This script is for macOS only${NC}"
    exit 1
fi
echo "  ✓ macOS detected"

# Check architecture
ARCH=$(uname -m)
IS_APPLE_SILICON=false
if [[ "$ARCH" == "arm64" ]]; then
    IS_APPLE_SILICON=true
    echo "  ✓ Apple Silicon ($ARCH) - will use Rosetta for Piper"
else
    echo "  ✓ Intel ($ARCH)"
fi

# Check Rosetta (needed for Apple Silicon)
if [[ "$IS_APPLE_SILICON" == true ]]; then
    if ! /usr/bin/pgrep -q oahd; then
        echo -e "${YELLOW}  Installing Rosetta 2...${NC}"
        softwareupdate --install-rosetta --agree-to-license
    fi
    echo "  ✓ Rosetta 2 available"
fi

# Check Claude Code CLI
if ! command -v claude &> /dev/null; then
    echo -e "${YELLOW}  Warning: Claude Code CLI not found${NC}"
    echo "  Install from: https://claude.ai/claude-code"
else
    echo "  ✓ Claude Code CLI found"
fi

# ============================================
# Phase 2: x86_64 Homebrew Setup (Apple Silicon)
# ============================================
echo ""
echo -e "${CYAN}[2/6] Setting up Homebrew...${NC}"

if [[ "$IS_APPLE_SILICON" == true ]]; then
    # Check for x86_64 Homebrew
    if [[ ! -f "/usr/local/bin/brew" ]]; then
        echo -e "${YELLOW}"
        echo "  ┌─────────────────────────────────────────────────────────┐"
        echo "  │  MANUAL STEP REQUIRED: Install x86_64 Homebrew         │"
        echo "  │                                                         │"
        echo "  │  Piper TTS requires x86_64 libraries on Apple Silicon. │"
        echo "  │  Please run this command in a NEW terminal:            │"
        echo "  │                                                         │"
        echo "  │  arch -x86_64 /bin/bash -c \"\$(curl -fsSL \\            │"
        echo "  │    https://raw.githubusercontent.com/Homebrew/\\        │"
        echo "  │    install/HEAD/install.sh)\"                           │"
        echo "  │                                                         │"
        echo "  │  Then re-run this script.                               │"
        echo "  └─────────────────────────────────────────────────────────┘"
        echo -e "${NC}"
        exit 1
    fi
    echo "  ✓ x86_64 Homebrew found at /usr/local"
    BREW_CMD="arch -x86_64 /usr/local/bin/brew"
    PIPX_CMD="arch -x86_64 /usr/local/bin/pipx"
    PYTHON_BIN="/usr/local/bin/python3.13"
else
    # Intel Mac - use standard Homebrew
    if ! command -v brew &> /dev/null; then
        echo -e "${YELLOW}  Installing Homebrew...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    echo "  ✓ Homebrew available"
    BREW_CMD="brew"
    PIPX_CMD="pipx"
    PYTHON_BIN="python3"
fi

# ============================================
# Phase 3: Install Dependencies
# ============================================
echo ""
echo -e "${CYAN}[3/6] Installing dependencies...${NC}"

# Install espeak-ng (required library for Piper)
if [[ "$IS_APPLE_SILICON" == true ]]; then
    if [[ ! -f "/usr/local/lib/libespeak-ng.dylib" ]]; then
        echo "  Installing espeak-ng (x86_64)..."
        $BREW_CMD install espeak-ng
    fi
    echo "  ✓ espeak-ng (x86_64)"
fi

# Install Python 3.13
if [[ "$IS_APPLE_SILICON" == true ]]; then
    if [[ ! -f "$PYTHON_BIN" ]]; then
        echo "  Installing Python 3.13 (x86_64)..."
        $BREW_CMD install python@3.13
    fi
    echo "  ✓ Python 3.13 (x86_64)"
else
    if ! command -v python3 &> /dev/null; then
        echo "  Installing Python..."
        $BREW_CMD install python@3.13
    fi
    PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
    echo "  ✓ Python $PYTHON_VERSION"
fi

# Install pipx
if [[ "$IS_APPLE_SILICON" == true ]]; then
    if [[ ! -f "/usr/local/bin/pipx" ]]; then
        echo "  Installing pipx (x86_64)..."
        $BREW_CMD install pipx
    fi
    echo "  ✓ pipx (x86_64)"
else
    if ! command -v pipx &> /dev/null; then
        echo "  Installing pipx..."
        $BREW_CMD install pipx
    fi
    echo "  ✓ pipx"
fi

# ============================================
# Phase 4: Install Piper TTS
# ============================================
echo ""
echo -e "${CYAN}[4/6] Installing Piper TTS...${NC}"

# Check if piper is already installed and working
PIPER_WORKS=false
if command -v piper &> /dev/null; then
    if echo "test" | piper --model /dev/null 2>&1 | grep -q "Unable to find voice"; then
        PIPER_WORKS=true
    fi
fi

if [[ "$PIPER_WORKS" == false ]]; then
    echo "  Installing piper-tts..."
    if [[ "$IS_APPLE_SILICON" == true ]]; then
        # Uninstall any existing broken installation
        $PIPX_CMD uninstall piper-tts 2>/dev/null || true
        # Install with x86_64 Python
        $PIPX_CMD install piper-tts --python "$PYTHON_BIN"
    else
        pipx install piper-tts
    fi
fi
echo "  ✓ piper-tts installed"

# ============================================
# Phase 5: Download Voice Models
# ============================================
echo ""
echo -e "${CYAN}[5/6] Downloading voice models...${NC}"

# Use ~/.claude/piper-voices/ for consistency with The-matrix
VOICE_DIR="$HOME/.claude/piper-voices"
mkdir -p "$VOICE_DIR"

# Download Oracle voice (kristin)
MODEL_NAME="en_US-kristin-medium"
if [[ ! -f "$VOICE_DIR/${MODEL_NAME}.onnx" ]]; then
    echo "  Downloading ${MODEL_NAME} (~63MB)..."
    curl -sL "https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/kristin/medium/${MODEL_NAME}.onnx" \
        -o "$VOICE_DIR/${MODEL_NAME}.onnx"
    curl -sL "https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/kristin/medium/${MODEL_NAME}.onnx.json" \
        -o "$VOICE_DIR/${MODEL_NAME}.onnx.json"
fi
echo "  ✓ Oracle voice: $MODEL_NAME"

# ============================================
# Phase 6: Configure Integration
# ============================================
echo ""
echo -e "${CYAN}[6/6] Configuring integration...${NC}"

# Make hooks executable
chmod +x "$SCRIPT_DIR/.claude/hooks/"*.sh 2>/dev/null || true
echo "  ✓ Hooks configured"

# Make active scripts executable
chmod +x "$SCRIPT_DIR/psi/active/"*.sh 2>/dev/null || true
echo "  ✓ Active scripts configured"

# Make voice scripts executable
chmod +x "$SCRIPT_DIR/psi/matrix/"*.sh 2>/dev/null || true
echo "  ✓ Voice scripts configured"

# ============================================
# Health Check
# ============================================
echo ""
echo -e "${CYAN}Running health check...${NC}"

# Test piper
PIPER_BIN=$(which piper)
TEST_WAV="/tmp/matrix_teleport_test.wav"

echo "The Matrix is ready" | "$PIPER_BIN" --model "$VOICE_DIR/${MODEL_NAME}.onnx" --output_file "$TEST_WAV" 2>/dev/null

if [[ -f "$TEST_WAV" ]] && [[ -s "$TEST_WAV" ]]; then
    echo -e "  ${GREEN}✓ Voice system operational${NC}"
    afplay "$TEST_WAV" 2>/dev/null || true
    rm -f "$TEST_WAV"
else
    echo -e "${RED}  ✗ Voice test failed${NC}"
    echo ""
    echo "  Troubleshooting:"
    echo "  1. Check if piper is in PATH: which piper"
    echo "  2. Check voice model exists: ls $VOICE_DIR/"
    echo "  3. Test manually: echo 'test' | piper --model $VOICE_DIR/${MODEL_NAME}.onnx --output_file /tmp/test.wav"
fi

# ============================================
# Complete
# ============================================
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                           ║${NC}"
echo -e "${GREEN}║    ✅ TELEPORTATION COMPLETE                             ║${NC}"
echo -e "${GREEN}║                                                           ║${NC}"
echo -e "${GREEN}║    The Matrix is ready.                                   ║${NC}"
echo -e "${GREEN}║                                                           ║${NC}"
echo -e "${GREEN}║    Voice models: ~/.claude/piper-voices/                  ║${NC}"
echo -e "${GREEN}║    Piper: $(which piper 2>/dev/null || echo 'not found')${NC}"
echo -e "${GREEN}║                                                           ║${NC}"
echo -e "${GREEN}║    Run: claude                                            ║${NC}"
echo -e "${GREEN}║    Then: /oracle                                          ║${NC}"
echo -e "${GREEN}║                                                           ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# ============================================
# Architecture Notes (for future reference)
# ============================================
#
# WHY x86_64 ON APPLE SILICON?
# ----------------------------
# Piper TTS ships x86_64 binaries for macOS (even in "aarch64" releases).
# These binaries require x86_64 versions of:
#   - libespeak-ng.1.dylib
#   - libpiper_phonemize.1.dylib
#   - libonnxruntime.1.14.1.dylib
#
# The piper-tts Python package (via pipx) bundles these libraries correctly
# when installed with an x86_64 Python interpreter.
#
# DUAL HOMEBREW SETUP:
# -------------------
# - ARM64 Homebrew: /opt/homebrew (native, fast)
# - x86_64 Homebrew: /usr/local (Rosetta, for Piper)
#
# Both can coexist. Use 'arch -x86_64' prefix to run x86_64 commands.
#
# Lesson learned: 2026-01-28, M4 MacBook Air migration
# ============================================
