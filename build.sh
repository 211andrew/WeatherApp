#!/bin/bash

set -e

# Function to print script usage
print_usage() {
  cat << EOM
Usage: WeatherApp build.sh [options]
  Available options:
    -h|--help          Print this help
    --app              Build and run the app target
    --test             Build and run the test suite
    --format           Run clang-format to check and fix code style
    --docs             Build the documentation
    --all              Build everything at once
EOM
}

# Handle command-line options
while [[ $# -gt 0 ]]; do
    key="$1"

    case "$key" in
        -h|--help)
            print_usage
            exit 0
            ;;
        --app)
            cmake -S app -B build/app
            cmake --build build/app
            ./build/app/WeatherApp
            exit 0
            ;;
        --test)
            cmake -S test -B build/test
            cmake --build build/test
            CTEST_OUTPUT_ON_FAILURE=1 cmake --build build/test --target test
            exit 0
            ;;
        --format)
            cmake -S test -B build/test
            cmake --build build/test --target format
            exit 0
            ;;
        --docs)
            cmake -S documentation -B build/doc
            cmake --build build/doc --target GenerateDocs
            # Open the documentation in the default browser
            lynx build/doc/doxygen/html/index.html
            exit 0
            ;;
        --all)
            cmake -S all -B build
            cmake --build build
            ./build/test/WeatherAppTests
            cmake --build build --target fix-format
            ./build/app/WeatherApp --help
            cmake --build build --target GenerateDocs
            # Open the documentation in the default browser
            lynx build/doc/doxygen/html/index.html
            exit 0
            ;;
        --clean)
            find -type d -name "build" -exec rm -r {} +
            echo "All build directories deleted."
            exit 0
            ;;
        *)
            echo "Error: Unknown option $key"
            print_usage
            exit 1
            ;;
    esac
done

# If no options are provided, print usage
print_usage
exit 0
