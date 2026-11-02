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

    unique_closure_dir=$(mktemp -d)
    trap 'rm -r -- "$unique_closure_dir"' EXIT

    ${./unique-closure-paths.nu} "$NIX_CLOSURE_PATH" | xargs ln -s -t "$unique_closure_dir"
    nix-store --add "$unique_closure_dir" | nix copy --to "$NIX_REMOTE_HOST" --stdin
  '';
}
