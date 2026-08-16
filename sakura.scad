// SAKURA — three-level 3D text logo
//
// Layers (inside → out), bottom-aligned at z = 0:
//   1. Pink text core          — height set by pink_height
//   2. White outline ring      — taller than purple (white_height)
//   3. Purple outline ring     — shortest layer (purple_height)
//
// Height order: purple < white. pink_height can be above or below white_height.
//
// Open in OpenSCAD and press F5 (preview) or F6 (render).
// Adjust parameters below to match your printer / desired scale.

// ── Text ──────────────────────────────────────────────────────────────────────
label       = "SAKURA";
font        = "Liberation Sans:style=Bold";  // try "Arial Black", "Comic Sans MS"
text_size   = 12;
spacing     = 0.92;   // letter spacing multiplier

// ── Outline widths (mm) ───────────────────────────────────────────────────────
white_width  = 1.4;
purple_width = 2.8;

// ── Extrusion heights (mm), all measured up from z = 0 ─────────────────────
purple_height = 2.0;   // shortest
white_height  = 4.0;   // taller than purple
pink_height   = 5.0;   // can be > or < white_height

// ── Corner roundness (mm) — 0 disables minkowski rounding ────────────────────
roundness = 0.6;

// ── Colors ────────────────────────────────────────────────────────────────────
pink_color   = [1.00, 0.82, 0.86];
white_color  = [1.00, 1.00, 1.00];
purple_color = [0.48, 0.18, 0.56];  // ≈ #7B2D8E

// ── 2D helpers ────────────────────────────────────────────────────────────────

module raw_text() {
  text(
    label,
    size     = text_size,
    font     = font,
    halign   = "center",
    valign   = "center",
    spacing  = spacing
  );
}

// Round letter corners to match the bubbly logo style.
module text_shape() {
  if (roundness > 0) {
    minkowski() {
      raw_text();
      circle(r = roundness, $fn = 24);
    }
  } else {
    raw_text();
  }
}

// Annulus between two offset distances from a 2D child shape.
module ring(inner, outer) {
  difference() {
    offset(r = outer) children();
    offset(r = inner) children();
  }
}

// ── 3D layers ─────────────────────────────────────────────────────────────────

// Level 1 — pink text core (top).
module pink_core() {
  color(pink_color)
    linear_extrude(height = pink_height, convexity = 10)
      text_shape();
}

// Level 2 — white outline ring (middle band on the top face).
module white_outline() {
  color(white_color)
    linear_extrude(height = white_height, convexity = 10)
      ring(inner = 0, outer = white_width)
        text_shape();
}

// Level 3 — purple outline ring (shortest).
module purple_outline() {
  color(purple_color)
    linear_extrude(height = purple_height, convexity = 10)
      ring(inner = white_width, outer = white_width + purple_width)
        text_shape();
}

// All layers share the same bottom at z = 0; each rises to its own height.
module sakura_logo() {
  purple_outline();
  white_outline();
  pink_core();
}

// ── Entry point ───────────────────────────────────────────────────────────────
sakura_logo();
