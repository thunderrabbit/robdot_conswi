extends Node

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
		# translate coordinates to upper left is (0,0)
		tc = coord - upperleft
		bitmapArray[tc.x + tc.y * width] = 1
	return bitmapArray

func printBitmap(swipeDimensions,bitmapArray):
	bitmapArray.push_front(swipeDimensions.width)
	print(bitmapArray)
	if Helpers.debug_level > 0:
		var debout = get_node("/root/GameScene/DebugOutput")
		debout.set_text(String(bitmapArray))

