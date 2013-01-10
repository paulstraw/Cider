# Cider.js

Want to jump right in? [Here's the demo](http://paulstraw.com/cider).

Cider is some kind of HTML5 game engine, or whatever. It's currently under construction by [Paul Straw](http://paulstraw.com), and is in a somewhat usable state.

If you're looking to contribute, I recommend using [CodeKit](http://incident57.com/codekit/) to mash all the `./src` stuff down to one file, and [Docco](http://jashkenas.github.com/docco/) for documentation generation (`docco src/*.coffee`).

---

## Buzz

Cider ships with a tile-based level editor called Buzz, which you can find in the `./buzz` directory. Its input and output are constructors for Cider's `Level` and `Map` classes.

### Configuration

Buzz is very easy to configure with a simple JSON file (`./buzz/config.json`). Right now, it has just two properties: `resourcesPrefix` and `resources`. Since Buzz is designed for use inside Cider projects, `resourcesPrefix` allows you to use the same source images for the editor and your game; it's simply prepended to the url of every item inside `resources` (you won't need to change this if you're using the default directory structure). `resources` is used (and structured) in the same way as a Cider `Game` resources hash without the audio elements.

Here's an example config file to get you started:

``` javascript
{
	"resourcesPrefix": "../",
	"resources": {
		"bg tiles": "img/bgtiles.png",
		"fg tiles": "img/fgtiles.png",
		"stars": "img/stars.gif"
	}
}
```

### Usage
When you load Buzz, a default level is created for you with a `tileSize` of 32px, and `size` of 50x25 (1600x800px total). To scroll around the level, just right-click and drag around the editor portion of the screen.

New layers (which translate to Cider `Maps` on export) are created by clicking the plus button next to the "Layers" header, and selected by clicking on them. Once you've selected a layer, a new section called "Layer Options" will appear below the layers menu with layer-specific controls:

* Name: The layer's name (this is just for editing convenience).
* Type: Select whether this layer is aesthetic, or should be used for collision in-game.
* Tile Size: The size of each square tile in this layer.
* Distance: Used inside Cider for parallax scrolling; `1` moves with the camera, while higher numbers move more slowly (and therefore appear to be further away).
* Tileset: Loaded from the resources specified in `config.json`. When converted to Cider maps, these will appear with the "friendly" name (e.g., `tileset: 'fg tiles'`), so you should make sure your Buzz config's resources match up with your game's.
* zIndex: Does what it says on the tin. Lower numbers get drawn behind higher numbers. Cider `Entities` have a default z-index of `99`, so you'll want to keep that in mind if any of your layers should be drawn in front of your entities.

Once you've selected a layer's tileset (and changed its tile size appropriately), you can start drawing. Simply put your mouse over the main canvas and left-click (dragging works, too). Press space to bring up the tile selection screen, then click on a tile (or the "delete" icon) to change your brush. You can also hold cmd/ctrl and click to select whatever tile is below your cursor on the currently selected layer.

---

## License

Cider and Buzz are licensed under the MIT license. For details, see the COPYING file.