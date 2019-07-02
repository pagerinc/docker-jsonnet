#!/usr/bin/env bats

@test "It should install jsonnet in PATH" {
  command -v jsonnet
}

@test "It should install jsonnetfmt in PATH" {
  command -v jsonnetfmt
}

@test "It should use jsonnet v0.13.0" {
  jsonnet --version | grep 0.13.0
}

@test "It should use jsonnetfmt v0.13.0" {
  jsonnetfmt --version | grep 0.13.0
}
