# my project

Track a folder to automate actions.

## Getting Started

First of all, initialize `my config`

```
my config init
```
Then you can track for the first time a project.
Let's assume that __/path/to/projfolder__ contains a git project.
```
my project track /path/to/projfolder
```
Now __projfolder__ is a tracked project command.

If not exist, a __entrypoint.sh__ script is created in the project root dir.

So, if you execute
```
my project projfolder
```
your terminal change working directory to __/path/to/projfolder__ and the __open__ function in __entrypoint.sh__ runs.
So you can configure anything in __entrypoint.sh__ file.
- open a text editor or ide for the project like `subl .` or `atom .`
- always sync remote repository when enter project like `git fetch`.
- start a virtual machine, a linux container or a web container and the browser for a web application.

Check below [examples](#Examples) or see the help page.
```
my project -h
```
## Commands

### Independent commands
-   `track`    - start to track a specific project.
-   `path`     - show dir location of a specific project.
-   `list`     - list all projects that are current tracked.

### Project dependent commands
-   `exec`     - execute a specific function on the entrypoint.sh
script located in project root folder.
-   `status`   - show usefull informations.
-   `untrack`  - untrack a project.

## Examples
1.  Track __projfolder__ with a different name.
    ```
    my project /path/to/projfolder newproj
    ```
2.  Enter a tracked project.
    ```
    my project newproj
    ```
    It execute an __open__ function in __entrypoint.sh__

3. Open your entrypoint.sh file and create a __test__ function. Then, run it:
    ```
    my project newproj exec test
    ```

4. If you are already in project working dir execute __test__ function
   ```
   my project exec test
   ```

5. Untrack a project
   ```
   my project newproj untrack
   ```

6.  Show current location of __newproj__ project.
    ```
    my project path newproj
    ```

7.  List all tracked projects.
    ```
    my project list
    ```

Go back to [readme](../README.md) for installation steps and usage examples.
