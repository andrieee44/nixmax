{
  perSystem =
    {
      lib,
      pkgs,
      self',
      ...
    }:
    {
      checks.nixmax-alpine-x86_64 = self'.legacyPackages.nixmax-alpine-x86_64 (
        lib.getExe pkgs.pkgsCross.gnu64.hello
      );

      legacyPackages.nixmax-alpine-x86_64 =
        app:
        self'.legacyPackages.nixmax {
          inherit app;
          preRunShellScript = "";
          prompt = "localhost:~# ";
          qemuBin = "${pkgs.buildPackages.qemu}/bin/qemu-system-x86_64";
          vmArch = "x86_64";

          loginExpectScript = ''
            expect "localhost login: "
            send "root\r"
          '';

          qemuArgs = {
            machine = "q35";

            cdrom = pkgs.fetchurl {
              url = "https://dl-cdn.alpinelinux.org/alpine/v3.24/releases/x86_64/alpine-standard-3.24.1-x86_64.iso";
              hash = "sha256-9N1hMgZnbGKUkUTIrXX8ZFggmfRE3RSFuuEEpg9R3SY=";
            };
          };
        };
    };
}
