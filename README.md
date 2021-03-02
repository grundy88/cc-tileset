# Chip's Challenge Tileset Generator

This tool will generate an image file containing tiles for Chip's Challenge.

## Prerequisites
* ImageMagick (uses `convert` and `composite`, for mac: `brew install imagemagick`)
* PovRAY (intel mac binary in the `povray` dir)

_TODO_ configurable locations of these (currently `convert` and `composite` must be on the PATH, and PovRAY location is hard coded)

## Usage
`generate.sh [-s SETTYPE] [-i INSTALL_DEST] [-r] [-c] [-t TILECODE]`

* `-s`: specify the image layout
    * `twlynx`: Tile World (large format - animated)
    * `twms`: Tile World (small format)
    * `ms`: original Microsoft layout

* `-i`: "install" (aka copy) the generated image file to INSTALL_DEST (ie. into your Tile World `res` folder)

* `-r`: replace the entire image file with the original one first (means, start over, otherwise any existing previously generated tileset image file will be modified - if the work dir still exists)

* `-c`: skip rendering, do tileset image file compositing only

* `-t`: operate on a specific tile only (codes are hard coded in the script and begin with 0)

## How It Works
* Everything happens in the `work` subdirectory.
* Tiles that are rendered are done so using `PovRAY`, using scene files from this dir to generate individual tile pngs in the work dir
* Tiles are then composited over the original tileset image (either rendered images or source images from this dir, depending on the tile)
* `work/cc.png` is the final output
