# Affinity wine nix configuration
> This module only sets up wine and creates binaries for applications in the affinity suite, The wine prefix containing all applications should be provided by the user

### Credits
- [Affinity crimes](https://github.com/lf-/affinity-crimes)
- [Wanesty](https://codeberg.org/Wanesty/affinity-wine-docs)

### Options
- `prefix`: (str) Path to Affinity wine prefix
- `setup_prefix`: (bool) Create a new wine prefix (if it doesn't exist already) and configures it for affinity
