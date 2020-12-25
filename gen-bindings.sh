echo "gen-bindings: enter nelua-decl"
cd nelua-decl

echo "gen-bindings: running gcc to generate bindings"

gcc -S ../tinycoffee/src/core.c \
    -I ../tinycoffee/include -I ../tinycoffee/external \
    -fplugin=./gcc-lua/gcc/gcclua.so \
    -fplugin-arg-gcclua-script=../gen-scripts/tico.lua \
    > ../output/raw_tico.nelua

cd ..

nelua --script gen-scripts/post-process.lua

nelua basic-test.nelua
