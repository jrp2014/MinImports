# MinImports

[![GitHub CI](https://github.com/jrp2014/MiniImports/workflows/CI/badge.svg)](https://github.com/jrp2014/MiniImports/actions)
[![Build status](https://img.shields.io/travis/jrp2014/MiniImports.svg?logo=travis)](https://travis-ci.org/jrp2014/MiniImports)
[![Windows build status](https://ci.appveyor.com/api/projects/status/github/jrp2014/MiniImports?branch=master&svg=true)](https://ci.appveyor.com/project/jrp2014/MiniImports)
[![Hackage](https://img.shields.io/hackage/v/MiniImports.svg?logo=haskell)](https://hackage.haskell.org/package/MiniImports)
[![MIT license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A GHC source plugin that replaces current imports with a minimal set, removing unused ones.

It is like [smuggler](https://github.com/kowainik/smuggler) but it depends on GHC 8.8.3 and newer.

## How to use

Add `minimports` to the dependencies of your project. Then add the following
compiler options (ghc-options):

```
-fplugin=MinImportsPlugin
```

This package automatically supports on-the-fly
feature if you use it with `ghcid`. MinImports doesn't perform file changes when
there are no unused imports. So you can just run `ghcid` as usual:

```
ghcid --command='cabal repl'
```

## For contributors

Requirements:

* `ghc-8.8.3`
* `cabal >= 3.0`

### Cabal: How to build?

```shell
cabal update
cabal build
```

## References
* [Extending and using GHC as a library](https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/extending_ghc.html)
* [Working with Source Plugins](https://mpickering.github.io/papers/working-with-source-plugins.pdf)
* [Unused Imports](https://gitlab.haskell.org/ghc/ghc/-/wikis/commentary/compiler/unused-imports)
* [Relax Unused Imports](https://gitlab.haskell.org/ghc/ghc/-/wikis/commentary/compiler/relaxed-unused-imports)
* [RnNames](https://hackage.haskell.org/package/ghc-8.6.5/docs/RnNames.html#v:printMinimalImports)
