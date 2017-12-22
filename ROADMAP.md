## Roadmap

* v0.0.0.1 add an Area2D to scene "Tile"
* v0.0.0.2 add a sprite to Area2D "TileSprite"
* v0.0.0.3 add mouse listener to Area2D
* v0.0.0.4 detect mouse

### v0.0.1.0 detected mouse

* v0.0.1.1 create a new scene to be GameScene
* v0.0.1.2 make new scene be the primary
* v0.0.1.3 instantiate tile programmatically
* v0.0.1.4 detect mouse

### v0.0.2.0 still detected mouse

* v0.0.2.1 add types to Tiles
* v0.0.2.2 randomly give type to Tile
* v0.0.2.3 change Tile color based on type
* v0.0.2.4 detect mouse

### v0.0.3.0 Tiles have types

* v0.0.3.1 add concept of game width and height
* v0.0.3.2 add board{} to track all Tiles
* v0.0.3.3 add player_tile_y_shadow to track player
* v0.0.3.4 tile on top center and shadow at bottom
* v0.0.3.5 mouse detection knows tile location

### v0.0.4.0 Tiles have shadows

* v0.0.4.1 Create Swipe Button scene
* v0.0.4.2 add sprite to it
* v0.0.4.3 add collision2D to it
* v0.0.4.4 Add it to screen at bottom
* v0.0.4.5 ensure it can see mouse
* v0.0.4.6 add buttons at bottom
* v0.0.4.7 buttons detect mouse
* v0.0.4.8 link buttons to move left and right
* v0.0.4.9 add bounds to tile movement

### v0.0.5.0 Tiles can be moved

* v0.0.5.1 add keyboard keys to move left and right
* v0.0.5.2 add keyboard key to move down
* v0.0.5.3 nail tiles to board if all the way down
* v0.0.5.4 detect mouse with nailed tiles

### v0.0.6.0 Tiles can be nailed

* v0.0.6.1 add minimum delay for moving tiles
* v0.0.6.2 add drop_tile option
* v0.0.6.3 nail tiles to board if all the way down
* v0.0.6.4 detect mouse with tiles which were dropped

### v0.0.7.0 Tiles can be moved timely

* v0.0.7.1 add Timer "Gravity"
* v0.0.7.2 add gravity to game via boolean
* v0.0.7.3 gray out tiles if game over
* v0.0.7.4 detect mouse with nailed tiles
* v0.0.7.5 no detect mouse with gray tiles

### v0.0.8.0 Tiles fall via gravity

* v0.0.8.1 highlight clicked piece
* v0.0.8.2 do not highlight falling piece
* v0.0.8.3 stop highlight if unclick
* v0.0.8.4 highlight mouseover piece
* v0.0.8.5 do not highlight other color piece
* v0.0.8.6 do not highlight non adjacent piece
* v0.0.8.7 keep list of highlighted pieces
* v0.0.8.8 unhighlight unmoused pieces
* v0.0.8.9 unhighlight all when unclick

### v0.0.9.0 Tiles can be highlighted

* v0.0.9.1 count pieces when unclick
* v0.0.9.2 remove highlighted pieces
* v0.0.9.3 move remaining pieces down
* v0.0.9.4 add queue for upcoming pieces
* v0.0.9.5 show upcoming pieces

### v.0.0.10.0   Pieces can be swiped
