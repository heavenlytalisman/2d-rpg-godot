extends CharacterBody2D

const speed = 100
var current_dir = "none"

var attack_ip = false

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 150
var player_alive = true





func _ready():
	$AnimatedSprite2D.play("front_Idle")


func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	
	if health <= 0:
		player_alive = false #add inscreen/gameover screen
		health = 0
		print("player has been killed")
		self.queue_free()
		
	
func player_movement(delta):
	
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
		
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
		
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.y = speed
		velocity.x = 0
		
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.y = -speed
		velocity.x = 0
		
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()
	

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_Walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_Idle")
			
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_Walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_Idle")
			
	if dir == "down":
		anim.flip_h = true
		if movement == 1:
			anim.play("front_Walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("front_Idle")
			
	if dir == "up":
		anim.flip_h = true
		if movement == 1:
			anim.play("back_Walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("back_Idle")
			
			
			
func player():
	pass
		
		
		
		
func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true


func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false
		
		
func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)
	
		
func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true
	
	
func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_ip = true
		
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_Attack")
			$deal_attack_timer.start()
			
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_Attack")
			$deal_attack_timer.start()
		
		if dir == "down":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("front_Attack")
			$deal_attack_timer.start()
			
		if dir == "up":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("back_Attack")
			$deal_attack_timer.start()
		


func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false
