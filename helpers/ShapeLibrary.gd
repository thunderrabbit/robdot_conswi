extends Node

func _ready():
	givenSwipe_showArray([Vector2(3,14),Vector2(3,15),Vector2(4,15)])
	
func givenSwipe_showArray(swipeCoordinates):
	var swipeDimensions = getSwipeDimensions(swipeCoordinates)
	print(swipeDimensions)
	createBitmap(swipeDimensions,swipeCoordinates)

# given coordinates of a swipe, return a Vector2
# of their width and height
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
	return Vector2(width,height)

func createBitmap(swipeDimensions,swipeCoordinates):
	var bitmapArray = []
	var width = swipeDimensions.x
	var height = swipeDimensions.y

	# fill array with zeroes
	for i in range(width * height):
		bitmapArray.append(0)

	print(bitmapArray)

