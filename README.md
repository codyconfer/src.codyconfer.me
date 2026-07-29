# src.codyconfer.me

> source for codyconfer.me.

## Getting Started

### Build Tools

Node 24+ (see `.nvmrc`) and [pnpm](https://pnpm.io/installation). The package manager
is pinned via the `packageManager` field, so corepack is the simplest setup:

```bash
corepack enable
```

This repo consumes [lmnt](https://github.com/codyconfer/lmnt) as a git submodule, so
clone with `--recurse-submodules` (or run `git submodule update --init` after cloning).

#### Install Dependencies

```bash
pnpm install && pnpm --dir lmnt install
```

### Dev

```bash
pnpm dev
```

### Build

Full build — rebuilds the lmnt submodule, copies its artifacts into `src/_includes/lmnt/`,
then runs eleventy. This is also the deploy command:

```bash
pnpm run pkg
```

Note the `run`: pnpm has a builtin `pkg` command, so bare `pnpm pkg` will not invoke
this script. `pnpm build` runs eleventy alone and only works after a prior `pnpm run pkg`,
since the liquid templates include CSS copied out of the submodule.
