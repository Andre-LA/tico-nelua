# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

echo "gen-bindings: running gcc to generate bindings"

gcc -S ./tico.c \
    -I ./tinycoffee/include/ -I ./tinycoffee/external/ \
    -fplugin=./nelua-decl/gcc-lua/gcc/gcclua.so \
    -fplugin-arg-gcclua-script=./tico.lua

nelua basic-test.nelua --no-cache
