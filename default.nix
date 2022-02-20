{ pkgs ? import <nixpkgs> {} }:

let
  sources = import ./nix/sources.nix {};

  haskellNix = import sources.haskellNix {};

  pkgs = import haskellNix.sources.nixpkgs-unstable haskellNix.nixpkgsArgs;

  tasklite-src = pkgs.fetchFromGitHub {
    owner = "ad-si";
    repo = "tasklite";
    # Master as of 2022-02-20
    rev = "08fd7b07637b081f4eb019910663cf674d1171c6";
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

