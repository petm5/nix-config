{
  writeShellApplication,
  nushell,
  nix,
}:

{ closure }:

writeShellApplication {
  name = "deploy-binary-cache";
  runtimeInputs = [
    nushell
    nix
  ];
  runtimeEnv = {
    NIX_CLOSURE_PATH = closure;
  };
  bashOptions = [ "errexit" "pipefail" ];
  text = ''
    if [ -z "$NIX_REMOTE_HOST" ]; then
      echo "Required variable NIX_REMOTE_HOST is not set" >&2
      exit 1
    fi

    ${./unique-closure-paths.nu} "$NIX_CLOSURE_PATH" | nix copy --to "$NIX_REMOTE_HOST" --stdin
  '';
}
