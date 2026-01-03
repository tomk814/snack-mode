extends Node
@export var mob_scene: PackedScene
@export var treat_scene: PackedScene

var score
var treat = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#new_game()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$TreatTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("treats", "queue_free")
	$Music.play()

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$TreatTimer.start()
	$ScoreTimer.start()

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)


func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = $SpawnPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	mob.position = mob_spawn_location.position
	
	var direction = mob_spawn_location.rotation + PI/2
	
	direction += randf_range(-PI/4, PI/4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
	

func _on_player_score() -> void:
	score += 10
	$HUD.update_score(score)


func _on_treat_timer_timeout() -> void:
	var treat = treat_scene.instantiate()
	
	var treat_spawn_location = $SpawnPath/TreatSpawnLocation
	treat_spawn_location.progress_ratio = randf()
	
	treat.position = treat_spawn_location.position
	
	var direction = treat_spawn_location.rotation + PI/2
	
	direction += randf_range(-PI/4, PI/4)
	treat.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	treat.linear_velocity = velocity.rotated(direction)
	
	add_child(treat)
