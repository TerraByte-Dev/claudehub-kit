# docs/assets

| File | What it is |
|------|------------|
| `icm-doc-wordmark.svg` | The README hero. Hand-authored SVG — a CRT panel with an amber phosphor `ICM·DOC` wordmark. Self-contained: it carries its own dark background, so it reads the same in GitHub's light and dark themes. |
| `terrabyte-logo.png` | The TerraByte Solutions mark used in the README footer. |

## Swapping the hero for a generated PNG

The SVG exists so the repo has a working hero with no toolchain. If you'd rather render a raster
wordmark, generate it at **1200 × 360** (or 2400 × 720 for retina), save it as
`icm-doc-wordmark.png`, and change the one `<img>` at the top of the root `README.md`.

Prompt used to describe the current mark, if you want a matching generation:

> A wide horizontal wordmark on a near-black CRT monitor panel with softly rounded corners and a
> faint amber bloom in the center. Fine horizontal scanlines across the whole panel. Centered
> heavy monospace text reading **ICM·DOC** in warm amber phosphor (#FFB000), with a soft
> analog glow and slight bleed, as if photographed off a 1980s amber terminal. Above it, small
> dim amber terminal text: `>_ diagnose --structure`. Below the wordmark, a thin amber rule, then
> small wide-tracked amber caps reading INTERPRETABLE CONTEXT METHODOLOGY. No people, no icons,
> no drop shadows outside the panel, flat vector-clean composition, generous margins.

Keep the amber (`#FFB000` / `#FFC44D`) — it's this repo's accent, and the README badges match it.
