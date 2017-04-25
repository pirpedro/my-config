# my sync

keep tracked and syncronized all linked files and folder in a easy way.

After some time, it's difficult to remind which are the symbolic links you made in yor environment. `my sync` keep track of it, so you can check and safely remove files without crashing anything.

## Getting Started

`my crypt` and `my sync` provide a useful combination to safely sync a external folder throw differents environments. Check [here](sync_usecase.md) to see a use case.

### Prerequisites
It just depends on `git`, to keep configuration files.

### Usage

For example
```
  my sync ~/.bash_profile ~/.profile
```
Some things can happen now:
1. If both files doesn't exist, nothing happens
2. if __~/.bash_profile__ exists and __~/.profile__ don't, a symbolic link is created to "synchronize" the files and you can check this connection later using `my sync list`.
3. if __~/.profile__ exists and __~/.bash_profile__ don't, move __~/.profile__ to __~/.bash_profile__ and create a symbolic link.
4. both exists, nothing happens. If you really know what you're doing, use flag force `-f` and __~/.profile__ will be removed and a symbolic link to __~/.bash_profile__ will be created.


## Commands
-   `refresh` - refresh all links previously tracked.
-   `list`    - list all tracked links
-   `alias`   - create an alias to different locations. See a great use for it in [sync use case](docs/sync_usecase.md) section.
-   `unset`   - remove the track of an specific source file or folder.

## Examples

1.  Link __~/.bash_profile__ to __~/.profile__
    ```
    my sync ~/.bash_profile ~/.profile
    ```

2.  List all current linked sources made with `my sync` help including theirs targets.
    ```
    my sync list -v
    ```

3.  Create an alias from __~/.zsh__ folder to __~/.bash__ folders.
    ```
    my sync alias ~/.bash ~/.zsh
    ```

4.  Using the above example, we can use alias to keep `my sync` command easier, like:
    ```
    my sync ~/.bash/configuration_file
    ```
    Using the previous configured alias, it is the same as
    ```
    my sync ~/.zsh/configuration_file ~/.bash/configuration_file
    ```

5.  Untrack a source.
    ```
    my sync unset ~/.zsh/configuration_file
    ```

Go back to [readme](../README.md) for installation steps and usage examples.
