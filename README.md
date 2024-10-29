# Blip Manager: Blips with info popups

#### ⭐ Check out our other resources on [Tebex](https://gamzky-scripts.tebex.io/) or in our [Discord](https://discord.com/invite/sjFP3HrWc3).
#### 📼 Preview video: [Streamable](https://streamable.com/la3460)

## Features

- Create blips with properties such as coordinates, sprite, label, and more.
- Update and delete existing blips.
- Handle blip overlays that provide additional information when hovering over or selecting blips.
- Automatically clean up blips when the resource is stopped.

## Installation

1. Place the script in your resource directory.
2. Ensure your resource is started in the server configuration.
3. Use the provided exports to interact with the blip system in your other scripts.

## Documentation

### `exports.gs_blips:CreateBlip(params)`
Creates a new blip on the map.
#### Parameters
- `params`: A table containing:
  - `coords` (required): Coordinates for the blip. Preferably a vector3, but any coordinate type will work.
  - `sprite` (required): The sprite ID for the blip. See [here](https://docs.fivem.net/game-references/blips/) for a list of sprites.
  - `label` (required): The label for the blip.
  - `scale` (optional): The scale of the blip (default is `1.0`).
  - `color` (optional): The color of the blip (default is `0`). See [here](https://docs.fivem.net/docs/game-references/blips/#blip-colors) for a list of colors.
  - `data` (optional): A table containing additional data for the blip.
    - `title` (optional): The title of the blip.
    - `description` (optional): The description of the blip.
  - `display` (optional): Display option for the blip (default is `4`).

#### Returns

A blip object with methods to modify or delete the blip.

### Methods of Blip Object

- `setData(newData)`: Updates the data associated with the blip.
- `setTitle(title)`: Sets the title of the blip.
- `setDescription(description)`: Sets the description of the blip.
- `setDisplayHandler(fn)`: Sets a custom display function for the blip.
- `delete()`: Deletes the blip from the map.

## Usage Examples

```lua
-- Example blip with default properties
exports.gs_blips:CreateBlip({
	coords = vector3(436.28, -993.07, 43.69),
	sprite = 60,
	scale = 1.3,
	color = 38,
	label = 'Police Station',
	data = {
		title = '👮🏽 Police Station',
		description = 'Mission Row Police Station is a key center for city police operations, equipped with holding cells, offices, and an impound lot.',
	},
})
```

```lua
-- Example blip with display handler
local blip = exports.gs_blips:CreateBlip({
	coords = vector3(189.69, -937.84, 30.69),
	sprite = 306,
	scale = 1.5,
	color = 5,
	label = 'Example blip',
	data = {
		title = 'Example blip',
		description = '',
	},
})

-- Example: Sets a random number each time the info box is opened
blip.setDisplayHandler(function()
	blip.setDescription('Random number: ' .. math.random(1, 100))
end)

-- Example: Delete the blip
blip.delete()
```

```lua
-- Delete a blip created with the CreateBlip export
exports.gs_blips:DeleteBlip(blipHandle)

-- Example: Get a blip object
local blip = exports.gs_blips:GetBlip(blipHandle)
```
