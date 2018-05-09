---
title: Using mkdeb
description: Usage of mkdeb Debian packaging helper
menu:
  main:
    weight: 20
---

# Using mkdeb

## Fetch the recipes

To initialize or update your local recipes repository, run:

    mkdeb update

## Build a package

To build a package, run:

    mkdeb build foo:amd64=1.2.3

This command will trigger the build of the `foo` package for the desired `amd64` architecture and using upstream
release version `1.2.3`.

## Repair local repository

If the local repository is in an inconsistent state, you can force its reinitialization by executing:

    mkdeb update --force

<div class="note"><span class="fas fa-info-circle"></span> The existing repository local copy will be removed.</div>
