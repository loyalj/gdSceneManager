extends Node

var currentScene = null
var nextScenePath = null
var transitionMask = null


func _ready():
	var root = get_tree().root
	currentScene = root.get_child(root.get_child_count() - 1)

# Switch the scene at the next best time, with no transition
func switch_scene(newScenePath):
	call_deferred("_deferred_switch_scene", newScenePath)

# Switch the scene at the next best time, with no transition
func _deferred_switch_scene(newScenePath):
	# Free Up the running scene
	currentScene.free()
	
	# Load the scene we want to switch to
	var newScene = load(newScenePath)
	currentScene = newScene.instantiate()
	
	# Add the new scene to the root
	get_tree().root.add_child(currentScene)
	get_tree().root.move_child(currentScene, 1)
	get_tree().current_scene = currentScene

# Switch the scene at the next best time, with a transition
func transition_scene(newScenePath, transitionName):
	call_deferred("_deferred_transition_scene", newScenePath, transitionName)

# Switch the scene at the next best time, with a transition
func _deferred_transition_scene(newScenePath, transitionName):
	# Store the scene we want to transition to so we can use it again when the animation is complete
	nextScenePath = newScenePath
	
	# Setup everything for the selected transition
	var transitionSceneToLoad = ""
	var entryAnimationToPlay = ""
	
	match transitionName:
		"fade_in_out":
			transitionSceneToLoad = "res://modules/scene_transitions/fade_mask.tscn"
			entryAnimationToPlay = "fade_in"
		
		"swipe_in_out_right":
			transitionSceneToLoad = "res://modules/scene_transitions/swipe_mask.tscn"
			entryAnimationToPlay = "swipe_in_right"
		
		"shrink_out":
			transitionSceneToLoad = "res://modules/scene_transitions/shrink_mask.tscn"
			entryAnimationToPlay = "shrink_none"
	
	#Load and play the selected Transition
	transitionMask = load(transitionSceneToLoad)
	transitionMask = transitionMask.instantiate()
	get_tree().root.add_child(transitionMask)
	
	# Pause the game while transitions are occuring
	get_tree().paused = true
	
	# Setup the animation complete signal catcher, then play the transition animation
	transitionMask.animationPlayer.animation_finished.connect(_on_animation_finished)
	transitionMask.animationPlayer.play(entryAnimationToPlay)

# Listen for the animation events of scene transitions and complete then scene swap 
func _on_animation_finished(animationName):
	
	var entryAnimation = false
	var exitAnimation = ""
	
	match animationName:
		"fade_in":
			entryAnimation = true
			exitAnimation = "fade_out" 
		"swipe_in_right":
			entryAnimation = true
			exitAnimation = "swipe_out_right"
		"shrink_none":
			entryAnimation = true
			exitAnimation = "shrink_out"
	
	#If it's an entry animation then trigger the scene switch and play the animation
	#If it's an exit animation then just clean up the mask and unpause the game
	if(entryAnimation):
		switch_scene(nextScenePath)
		transitionMask.animationPlayer.play(exitAnimation)
	else:
		transitionMask.queue_free()
		get_tree().paused = false
