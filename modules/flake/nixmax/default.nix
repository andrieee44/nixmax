{
  perSystem = { pkgs, system, ... }: {
    legacyPackages.nixmax =
      {
        app,
        loginExpectScript,
        preRunShellScript,
        prompt,
        qemuArgs,
        qemuBin,
        vmArch,
      }:
      pkgs.buildPackages.callPackage ../../../pkgs/nixmax {
        inherit
          app
          loginExpectScript
          preRunShellScript
          prompt
          qemuArgs
          qemuBin
          system
          vmArch
          ;
      };
  };
}
