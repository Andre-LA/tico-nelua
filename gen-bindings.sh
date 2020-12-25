echo "gen-bindings: enter nelua-decl"
cd nelua-decl

echo "gen-bindings: running gcc to generate bindings"

gcc -S ../tinycoffee/src/core.c \
    -I ../tinycoffee/include -I ../tinycoffee/external \
    -fplugin=./gcc-lua/gcc/gcclua.so \
    -fplugin-arg-gcclua-script=../gen-scripts/tico.lua

cd ..

nelua basic-test.nelua --no-cache
