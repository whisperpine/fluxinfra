# list all available subcommands
_default:
  @just --list

# validate flux resources and kustomizations
validate:
  bash ./scripts/validate.sh
