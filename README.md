# [ELD Labs](https://www.youtube.com/playlist?list=PL579fbjB-a0u7ilbp5173Ulm-RJelsHtR)

## Tools Used

-   Vivado 2019.1
-   Git

## How to create and open a new project ?

```sh
$ new_project.bat <project_name>    # using command prompt
$ ./new_project.sh <project_name>   # using bash

$ cd <project_name>
$ vivado
```

## Project structure

```sh
.
├───build               # vivado project lives/builds here
├───constrs             # keep constraints files here
├───ip                  # keep ip files here
├───simsrcs             # keep testbenches/simulation sources here
├───srcs                # keep design sources here
├───build_project.tcl   # exported vivado project tcl script
├───ss                  # keep screenshots here
├───README.md           # for project info/documentation
└───.gitignore          # to ignore vivado generated files from git
```

## Setting up the project

1. Create Project

    - Set `Project Name` as `build`.
    - Set `Project Location` to `/<project_name>` where `<project_name>` is the project directory created using `new_project` script.
    - Check `Create project subdirectory`.

2. Set `Project Type` as `RTL Project`.

3. Add Sources

    - Add source files from `srcs, simsrcs, and ip (.xci file)` directories.
    - Create new source file but set location to:
        - `srcs` for design source
        - `simsrcs` for testbenches/simulation source
    - Change `HDL Source For` option for testbenches/simulation sources to `Simulation only`.
    - Uncheck `Copy sources into project`.

4. Add Constraints

    - Add constraints files from `constrs (.xdc file)` directory.
    - Create new constraint file but set location to `constrs`.
    - Uncheck `Copy constraints into project`.

5. Set Default Part

6. Finish

## Project development

-   Whenever you add a new file, remember to set the location to `srcs`, `simsrcs`, or `constrs` as needed.
-   When adding an IP from the catalog, make sure to set `IP Location` as `ip`.
-   After development, make sure to regenerate `build_project.tcl` script.
    -   Select `File > Project > Write Tcl`.
    -   Set output file location to `build_project.tcl` (overwrite).
    -   Check `Copy sources to new project`.

## Building Vivado project

```sh
$ cd <project_name>
$ vivado -source build_project.tcl
```
