extends Node

# Offset square layout.
var screen_offset_hex_layout := HexLayout.new(Vector3(63, 49, 0), Vector3.ZERO)

# Layout for display.  Used for translating between screen coordinates and hex coordinates.
#
# X is calculated manually because hexagons aren't perfect squares.  With 64x64 sprites,
# effectively each hexagon is 63x49 (offset squares), and for pixel perfect translation
# hexagons are: 63/sqrt(3) by size/2 or:
var pixel_hex_layout := HexLayout.new(Vector3(36.373066958946424, 32, 0), Vector3(32, 32, 0))

# Playing board size.
var board_hex_set := HexSets.rectangle(0, 11, 0, 11)

# Global RNG.
var rand := Random.new()

