# UNTESTED LLM CODE

@tool
extends EditorScript

const TILESET_PATH := "res://resources/tilesets/interior_tileset.tres"
const FROM_PHYS_LAYER := 0 # physics layer index to copy from
const MULTI_POLY_TO_MULTIPLE_OCCLUSION_LAYERS := false
# If true and a tile has multiple collision polygons, the script will ensure
# enough occlusion layers exist and place polygon 0 -> occl layer 0, polygon 1 -> occl layer 1, etc.

func _run() -> void:
	var ts: TileSet = load(TILESET_PATH)
	if ts == null:
		push_error("Couldn't load TileSet at %s" % TILESET_PATH)
		return

	# Make sure we have at least one occlusion layer
	if ts.get_occlusion_layers_count() == 0:
		ts.add_occlusion_layer()  # adds at the end

	# Optionally compute how many occlusion layers we need (if MULTI mode)
	var needed_layers := 1
	if MULTI_POLY_TO_MULTIPLE_OCCLUSION_LAYERS:
		var max_polys := 1
		for si in range(ts.get_source_count()):
			var sid := ts.get_source_id(si)
			var src := ts.get_source(sid)
			if src is TileSetAtlasSource:
				for ti in range(src.get_tiles_count()):
					var coords: Vector2i = src.get_tile_id(ti)
					var alt_count := src.get_alternative_tiles_count(coords)
					for ai in range(alt_count):
						var alt_id := src.get_alternative_tile_id(coords, ai)
						var td: TileData = src.get_tile_data(coords, alt_id)
						if td:
							max_polys = maxi(max_polys, td.get_collision_polygons_count(FROM_PHYS_LAYER))
		needed_layers = max(1, max_polys)
		while ts.get_occlusion_layers_count() < needed_layers:
			ts.add_occlusion_layer()

	# Copy physics polygons -> occluder(s)
	var tiles_touched := 0
	for si in range(ts.get_source_count()):
		var sid := ts.get_source_id(si)
		var src := ts.get_source(sid)
		if src is TileSetAtlasSource:
			for ti in range(src.get_tiles_count()):
				var coords: Vector2i = src.get_tile_id(ti)
				var alt_count := src.get_alternative_tiles_count(coords)
				for ai in range(alt_count):
					var alt_id := src.get_alternative_tile_id(coords, ai)
					var td: TileData = src.get_tile_data(coords, alt_id)
					if td == null:
						continue

					var pcount := td.get_collision_polygons_count(FROM_PHYS_LAYER)
					if pcount <= 0:
						continue

					if MULTI_POLY_TO_MULTIPLE_OCCLUSION_LAYERS:
						for pi in range(pcount):
							var occ := OccluderPolygon2D.new()
							occ.polygon = td.get_collision_polygon_points(FROM_PHYS_LAYER, pi)
							td.set_occluder(pi, occ) # polygon i -> occlusion layer i
					else:
						# Single occluder per tile: use the first polygon
						var occ := OccluderPolygon2D.new()
						occ.polygon = td.get_collision_polygon_points(FROM_PHYS_LAYER, 0)
						td.set_occluder(0, occ)

					tiles_touched += 1

	var err := ResourceSaver.save(ts, TILESET_PATH)
	if err != OK:
		push_error("Save failed with code %s" % err)
	else:
		print("Done. Updated tiles:", tiles_touched)
