# Affinity wine nix configuration

#### This module does a few things to greatly simplify the process of installing Affinity applications on linux
- Build and install [ElementalWarrior's Wine fork](https://gitlab.winehq.org/ElementalWarrior)
- Create and set up a wine prefix if it doesn't already exist
- Provide binaries to easily launch Affinity applications: `affinity-designer`, `affinity-photo` and `affinity-publisher`
- Provide the `affinity-run` binary to run Affinity installers that install into your prefix

### Credits
- [Affinity crimes](https://github.com/lf-/affinity-crimes)
- [Wanesty](https://codeberg.org/Wanesty/affinity-wine-docs)

### Options
> example config e.g. `home.nix`
```nix
{ ... }:
{ 
  affinity = {
    # If there is no prefix found at this path it will be created and set up for you.
    prefix = "/home/${user}/affinity/prefix";

    # Add script to path which launches the application and create desktop entries for this script.
    # You will have to install each application into your prefix manaully for them to work.
    photo.enable = true;
    designer.enable = true;
    publisher.enable = true;
  };
}
```

### Installing the Affinity suite
> Make sure the prefix is created before following these steps
1. Download the desired application installers: (Choose MSI/EXE(x64))
    - [Photo 2](https://store.serif.com/en-us/update/windows/photo/2/)
    - [Designer 2](https://store.serif.com/en-us/update/windows/designer/2/)
    - [Publisher 2](https://store.serif.com/en-us/update/windows/publisher/2/)
2. Open a terminal and run `affinity-run <path-to-installer>`
3. Follow the steps in the installer and you're done!

### Updating
Follow the same steps as when [installing](#installing-the-affinity-suite). 
