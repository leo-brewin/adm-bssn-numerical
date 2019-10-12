# Evolving initial data using the ADM and BSSN equations.

This repository provides simple Cadabra and Ada codes for 3+1 numerical evolutions of Kasner initial data.

## Rationale

There is no need for yet another elementary code that does nothing more than evolve Kasner initial data. That job can be adequately done using existing codes (such as the [Einstein Toolkit][1] or [Cactus][2]). But if you want to do something slightly less standard (off piste), e.g., evolve the initial data with respect to a modified evolution scheme, then you are faced with a serious question. Should you invest the time to understand the inner workings of the existing software so that you can be assured that your changes actually do what you want them to do? Or do you use that same time to write your own code from the ground up? The later case is certainly an example of reinventing the wheel but once you have your new wheel your are in complete charge. The risk you take is that your code will contain bugs and that it will not have all the features of other codes.

The [codes][3] on which this project is based were written mainly because I did not have the time, the patience or the inclination to delve into the inner workings of Cactus. I did not need all of the features of Cactus. So I wrote a code that met my limited needs. I am sharing them here so that if anyone else feels inclined to write their own own (which I strongly encourage) you may find this code a useful guide (or maybe not). The bulk of the Ada code is standard (simple uni-grid code, periodic boundaries and second order centred finite differences). The things that might be of interest are the multi-tasking (using native Ada constructs) and the modular structure of the code (using Ada packages for the various tasks, e.g., I/O, time stepping, constraints).

The code uses [Cadabra][4] to convert the tensor equations to bare C-code. Other tools are used to integrate these into larger programs written in Ada. The result is a bridge between the formal equations on one side (the ADM or BSSN equations) and the numerical or graphical results on the other side (the data generated by the codes).

Having an automated system that converts the tensor equations to code and then runs that code to produce numerical or graphical results does make experimentation very easy. Your time can be spent on the mathematics rather than on writing low level code. This also reduces the chances of (human) coding errors.

This philosophy (of having computers do all the work) is not new. See for example the [NRPY+ software][5] and the [Einstein Toolkit][1].

### Why Cadabra?

Cadabra is a symbolic algebra system ideally suited to tensor computations in General Relativity. The core software is written in C++ while its native syntax is a subset of LaTeX for the tensor equations and Python to control the computations. Cadabra is mostly used to do abstract tensor computations (e.g., showing that the Levi-Civita connection is metric compatible) as well as component computations (e.g., computing the Riemann components for a Schwarzschild metric in isotropic coordinates).

Using familiar tools like LaTeX and Python means that the learning curve for Cadabra is very gentle (and that's a big plus).

A detailed tutorial on Cadabra can be found [here][6].

### Why Ada?

Most codes in computational relativity are written either in C/C++ or Fortran or some combination. So why does this project use Ada? The simple answer is that I like to do things outside the triangle. The better answer is that Ada is a superb language (IMHO) for any large scale computational project. Here are a few of its features.

* __Strong typing.__
Ada forces you to declare the type of every object. You can create your own types or use predefined types. This information is used by the compiler to avoid the classic apples and oranges errors.
* __Native multitasking.__
The Ada language contains explicit rules for multi-tasking and distributed computing.
* __Exception handling.__
Easily catch and handle any exceptions (array bounds error, floating point errors, file and i/o errors).
* __Platform agnostic.__
Ada codes can be ported from one platform to another without change. The usual #ifdef constructs in C/C++ have no counterparts in Ada. All platform dependencies are resolved in the compiler.
* __Interface with C and Fortran.__
Ada has precisely defined rules for communicating with C and Fortran codes. This makes it easy to access
external libraries.


## Dependencies

You will need an Ada compiler and the Cadabra software.

### Ada

Ada compilers are available for a wide variety of platforms. A popular free compiler is the gnat community edition provided by AdaCore. The installer can be downloaded from the [Adacore website][7]. Other Ada compilers could also be used (for example the GCC compiler from the Free Software Foundation).

### Cadabra

Cadabra is easy to compile and install. Full details on how to install Cadabra can be found on the [Cadabra repository][8].

## Installing the codes foo

To build everything from scratch just run

    $ make

from the top directory. This will build, install and run the Ada, Cadabra and LaTeX codes. The end result will be a pdf file `adm-bssn-plots.pdf` showing the evolution of the Kasner initial data for both the ADM and BSSN equations.

__Note__ that the simple `make` command will install various files before running the ADM and BSSN codes. The files will be installed in the directories

|  Directory  | Content | Path variable |
|:------------:|:--------|:-------------|
| `$HOME/local/adm-bssn/bin/` | Ada binaries, Python and Shell scripts | `$PATH` |
| `$HOME/local/adm-bssn/lib/` | Python libraries | `$PYTHONPATH` |
| `$HOME/local/adm-bssn/tex/` | LaTeX files | `$TEXINPUTS` |

You will need to add these directories to the indicated paths __before__ issuing the `make` command. If you wish to use other directories then you should first edit `INSTALL.sh` and also `hybrid-latex/INSTALL.sh`.

You can also compile and install these tools by hand. See the `INSTALL.txt` and `utilities/INSTALL.txt` for full details.

## Tinkering with the codes

Most of the directories contain a `Makefile` and a `build.sh` file. These are useful when compiling and running the codes. You may want to look inside these files to see which make targets are available. The `Makefile` contains many targets while the `build.sh` script is a one-trick-pony (usually to just rebuild the files). In most cases `build.sh` is simply a wrapper to `gprbuild`.

You may notice that all of the Ada codes are compiled using `gprbuild`. This is a standard tool for Ada programs. It makes intelligent decisions about which files are out of date and which files need to be recompiled. The nice thing about `gprbuild` is that it determines the dependencies by inspection of the Ada files (compare this with `make` where the dependencies must be explicitly encoded in the `Makefile`).

If you make changes to any of the Cadabra codes in the `bssn` directory you will need to recompile the Cadabra codes then compile and run the Ada codes. This can be done using

```
cd bssn/cadabra
build.sh
cd ../bssn/code
build.sh
bssninitial.sh
bssnevolve.sh
```

If you make changes only to the Ada codes in `bssn/code/src` then you need only run

```
cd bssn/code
build.sh
```

Creating the initial data and running the evolution code for the BSSN equations can be done using

```
cd bssn/code
bssninitial.sh
bssnevolve.sh
```

All of the above tasks can also be run using selected targets in the `Makefile`. Similar steps can be taken when tinkering with the ADM codes.

Note that any changes to the ADM codes will have no effect on the BSSN codes and vice-versa. The single point of connection between the ADM and BSSN codes is that they share the `support` library.

## License

All files in this collection are distributed under the [MIT][9] license. See the file LICENSE.txt for the full details.

  [1]: http://einsteintoolkit.org
  [2]: https://cactuscode.org
  [3]: https://journals.aps.org/prd/abstract/10.1103/PhysRevD.96.024037
  [4]: https://cadabra.science
  [5]: http://astro.phys.wvu.edu/bhathome/nrpy.html
  [6]: https://github.com/leo-brewin/cadabra-tutorial
  [7]: https://www.adacore.com/download/more/
  [8]: https://github.com/kpeeters/cadabra2
  [9]: https://opensource.org/licenses/MIT