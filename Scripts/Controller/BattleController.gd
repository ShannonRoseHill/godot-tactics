extends Node
class_name BattleController

# This script manages the components of controllers

@export var board: BoardCreator
@export var inputController: InputController
@export var cameraController: CameraController
@export var stateMachine: StateMachine
@export var startState: State

func _ready():
	stateMachine.ChangeState(startState) # Sets the state machine's starting state
