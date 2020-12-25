# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

echo "setup-dev: setup nelua-decl"

# clone nelua-decl
git clone --recurse-submodules https://github.com/edubart/nelua-decl.git
cd nelua-decl

# build gcc-lua
make -C gcc-lua

# return
cd ..

echo "setup-dev: setup tinycoffee"
echo ""

# clone tinycoffee
git clone https://github.com/canoi12/tinycoffee.git
cd tinycoffee

# build tinycoffee (necessary for testing the binding with basic-test.nelua)
mkdir build
cd build
cmake ..
make

# return
cd ../../

echo "setup done"
