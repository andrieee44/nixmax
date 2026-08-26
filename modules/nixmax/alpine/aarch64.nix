{
  perSystem =
    {
      lib,
      pkgs,
      self',
      ...
    }:
    {
      checks.nixmax-alpine-aarch64 = self'.legacyPackages.nixmax-alpine-aarch64 (
        lib.getExe pkgs.pkgsCross.aarch64-multiplatform.hello
      );

      legacyPackages.nixmax-alpine-aarch64 =
        app:
        (self'.legacyPackages.nixmax-alpine-x86_64 app).override {
          qemuBin = "${pkgs.buildPackages.qemu}/bin/qemu-system-aarch64";
          vmArch = "aarch64";

          qemuArgs = {
            bios = "${pkgs.buildPackages.qemu}/share/qemu/edk2-aarch64-code.fd";
            machine = "virt";

            cdrom = pkgs.fetchurl {
              url = "https://dl-cdn.alpinelinux.org/alpine/v3.24/releases/aarch64/alpine-standard-3.24.1-aarch64.iso";
              hash = "sha256-leupBm15IP5wPdYri45/OMReugutIl2+LM+1t2z1NW0=";
            };
          };
        };
    };
}
