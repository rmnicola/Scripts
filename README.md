# She-bangs

> [!IMPORTANT]  
> My scripts are made to set up my Linux systems (mostly terminal applications)
> to work just the way I want them. They are heavily opinionated and thus, not
> made to be appealing to all users. That being said, I like to think I did a
> pretty good job at configuring my system to be comfy and buttery smooth, so
> enjoy! =)

Welcome to my bash scripts repository! This repository contains a collection of
useful bash scripts that can help you automate the boring steps required to set
up a Linux system. In this README, you'll find instructions on how to use the
symlink script to create symbolic links to the user bin folder, allowing you to
easily execute the scripts as if they were installed binaries.

## 1. Installation

To get started, clone this repository to your local machine by running the
following command in your terminal:

```bash
git clone https://github.com/rmnicola/shebangs.git Scripts
```

Alternatively, you can download the repository as a zip file and extract it.

### 1.1. Installing the scripts

> [!NOTE]  
> These steps are entirely optional. You can (and some would argue should) just
> run these scripts like any other normal scripts. I just created the linker
> script out of laziness. 

I call this an installation, but all you're doing is creating symlinks from the
scripts to the user bin folder and ommiting the `.sh` suffix. To do this,
you'll need to: 

1. Navigate to the repository's root directory:

   ```bash
   cd Scripts
   ```

2. Make the symlink script executable (if it's not already):

   ```bash
   chmod +x install.sh
   ```

3. Run the symlink script:

   ```bash
   ./install.sh
   ```

## 2. Usage

To use my scripts all you have to do is run them (before or after installing),
so there really isn't anything to add here. What I can talk about, though, is
how the scripts are organized and in what order I suggest you run them if your
goal is to copy my setup.

### 2.1. Organization

The scripts dir is organized as follows:

```bash
.
├── 01Basics // Basic cli tools config
│   ├── charm-cli-install.sh
│   ├── dotfiles-link.sh
│   ├── flatpak-install.sh
│   ├── go-install.sh
│   ├── starship-install.sh
│   └── zsh-install.sh
├── 02Gnome // Gnome DE configuration
│   ├── fonts-install.sh
│   ├── gnome-pull.sh
│   └── gnome-push.sh
├── 03Dev // Dev tools configuration
│   ├── generate-ssh-key.sh
│   ├── git-configure.sh
│   ├── node-install.sh
│   └── rust-install.sh
├── 04Arch // Arch specific configurations
│   └── ilovecandy.sh
├── 05Ubuntu // Ubuntu specific configurations
│   ├── neovim-install.sh
│   ├── ros-install.sh
│   └── rosstart.sh
├── 06Peripherals // Peripherals configurations
│   ├── configure-bt-autosuspend.sh
│   └── logiops-install.sh
├── install.sh
└── README.md

6 directories, 21 files
```

The number before each directory is not just for show, but a general suggestion
as to which order you should go about executing them. There are a few scripts
that depend on the previous tool being correctly installed, so it is in your
best interest to at least start with this order:

1. (optional) download dotfiles;
2. (optional) dotfiles-link inside dotfiles dir;
3. zsh-install;
4. Reboot;
5. starship-install;
6. go-install;
7. charm-cli-install;
8. (optional) flatpak-install;

If you follow this order, the other scripts can be followed in any particular
order you want.
