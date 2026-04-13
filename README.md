# Mapequation Infomap

## How do I install these formulae?

Primary install path:

```bash
brew tap mapequation/infomap
brew install infomap
```

Alternative one-command install:

```bash
brew install mapequation/infomap/infomap
```

On supported GitHub-hosted macOS and Linux platforms, Homebrew will pour a
prebuilt bottle after the release has been published in this tap. Unsupported
platforms will continue to build from source.

## Maintainers

Bottle publishing stays on the tap PR flow:

1. `infomap` opens or updates the version bump PR in this tap.
2. `brew test-bot` verifies the formula and builds bottle artifacts for the PR.
3. After review, apply the `pr-pull` label to the PR.
4. The publish workflow runs `brew pr-pull`, updates the formula with a
   generated `bottle do` block, and publishes bottles to GitHub Releases for
   future installs.

This does not change formula discovery: new users still need
`brew tap mapequation/infomap` before `brew install infomap`, or they can use
`brew install mapequation/infomap/infomap` directly.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
