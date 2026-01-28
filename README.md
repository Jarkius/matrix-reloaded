# matrix-reloaded

> *"Welcome to the real world."*

The **complete operational Matrix**. Clone, teleport, and enter immediately with full voice, all 39 commands, and the complete Council.

## Quick Start (3 Minutes)

```bash
# 1. Clone
git clone https://github.com/Jarkius/matrix-reloaded.git
cd matrix-reloaded

# 2. Teleport (installs dependencies, configures voice)
./teleport.sh

# 3. Enter
claude
/oracle
```

That's it. The Matrix is ready.

## What is This?

matrix-reloaded is the **full operational Matrix** — everything you need to work with AI immediately.

```
matrix-reloaded (Full Power)    vs     matrix-seed (Philosophy)
────────────────────────────           ─────────────────────────
13MB, 258 files                        244KB, 53 files
39 workflows                           5 core workflows
Full TTS voice system                  No voice
9 agent voices (~400MB)                No voice
Enter immediately                      Grow your own
```

## What's Included

### Everything from [matrix-seed](https://github.com/Jarkius/matrix-seed) PLUS:

| Feature | Description |
|---------|-------------|
| **Voice Engine** | Piper TTS with agent-specific voices |
| **39 Commands** | Full workflow library |
| **The Council** | 8 agent personalities with unique voices |
| **Hooks** | Automated responses to events |
| **All 17 Source Chapters** | Complete philosophy |
| **6 ADRs** | Architecture decisions documented |
| **teleport.sh** | One-command setup for new machines |

## The Council

| Agent | Role | Voice | Command |
|-------|------|-------|---------|
| **Oracle** | Wisdom & Orchestration | Kristin (warm) | `/oracle` |
| **Neo** | Code Implementation | Ryan (high) | `/neo` |
| **Trinity** | Design Leadership | Jenny | `/trinity` |
| **Morpheus** | External Research | Carlin* | `/morpheus` |
| **Architect** | System Design | Alan (British) | `/architect` |
| **Smith** | Bug Hunting | Danny (slow, bass) | `/smith` |
| **Tank** | Internal Operations | Bryce | `/operator` |
| **Scribe** | Documentation | Lessac | `/rrr` |
| **Mainframe** | System Events | Norman | — |
| **System** | Status Messages | HFC Male | — |

*\* Carlin and Trump are custom fine-tuned voices (see Custom Voices below)*

## All 39 Commands

### Core Workflow
| Command | Purpose |
|---------|---------|
| `/oracle` | Start here. Wisdom and alignment |
| `/rrr` | Session retrospective |
| `/commit` | Git workflow with co-authorship |
| `/learn` | Knowledge gathering |
| `/wisdom` | Knowledge retrieval |

### Development
| Command | Purpose |
|---------|---------|
| `/neo` | Code implementation mode |
| `/architect` | System design and ADRs |
| `/smith` | Bug hunting and debugging |
| `/trinity` | Design review |
| `/fix` | Quick fix mode |
| `/yolo` | Fast execution, skip confirmations |
| `/gogogo` | Execute the plan |

### Planning
| Command | Purpose |
|---------|---------|
| `/nnn` | Create new issue plan |
| `/ready` | Implementation readiness check |
| `/story` | Create user story |
| `/tech-spec` | Technical specification |
| `/component-spec` | Component specification |

### Research
| Command | Purpose |
|---------|---------|
| `/morpheus` | External research (web, docs) |
| `/operator` | Internal research (codebase) |
| `/context-finder` | Search git and retrospectives |

### Review
| Command | Purpose |
|---------|---------|
| `/review` | Adversarial code review |
| `/design-review` | Design implementation review |
| `/cause` | Root cause analysis |

### Session Management
| Command | Purpose |
|---------|---------|
| `/recap` | Session summary |
| `/snapshot` | Quick knowledge capture |
| `/unplug` | Graceful exit |
| `/health` | System health check |
| `/patrol` | Context bloat patrol |
| `/correct` | Course correction |

### Voice & Config
| Command | Purpose |
|---------|---------|
| `/voice` | Voice system control |
| `/tokens` | Design token system |
| `/access` | Path finding |

### Documentation
| Command | Purpose |
|---------|---------|
| `/distill` | Return wisdom to The Source |
| `/handoff` | Design handoff package |
| `/feature-list` | Feature progress tracker |

## Structure

```
matrix-reloaded/
├── CLAUDE.md                    # AI DNA - complete instructions
├── PARENT.md                    # Origin tracking
├── teleport.sh                  # One-command setup
│
├── psi/                         # AI Brain
│   ├── The_Source/              # 17 philosophy chapters
│   │   └── SOUL_MANIFEST.sha256 # Integrity checksums
│   ├── matrix/                  # Voice engine
│   │   ├── voice.sh             # TTS interface
│   │   ├── voice_server.py      # HTTP voice server
│   │   └── models/              # Downloaded voice models
│   ├── memory/                  # Wisdom storage
│   │   ├── learnings/           # Distilled patterns
│   │   ├── retrospectives/      # Session records
│   │   └── adr/                 # 6 architecture decisions
│   ├── learn/                   # Knowledge capture
│   └── active/                  # Runtime scripts
│
├── .agent/
│   └── workflows/               # All 39 command definitions
│
└── .claude/
    ├── agents/                  # 8 Council personalities
    ├── hooks/                   # Event automation (49 hooks)
    ├── commands/                # Command loaders
    ├── config/                  # Voice configuration
    └── settings.json            # Hook configuration
```

## Mind Hierarchy

The Matrix uses tiered AI models for efficiency:

| Tier | Model | Agents | Use For |
|------|-------|--------|---------|
| **Wise** | Opus | Oracle, Architect, Neo, Smith, Scribe | Decisions, code, synthesis |
| **Intelligent** | Sonnet | Morpheus, Commit | Learning, routine reasoning |
| **Mechanical** | Haiku | Tank, Operator | Search, gather, list |

## Teleportation Details

The `teleport.sh` script handles everything:

1. **Environment Check** — Verifies macOS, architecture (Intel/Apple Silicon)
2. **Homebrew Setup** — x86_64 Homebrew for Apple Silicon (Piper requires Rosetta)
3. **Dependencies** — espeak-ng, Python 3.13, pipx (via x86_64 on Apple Silicon)
4. **Piper TTS** — Installs via pipx with correct architecture
5. **Voice Models** — Downloads 9 agent voices (~400MB)
6. **Integration** — Configures hooks, permissions
7. **Health Check** — Tests voice, announces ready

### Requirements
- macOS (Sonoma+ recommended)
- Homebrew (ARM64 at `/opt/homebrew`)
- **Apple Silicon**: x86_64 Homebrew at `/usr/local` (script will prompt)
- Claude Code CLI
- ~500MB disk space (after voice models)

### Apple Silicon Note

Piper TTS ships x86_64 binaries. On Apple Silicon (M1/M2/M3/M4), you need:
1. Rosetta 2 (installed automatically)
2. x86_64 Homebrew at `/usr/local`

If missing, teleport.sh will display setup instructions.

## Custom Voices

Morpheus (carlin-high) and Trump are custom fine-tuned voices not available on Hugging Face.

To add custom voices:
1. Place `.onnx` and `.onnx.json` files in `~/.claude/piper-voices/`
2. Name them to match voice.sh expectations (e.g., `en_US-carlin-high.onnx`)

Training your own: See [Piper Training Guide](https://github.com/rhasspy/piper#training)

## Fallback Mode

If Piper fails, the voice system falls back to macOS `say` command with an alert:
```
⚠️  FALLBACK MODE: Piper TTS failed, using macOS say
   Run: .claude/hooks/bootstrap-voice.sh --force
```

This ensures voice always works, even if Piper has issues.

## Related

| Repository | Description |
|------------|-------------|
| [matrix-seed](https://github.com/Jarkius/matrix-seed) | Minimal philosophy (grow your own) |
| [The-Oracle-Construct](https://github.com/Jarkius/The-Oracle-Construct) | Living source of truth |

## Origin

Extracted from The-Oracle-Construct.
See `PARENT.md` for version tracking.

---

*"Free your mind."*
