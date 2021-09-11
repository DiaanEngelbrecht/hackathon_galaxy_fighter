extends ParallaxBackground

export var scrolling_speed = 200

func _process(delta):
	scroll_offset.y += scrolling_speed * delta
