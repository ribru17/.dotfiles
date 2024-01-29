# My Iosevka font configuration

## Installation

First clone the Iosevka repo:

```
git clone --depth 1 https://github.com/be5invis/Iosevka.git
```

Then:

1. Ensure that [`nodejs`](http://nodejs.org) (≥ 14.0.0) and
   [`ttfautohint`](http://www.freetype.org/ttfautohint/) are present, and
   accessible from `PATH`.
2. Run (in repo) `npm install`. This command will install **all** the NPM
   dependencies, and will also validate whether external dependencies are
   present.
3. Move `private-build-plans.toml` into the repo.
4. Run (in repo) `npm run build -- --jCmd=4 ttf::iosevka-custom` (this runs the
   build command with 4 threads to give the computer some room to breathe).
5. This will take some time. Once done, move fonts from `dist` to
   `~/.local/share/fonts` and run `fc-cache`.

## Usage

I've experienced best results with Iosevka Extended variant, 15pt font size.
