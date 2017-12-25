extends Node

func _ready():
	givenSwipe_showArray([Vector2(3,14),Vector2(3,15),Vector2(4,15)])
	givenSwipe_showArray([
Vector2(10,14),
Vector2(12,14),
Vector2(8,15),
Vector2(9,15),
Vector2(10,15),
Vector2(12,15),
Vector2(8,16),
Vector2(9,16),
Vector2(12,16),
Vector2(9,17),
Vector2(10,17),
Vector2(11,17),
Vector2(12,17)
])

func givenSwipe_showArray(swipeCoordinates):
	var swipeDimensions = getSwipeDimensions(swipeCoordinates)
	print(swipeDimensions)
	var bitmapArray = createBitmap(swipeDimensions,swipeCoordinates)
	printBitmap(swipeDimensions, bitmapArray)
# given coordinates of a swipe, return its width, height, top left, bottom right
func getSwipeDimensions(swipeCoordinates):
	# start somewhere and call it extreme
	var leftmost_x = swipeCoordinates[0].x
	var rightmost_x = swipeCoordinates[0].x
	var upmost_y = swipeCoordinates[0].y
	var downmost_y = swipeCoordinates[0].y


	for coord in swipeCoordinates:
		leftmost_x = min(leftmost_x,coord.x)
		rightmost_x = max(rightmost_x,coord.x)
		upmost_y = min(upmost_y,coord.y)
		downmost_y = max(downmost_y, coord.y)

	# see how wide/tall the swipe is
	var width = (rightmost_x - leftmost_x) + 1
	var height = (downmost_y - upmost_y) + 1

	return {'topleft': Vector2(leftmost_x,upmost_y),
			'botright': Vector2(rightmost_x, downmost_y),
			'width': width,
			'height': height}

func createBitmap(swipeDimensions,swipeCoordinates):
	var bitmapArray = []
	var width = swipeDimensions.width			# int
	var height = swipeDimensions.height			# int
	var upperleft = swipeDimensions.topleft		# Vector2
	var tc = Vector2(0,0)	# translated_coordinates

	# fill array with zeroes
	for i in range(width * height):
		bitmapArray.append(0)

	for coord in swipeCoordinates:
		tc = coord - upperleft
		bitmapArray[tc.x + tc.y * width] = 1
	return bitmapArray

func printBitmap(swipeDimensions,bitmapArray):
	print(bitmapArray)
	print("[%d," % swipeDimensions.width)
	print(bitmapArray)

