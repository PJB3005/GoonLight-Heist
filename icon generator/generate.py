from __future__ import division # For all the nerds using Pyton 2.
from PIL        import Image
from math       import sqrt
from sys        import argv
from byond.DMI  import DMI, State

def CLAMP01(x):
	return max(min(x, 1), 0)

def falloff(relX, relY, size):
	value = relX ** 2 + relY ** 2 + 1

	return CLAMP01((1 - CLAMP01(sqrt(value) / size)) * (1 / (sqrt(value + 1))))

def makeDMI(image, dmi, stateName):
	state      = State(stateName)
	state.dirs = 1
	state.icons.append(image)

	dmi.states[stateName] = state

def main():
	if len(argv) < 2:
		print("Not enough argument supplied.")
		quit()
	
	size           = int(argv[1])
	
	imageSize      = ((size * 2) - 1) * 32
	
	GreyScaleImage = Image.new("RGBA", (imageSize, imageSize))
	
	pixels         = GreyScaleImage.load()

	# Go through all the pixels and apply the correct falloff to them.
	for x in range(imageSize):
		for y in range(imageSize):

			# We need coordinates so the center of the image is (0, 0) for the purposes of the falloff() formula.
			x2    = (x - (imageSize / 2)) / 32
			y2    = (y - (imageSize / 2)) / 32
			alpha = int(falloff(x2, y2, size) * 255)
	
			print("x: %s, y: %s, x2: %s, y2: %s alpha: %s" % (x, y, x2, y2, alpha))
			pixels[x, y] = (255, 255, 255, alpha)
	
	GreyScaleImage.show()
	GreyScaleImage.save("test.png")

	dmi = DMI("lighting_falloff_%s.dmi" % size)

	# Now we divide all of that into 32x32 images, and stick them in the DMI.
	for x in range(int(imageSize / 32)):
		for y in range(int(imageSize / 32)):
			region = (x * 32, y * 32, 32 + (x * 32), 32 + (y * 32))
			cropped = GreyScaleImage.crop(region)
			makeDMI(cropped, dmi, "%s-%s" % (x, y))

	dmi.save("lighting_falloff_%s.dmi")

if __name__ == "__main__":
	main()