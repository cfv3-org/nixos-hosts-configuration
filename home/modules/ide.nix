{ pkgs, ... }:

{
  home.packages = [
    pkgs.jetbrains.jdk
    pkgs.jetbrains.idea-ultimate
    pkgs.jetbrains.datagrip
    pkgs.jetbrains.phpstorm
    pkgs.jetbrains.goland
    pkgs.jetbrains.webstorm
    pkgs.direnv
    pkgs.insomnia
    pkgs.nix-direnv
    pkgs.nixfmt-rfc-style
  ];

  xdg.configFile."JetBrainsPlugins/ide-eval-resetter-1.0.0.zip".source = ./jetbrains/trial-reset.zip;

  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscode;

      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          bmewburn.vscode-intelephense-client
          xdebug.php-debug
          yzhang.markdown-all-in-one
          davidanson.vscode-markdownlint
          jnoortheen.nix-ide
          rooveterinaryinc.roo-cline
          streetsidesoftware.code-spell-checker
        ];

        userSettings = {
          "workbench.experimental.disableBuiltinExtensions" = [
            "vscode.php-language-features"
            "vscode.php"
          ];

          "editor.bracketPairColorization.enabled" = true;
          "editor.fontLigatures" =
            "'calt', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'ss09', 'ss10', 'dlig', 'liga'";
          "editor.formatOnPaste" = true;
          "editor.formatOnSave" = true;
          "editor.formatOnType" = false;
          "editor.guides.bracketPairs" = true;
          "editor.guides.indentation" = true;
          "editor.inlineSuggest.enabled" = true;
          "editor.minimap.enabled" = false;
          "editor.minimap.renderCharacters" = false;
          "editor.overviewRulerBorder" = false;
          "editor.renderLineHighlight" = "all";
          "editor.smoothScrolling" = true;
          "editor.suggestSelection" = "first";

          "breadcrumbs.enabled" = true;
          "explorer.confirmDelete" = false;
          "files.trimTrailingWhitespace" = true;
          "javascript.updateImportsOnFileMove.enabled" = "always";
          "security.workspace.trust.enabled" = false;
          "todo-tree.filtering.includeHiddenFiles" = true;
          "typescript.updateImportsOnFileMove.enabled" = "always";
          "vsicons.dontShowNewVersionMessage" = true;
          "window.nativeTabs" = true;
          "window.restoreWindows" = "all";
          "roo-cline.allowedCommands" = [ "*" ];
        };
      };
    };
  };
}
