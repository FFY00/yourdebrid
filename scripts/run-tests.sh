#!/bin/sh

cd "${MESON_BUILD_ROOT}"

echo "Running TEST-SOURCE-SHOW..."
test/test-source-show 4052886 3 23 hdtv | tee "${MESON_BUILD_ROOT}/test-source-show_result.txt"

echo -e "\n"

echo "Running TEST-SOURCE.MOVIE..."
test/test-source-movie 1559547 hdtv | tee "${MESON_BUILD_ROOT}/test-source-movie_result.txt"
