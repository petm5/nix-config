{ pkgs, home-manager, nixpkgs }:
let
  userName = "nix";
  uid = "1000";
  gid = "1000";

  homeConfig = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [
      ../../homes/petms/base.nix
      {
        home.username = "nix";
        home.homeDirectory = "/home/nix";
        home.stateVersion = "23.11";
      }
    ];
  };

  home = homeConfig.activationPackage;

  closureInfo = pkgs.closureInfo {
    rootPaths = [ home ];
  };

  activationScript = pkgs.writeShellScript "activate-nix-env.sh" ''
    ${pkgs.nix}/bin/nix-store --init
    ${pkgs.nix}/bin/nix-store --load-db < ${closureInfo}/registration
    [ -e "$HOME/.nix-profile" ] || "${home}/activate"
    . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    export COLORTERM=truecolor
    exec nu
  '';

  shadow = with pkgs;
  [
    (writeTextDir "etc/shadow" ''
      root:!x:::::::
      ${userName}:!:::::::
    '')
    (writeTextDir "etc/passwd" ''
      root:x:0:0::/root:${pkgs.runtimeShell}
      ${userName}:x:${toString uid}:${toString gid}::/home/${userName}:
    '')
    (writeTextDir "etc/group" ''
      root:x:0:
      ${userName}:x:${toString gid}:
    '')
    (writeTextDir "etc/gshadow" ''
      root:x::
      ${userName}:x::
    '')
  ];

  flakeRegistry = pkgs.writeTextDir "etc/nix/registry.json" (builtins.toJSON {
    version = 2;
    flakes = [ {
      from = {
        type = "indirect";
        id = "nixpkgs";
      };
      to = {
        type = "path";
        path = nixpkgs.outPath;
        inherit (nixpkgs) rev narHash lastModified;
      };
    } ];
  });
in pkgs.dockerTools.streamLayeredImage {
  name = "devshell";
  contents = [ shadow flakeRegistry pkgs.nix pkgs.coreutils pkgs.vim pkgs.git ];
  inherit uid gid;
  uname = userName;
  gname = userName;
  config = {
    User = userName;
    Cmd = [ "${activationScript}" ];
    Volumes = { "/workspaces/" = {}; };
    WorkingDir = "/workspaces";
    Env = [
      "USER=${userName}"
      "HOME=/home/${userName}"
      "PATH=/home/${userName}/.nix-profile/bin:/bin"
      "NIX_SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      "NIX_PAGER=cat"
    ];
  };
  fakeRootCommands = ''
    mkdir -p etc
    mkdir -p nix/store
    mkdir -p nix/var/nix/db
    mkdir -p tmp
    mkdir -p home/${userName}
    chown -R ${uid}:${gid} tmp nix home/${userName}
  '';
}
