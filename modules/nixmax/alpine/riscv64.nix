{
  perSystem =
    {
      lib,
      pkgs,
      self',
      ...
    }:
    {
      checks.nixmax-alpine-riscv64 = self'.legacyPackages.nixmax-alpine-riscv64 (
        lib.getExe pkgs.pkgsCross.riscv64.hello
      );

      legacyPackages.nixmax-alpine-riscv64 =
        app:
        (self'.legacyPackages.nixmax-alpine-x86_64 app).override {
          qemuBin = "${pkgs.buildPackages.qemu}/bin/qemu-system-riscv64";
          vmArch = "riscv64";

          qemuArgs = {
            machine = "virt,acpi=off";
            drive = "file=${pkgs.buildPackages.qemu}/share/qemu/edk2-riscv-code.fd,if=pflash,format=raw,unit=0,readonly=on";

            cdrom = pkgs.fetchurl {
              url = "https://dl-cdn.alpinelinux.org/alpine/v3.24/releases/riscv64/alpine-standard-3.24.1-riscv64.iso";
              hash = "sha256-40AeHgiNuKlr7Cdc3WB5Dl5Rjzvq6hQOa9zZ8tXHwc4=";
            };
          };
        };
    };
}
