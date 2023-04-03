# She-bangs

Welcome to my bash scripts repository! This repository contains a collection of useful bash scripts that can help you automate various tasks and improve your productivity. In this README, you'll find instructions on how to use the symlink script to create symbolic links to the user bin folder, allowing you to easily execute the scripts.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

To use these scripts, you need to have the following installed on your system:

- Bash (v4.0 or later)
- Git (optional, for cloning the repository)

## Installation

To get started, clone this repository to your local machine by running the following command in your terminal:

```bash
git clone https://github.com/rmnicola/shebangs.git Scripts
```

Alternatively, you can download the repository as a zip file and extract it.

## Usage

### Creating Symbolic Links

To create a symbolic link to the user bin folder, follow these steps:

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

   The script will create symbolic links for all the scripts in the repository to your user's `bin` folder (`/usr/local/bin`).
