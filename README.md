# Resume

LaTeX resume template (single column, Overleaf-ready). Source: `hunter.tex`; class: `hunter.cls`; output: `hunter.pdf`.

## Compile on Overleaf

1. Zip the project (`hunter.tex`, `hunter.cls`, and a `publications.bib` if you use the publications section).
2. In Overleaf: **New Project → Upload Project** and upload the zip.
3. **Menu → Settings → Compiler:** `XeLaTeX` (required for `fontspec`).
4. **Menu → Settings → TeX Live version:** a recent year (so `biber` is available).
5. Set `hunter.tex` as the main document and click **Recompile**. Overleaf runs `biber` automatically.

The default font setup uses TeX Gyre / EB Garamond / Inter / Cormorant Garamond families that ship with Overleaf, so no font upload is needed.

## Compile locally

Requires a TeX distribution with XeLaTeX and Biber (TeX Live, MacTeX, or MiKTeX).

```sh
xelatex hunter.tex
biber   hunter
xelatex hunter.tex
xelatex hunter.tex
```

Or with `latexmk`:

```sh
latexmk -xelatex hunter.tex
```

### Fonts

The class loads these families via `fontspec`:

- **EB Garamond**
- **Inter** (Thin and Regular)

Install them system-wide before compiling.

**Arch / CachyOS:**
```sh
sudo pacman -S tex-gyre-fonts otf-eb-garamond inter-font
```

**Debian / Ubuntu:**
```sh
sudo apt install fonts-ebgaramond fonts-inter texlive-fonts-extra
```

**macOS (Homebrew):**
```sh
brew install --cask font-eb-garamond font-inter
```

**Manual:** download from Google Fonts ([EB Garamond](https://fonts.google.com/specimen/EB+Garamond), [Inter](https://fonts.google.com/specimen/Inter)) and install into your OS font directory (`~/.local/share/fonts/` on Linux; run `fc-cache -fv` afterward).

Verify they're visible to XeLaTeX:
```sh
fc-list | grep -iE "garamond|inter|cormorant"
```

### Switching to the original custom fonts

`hunter.cls` includes an "Option B" block (commented out) that uses Vegur + Portland LDO. To use it, place the font files in a `fonts/` folder and swap the active block in the `FONT CONFIGURATION` section of `hunter.cls`.

## Publications

The publications section uses BibLaTeX + Biber. Add entries to `publications.bib`; `\nocite{*}` includes them all.
