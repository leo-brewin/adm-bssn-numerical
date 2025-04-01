# A road map

The are many interactions between the many files that make up this repository. Here is a short summary of which files are used as sources and which files are created. Some of the created files are later used as sources in later steps. A similar summary applies for the BSSN system. Note that the files are processed in the order listed below.

## cadabra/adm-eqtns.tex

Creates a json file that defines all of the ADM initial data and evolution equations in terms of the metric and extrinsic curvature tensors and their partial derivatives.

```sh
 reads
    cadabra/adm-eqtns.tex

 creates
    cadabra/adm-eqtns.json
    cadabra/adm-eqtns.pdf
```

## cadabra/adm-code.tex

Uses Cadabra to read the `adm-eqtns.json` file to convert the tensor equations to component form.
Uses Python/sympy to write c-code to evaluate all quantities.

```sh
 reads
    cadabra/adm-code.tex
    cadabra/adm-eqtns.json

 creates
    cadabra/adm-code.pdf
    cadabra/code-c/*.c
```

## cadabra/reformat.sh

Converts c-code to Ada.
Uses the `templates/*.ad` files to build (fragments of) Ada functions and procedures from the c-source.

```sh
 reads
    cadabra/code-c/*.c
    cadabra/templates/*.ad

 creates
    ../code/templates/code-ada/*.ad
```

## code/templates/merge.sh

Merges the generated Ada fragments to produce complete Ada code.

```sh
 reads
    code/templates/admbase-constraints.adt
    code/templates/admbase-time_derivs.adt
    code/templates/code-ada/*.ad

 creates
    code/src/admbase-constraints.adb
    code/src/admbase-time_derivs.adb
```
