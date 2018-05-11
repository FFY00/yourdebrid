#!/bin/sh

cd "${MESON_BUILD_ROOT}"

echo -e "\e[1m\e[96mRunning TEST-SOURCE...\e[0m"
test/test-source | tee "${MESON_BUILD_ROOT}/test-source_result.txt"