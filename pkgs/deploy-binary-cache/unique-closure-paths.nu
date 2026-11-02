#! /usr/bin/env nix
#! nix shell nixpkgs#nushell --command nu

let cache_domain = "cache.nixos.org"

def cache_contains_nix_path [path: path] {
  let nix_path = $path | path basename | parse "{hash}-{name}" | get 0
  let nix_hash = $nix_path.hash

  let http_path = $"https://($cache_domain)/($nix_hash).narinfo"

  let response = http head --full --allow-errors $http_path

  let $status = $response.status

  if $status == 200 {
    true
  } else if $status == 404 {
    false
  } else {
    error make $"Unknown cache status code: ($status)"
  }
}

def --wrapped main [...paths: path] {
  http pool
  nix-store --query --requisites ...$paths | lines | par-each { |path|
    if not (cache_contains_nix_path $path) {
      $path
    }
  } | str join "\n"
}
