# ══════════════════════════════════════════════════════════════════════════════
#  Resume Makefile — Alec Davis
# ══════════════════════════════════════════════════════════════════════════════
#
#  USAGE
#  ─────
#  make                        # default build (curated subset)
#  make all                    # include every job, project, and skill
#  make OUTPUT=my_resume       # change the output filename (no extension)
#
#  Fine-grained control (space-separated keys, quoted):
#    make JOBS="llnl byu_research" PROJECTS="rowan koru" SKILLS="languages frameworks"
#
#  AVAILABLE KEYS
#  ──────────────
#  JOBS:
#    capstone      Software Engineering Capstone (Backend Tech Lead)
#    llnl          Lawrence Livermore National Laboratory (HPC Scholar)
#    byu_research  BYU Static Analysis Lab (Research Assistant)
#    byu_ta        BYU CS110 Teacher's Assistant
#    dominos       Domino's Pizza Delivery Expert
#
#  PROJECTS (Programming):
#    koru           Koru Edit (Emacs-inspired editor)
#    rowan          Rowan (OO programming language + JIT)
#    strong_brew    Strong Brew (dependently typed systems language)
#    cocoa          Cocoa (systems language with Cranelift JIT)
#    koka_community Koka Community (std-lib extensions + BLAS bindings)
#    speak_vm       Speak VM (Smalltalk-inspired VM)
#    caat           Commands as Arrow Types (experimental shell)
#    sevi           SEVI Text Editor (11k LOC, LSP client)
#    cwc            C with Classes (hand-written compiler)
#
#  PROJECTS (Other):
#    wireguard     Wireguard Server Tunnel
#    linux_ws      Linux Workstation (NixOS)
#    virt_ws       Virtualized Workstation (QEMU + GPU passthrough)
#
#  SKILLS:
#    languages     Programming Languages (Rust, Python, Koka, C/C++, ...)
#    skills        General Skills (Linux, Git, ...)
#    frameworks    Frameworks & Toolkits (Actix, Leptos, Ansible, Kafka, ...)
#
#  ADDING NEW ENTRIES
#  ──────────────────
#  1. Create  jobs/<key>.tex, projects/<key>.tex, or skills/<key>.tex
#     using the macros: \JobEntry, \ProjectEntry, \OtherProjectEntry
#  2. Add an \IncludeIfListed line in resume.tex under the right section
#  3. Document the key in this comment block
#
# ══════════════════════════════════════════════════════════════════════════════

LATEX     := pdflatex
LATEXOPTS := -interaction=nonstopmode -halt-on-error

OUTPUT    ?= resume

# Default curated subset
DEFAULT_JOBS     := capstone llnl byu_research byu_ta
DEFAULT_PROJECTS := koru rowan strong_brew koka_community caat
DEFAULT_SKILLS   := languages skills frameworks

JOBS     ?= $(DEFAULT_JOBS)
PROJECTS ?= $(DEFAULT_PROJECTS)
SKILLS   ?= $(DEFAULT_SKILLS)

TEXSRC := resume.tex \
          $(wildcard jobs/*.tex) \
          $(wildcard projects/*.tex) \
          $(wildcard skills/*.tex)

# Convert space-separated list to comma-separated (recipe-time, so overrides work)
space := $(empty) $(empty)
comma := ,

define run_latex
	$(eval _j := $(subst $(space),$(comma),$(strip $(JOBS))))
	$(eval _p := $(subst $(space),$(comma),$(strip $(PROJECTS))))
	$(eval _s := $(subst $(space),$(comma),$(strip $(SKILLS))))
	@echo "Building $(OUTPUT).pdf"
	@echo "  Jobs:     $(JOBS)"
	@echo "  Projects: $(PROJECTS)"
	@echo "  Skills:   $(SKILLS)"
	$(LATEX) $(LATEXOPTS) -jobname=$(OUTPUT) \
	  '\def\IncludeJobs{$(_j)}\def\IncludeProjects{$(_p)}\def\IncludeSkills{$(_s)}\input{resume}'
	$(LATEX) $(LATEXOPTS) -jobname=$(OUTPUT) \
	  '\def\IncludeJobs{$(_j)}\def\IncludeProjects{$(_p)}\def\IncludeSkills{$(_s)}\input{resume}'
	@echo "Done → $(OUTPUT).pdf"
endef

# ══════════════════════════════════════════════════════════════════════════════
.PHONY: all clean distclean help

$(OUTPUT).pdf: $(TEXSRC)
	$(call run_latex)

all: JOBS     = all
all: PROJECTS = all
all: SKILLS   = all
all: $(TEXSRC)
	$(call run_latex)

clean:
	rm -f *.aux *.log *.out *.toc

distclean: clean
	rm -f *.pdf

help:
	@echo ""
	@echo "  make                        Build default resume (curated subset)"
	@echo "  make all                    Build with every entry included"
	@echo "  make OUTPUT=foo             Write to foo.pdf instead of resume.pdf"
	@echo ""
	@echo "  make JOBS=\"llnl byu_research\" PROJECTS=\"rowan koru\" SKILLS=\"languages\""
	@echo "                              Build with specific entries only"
	@echo ""
	@echo "  make clean                  Remove aux/log files"
	@echo "  make distclean              Remove aux/log files AND pdfs"
	@echo "  make help                   Show this help"
	@echo ""
	@echo "  See the top of the Makefile for all available JOBS/PROJECTS/SKILLS keys."
	@echo ""
