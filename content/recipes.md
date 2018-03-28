---
title: Recipes
description: Recipes for the Debian packaging helper
menu:
  main:
    weight: 30
---

# Recipes

Packages generation is based on collection of pre-defined recipes available in a dedicated
[Git repository][mkdeb-recipes].

The recipes are simple [YAML][yaml-spec] files that may provide additional maintainers scripts and files to be appended
to the resulting Debian package.

## Base information

Recipe information consist of some base fields:

 * a `version`__*__ field corresponding to the current recipe format version (should be equal to `1`)
 * a `name`__*__ field containing the package name
 * a `description`__*__ field containing the package short description
 * a `maintainer`__*__ field containing the package maintainer's address
 * a `homepage` field providing the upstream website address

### Example

    version: 1
    name: foo
    description: a great description here
    maintainer: Foo Bar <foo@example.org>
    homepage: https://example.org/

## Source

The `source` section provides references to the upstream releases and parameters impacting source retrieval during the
packaging process.

The `url`__*__ parameter describes the pattern of the URL pointing to upstream source archive. The two
templating variables `Arch` and `Version` can be used to point to a specific release.

The optional `strip` parameter is an integer representing the number of leading path elements to strip upon upstream
archive file names extraction. For example, a level of `1` will transform `foo-1.2.3/foo` to `foo`.

The `arch-mapping` parameter maps the upstream architecture names to the ones used by [Debian][debian-archs].

### Example

    source:
      url: https://example.org/path/to/foo-{{ .Version }}.{{ .Arch }}.tar.gz
      strip: 1
      arch-mapping:
        "386": i386
        amd64: amd64
        arm64: arm64
        arm: armel

## Control

The `control` section provides additional data to be passed on to the Debian package control file.

| Parameter       | Description                                  | Default value  |
|:----------------|:---------------------------------------------|:---------------|
| `section`       | Fills the `Section` Debian control field     |                |
| `priority`      | Fills the `Priority` Debian control field    | `extra`        |
| `version.epoch` | Sets the Debian version epoch prefix         | `0` (no epoch) |
| `depends`       | Fills the `Depends`  Debian control field    |                |
| `pre-depends`   | Fills the `Pre-Depends` Debian control field |                |
| `recommends`    | Fills the `Recommends` Debian control field  |                |
| `suggests`      | Fills the `Suggests` Debian control field    |                |
| `enhances`      | Fills the `Enhances` Debian control field    |                |
| `breaks`        | Fills the `Breaks` Debian control field      |                |
| `conflicts`     | Fills the `Conflicts` Debian control field   |                |
| `description`   | Fills the `Description` Debian control field |                |

### Example

    control:
      depends:
      - bar
      - baz (>= 1.2.3)
      description: |
        A long package description providing us with enough information on the
        upstream software.
      section: utils

## Install

The `install` section provides the files installation rules for the resulting package.

It consists of two sub-sections `recipe` and `upstream` that both defines installation rules. The `recipe` section will
handle files present in the `files` sub-directory of the recipe, when `upstream` will match files present in the
upstream archive.

Each installation rule consist uses the destination path as key and may contain the following attributes:

| Name       | Description                                               |
|:-----------|:----------------------------------------------------------|
| `conffile` | Debian configuration file flag                            |
| `path`     | single file path                                          |
| `pattern`  | multiple files matching pattern (see [Glob][golang-glob]) |
| `rename`   | file target name                                          |

### Example

Given the following recipe structure:

    foo/
    ├── control
    │   ├── postinst
    │   └── postrm
    ├── files
    │   ├── init
    └── recipe.yaml

And the install section:

    install:
      recipe:
        /etc/init.d:
        - pattern: init
          rename: foo
          conffile: true
      upstream:
        /usr/bin:
        - pattern: foo

The package will contain:

 * both files present in the `control` directory in the package control archive
 * `files/init` copied at `/etc/init.d/foo` and declared as a [configuration file][debian-conffiles].
 * `foo` present in the upstream archive copied at `/usr/bin/foo`

## Directories

The `dirs` section provides a list of additional directories to be part of the resulting package.

### Example

    dirs:
    - /path/to/dir


## Links

The `links` section provides a list of additional symbolic links to be part of the resulting package.

### Example

    links:
      /path/to/link: /path/to/target


<p class="legend"><strong>*</strong> Mandatory field</p>


[mkdeb-recipes]: https://github.com/mkdeb/recipes
[yaml-spec]: http://yaml.org/spec/
[debian-archs]: https://wiki.debian.org/SupportedArchitectures
[debian-conffiles]: https://www.debian.org/doc/manuals/maint-guide/dother.en.html#conffiles
[golang-glob]: https://golang.org/pkg/path/#Match
