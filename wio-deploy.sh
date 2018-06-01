#!/bin/sh

if ! type "npm" > /dev/null; then
    echo "wio-deploy FAILED: npm not installed"
    exit 1;
fi

if ! type "wio" > /dev/null; then
    echo "wio-deploy FAILED: wio not installed"
    exit 1;
fi

if ! type "cmake" > /dev/null; then
    echo "wio-deploy FAILED: cmake not installed"
    exit 1;
fi

echo "wio-deploy INFO: initializing deploy package"

# Create wlib-wio
rm -rf wlib-wio
wio create pkg wlib-wio ALL --platform ALL

# Replace with template wio.yml
rm wlib-wio/wio.yml
cp wio.yml wlib-wio/

rm -rf wlib-wio/src
rm -rf wlib-wio/include
rm -rf wlib-wio/tests

mkdir wlib-wio/src
mkdir wlib-wio/include
mkdir wlib-wio/tests

# Copy over WLib files
echo "Copying WLib files into wio package"
cp -r lib/wlib/wlib wlib-wio/src/
cp -r lib/wlib/include/wlib wlib-wio/include

# Generate a dummy test
printf "#include <wlib/array_list>\n\nint main(int argc, char *argv[]) {\n    wlp::array_list<int> int_list(12);\n    int_list.push_back(12);\n}\n" > wlib-wio/tests/main.cpp

# Move all `src` headers to `include`
headers=$()

mv `find wlib-wio/src/ -type f -name "*.h" -exec realpath --relative-to="." {} \;` wlib-wio/include
