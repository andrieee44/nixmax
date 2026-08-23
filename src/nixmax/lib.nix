rec {
  nixmax =
    {
      app,
      hostCPU,
      loginExpectScript,
      pkgs,
      preRunShellScript,
      prompt,
      qemuArgs,
      qemuBin,
      system,
    }:
    pkgs.buildPackages.callPackage ./main.nix {
      inherit
        app
        hostCPU
        loginExpectScript
        preRunShellScript
        prompt
        qemuArgs
        qemuBin
        system
        ;
    };

  nixmax-alpine-x86_64 =
    {
      app,
      pkgs,
      system,
    }:
    nixmax {
      inherit app pkgs system;
      hostCPU = "x86_64";
      preRunShellScript = "";
      prompt = "localhost:~# ";
      qemuBin = "${pkgs.buildPackages.qemu}/bin/qemu-system-x86_64";

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

  nixmax-alpine-aarch64 =
    {
      app,
      pkgs,
      system,
    }:
    (nixmax-alpine-x86_64 {
      inherit app pkgs system;
    }).override
      {
        hostCPU = "aarch64";
        qemuBin = "${pkgs.buildPackages.qemu}/bin/qemu-system-aarch64";

        qemuArgs = {
          bios = "${pkgs.buildPackages.qemu}/share/qemu/edk2-aarch64-code.fd";
          machine = "virt";

          cdrom = pkgs.fetchurl {
            url = "https://dl-cdn.alpinelinux.org/alpine/v3.24/releases/aarch64/alpine-standard-3.24.1-aarch64.iso";
            hash = "sha256-leupBm15IP5wPdYri45/OMReugutIl2+LM+1t2z1NW0=";
          };
        };
      };

  nixmax-alpine-riscv64 =
    {
      app,
      pkgs,
      system,
    }:
    (nixmax-alpine-x86_64 {
      inherit app pkgs system;
    }).override
      {
        hostCPU = "riscv64";
        qemuBin = "${pkgs.buildPackages.qemu}/bin/qemu-system-riscv64";

        qemuArgs = {
          machine = "virt,acpi=off";
          drive = "file=${pkgs.buildPackages.qemu}/share/qemu/edk2-riscv-code.fd,if=pflash,format=raw,unit=0,readonly=on";

          cdrom = pkgs.fetchurl {
            url = "https://dl-cdn.alpinelinux.org/alpine/v3.24/releases/riscv64/alpine-standard-3.24.1-riscv64.iso";
            hash = "sha256-40AeHgiNuKlr7Cdc3WB5Dl5Rjzvq6hQOa9zZ8tXHwc4=";
          };
        };
      };
}
