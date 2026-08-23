# nixmax

**Nix + virtual MAchine + cross (x)** - run cross-compiled binaries inside a
lightweight QEMU VM, driven entirely by Nix.

## What it does

`nixmax` boots a minimal Alpine Linux VM in QEMU, mounts your Nix store into
it read-only over 9p, runs a single app inside the VM, and captures its exit
status. It's a way to test or execute cross-compiled binaries under a real
kernel without needing a full NixOS VM test or a heavier VM solution.

Pre-built Alpine ISOs are provided out of the box for `x86_64`, `aarch64`, and
`riscv64`, so most users don't need to build or configure anything beyond
pointing at their app.

## Why

- **`nixos-lib.runTest` / `runNixOSTest`** recompiles large parts of the
system when cross-compiling, which is slow and wasteful just to run one binary
under a kernel.
- **Lima** VMs are fast to iterate with, but accumulate state over time,
aren't reproducible, and have a heavier minimum footprint (startup time,
memory) than is needed for a one-shot run. It also needs netboot/SSH to get an
ISO in, which is slow.
- **Containers** don't give you a real kernel, so anything relying on
kernel-level features (not just userspace + binfmt) won't work.

`nixmax` avoids all of this by downloading a premade Alpine ISO once and only
compiling the app you actually want to run while still giving you a real
kernel via QEMU.

## How it works

1. QEMU boots the Alpine ISO (with KVM acceleration when the host and guest
CPU architectures match).
2. Your Nix store is shared into the VM read-only via a 9p virtio mount.
3. An `expect` script logs in and drives the VM: mounting the store, running
your app, and checking its exit code via a shell echo/status marker.
4. The VM powers off, and the whole thing succeeds or fails as a normal Nix
derivation.

## Usage

The library is exposed as `nixmax`, plus ready-made variants for each
supported architecture:

- `nixmax-alpine-x86_64`
- `nixmax-alpine-aarch64`
- `nixmax-alpine-riscv64`

Each of these takes `app`, `pkgs`, and `system`, and builds on sensible
defaults (login prompt, QEMU binary, boot args, etc.) for that architecture.

### Custom configurations

For more control, call `nixmax` directly and supply your own `hostCPU`,
`qemuBin`, `qemuArgs`, `loginExpectScript`, `prompt`, and `preRunShellScript`.
This lets you use a different base image, architecture, or login flow than the
built-in Alpine variants.

## License

AGPL-3.0. See [LICENSE](./LICENSE).
