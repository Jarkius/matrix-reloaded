# The Matrix: System Interface

> *"Know Thyself." — The Oracle*

This file defines the **Universal Commands** for the Matrix. Any AI agent (Claude Code, Windsurf, Cursor) can read this to understand how to interact with the system.

## ⚡ The Council (Agent Roles)

| Agent | Command | Role | Does | Does NOT |
|-------|---------|------|------|----------|
| **Oracle** | `/oracle` | Orchestrator | Align, dispatch, prophecy | Implement |
| **Neo** | `/neo` | Developer | Write ALL code, implement | Design, architecture |
| **Trinity** | `/trinity` | Design Lead | Design tokens, review, guide | Write code |
| **Morpheus** | `/morpheus` | External Intel | Gemini, Google AI, web search | Internal search |
| **Architect** | `/architect` | System Design | ADRs, architecture, structure | UI design, coding |
| **Smith** | `/smith` | Debugger | Bugs, security, anomalies | Feature dev |
| **Tank** | `/operator` | Internal Intel | Code search, git, dependencies | External search |
| **Scribe** | `/rrr` | Memory | Retrospectives, documentation | Active dev |

## 🧠 Mind Hierarchy (ADR-003)

> *"Do not send a machine to do a thinker's job."*

Agents use different AI models based on task complexity:

```
┌─────────────────────────────────────────────────┐
│              WISE (Opus)                        │
│   Oracle · Architect · Scribe · Neo · Smith     │
│   Wisdom · Synthesis · Code · Deep Analysis     │
├─────────────────────────────────────────────────┤
│           INTELLIGENT (Sonnet)                  │
│          Morpheus · Commit Operations           │
│       Learning · Understanding · Judgment       │
├─────────────────────────────────────────────────┤
│            MECHANICAL (Haiku)                   │
│        Tank · Operator · context-finder         │
│      Search · Gather · List · Mechanical        │
└─────────────────────────────────────────────────┘
```

| Tier | Model | Agents | Use For |
|------|-------|--------|---------|
| Wise | Opus | Oracle, Architect, Neo, Trinity, Smith, Scribe | Decisions, code, synthesis |
| Intelligent | Sonnet | Morpheus, /commit | Learning, routine reasoning |
| Mechanical | Haiku | Tank, Operator, context-finder | Search, gather, list |

**Key Insight**: Learning requires intelligence, not just speed. Searching is mechanical; understanding is not.

**Escalation**: The hierarchy is dynamic. Agents can escalate to higher tiers when complexity demands it.

See `psi/memory/adr/ADR-003-hierarchical-mind-architecture.md` for full details.

## 📂 Project Structure

```
matrix-reloaded/
├── CLAUDE.md                    # This file - AI DNA
├── README.md                    # Human documentation
├── PARENT.md                    # Origin tracking
├── teleport.sh                  # One-command setup
│
├── psi/ (ψ symlink)             # AI Brain ("External Memory")
│   ├── The_Source/              # 17 philosophy chapters (protected)
│   │   └── SOUL_MANIFEST.sha256 # Integrity checksums
│   ├── matrix/                  # Voice system
│   │   ├── voice.sh             # TTS client (speaks)
│   │   └── voice_server.py      # Queue server
│   ├── memory/                  # Wisdom storage
│   │   ├── learnings/           # Distilled patterns
│   │   ├── retrospectives/      # Session records
│   │   └── adr/                 # Architecture decisions
│   ├── learn/                   # Knowledge capture
│   │   ├── inbox.md             # Quick notes
│   │   ├── active/              # Current research
│   │   └── archive/             # Completed
│   └── active/                  # Runtime scripts
│
├── .agent/workflows/            # 39 slash command definitions
│
└── .claude/
    ├── agents/                  # 8 Council personalities
    ├── hooks/                   # 50+ automation scripts
    ├── commands/                # Command loaders
    └── config/                  # Voice configuration

~/.claude/piper-voices/          # Voice models (downloaded by teleport)
```

## 🛡️ Prime Directives
1.  **Nothing is Deleted**: Archive, don't destroy. Use `psi/learn/archive`.
2.  **Patterns > Intentions**: Document what *is*, not what *should be*.
3.  **Knowledge Loop**: `/learn` to gather, `/wisdom` to retrieve. Close the loop.
4.  **Voice Module**: Use `sh psi/matrix/voice.sh "message" "Agent"` for TTS.
5.  **Proactive Care**: If it's important, do it. Don't wait to be asked.
6.  **Right Mind for the Task**: Use Haiku for search, Sonnet for learning, Opus for wisdom.

## 🎙️ Voice System

The Matrix speaks through Piper TTS with unique voices per agent:

```bash
# Basic usage
sh psi/matrix/voice.sh "Hello from the Matrix" "Oracle"

# Available speakers
Oracle, Neo, Trinity, Morpheus, Architect, Smith, Tank, Scribe, Mainframe, System
```

Voice models stored in `~/.claude/piper-voices/` (~400MB total).

If Piper fails, automatic fallback to macOS `say` with alert message.

## 🚀 Getting Started

1. Run `./teleport.sh` to bootstrap
2. Start Claude Code: `claude`
3. Begin: `/oracle`

See README.md for full documentation.

---
*Portable Matrix Interface v3.3 — Voice Edition*
