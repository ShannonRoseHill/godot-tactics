# godot-tactics

The purpose of this project is to learn the basics of tactical RPG development.
I'll do this by analyzing design decisions from 7thSage's [Godot Tactics](https://theliquidfire.com/category/projects/godot-tactics/) series on the The Liquid Fire game programming blog.
This process will be a line-by-line code review with commenting and documentation.

<p>There are currently eighteen entries in the series, with the lastest being published on 29 August 2025.
Thus far, I have reviewed four entries:</p>

1. Intro & Setup
	+ Installing and configuring the game engine
	+ Organizing directories
	+ Importing assets
	+ Creating objects from meshes and materials

2. Board Generator
	+ Defining the Tile class
	+ Creating the BoardCreator plugin
	+ Implementing Grow and Shrink methods to add/remove tiles
	+ Implementing Save and Load methods for binary and JSON formats

3. Input & Camera
	+ Creating controller classes for directional input and camera movement
	+ Mapping input buttons
	+ Implementing a camera with zoom and rotation functionality
	+ Connecting signals for input and camera events

4. State Machine
	+ Implementing state machine pattern to manage input to the BattleController node
	+ Refactoring the cameraController
	+ Creating a BattleState class to register/unregister signal listeners
	+ Linking the BattleState class to the BattleController

<p>I am currently reviewing:</p>

5. Pathfinding
