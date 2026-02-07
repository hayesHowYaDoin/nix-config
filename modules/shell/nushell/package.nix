{
  config,
  self,
  ...
}: {
  perSystem = {pkgs, ...}: let
    themeFile = pkgs.writeTextFile (
      import (self + "/lib/shell/oh-my-posh/build.nix") {
        inherit config;
        name = "nushell";
        theme = "pristine";
        colors = "cool";
        sigil = "✪";
      }
    );

    runtimeDeps = with pkgs; [
      fzf
      zoxide
      direnv
      oh-my-posh
      eza
      bat
      dust
      lazygit
      neovim
    ];

    configFile = pkgs.writeText "config.nu" ''
      $env.config = {
        show_banner: false
        completions: {
          case_sensitive: false
          quick: true
          partial: true
          algorithm: "fuzzy"
        }
        history: {
          max_size: 5000
          sync_on_enter: true
          file_format: "sqlite"
        }
        edit_mode: vi
        shell_integration: {
          osc2: true
          osc7: true
          osc8: true
          osc9_9: false
          osc133: true
          osc633: true
          reset_application_mode: true
        }
        hooks: {
          env_change: {
            PWD: [
              { ||
                if (which direnv | is-empty) {
                  return
                }
                direnv export json | from json | default {} | load-env
              }
            ]
          }
        }
      }

      source ($nu.data-dir | path join 'zoxide.nu')
      source ($nu.data-dir | path join 'oh-my-posh.nu')
    '';

    envFile = pkgs.writeText "env.nu" ''
      mkdir ($nu.data-dir)
      ${pkgs.zoxide}/bin/zoxide init --cmd cd nushell | save -f ($nu.data-dir | path join 'zoxide.nu')
      ${pkgs.oh-my-posh}/bin/oh-my-posh init nu --config ${themeFile} | save -f ($nu.data-dir | path join 'oh-my-posh.nu')

      $env.ENV_CONVERSIONS = {
        "PATH": {
          from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
          to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
        }
        "Path": {
          from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
          to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
        }
      }

      $env.NU_LIB_DIRS = [
        ($nu.default-config-dir | path join 'scripts')
      ]

      $env.NU_PLUGIN_DIRS = [
        ($nu.default-config-dir | path join 'plugins')
      ]
    '';

    configDir = pkgs.runCommand "nushell-config" {} ''
      mkdir -p $out
      ln -s ${configFile} $out/config.nu
      ln -s ${envFile} $out/env.nu
    '';
  in {
    packages.nushell = pkgs.symlinkJoin {
      name = "nushell-wrapped";
      meta.mainProgram = "nu";
      paths = [pkgs.nushell];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        rm $out/bin/nu
        makeWrapper ${pkgs.nushell}/bin/nu $out/bin/nu \
          --prefix PATH : ${pkgs.lib.makeBinPath runtimeDeps} \
          --add-flags "--config ${configDir}/config.nu" \
          --add-flags "--env-config ${configDir}/env.nu"
      '';
    };
  };
}
