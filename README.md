# Resume & CV

LaTeX resume and CV templates (single column, Overleaf-ready).

- `Resume/` -- one-page resume. Source: `resume.tex`, class: `resume.cls`, output: `resume.pdf`.
- `CV/` -- longer CV (publications, awards, certifications, volunteering). Source: `cv.tex`, class: `cv.cls`, output: `cv.pdf`.

Each directory ships its own class file so it can be uploaded to Overleaf as a self-contained zip. The two classes are near-identical; keep them in sync by hand when tweaking shared macros.

## Compile on Overleaf

1. Zip the contents of `Resume/` (or `CV/`): the `.tex`, the `.cls`, and `publications.bib`.
2. In Overleaf: **New Project → Upload Project** and upload the zip.
3. **Menu → Settings → Compiler:** `XeLaTeX` (required for `fontspec`).
4. **Menu → Settings → TeX Live version:** a recent year (so `biber` is available).
5. Set the `.tex` file as the main document and click **Recompile**. Overleaf runs `biber` automatically.

EB Garamond and Inter ship with Overleaf, so no font upload is needed.

## Compile locally

Requires a TeX distribution with XeLaTeX and Biber (TeX Live, MacTeX, or MiKTeX). From inside `Resume/` or `CV/`:

```sh
latexmk -xelatex <name>.tex   # resume.tex or cv.tex
```

Or the manual sequence:

```sh
xelatex <name>.tex
biber   <name>
xelatex <name>.tex
xelatex <name>.tex
```

### Fonts

The class loads these families via `fontspec`:

- **EB Garamond** (body)
- **Inter** (headings; Thin and Regular)

Install them system-wide before compiling.

**Arch / CachyOS:**
```sh
sudo pacman -S otf-eb-garamond inter-font
```

**Debian / Ubuntu:**
```sh
sudo apt install fonts-ebgaramond fonts-inter
```

**macOS (Homebrew):**
```sh
brew install --cask font-eb-garamond font-inter
```

**Manual:** download from Google Fonts ([EB Garamond](https://fonts.google.com/specimen/EB+Garamond), [Inter](https://fonts.google.com/specimen/Inter)) and install into your OS font directory (`~/.local/share/fonts/` on Linux; run `fc-cache -fv` afterward).

Verify they're visible to XeLaTeX:
```sh
fc-list | grep -iE "garamond|inter"
```

To swap in different fonts, edit the `\newfontfamily` lines in the `FONT CONFIGURATION` section of `resume.cls` / `cv.cls`.

## Publications

The publications section uses BibLaTeX + Biber. Add entries to `publications.bib`; `\nocite{*}` includes them all. To bold your own name in the rendered bibliography, annotate the author position in the `.bib` entry, e.g. `author+an = {1=highlight}`.
