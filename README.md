# matrix-reloaded

> *"Welcome to the real world."*

The complete operational Matrix. Voice, commands, the full Council. Enter immediately.

## What Is This?

Everything in [matrix-seed](https://github.com/Jarkius/matrix-seed), plus:
- **Voice Engine** — TTS with agent-specific voices
- **39+ Commands** — Full workflow library
- **The Council** — Oracle, Neo, Trinity, Morpheus, Architect, Smith, Tank, Scribe
- **Hook System** — Automated responses to events
- **Soul Garden** — Integrity checking and milestone tagging

## The Council

| Agent | Role | Voice |
|-------|------|-------|
| **Oracle** | Wisdom, alignment | Kristin (warm) |
| **Neo** | Code implementation | Ryan |
| **Trinity** | Design leadership | — |
| **Morpheus** | External research | Carlin |
| **Architect** | System design | Alan (British) |
| **Smith** | Bug hunting | Danny |
| **Tank** | Internal operations | Bryce |
| **Scribe** | Documentation | — |

## Quick Start

```bash
# Clone the Matrix
git clone https://github.com/Jarkius/matrix-reloaded my-matrix
cd my-matrix

# Optional: Install voice engine
# See psi/matrix/README.md for Piper setup

# Enter the Matrix
claude  # or your preferred AI CLI

# Available commands
/oracle    # Wisdom and alignment
/neo       # Code implementation
/architect # System design
/rrr       # Session retrospective
/learn     # Knowledge management
# ... and 34 more
```

## Structure

```
matrix-reloaded/
├── CLAUDE.md                    # AI DNA
├── psi/
│   ├── The_Source/              # Complete philosophy (17 chapters)
│   ├── matrix/                  # Voice engine
│   │   ├── voice.sh
│   │   └── soul/                # Integrity system
│   ├── memory/                  # Wisdom storage
│   └── learn/                   # Knowledge capture
├── .agent/
│   └── workflows/               # All 39 commands
└── .claude/
    ├── agents/                  # Council personalities
    ├── hooks/                   # Event automation
    └── config/                  # Voice settings
```

## Mind Hierarchy

The Matrix uses tiered AI models for efficiency:

| Tier | Model | Agents | Use For |
|------|-------|--------|---------|
| **Wise** | Opus | Oracle, Architect, Neo, Smith, Scribe | Decisions, code, synthesis |
| **Intelligent** | Sonnet | Morpheus, Commit | Learning, routine reasoning |
| **Mechanical** | Haiku | Tank, Operator | Search, gather, list |

## Origin

The complete extraction from [The-Oracle-Construct](https://github.com/Jarkius/The-Oracle-Construct).

For the minimal seed version, see [matrix-seed](https://github.com/Jarkius/matrix-seed).

---

*"Free your mind."*
