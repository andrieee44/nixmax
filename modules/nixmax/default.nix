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
      pkgs.buildPackages.callPackage ./_src {
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
