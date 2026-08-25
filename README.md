# TrollPadOS 4.0.0 — iPadOS 18-inspired compatibility layer

TrollPadOS is a Theos/Logos tweak source tree for a jailbroken iPhone. This release expands the previous source with additional iPad-style compatibility hooks and a larger feature-control panel.

## Implemented in this release

- iPad device/trait compatibility in SpringBoard.
- Optional global UIKit iPad trait spoofing (`TPOSGlobalPadTraits`). This is opt-in because it can change third-party app layouts.
- Medusa/iPad-style windowing compatibility.
- Stage Manager / Chamois compatibility and configurable maximum apps on stage.
- The requested combined Display Management section with three independent switches:
  - Full-screen apps
  - Windowed apps
  - Display management
- iPad-style app switcher animation flag.
- Landscape Home Screen compatibility.
- Dock / recent apps / App Library compatibility.
- Floating Dock compatibility.
- Keyboard shortcut-bar and iPad keyboard idiom compatibility.
- External display / AirPlay capability hooks.
- External-display Stage Manager and full-screen compatibility hooks.
- Optional AVKit Picture-in-Picture capability advertisement when the class exists.
- Rootless and rootful package workflows.
- arm64 + arm64e package architectures.

## Deliberately not faked

iPadOS 18 also includes features implemented inside individual system apps and deeper OS services, including Calculator/Math Notes, Smart Script, the Photos redesign, Messages effects and scheduling, Passwords, SharePlay remote control, Safari Highlights, Apple Intelligence, and other app/service-specific changes. Those cannot be made into 1:1 working copies by adding a few SpringBoard hooks. This project therefore does not claim those unavailable pieces are implemented.

## Stability policy

- Feature switches are independent where possible.
- Full-screen-only mode suppresses resize corners so it does not fight windowed mode.
- Global iPad trait spoofing is disabled by default.
- Optional hooks are initialized only when the relevant runtime class exists.

## Build

### Rootless

```sh
export THEOS=/path/to/theos
./build.sh rootless
```

### Rootful

```sh
export THEOS=/path/to/theos
./build.sh rootful
```

The package is written to `packages/`.

## GitHub Actions

The workflow is located at `.github/workflows/build.yml` and uploads both rootless and rootful `.deb` artifacts.

## Testing

A source archive cannot guarantee a working tweak for every iOS build. Build against the SDK matching the target environment and test each feature individually. The private class/method names used by jailbreak tweaks can change between iOS releases.
