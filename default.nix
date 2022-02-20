{ pkgs ? import <nixpkgs> {} }:

let
  sources = import ./nix/sources.nix {};

  haskellNix = import sources.haskellNix {};

  pkgs = import haskellNix.sources.nixpkgs-unstable haskellNix.nixpkgsArgs;

  tasklite-src = pkgs.fetchFromGitHub {
    owner = "ad-si";
    repo = "tasklite";
    rev = "master";
    sha256 = "kxX5U2lMqRJX9TvYOIdngGEd5zCNqvNGF2IRSLWUAqU=";
  };
  project = pkgs.haskell-nix.project {
    src =  tasklite-src;

    modules = [{
      packages.tasklite-core.patches = [ ./nix/dont-get-version-from-git.patch ];
    }];
  };
in
  project.tasklite-core.components.exes.tasklite

