#!/bin/bash
# teleport.sh - Bootstrap The Matrix on a new macOS machine
#
# Usage: ./teleport.sh
#
# This script:
# 1. Checks macOS environment
# 2. Installs dependencies (Python, piper-tts)
# 3. Downloads voice model
# 4. Configures Claude integration
# 5. Runs health check

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
echo -e "${CYAN}[1/5] Checking environment...${NC}"

# Check macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo -e "${RED}Error: This script is for macOS only${NC}"
    exit 1
fi
echo "  ✓ macOS detected"

# Check Homebrew
if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}  Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
echo "  ✓ Homebrew available"

# Check Claude Code CLI
if ! command -v claude &> /dev/null; then
    echo -e "${YELLOW}  Warning: Claude Code CLI not found${NC}"
    echo "  Install from: https://claude.ai/claude-code"
    echo "  Continuing anyway..."
else
    echo "  ✓ Claude Code CLI found"
fi

# ============================================
# Phase 2: Python Setup
# ============================================
echo ""
echo -e "${CYAN}[2/5] Setting up Python...${NC}"

# Check Python 3.11+
if ! command -v python3 &> /dev/null; then
    echo -e "${YELLOW}  Installing Python via Homebrew...${NC}"
    brew install python@3.11
fi

PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
echo "  ✓ Python $PYTHON_VERSION"

# Create venv if needed
if [[ ! -d "$SCRIPT_DIR/.venv" ]]; then
    echo "  Creating virtual environment..."
    python3 -m venv "$SCRIPT_DIR/.venv"
fi
echo "  ✓ Virtual environment ready"

# ============================================
# Phase 3: Install Piper TTS
# ============================================
echo ""
echo -e "${CYAN}[3/5] Installing voice system...${NC}"

source "$SCRIPT_DIR/.venv/bin/activate"

# Install piper-tts
if ! pip show piper-tts &> /dev/null; then
    echo "  Installing piper-tts..."
    pip install --quiet piper-tts
fi
echo "  ✓ piper-tts installed"

# ============================================
# Phase 4: Download Voice Model
# ============================================
echo ""
echo -e "${CYAN}[4/5] Downloading voice model...${NC}"

MODELS_DIR="$SCRIPT_DIR/psi/matrix/models"
MODEL_NAME="en_US-kristin-medium"
MODEL_URL="https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/kristin/medium/en_US-kristin-medium.onnx"
CONFIG_URL="https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/kristin/medium/en_US-kristin-medium.onnx.json"

mkdir -p "$MODELS_DIR"

if [[ ! -f "$MODELS_DIR/${MODEL_NAME}.onnx" ]]; then
    echo "  Downloading ${MODEL_NAME} (~15MB)..."
    curl -sL "$MODEL_URL" -o "$MODELS_DIR/${MODEL_NAME}.onnx"
    curl -sL "$CONFIG_URL" -o "$MODELS_DIR/${MODEL_NAME}.onnx.json"
fi
echo "  ✓ Voice model: $MODEL_NAME"

# Update voice.sh to use local model
VOICE_SCRIPT="$SCRIPT_DIR/psi/matrix/voice.sh"
if [[ -f "$VOICE_SCRIPT" ]]; then
    # Check if already configured for local model
    if ! grep -q "MODELS_DIR" "$VOICE_SCRIPT"; then
        echo "  Configuring voice.sh for local model..."
        # Add model path to voice.sh header
        sed -i '' '2a\
MODELS_DIR="$(dirname "$0")/models"
' "$VOICE_SCRIPT"
    fi
fi

deactivate

# ============================================
# Phase 5: Configure Integration
# ============================================
echo ""
echo -e "${CYAN}[5/5] Configuring integration...${NC}"

# Make hooks executable
chmod +x "$SCRIPT_DIR/.claude/hooks/"*.sh 2>/dev/null || true
echo "  ✓ Hooks configured"

# Make active scripts executable
chmod +x "$SCRIPT_DIR/psi/active/"*.sh 2>/dev/null || true
echo "  ✓ Active scripts configured"

# Make voice scripts executable
chmod +x "$SCRIPT_DIR/psi/matrix/"*.sh 2>/dev/null || true
echo "  ✓ Voice scripts configured"

# Create audio cache
mkdir -p "$SCRIPT_DIR/psi/matrix/audio_cache"
echo "  ✓ Audio cache ready"

# ============================================
# Health Check
# ============================================
echo ""
echo -e "${CYAN}Running health check...${NC}"

# Test voice
source "$SCRIPT_DIR/.venv/bin/activate"
echo "The Matrix is ready" | piper --model "$MODELS_DIR/${MODEL_NAME}.onnx" --output_file /tmp/matrix_test.wav 2>/dev/null

if [[ -f "/tmp/matrix_test.wav" ]]; then
    echo -e "  ✓ Voice system operational"
    afplay /tmp/matrix_test.wav 2>/dev/null || true
    rm /tmp/matrix_test.wav
else
    echo -e "${YELLOW}  ⚠ Voice test failed - check piper installation${NC}"
fi
deactivate

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
echo -e "${GREEN}║    Run: claude                                            ║${NC}"
echo -e "${GREEN}║    Then: /oracle                                          ║${NC}"
echo -e "${GREEN}║                                                           ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
