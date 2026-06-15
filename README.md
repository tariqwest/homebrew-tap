# tariqwest/homebrew-tap

Homebrew tap for [apfel-plus](https://github.com/tariqwest/apfel-plus) — the free AI already on your Mac.

## Install

```bash
brew install tariqwest/tap/apfel-plus
```

Or add the tap first:

```bash
brew tap tariqwest/tap
```

```bash
brew install apfel-plus
```

## What you get

- `apfel-plus` — on-device Apple FoundationModels CLI and OpenAI-compatible HTTP server
- `apfel-plus-cmd` — natural language → shell command
- `apfel-plus-oneliner` — complex awk/sed/find pipe chains
- `apfel-plus-explain` — explain a command, error, or code snippet
- `apfel-plus-wtd` — "what's this directory?" project orientation
- `apfel-plus-naming` — suggest names for functions/variables/classes
- `apfel-plus-port` — identify the process on a port
- `apfel-plus-gitsum` — plain-English summary of recent git activity
- `apfel-plus-mac-narrator` — dry-British-humor system narration

## Requirements

- macOS 26 Tahoe or newer
- Apple Silicon (M1 or later)
- Xcode 26+ Command Line Tools (for building)
- Apple Intelligence enabled

## Run the server as a service

```bash
brew services start apfel-plus
```

This starts `apfel-plus --serve` on `http://127.0.0.1:11434` — a drop-in OpenAI-compatible endpoint.
