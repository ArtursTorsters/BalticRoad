#!/bin/bash
# Wrapper around swiftlint that points it at Command Line Tools' sourcekitd,
# needed because this machine has no full Xcode install (only CLT), and
# swiftlint/SourceKitten don't find sourcekitd there on their own.
export DYLD_FRAMEWORK_PATH="/Library/Developer/CommandLineTools/usr/lib"
exec swiftlint "$@"
