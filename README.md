# nixmax

## Name

nixmax - NIX virtual MAchine cross (x)

## Library

Nix library with [flakes](https://nixos.wiki/wiki/Flakes) support.

## Synopsis

In your `flake.nix`:

```nix
inputs.nixmax.url = "github:andrieee44/nixmax";
```

### nixmax.lib.nixmax

```haskell
nixmax.lib.nixmax :: {
  app,
  loginExpectScript,
  pkgs,
  preRunShellScript,
  prompt,
  qemuArgs,
  qemuBin,
  system,
  vmArch,
} -> Derivation
```

### nixmax.lib.nixmax-alpine-x86_64

```haskell
nixmax.lib.nixmax-alpine-x86_64 :: {
  app,
  pkgs,
  system,
} -> Derivation
```

### nixmax.lib.nixmax-alpine-aarch64

```haskell
nixmax.lib.nixmax-alpine-aarch64 :: {
  app,
  pkgs,
  system,
} -> Derivation
```

### nixmax.lib.nixmax-alpine-riscv64

```haskell
nixmax.lib.nixmax-alpine-riscv64 :: {
  app,
  pkgs,
  system,
} -> Derivation
```

## Description

nixmax is a [Nix flake](https://nixos.wiki/wiki/Flakes) library for testing
cross compiled apps that need kernel features, while avoiding the expensive
cost of cross-compiling [QEMU](https://www.qemu.org/) and its dependencies
([`runNixOSTest`](https://noogle.dev/f/pkgs/testers/runNixOSTest/)), and
avoiding the state accumulation of [Lima](https://lima-vm.io/) VMs, which also
suffers from unreproducible results and heavy memory/CPU requirements on
startup (netboot ISO, SSH, etc.), taking quite a while to get running.

If your app does not need kernel features, is not cross compiled, try using
QEMU userspace and `binfmt`, or `runNixOSTest` with containers instead. If
your system can comfortably run a Lima VM, you can run a Lima VM for quick
iteration and use this library as the final check, since this is
reproducible.

Basically, this library offloads the compilation to an already compiled ISO.
For convenience, Alpine ISOs for three different architectures are already
configured for you. If you want a custom ISO, use the general purpose
function `nixmax`, or override the Alpine ISO with your preferred
architecture, which has already figured out the correct arguments to boot
that architecture.

The end result is that, similar to Lima, you download an ISO, but the host
does not perform any cross compilation related to setting up the virtual
machine, only the app itself is cross compiled, which saves a lot of time.
[QEMU](https://www.qemu.org/) itself is not cross compiled and, for this
reason, has a very high chance of already being in the cache. This library
therefore optimizes for cache hits, and you can get away with a small memory
footprint because it is just a standard ISO which boots fast and needs
little to run.

## Parameters

### app

app is the path to run.

```nix
"${pkgs.hello}/bin/hello"
```

```nix
lib.getExe pkgs.hello
```

### loginExpectScript

loginExpectScript is the [Expect](https://core.tcl-lang.org/expect/index)
snippet to run for logging in.

```nix
# loginExpectScript used in Alpine ISOs
''
  expect "localhost login: "
  send "root\r"
''
```

### pkgs

pkgs is your [Nixpkgs](https://github.com/NixOS/nixpkgs) instance.

```nix
nixpkgs.legacyPackages.x86_64-linux
```

### preRunShellScript

preRunShellScript is an escape hatch shell script snippet that runs before
starting [Expect](https://core.tcl-lang.org/expect/index) and
[QEMU](https://www.qemu.org/). Use it when `qemuArgs` is not enough.

### prompt

prompt is the expected string after logging in to the ISO, used by
[Expect](https://core.tcl-lang.org/expect/index).

```nix
# prompt used in Alpine ISOs
"localhost:~# "
```

### qemuArgs

qemuArgs is used to pass arguments to the
[QEMU](https://www.qemu.org/docs/master/system/invocation.html) binary.

```nix
{
  machine = "q35"; # For x86_64

  cdrom = pkgs.fetchurl {
    url = "your-x86_64-iso-url";
    hash = "";
  };
}
```

### qemuBin

qemuBin is your [QEMU](https://www.qemu.org/) binary to be executed.

```nix
"${pkgs.qemu}/bin/qemu-system-x86_64"
```

### system

system is your current
[Nix system](https://nix.dev/manual/nix/stable/language/builtins.html#builtins-currentSystem)
identifier.

```nix
builtins.currentSystem
```

### vmArch

vmArch is the ISO's architecture.

```nix
"x86_64"
```

## Return Value

These functions return a
[derivation](https://nix.dev/manual/nix/stable/language/derivations.html)
which runs the test when realized. The derivation fails when the app fails
to return a success status code.

## Examples

See [`flake.nix`](flake.nix).

## Reporting Bugs

Open a GitHub issue at
[github.com/andrieee44/nixmax](https://github.com/andrieee44/nixmax/issues).

## Copyright

See [`LICENSE`](LICENSE). Uses
[AGPLv3 or later](https://www.gnu.org/licenses/agpl-3.0.html).

## See Also

- [Nix](https://nixos.org/)
- [Nixpkgs](https://github.com/NixOS/nixpkgs)
- [Nix flakes](https://nixos.wiki/wiki/Flakes)
- [QEMU](https://www.qemu.org/)
- [Expect](https://core.tcl-lang.org/expect/index)
- [Lima](https://lima-vm.io/)
- [GitHub repository](https://github.com/andrieee44/nixmax)
