# my crypt

Manage creation and encryption of disks and volumes.
We are going to use __vault__ as a alias for what is going to be created.

## Getting Started

First of all, install one of the encryption tools supported.

The `my crypt` plugin can install it for you. Check below [examples](#Examples).

`my crypt` and `my sync` provide a useful combination to safely sync a external folder throw differents environments. Check [here](sync_usecase.md) to see a use case.

### Encryption tools supported
-   [encfs](https://github.com/vgough/encfs) - it's a file system that maps an encrypted folder to a mount point.
-   [veracrypt](http://veracrypt.codeplex.com/) - a disk encryption tool that creates a file contains your disk. Useful to send critical data to other people.

## Commands
-   `install` - install a supported tool.
-   `remove`  - remove a supported tool.
-   `create`  - created a new encrypted disk.
-   `open`    - open the encrypted disk.
-   `close`   - close the encrypted disk.

## Examples
1.  Install __encfs__.
    ```
    my crypt install encfs
    ```
2.  create a new __vault__.
    ```
    my crypt create new_vault
    ```
    And follow any instructions.

3.  open a vault __vault__.
    ```
    my crypt open new_vault
    ```
    Follow any further instructions. It will probably prompt for your __vault__ password any time you try to open it.

4.  close a __vault__ after work.
    ```
    my crypt close new_vault
    ```

Go back to [readme](../README.md) for installation steps and usage examples.
