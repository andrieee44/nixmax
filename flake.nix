{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs@{ flake-parts, systems, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (top: {
      systems = builtins.filter (system: system != "x86_64-darwin") (import systems);
      flake.lib = import ./src/nixmax/lib.nix;

      perSystem =
        {
          lib,
          pkgs,
          system,
          ...
        }:
        {
          checks = {
            nixmax-alpine-x86_64 = top.config.flake.lib.nixmax-alpine-x86_64 {
              inherit pkgs system;
              app = lib.getExe pkgs.pkgsCross.gnu64.hello;
            };

            nixmax-alpine-aarch64 = top.config.flake.lib.nixmax-alpine-aarch64 {
              inherit pkgs system;
              app = lib.getExe pkgs.pkgsCross.aarch64-multiplatform.hello;
            };

            nixmax-alpine-riscv64 = top.config.flake.lib.nixmax-alpine-riscv64 {
              inherit pkgs system;
              app = lib.getExe pkgs.pkgsCross.riscv64.hello;
            };
          };
        };
    });
}
