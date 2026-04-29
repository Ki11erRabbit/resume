# shell.nix — build environment for Alec Davis's resume
#
# Usage:
#   nix-shell          # drop into a shell with pdflatex available
#   nix-shell --run 'make'        # build default resume
#   nix-shell --run 'make all'    # build full resume
#
# With flakes (nix develop), see flake.nix if you prefer that workflow.

{ pkgs ? import <nixpkgs> {} }:

let
  # Minimal TeX Live environment with exactly the packages the resume needs.
  # To add more LaTeX packages later, append to this list — find names at:
  #   https://search.nixos.org/packages?channel=unstable&query=texlive
  texliveEnv = pkgs.texlive.combine {
    inherit (pkgs.texlive)
      # ── Core ──────────────────────────────────────────────────────────────
      scheme-basic     # pdflatex, plain TeX, base classes
      latex            # LaTeX2e kernel (article.cls, fontenc, etc.)
      latex-bin        # pdflatex binary

      # ── Packages used in resume.tex ───────────────────────────────────────
      geometry         # page margins  (\usepackage{geometry})
      enumitem         # list customisation  (\usepackage{enumitem})
      titlesec         # section heading styles  (\usepackage{titlesec})
      hyperref         # clickable links  (\usepackage{hyperref})
      xstring          # string tests (\IfStrEq, \IfSubStr)
      parskip          # paragraph spacing  (\usepackage{parskip})
      etoolbox         # LaTeX toolbox (pulled in by hyperref; keep explicit)

      # ── Font encoding ─────────────────────────────────────────────────────
      cm-super         # Type-1 CM fonts needed for T1 encoding
      ;
  };

in pkgs.mkShell {
  name = "resume-build-env";

  buildInputs = [
    texliveEnv
    pkgs.gnumake
  ];

  shellHook = ''
    echo "Resume build environment ready."
    echo "  make          — default build"
    echo "  make all      — full resume (every entry)"
    echo "  make help     — show all options"
  '';
}
