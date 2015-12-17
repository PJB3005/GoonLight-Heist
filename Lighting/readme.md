# What is this?

This is the main lighting module, this is **not** plug and play, it requires the files in `/stubs` and `/helpers`.

# How does it work?
**Note:** This is a more technical and behind-the-scenes documentation of it, documentation for usage will be in the `/docs` folder.

First, every turf that has dynamic lighting enabled gets a single lighting overlay, the sprite of this overlay looks like this:

![](https://github.com/PJB3005/GoonLight-Heist/blob/master/icon.png)

While it may be hard to see, ever corner of the 32x32 sprite has its own channel filled:

* Top right: Alpha
* Top left: Blue
* Bottom left: Red (basically unnoticable, as there is no alpha)
* Bottom right: Green

Because each corner has a different channel, each corner can individual colours (and have them blend between the other corners) with a smart colour matrix.

The base of said colour matrix is this:

|r|g|b|a
-|-|-|-|-
r|0|0|0|0
g|0|0|0|0
b|0|0|0|0
a|0|0|0|0
c|0|0|0|255

This will result in the overlay appearing as a full blac square, and as such completely obstructs the tile.

If one wants to manipulate a certain
