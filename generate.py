from PIL       import Image
from math      import sqrt
from sys       import argv

def CLAMP01(x):
	return max(min(x, 1), 0)

def falloff(relX, relY, size):
	value = relX ** 2 + relY ** 2 + 1

	return CLAMP01((1 - CLAMP01(sqrt(value) / size)) * (1 / (sqrt(value + 1))))

if len(argv) < 2:
	print("Not enough argument supplied.")
	quit()

size           = int(argv[1])

imageSize      = ((size * 2) - 1) * 32

GreyScaleImage = Image.new("RGB", (imageSize, imageSize))

pixels         = GreyScaleImage.load()

for x in range(imageSize):
	for y in range(imageSize):
		x2    = (x - (imageSize / 2)) / 32
		y2    = (y - (imageSize / 2)) / 32
		alpha = falloff(x2, y2, size) * 255

		print("x: %s, y: %s, x2: %s, y2: %s alpha: %s" % (x, y, x2, y2, alpha))
		pixels[x, y] = (int(alpha), int(alpha), int(alpha))

GreyScaleImage.show()
GreyScaleImage.save("test.png")

# Now we divide all of that into 32x32 images!
for x in range(int(imageSize / 32)):
	for y in range(int(imageSize / 32)):
		region = (x * 32, y * 32, 32 + (x * 32), 32 + (y * 32))
		cropped = GreyScaleImage.crop(region)
		cropped.save("test %s-%s.png" % (x, y))
