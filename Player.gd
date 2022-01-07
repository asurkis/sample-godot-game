extends Area2D

signal hit

export var acceleration = 2000
export var speed = 400
var screen_size
var target = Vector2()
var velocity = Vector2()

func _ready():
	screen_size = get_viewport_rect().size
	disable()

func _input(event):
	if event is InputEventScreenDrag:
		target = event.position
	if event is InputEventScreenTouch and event.pressed:
		target = event.position

func _process(delta):
	var acc = Vector2()
	if position.distance_to(target) > 10:
		acc = target - position
	if acc.length() > 0:
		acc = acc.normalized() * acceleration
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	# velocity = speed => resistance = acc
	# resistance = v * k
	# speed * k = acceleration
	var resistance = velocity * (acceleration / speed)
	var old_velocity = velocity
	velocity += (acc - resistance) * delta
	position += (velocity + old_velocity) * (delta / 2)
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_h = velocity.x < 0
		$AnimatedSprite.flip_v = false
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.flip_v = velocity.y > 0

func _on_Player_body_entered(_body):
	disable()
	emit_signal("hit")

func disable():
	hide()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.set_deferred("disabled", false)
