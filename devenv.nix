{ config, pkgs, ... }:
{
  languages.nix.enable = true;

  git-hooks.hooks = {
    # Markdown
    markdownlint = {
      enable = true;
      settings.configuration.MD013.code_blocks = false;
    };

    # Miscellaneous
    check-added-large-files.enable = true;
    check-merge-conflicts.enable = true;
    detect-private-keys.enable = true;
    end-of-file-fixer.enable = true;
    lychee.enable = true;
    treefmt.enable = true;
    trim-trailing-whitespace.enable = true;

    # Nix
    flake-checker.enable = true;
    nil.enable = true;

    flake-checks = {
      enable = true;
      entry = ''nix flake check --all-systems "${config.git.root}"'';
      pass_filenames = false;
    };

    # YAML
    check-yaml.enable = true;
  };

  packages = with pkgs; [
    git
    nixfmt
  ];

  treefmt = {
    enable = true;

    config.programs = {
      # Bash
      shellcheck.enable = true;
      shfmt.enable = true;

      # Markdown
      mdformat.enable = true;

      # Nix
      deadnix.enable = true;
      nixfmt.enable = true;
      statix.enable = true;

      # YAML
      yamllint.enable = true;
    };
  };
}
