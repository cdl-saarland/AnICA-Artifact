# Artifact for "AnICA: Analyzing Inconsistencies in Microarchitectural Code Analyzers"

This artifact was created to be used as a Vagrant Virtual Machine.
Usage without the VM is possible, but might require you to apply some steps from `vm_setup/setup/bootstrap.sh` and `vm_setup/setup/post_install.sh`.

## Setting up the VM

The artifact is provided as a Vagrant Virtual Machine using the Virtual Box
provider. To run it, you will need to install Vagrant as described here:

    https://www.vagrantup.com/intro/getting-started/install.html

and also Virtual Box as available here:

    https://www.virtualbox.org/

Depending on your hardware platform, it might be necessary to enable
virtualization options in your system's BIOS to use virtual box.

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

