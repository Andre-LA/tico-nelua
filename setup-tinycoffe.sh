echo "removing local directories created by a previous run"
rm -rf libs/
rm -rf include/
rm -rf tinycoffee/

echo "cloning tinycoffee repository from master branch"
git clone https://github.com/canoi12/tinycoffee.git

echo "entering on tinycoffee directory"
cd tinycoffee/

echo "building tinycoffee: step 1/0 -> create build directory"
# on tinycoffee/
mkdir build

echo "building tinycoffee: step 2/0 -> entering build directory"
# on tinycoffee/
cd build/

echo "building tinycoffee: step 3/0 -> running tinycoffee's cmake"
# on tinycoffee/build
cmake ..

echo "building tinycoffee: step 4/0 -> running generated make"
# on tinycoffee/build
make

echo "building tinycoffee: step 5/0 -> leaving tinycoffee directory"
cd ../../

echo "setup tinycoffee for binding and use: step 2/0 -> create libs and include directories"
mkdir libs
mkdir include

echo "setup tinycoffee for binding and use: step 1/0 -> copying include directory headers"
cp -r tinycoffee/include/ .

echo "setup tinycoffee for binding and use: step 1/0 -> copying compiled static libraries to libs"
cp tinycoffee/build/{libcimgui.a,libgl3w.a,libglfw.a,liblua.a,libtico_lib.a} libs/

echo "DONE"
