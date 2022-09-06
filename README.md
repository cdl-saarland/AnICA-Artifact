# Artifact for "AnICA: Analyzing Inconsistencies in Microarchitectural Code Analyzers"

This repository provides the scripts used to generate the Vagrant Virtual Machine of the AnICA research artifact.
Usage without the VM is possible, but might require you to apply some steps from `vm_setup/setup/bootstrap.sh` and `vm_setup/setup/post_install.sh`.

You can find a pre-built version of this artifact [on Zenodo](https://doi.org/10.5281/zenodo.6818170).

## Context: The AnICA Project

**This repo is a part of the AnICA project.** Here are more related resources, for some context:
- [The project page](https://compilers.cs.uni-saarland.de/projects/anica/) provides general information on the project.
- [AnICA](https://github.com/cdl-saarland/AnICA), the repo for the implementation of the core AnICA algorithm. Start there if you want to work with AnICA without the artifact VM and don't want to use the browser-based user interface.
- [AnICA-UI](https://github.com/cdl-saarland/AnICA-UI), the repo for the accompanying browser-based user interface for inspecting discovered inconsistencies. Start there if you want to work with AnICA without the artifact VM and you want to use the UI.
- [iwho](https://github.com/cdl-saarland/iwho), a subcomponent of AnICA that provides a convenient abstraction around instructions, which in this project greatly eases the task of randomly sampling valid basic blocks. Start there if you only want to use the instruction schemes abstraction, independent of AnICA.
- [AnICA-Artifact](https://github.com/cdl-saarland/AnICA-Artifact) (this repository), which provides the scripts used to generate the AnICA research artifact.
- [The pre-built artifact](https://doi.org/10.5281/zenodo.6818170) on Zenodo, including a Vagrant VM and a guide to reproduce our results.


## Setting up the VM

The artifact is provided as a Vagrant Virtual Machine using the Virtual Box
provider. To run it, you will need to install Vagrant as described here:

    https://www.vagrantup.com/intro/getting-started/install.html

and also Virtual Box as available here:

    https://www.virtualbox.org/

Depending on your hardware platform, it might be necessary to enable
virtualization options in your system's BIOS to use virtual box.

First, fetch all the code and data:
```
./make_vm.sh
```

Use the following command to build the VM:
```
cd vm_setup
vagrant up
```

Once this is done, ssh to the VM and run the post-install scripts:
```
vagrant ssh
./setup/post_install.sh
./setup/reduce_size.sh
```

Next, leave the VM and package it up:
```
exit
vagrant package --output ../anica-artifact.box
```

Take the resulting box and put it into an archive together with the shipping
vagrant file:
```
cd ..
tar -czvf anica-artifact.tgz Vagrantfile anica-artifact.box
```

Done!

