# tico-nelua

[Tinycoffee](https://github.com/canoi12/tinycoffee) binding for [Nelua](https://nelua.io/)

This project uses [nelua-decl](https://github.com/edubart/nelua-decl) to generate the bindings, which
 the output is processed later to add better integration between the language and the library.

## How to generate bindings

First, **you don't need to generate a binding**, the `output/tico.nelua` file already contains a
 generated binding ready for use.

However, if you want to generate a new one to improve the binding and make a contribution,
 follow the instructions:

### Setup
To generate the binding, you will need both `tinycoffee` and `nelua-decl`.

1. Ensure that you have the dependencies installed:
    - [tinycoffee dependencies](https://github.com/canoi12/tinycoffee#dependencies)
    - [nelua-decl dependencies](https://github.com/edubart/nelua-decl#usage)
2. Run `setup-dev.sh` script, this will automatically clone and build both libraries.

### Generating

Run `gen-bindings.sh`, this script will run everything to generate the binding, which will overwrite `output/tico.nelua`, ready for use.
After that, the script will build and run `basic-test.nelua`, to test the binding.
