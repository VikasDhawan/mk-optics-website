# Working notes for this repo

## Pixel-level image work: say so, don't grind

For anything involving precise visual composition — cropping a photo
around existing text, removing/replacing baked-in text in an image,
matching an exact reference design pixel-for-pixel — say up front that
a visual design tool (e.g. Claude Design) is likely a better fit than
doing it in code. Don't spend multiple rounds fighting it with Python/
PIL/OpenCV (crop guessing, patch-pasting, blur-blending, inpainting)
before suggesting the alternative. That wastes time for everyone.

Plain HTML/CSS layout work (typography, colors, responsive grids,
matching a reference's *structure*) is a good fit for code and doesn't
need this caveat — it's specifically pixel-editing of flattened images
that doesn't belong here.

## Verify visual changes before reporting them done

Before saying a UI/visual change is complete, actually render the page
and look at it — don't just assert it based on reading the code.

This environment has a working setup for this:
- Playwright's Python package can be installed with `pip install playwright`.
- The browser binary is already present at
  `/opt/pw-browsers/chromium-1194/chrome-linux/chrome` — launch with
  `executable_path` pointing there directly (don't run
  `playwright install`, and don't assume the default lookup path
  matches the installed pip version).
- Serve the repo with `python3 -m http.server <port> --directory .`,
  then screenshot the relevant element/viewport before reporting.
- Check both a desktop width and a phone width (~390px) when the
  change touches layout — several bugs in this project only showed up
  on one or the other.

## Sending files for local preview

Sending files one at a time (e.g. via a file-send tool) does not
preserve relative folder structure on the recipient's end — a page
that references `images/foo.jpg` will show broken images if `foo.jpg`
was sent as a separate, individually-saved file. Bundle the page and
everything it references into a single zip before sending for local
preview.
