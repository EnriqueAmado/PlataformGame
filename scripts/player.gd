extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = -1500.0

var can_attack: bool = true
@export var attack_cooldown: float = 7

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		GameManager.playSoundFx(load("res://assets/Sounds/Retro Jump Simple C2 02.wav"))
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var run_multiplier = 1
	
	if Input.is_action_pressed("run"):
		
		run_multiplier = 1.75
	else:
		run_multiplier = 1
		
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED * run_multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * run_multiplier)
		
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		
	if velocity.x != 0:
		$AnimatedSprite2D.play("walk")
	else: 
		$AnimatedSprite2D.play("idle")
		
	move_and_slide()
	if Input.is_action_just_pressed('Magic'):
		attack_magic()
func attack_magic():
	if not can_attack:
		return
	can_attack = false
		
	var magicNode = load("res://scenes/magic_area.tscn")
	var newMagic = magicNode.instantiate()
		
	if $AnimatedSprite2D.flip_h == false:
		newMagic.direction = -1
	else:
		newMagic.direction = 1
		
	newMagic.set_position(%MagicSpawnPoint.global_transform.origin)
	
	get_parent().add_child(newMagic)
	
	GameManager.playSoundFx(load("res://assets/Sounds/Retro Magic Protection 01.wav"))
		
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
	
func KillPlayer():
		position = %RespawnPoint.position
		$AnimatedSprite2D.flip_h = false
		GameManager.playSoundFx(load("res://assets/Sounds/Retro Negative Short 21.wav"))
		GameManager.reset_level()
		get_tree().reload_current_scene()

func _on_death_area_body_entered(body: Node2D) -> void:
	KillPlayer()
	GameManager.playSoundFx(load("res://assets/Sounds/Retro Negative Short 23.wav"))
	
func _process(delta):
	# Supongamos que quieres usar la tecla F5 para guardar
	if Input.is_action_just_pressed("save_game"):
		save_current_game()

func save_current_game():
	var current_level_node = get_tree().current_scene
	var current_level = current_level_node.level_path
	GameManager.save_game(global_position, current_level)
	print("Partida guardada!")

	
