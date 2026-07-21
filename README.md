# Fontara for Safari

<p align="center">
  <img src="fontara/docs/images/demo/logo.svg" alt="Fontara" width="180" />
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT"></a>
  <img src="https://img.shields.io/badge/platform-macOS%20%7C%20Safari-lightgrey?logo=safari&logoColor=white" alt="Platform: macOS / Safari">
  <img src="https://img.shields.io/badge/Manifest-V3-orange" alt="Manifest V3">
  <img src="https://img.shields.io/badge/built%20with-Swift%20%2F%20SwiftUI-F05138?logo=swift&logoColor=white" alt="Built with Swift / SwiftUI">
  <img src="https://img.shields.io/badge/status-unsigned%20%2F%20local%20build-yellow" alt="Status: unsigned, local build only">
</p>

**Fontara for Safari** is a native Safari App Extension port of
[**Fontara**](https://github.com/mimalef70/fontara) — the popular open-source
browser extension for applying custom fonts across the web, with first-class
support for multilingual and right-to-left (RTL) pages.

This project wraps Fontara's Manifest V3 web extension in a native macOS
container app (built with Swift and SwiftUI) so it can run inside Safari,
which does not support installing Chrome/Firefox extensions directly.

> This is an independent, community-driven port. It is not affiliated with or
> endorsed by Apple. See [Acknowledgments](#acknowledgments) for full credit
> to the original project.

## Contents

- [About This Port](#about-this-port)
- [Features](#features)
- [Project Structure](#project-structure)
- [For Developers / Manual Installation](#for-developers--manual-installation)
  - [Prerequisites](#prerequisites)
  - [Build & Run](#build--run)
  - [Enabling the Extension in Safari](#enabling-the-extension-in-safari)
- [Updating to a New Upstream Release](#updating-to-a-new-upstream-release)
- [Known Limitations](#known-limitations)
- [Acknowledgments](#acknowledgments)
- [License](#license)

## About This Port

Safari doesn't support Chrome/Firefox-style extension installs — extensions
must ship as **Safari App Extensions**, bundled inside a native macOS app and
built with Xcode. This project bridges that gap:

- The upstream Fontara **web extension source** (TypeScript, MV3) lives
  unmodified in [`fontara/`](fontara) as a git-trackable copy of the original
  project, adapted with a Safari MV3 build target and the Safari-specific
  shims it needs (e.g. storage and messaging behavior differences from
  Chrome/Firefox).
- A native **Swift/SwiftUI macOS container app** and **Safari Web Extension
  handler** wrap the built extension bundle so Safari can load it, located in
  [`FontaraSafari/`](FontaraSafari).
- The extension's built output (background scripts, UI, injected content
  scripts, manifest, and assets) is compiled from the web extension source and
  copied into the Xcode project's extension `Resources` folder.

The port currently tracks **upstream Fontara v5.0.0**, merged with zero
conflicts, which brought a multilingual UI (English, Persian, Arabic), curated
RTL adapters, per-site font profiles, and broader release tooling — all fully
intact in this Safari build.

## Features

Everything upstream Fontara supports is available in this port:

- 🔤 **Custom font replacement** across the web using built-in, Google,
  custom-uploaded, and system fonts.
- 🌍 **Multilingual extension UI** — English, Persian, and Arabic.
- ↔️ **Smart RTL support** — automatic right-to-left script detection,
  editable-field auto-direction, and curated per-site RTL adapters.
- 🎯 **Built-in site optimizations** for popular AI, search, social,
  productivity, and publishing sites (ChatGPT, Claude, Gemini, Gmail, YouTube,
  X, LinkedIn, GitHub, Slack, Wikipedia, and more), with targeted CSS that
  protects icon fonts, code blocks, and inline glyphs.
- 🧩 **Per-site font & text-stroke profiles**, with global mode and
  include/exclude rules.
- 💾 **Portable settings** — backup, import, export, reset, and sync support.
- 🍎 **Native Safari integration** — runs as a first-class Safari App
  Extension on macOS, launched and managed like any other Safari extension.

## Project Structure

```
fontaraSafari/
├── fontara/            # Upstream Fontara web extension source (MV3, TypeScript)
│                       # — build pipeline, UI, background/content scripts, site config
├── FontaraSafari/      # Native Swift/SwiftUI macOS container app
│   └── FontaraSafari/
│       ├── FontaraSafari/                # Container app target
│       └── FontaraSafari Extension/      # Safari Web Extension target (built output lands here)
├── xcode/              # Supplementary Swift scaffolding for the extension handler
└── LICENSE
```

## For Developers / Manual Installation

Fontara for Safari is **not distributed via the Mac App Store** and the build
is **unsigned**. To use it, you'll need to build it yourself locally with
Xcode. This is by design — it keeps the port free, open, and easy to audit.

### Prerequisites

- **macOS** with **Safari** and **Xcode** (latest stable release recommended)
- **Node.js 24+**
- **pnpm 11+**
- Safari's **"Allow Unsigned Extensions"** developer setting (see below)

### Build & Run

1. **Clone the repository**

   ```sh
   git clone https://github.com/ImanMontajabi/FontaraSafari.git
   cd FontaraSafari
   ```

2. **Install web extension dependencies**

   ```sh
   cd fontara
   pnpm install
   ```

3. **Build the Safari MV3 extension bundle**

   ```sh
   pnpm build:safari
   ```

   This compiles the extension source and outputs a Safari-ready MV3 package,
   which the Xcode project consumes as the extension's web resources.

4. **Open the project in Xcode**

   ```sh
   cd ..
   open FontaraSafari/FontaraSafari/FontaraSafari.xcodeproj
   ```

5. **Build and run** the `FontaraSafari` scheme (⌘R) in Xcode. This builds
   and launches the native container app, which registers the Safari Web
   Extension with macOS.

### Enabling the Extension in Safari

Since the app is unsigned and not notarized through the App Store:

1. In Safari, go to **Settings → Advanced** and enable **"Show features for
   web developers"**.
2. Go to **Settings → Developer** and enable **"Allow Unsigned Extensions"**
   (you'll need to re-enable this each time you restart Safari, unless you
   keep Safari open).
3. Open **Settings → Extensions**, find **Fontara**, and enable it.
4. Grant the extension permission for the websites you want to use it on.

## Updating to a New Upstream Release

The `fontara/` directory tracks the upstream project's source. To pull in a
newer upstream release:

1. Merge or re-apply the upstream changes into `fontara/`, keeping the
   Safari MV3 build target and any Safari-specific shims intact.
2. Re-run `pnpm build:safari` to regenerate the extension bundle.
3. Rebuild in Xcode and re-verify the extension in Safari.

## Known Limitations

- The extension is unsigned, so **"Allow Unsigned Extensions"** must stay
  enabled in Safari's developer settings for it to run.
- Not distributed through the Mac App Store — every user builds it locally
  from source.
- As with all Safari extensions, it cannot run on Safari's internal pages or
  other restricted pages.

## Acknowledgments

This project is a Safari port built on top of the excellent work of the
original **Fontara** project and its author:

- **Original repository:** [mimalef70/fontara](https://github.com/mimalef70/fontara)
- **Original author:** [mimalef70](https://github.com/mimalef70)

All core extension logic, UI, font handling, RTL support, and site
configuration originate from the upstream project. This port's contribution
is the native Safari/macOS wrapper and the Safari-specific build adaptations
required to run it as a Safari App Extension.

## License

This project is released under the **MIT License**, consistent with the
original Fontara project. See [`LICENSE`](LICENSE) for the full text and
copyright notices covering both the original web extension and this Safari
port.
