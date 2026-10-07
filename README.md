# Homebrew tap

Homebrew packages maintained by [devwooops](https://github.com/devwooops).

## Install pktide

```sh
brew install devwooops/tap/pktide
pktide --version
pktide -r capture.pcap 'tcp port 443'
```

Homebrew adds this tap automatically when installing the fully qualified formula.

[pktide](https://github.com/devwooops/pktide) is a lightweight packet monitor for legacy and modern Linux and macOS. This formula installs the published release executable as `pktide`, verifies its SHA-256, and requires no compilation, Python, or third-party runtime libraries.

| Platform | Installed release asset |
|---|---|
| macOS Apple Silicon / Intel | `pktide-macos` (Universal) |
| Linux x86_64 | `pktide-x86_64` (static) |

Linux ARM and 32-bit Homebrew are not supported by this formula. For a standalone i386 executable, use the [upstream releases](https://github.com/devwooops/pktide/releases). Homebrew's own supported OS range may be narrower than pktide's standalone compatibility range; install the standalone executable directly on legacy systems without Homebrew.

Live capture requires root or OS-specific capture permissions. Offline PCAP reading does not. Actual macOS live BPF capture remains unverified upstream; see the [validation record](https://github.com/devwooops/pktide/blob/main/docs/VALIDATION.md).

## Update or uninstall

```sh
brew update
brew upgrade devwooops/tap/pktide

# Remove pktide
brew uninstall pktide
```

## Validate the formula

```sh
brew test devwooops/tap/pktide
brew audit --strict devwooops/tap/pktide
brew style devwooops/tap/pktide
```

The formula test generates synthetic PCAP data with Ruby, checks TCP/UDP filters, and verifies PCAP save/replay without root, Python, or live traffic. GitHub Actions runs installation and tests on macOS and Linux.

## Updating a release

Update the release URLs and both platform SHA-256 values in `Formula/pktide.rb` after publishing an upstream release. Run the checks above and push the change. Do not replace existing upstream release assets in place.

This is an independently maintained tap, not the official `homebrew/core` repository.

## License

[MIT License](LICENSE).
