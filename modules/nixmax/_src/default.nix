{
  app,
  lib,
  loginExpectScript,
  pkgs,
  preRunShellScript,
  prompt,
  qemuArgs,
  qemuBin,
  system,
  vmArch,
}:
let
  inherit (pkgs) buildPackages;
  isHost = vmArch == builtins.head (builtins.split "-" system);

  defaultArgs = {
    boot = "d";
    cpu = if isHost then "host" else "max";
    enable-kvm = isHost;
    m = 512;
    no-reboot = true;
    nographic = true;
    virtfs = "local,path=/nix/store,mount_tag=nixstore,security_model=none,readonly=on";
  };

  optionFormat = optionName: {
    explicitBool = false;
    option = "-${optionName}";
    sep = null;
  };

  finalQEMUArgs = lib.strings.concatStringsSep " " (
    lib.cli.toCommandLine optionFormat (defaultArgs // qemuArgs)
  );

  expectScript = buildPackages.writeText "nixmax-expect-script" ''
    set timeout -1

    set commands {
      "mkdir -p /nix/store /mnt/out"
      "mount -t 9p -o trans=virtio,version=9p2000.L,ro nixstore /nix/store"
      "${app}"
    }

    spawn ${qemuBin} ${finalQEMUArgs}

    ${loginExpectScript}

    foreach cmd $commands {
      expect "${prompt}"
      send "$cmd\r"

      expect "${prompt}"
      send "echo ___NIXMAX_CMD_STATUS___=\$?\r"

      expect {
        -re {___NIXMAX_CMD_STATUS___=([0-9]+)} {
          if {$expect_out(1,string) != "0"} {
            exit 1
          }
        }

        default {
          exit 1
        }
      }
    }

    send "poweroff -f\r"
  '';
in
buildPackages.runCommand "nixmax"
  {
    meta.license = lib.licenses.agpl3Plus;
    nativeBuildInputs = [ buildPackages.expect ];
  }
  ''
    ${preRunShellScript}
    expect "${expectScript}"
    touch "$out"
  ''
