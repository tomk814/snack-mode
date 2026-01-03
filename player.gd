extends Area2D
signal hit
signal score

@export var speed = 400
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x += -1
	if Input.is_action_pressed("move_up"):
		velocity.y += -1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		
	if velocity.length() > 0:
		rotation = atan2(velocity.y,velocity.x) + PI/2
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)


func _on_body_entered(body: Node2D) -> void:
	
	# Figure out which kind of thing hit you
	
	#DEBUG - how do I find out if "body" is a "Mob" or a "Treat"?
	
	if body.is_in_group("treats"):
		score.emit()
		$AudioStreamPlayer.play()
		body.queue_free()
		
	elif body.is_in_group("mobs"):
		hide() # Player disappears after being hit.
		hit.emit()
	
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
