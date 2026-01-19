# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

libjpraat is a shared library wrapper around Praat (speech analysis software). It builds Praat as a dynamically linked library instead of an executable, enabling integration into other applications via JNI and other language bindings. The `jpraat/jpraat.cpp` wrapper provides C-language bindings with thread-safe error handling.

## Build Commands

**Setup** (copy appropriate makefile.defs for your platform):
```bash
# macOS ARM64 (Apple Silicon)
cp makefiles-libjpraat/makefile.defs.macos.arm64 makefile.defs

# macOS Intel
cp makefiles-libjpraat/makefile.defs.macos.x64 makefile.defs

# Windows 64-bit (MinGW cross-compile)
cp makefiles-libjpraat/makefile.defs.mingw64 makefile.defs

# Windows 32-bit
cp makefiles-libjpraat/makefile.defs.mingw32 makefile.defs

# Linux (silent, no audio)
cp makefiles-libjpraat/makefile.defs.linux.silent.lib makefile.defs
```

**Build**:
```bash
make              # Full build (external deps + internal modules + link library)
make -j12         # Parallel build (recommended)
make all-external # Build only external dependencies
make all-self     # Build only internal modules
```

**Clean**:
```bash
make clean          # Clean everything
make clean-external # Clean only external dependencies
make clean-self     # Clean only internal modules
```

**Output**: Platform-specific shared library (e.g., `libjpraat-arm64-apple-macos11.dylib`, `jpraat.dll`, `libjpraat.so`)

## Build Architecture

Uses the `makefiles-libjpraat/Makefile` which differs from the standard Praat Makefile:
- Links with `-shared` flag to produce a dynamic library instead of executable
- Includes `jpraat/jpraat.o` wrapper object
- Includes `sys/sendpraat.o` for inter-process communication

Build order is critical - modules depend on each other:
1. External deps: clapack → gsl → glpk → mp3 → flac → portaudio → espeak → vorbis → opusfile
2. Internal: kar → melder → sys → dwsys → stat → fon → foned → dwtools → LPC → EEG → gram → FFNet → artsynth → main → jpraat

## Code Architecture

**Core Modules**:
- `melder/` - Core utilities, error handling, memory management
- `sys/` - System module (UI, graphics, Praat library core, `praatlib.h`)
- `fon/` - Phonetics/sound analysis (Sound, Pitch, Formant, Spectrogram, TextGrid)
- `stat/` - Statistical analysis (Table, TableOfReal)
- `dwtools/` - Signal processing and statistics (David Weenink tools)
- `gram/` - Grammar models (OT, HMM, neural networks)

**jpraat Wrapper** (`jpraat/jpraat.cpp`):
- Wraps Praat C++ functions with C-linkage exports
- Pattern: `Function_wrapped()` wraps `Function()` with exception handling
- Thread-safe error handling via mutex-protected `jpraat_last_error()`, `jpraat_set_error()`, `jpraat_clear_error()`
- Returns `releaseToAmbiguousOwner()` for objects to transfer ownership to caller

**External Dependencies** (in `external/`):
- clapack, gsl, glpk - Math/linear algebra
- flac, mp3, vorbis, opusfile - Audio codecs
- portaudio - Cross-platform audio I/O
- espeak - Text-to-speech

## Language Requirements

- C code: C99 (`-std=gnu99`)
- C++ code: C++17 (`-std=c++17`)
- macOS: Requires Objective-C++ for some files (`-ObjC++`)

## Deployment

Maven deployment to `https://phon.ca/artifacts/libs-release-local/`:
- Group: `ca.hedlund`
- Artifact: `libjpraat`
- Use `build_and_deploy.sh <version>` for automated cross-platform builds and deployment
