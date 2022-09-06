# Artifact for "AnICA: Analyzing Inconsistencies in Microarchitectural Code Analyzers"

by Fabian Ritter and Sebastian Hack, Saarland University

## How this Artifact Works

This artifact is a Vagrant VM with AnICA and all dependencies installed.
You can interact with the artifact in two ways:

- You can ssh into the VM, to run AnICA campaigns and explore the code.
- You can access a graphical user interface in a web browser of the host system
  via a local website provided by the VM. This UI serves to inspect the
  results of AnICA. It is pre-populated with our evaluation results; new
  results can be added via commands in the VM's shell. Whenever something in
  the UI is unclear, please click the "Open Docs" button in the top right
  corner to open a description of all components of the current site.

The following sections will discuss the usage in more detail.


## Getting Started Guide ("Kick the Tires")

### Requirements

You will need an x86-64 processor to evaluate this artifact.
ARM Processors, like in recent Mac(Book)s, are not supported by the VM.

The artifact was only tested on 64-bit Linux systems.

### Setup

The artifact is provided as a Vagrant Virtual Machine using the Virtual Box
provider. To run it, you will need to install Vagrant as described here:

> https://www.vagrantup.com/intro/getting-started/install.html

and also Virtual Box as available here:

> https://www.virtualbox.org/

Depending on your hardware platform, it might be necessary to enable
virtualization options in your system's BIOS to use virtual box.

In the provided archive, you will find the `anica-artifact.box` vagrant box and
a `Vagrantfile` for configuring your instance of the virtual machine. It comes
with defaults for the number of CPU cores and the available RAM, however the
performance of our tool can be improved by allocating more cores (with
corresponding RAM) if available. We recommend using as many cores as reasonably
possible, but at least 4 cores and 8GBs of RAM to actually run AnICA campaigns.
Additionally, the Vagrantfile specifies ports on the host machine (8300 and
8380 by default) that will be used to display results in the web browser of the
host machine. We recommend to not change the ports, so that the links in this
document work.
Once you have adjusted the settings to your liking and installed vagrant and
virtualbox, use the following commands to make the box known to vagrant, to
start the VM, and to establish an SSH connection into the VM:

```
vagrant box add --name anica-artifact anica-artifact.box
vagrant up
vagrant ssh
```

The VM is based on a 64-bit stock Debian 11 (bullseye) image. Additionally to
common tools, we pre-installed tmux, vim, and nano for convenience. Vagrant by
default mounts the directory that includes the Vagrantfile in the host system
as a shared directory in the VM, at `/vagrant/`. You can use this to move files
into or out of the VM if you choose to do so.

The VM can be shut down from the host via `vagrant halt`. Changes to the file
system are persistent, just run `vagrant up` and `vagrant ssh` again to boot
the VM and connect to it again. Once it is no longer used, the VM can be
deleted from vagrant with `vagrant destroy`. The AnICA base box can then be
removed with `vagrant box remove anica-artifact`.

With the artifact VM now running, you can also access a rendered version of
these instructions with clickable links in your web browser at

> http://127.0.0.1:8380/doc/artifact

### Testing the Setup

To quickly verify that all components of the artifact are working, run the
following command in the VM via the ssh connection in the home folder of the
default user `vagrant`:

```
./test_setup.sh
```

It runs the major components of the artifact with small inputs and should
execute without error. In the unexpected case of an error here, a log of the
testing is placed in the VM's shared directory (which should be mirrored in the
directory containing the Vagrantfile on the host system) under the name
`test_setup_error.log`. Please provide this log if you encounter errors.

Lastly, access the results website in a browser on your host system under the
address http://127.0.0.1:8300/anica .
This should display a website hosted in the VM.

Should you wish to access the browser-based user interface from a different
host (e.g. because you run the VM on a headless machine that you only access
via SSH, given a sufficiently lenient firewall configuration), you need to
enter the corresponding host (IP address or DNS name) as a string into the
`ALLOWED_HOSTS` list of the django server in this file in the VM:
```
~/anica_ui/anica_ui/anica_ui/settings.py
```
Be aware that, depending on your firewall configuration, this may expose
non-hardened software running on your machine to the world.


## Overview of the Artifact Contents

This section is a reference on where things in the artifact can be found.
You are welcome to skip this section and only use it to look up parts as needed.

Most relevant things in the VM are located in the home folder of the `vagrant`
user:

- The AnICA implementation is in `~/anica_ui/lib/anica`.
  For example, the implementation of Algorithms 1 and 2 from the paper is in
  `~/anica_ui/lib/anica/anica/discovery.py`. The abstract domain is implemented
  in `~/anica_ui/lib/anica/anica/abstractblock.py`.
- The raw data from the paper evaluation is in `~/results/provided/`, but we
  recommend using the UI to investigate these results, as described in the
  following sections.
- The AnICA configuration files used for the paper evaluation and more that we
  provide for the artifact evaluation are in `~/artifact_configs/`.
- The `~/test_setup.sh` script runs tests to validate that the setup is
  working.
- The provided predictors are located at different places: the versions of
  llvm-mca are built in the subdirectories under `~/utils`. The other ones are
  installed with the provided scripts in the subdirectories of
  `~/anica_ui/lib/anica/lib/iwho/predictors`. Ithemal is a special case: we
  included their artifact, a docker container, with an added interface to query
  predictions and sparingly updated build scripts. The artifact VM is
  configured to start the Ithemal container automatically, so no interaction
  should be necessary.

The scripts in the `setup` directory were used in the VM build process and
normally do not need to be touched when using the artifact.

## Reusability and Documentation

The software development for AnICA is split into two python packages, `anica`
(for the core algorithms and data structures) and `iwho` (for a workable
representation of instructions suitable for our purposes).
Both come with extensive READMEs (`~/anica_ui/lib/anica/README.md` and
`~/anica_ui/lib/anica/lib/iwho/README.md` in the artifact VM) as well as
generated API documentation (served at http://127.0.0.1:8380/doc/anica and
http://127.0.0.1:8380/doc/iwho by the running artifact VM) to enable use by
other researchers.

The AnICA README in particular discusses the necessary steps when extending
AnICA in several ways.

Do note that these extension steps can be performed inside the VM, so that the
VM can be used directly to, e.g., investigate new throughput predictors. The
throughput predictor only needs to be placed in the VM's shared folder or
downloaded into the VM and a wrapper needs to be added as described in the
README.


## Scope of the Artifact

### Supported Claims from the Paper

- We provide our measurements and instructions to reproduce them for the
  heatmap in Fig. 1 of the paper, which shows vastly inconsistent behavior
  between the predictors (with the exception of IACA, see below).

- We provide the AnICA campaigns evaluated in Section 4.3 of the paper, with
  all discoveries in a very detailed format, for investigation.
  The artifact further comes with instructions for running similar (optionally:
  shorter) campaigns to reproduce the results (with the exception of IACA, see
  below).

- We provide the means to compute metrics corresponding to Table 2 in the paper
  for any combination of newly sampled or provided basic block sets with newly
  performed or provided AnICA campaigns.

- We provide the abstract basic blocks used in the case studies in Section 5 of
  the paper for inspection.


### Unsupported Claims from the Paper

- While the artifact provides all interfaces on the AnICA side necessary to
  run IACA and evaluate its predictions, its proprietary license does not allow
  us to package it in this artifact. We provide the campaigns we ran with IACA,
  but this artifact does not produce new IACA campaigns.

- NanoBench, which we used for the case study in Section 5.3, is also not
  present in the artifact since it performs highly platform-dependent
  microbenchmarks that would require a processor with a specific
  microarchitecture and a highly controlled environments to ensure stable
  measurements, which are out of scope of this artifact. We nevertheless
  provide the NanoBench measurements that we performed for the case studies.


## Step-by-Step Guide

### Inspecting the Overview Heatmap Data (Figure 1)

We provide the data set used for the heatmap in Fig. 1 of the paper, accessible
in two formats: a CSV file with prediction results for basic blocks, located at
`~/results/provided/oopsla22_data/overview_bbs_hsw_l4_03.csv`, and a more
human-friendly inspection interface in the UI. For the latter, go to this page:

> http://127.0.0.1:8300/anica/bbsets/1

There, you see the heatmap from the paper (with a different order of
predictors, and additionally including llvm-mca version 8). We will return to
the table below in this view in a later step. By clicking the `view Basic
Blocks` link in the top section of the page (or by going to
http://127.0.0.1:8300/anica/bbsets/1/allbbs), you can find a view to inspect
the actual disassembled basic blocks and the tool predictions.


### Generating your own Overview Heatmap Data

To sample new basic blocks, you can run this script in the VM:
```
~/scripts/produce_overview_data.sh
```
It will sample 1,000 random basic blocks (instead of 10,000 in the paper) with
4 instructions each and evaluate them with the provided predictors (this can
take a few minutes, 10 on our test system, and is likely to print warnings for
cases where Ithemal was not able to handle a basic block; these can be
ignored).
The results are written to `~/results/new/overview_data.csv` and can be
imported to the UI for inspection via the following script:
```
~/scripts/import_produced_overview_data.sh
```
After that, you should find an entry with a clickable link for the new data set
in the overview here:

> http://127.0.0.1:8300/anica/bbsets/

The heatmap values will, most likely, not be identical to the ones in the
paper, since this is a different data set, but the trends should be the same.


### Inspecting the Campaigns Used in Section 4.3

The VM provides the AnICA campaigns that we used in the evaluation in Section
4.3. They are present in the browser-based UI here, with the
`paper_eval_provided` tag:

> http://127.0.0.1:8300/anica/campaign/

By clicking on the numerical ID of such a campaign entry, you get to an
overview of the campaign. From there, you can click the "All Discoveries" link
in the very bottom to come to a list of the discoveries (i.e. abstract blocks)
of the campaign.

Remember that on each page of the UI, you can click the "Open Docs" button in
the top-right corner for an explanation on what is displayed.

You can view more details about a discovery by clicking its identifier in the
table. For example, this discovery shows the inconsistent handling of memory
dependencies in llvm-mca versions 9 and 13:

> http://127.0.0.1:8300/anica/campaign/7/discoveries/b001_i003_g000/

On such a detailed discovery view, you can click on the link under "Witness" to
obtain a generalization tree similar to the one in Fig. 3 in the paper. If you
click a red node of the tree, you open an overview of the basic blocks that
were sampled and evaluated to judge the abstract block's interestingness.


### Running New Campaigns Like the Ones in Section 4.3

A number of obstacles prevent the exact campaigns from the previous step to be
reproduced in this artifact:
- We cannot distribute IACA in the artifact because of its proprietary license.
- The campaigns are concurrent and inherently randomized, so that we cannot
  reproduce the exact same results.
- The original running time for all campaigns was in the order of days on a
  strong machine with 20 mostly utilized CPU cores.

We therefore provide the original AnICA configurations used for the campaigns
presented in the paper for inspection, as well as smaller ones producing fewer
discoveries that we recommend for reasonable running times in the artifact
evaluation.

The original config is in `~/artifact_configs/campaign/paper_full.json` (for
the campaign behavior) and in `~/artifact_configs/abstraction/paper_full.json`
(for the abstraction behavior). A variation without IACA campaigns is provided
in `~/artifact_configs/campaign/paper_no_iaca.json`. Given enough time (days to
weeks, depending on the machine), this config would run in the artifact VM;  we
do not recommend to run it, to value the time of the reviewers.

Instead, the artifact provides a number of smaller configurations in the
`~/artifact_configs/campaign/artifact_$N_discoveries` directories.
They differ from the original campaign config in several ways:

- They use the `~/artifact_configs/abstraction/quick.json` abstraction config,
  which uses 50 instead of 100 samples to judge whether an abstract block is
  interesting during generalization (which effectively halves the evaluation
  time, at the cost of accuracy). It also uses a smaller batch size (5) which
  determines how many generalizations of different sampled basic blocks are
  attempted between checks for the termination condition.
- They run until `$N` discoveries are made, instead of 150 as in the paper
  evaluation (where `$N` is given in the directory name). Terminating earlier
  means that less time will be spent, but also fewer discoveries are made.
- Each individual config only contains a single campaign, so that they can be
  evaluated selectively. The config file names (from 000 to 010) are in
  ascending order by how long the corresponding campaigns took in the paper
  evaluation.

We suggest to start with campaigns with short expected running time, e.g.
```
~/artifact_configs/campaign/artifact_020_discoveries/campaign_000_llvm-mca.13-r+a.hsw_v_llvm-mca.9-r+a.hsw.json
```
After running and inspecting such short campaigns and observing the actual
running time, we leave it to the reviewers to decide which and how many other
campaigns with longer running times they deem interesting to run. Be aware that
running campaigns for such dramatically reduced numbers of abstract blocks
means that it is to be expected that the coverage metrics reported in Table 2
in the paper (computed in a later step) will not be achieved.

The AnICA campaigns will run faster with more CPU cores available to the VM.
If necessary, you can adjust the number of CPU cores allocated to the VM by
`exit`ing from the VM's ssh shell, running `vagrant halt` to shut it down,
adjusting the `Vagrantfile`, and running `vagrant up` and `vagrant ssh` to boot
the VM with the new number of cores.

Once you have chosen a campaign config as described above, you can run it with
the following command:
```
anica-discover -c ~/artifact_configs/campaign/<remaining path>.json ~/results/new/
```
AnICA will run for a while (a few minutes for the fastest campaign config)
while printing logs that can be ignored. Once it has terminated successfully,
the resulting campaign will be written in a time-stamped subdirectory of
`~/results/new/`.

You can import the new campaign for inspection to the web browser UI with the
following command (`my_campaigns` is an arbitrary tag by which you can group
campaigns in the UI):

```
~/anica_ui/anica_ui/manage.py import_campaign my_campaigns ~/results/new/<timestamped campaign directory>
```

Once this terminates successfully, you should see your new campaign in the
campaign overview of the UI:

> http://127.0.0.1:8300/anica/campaign/

You can inspect the new campaigns there just as the provided ones.


### Producing Statistics Like the Ones in Table 2

The corresponding coverage metrics for the provided campaigns and the provided
basic block set can be found in the table beneath the heatmap here in the UI:

> http://127.0.0.1:8300/anica/bbsets/1

You can reproduce these metrics for the basic block set that has been sampled
in a previous step, and with the AnICA campaigns performed in a previous step.

To compute table entries for a specific basic block set with the numerical
identifier `L` (likely 2, if you followed the steps here), and a specific
campaign with numerical identifier `K` (both must have been imported into the
UI as described previously), you can use the following command:

```
~/anica_ui/anica_ui/manage.py compute_bbset_coverage --campaign K --bbset L
```

Without specific arguments, this command will compute metrics for all
combinations of imported campaigns and basic block sets that have not been
computed before:

```
~/anica_ui/anica_ui/manage.py compute_bbset_coverage
```

These commands can take several minutes. When using 4 or fewer CPU cores, we
encountered very long running times for this command. If your hardware does not
allow you to allocate more CPU cores to the VM, you might want to use the
`--heuristic` command line option in the above commands to use an approximate
implementation that under-approximates the "covered by top 10" metric and does
not show this behavior.

You can see the new table entries afterwards on the corresponding basic block
set pages of the UI:

> http://127.0.0.1:8300/anica/bbsets/1
> http://127.0.0.1:8300/anica/bbsets/2

The coverage metrics there should show similar tendencies as the ones in the
corresponding provided campaigns (but, most likely, not exact, because of
different randomizations and configurations). Do note that especially campaigns
that terminate after fewer discoveries to reduce the time required for the
artifact evaluation are bound to have lower coverage metrics than the ones in
the paper. (It would be surprising to see the same amount of inconsistent basic
blocks covered when we only look for 33% or 13% of the abstract blocks, after
all.)

### Inspecting Specific Abstract Blocks for the Case Studies

We provide abstract blocks with generalizations for the case studies that we
present in the paper. As described above, the randomized nature of AnICA stops
us from reproducing them exactly in this artifact. Additionally, the
discoveries for the llvm-mca/Zen+ case study in Table 4 are based on delicate
microbenchmarks on a computer with a specific microarchitecture. While we
provide the setup with which we produced these numbers, reproducing them in a
portable artifact is not feasible.

The generalizations that we provide do however contain all tool outputs for
each generalization step performed, they can be inspected in the web UI.
You can find them here:

> http://127.0.0.1:8300/anica/generalization/

(Note that the Fig. 4 generalizations there are not exactly the same as in the
paper since they were from earlier campaigns.)

For example, you might consider the generalization for discovery (F) in Table 4
of the paper:

> http://127.0.0.1:8300/anica/generalization/12/

In the witness linked on that page, by clicking on the highest red node of the
generalization tree, you can see that nanoBench reports a surprisingly slow
execution only for about half of the sampled basic blocks, namely those where
the shift amount is 0.

