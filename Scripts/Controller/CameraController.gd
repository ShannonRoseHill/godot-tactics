extends Node
class_name CameraController

@export var _followSpeed: float = 3.0 # Sets the speed of the camera
var _follow: Node3D # Stores a node object for the camera to follow

var _minZoom = 5 # Set the minimum camera zoom height
var _maxZoom = 20 # Set the maximum camera zoom height
var _zoom = 10 # Set the current zoom level

var _minPitch = -90 # Stops the rotation of the camera when its pointing straight down
var _maxPitch = 0 # Stops the rotation of the camera when its level with the ground

# Update the position of the camera when following the tile selection indicator
func _process(delta):
	if _follow: # If the camera is following a node object,
		# use linear interpolation to calculate a point a specific percentage of the way between two given values;
		# helps achieve smooth camera movement when following the node object
		self.position = self.position.lerp(_follow.position, _followSpeed * delta)

# Creates a node object for the camera to follow		
func setFollow(follow: Node3D):
	if follow: # If there is a node object for the camera to follow,
		_follow = follow # store the object in the _follow variable

# Returns zoom values for orthogonal and perspective camera projection
# Pitch: the physical distance in millimeters between the centers of two adjacent pixels (or sub-pixels) on a screen
func Zoom(scroll: int):
	_zoom = clamp(_zoom + scroll, _minZoom, _maxZoom) # Clamps zoom values to not violate height boundaries
	
	if $Heading/Pitch/Camera3D.projection == Camera3D.PROJECTION_ORTHOGONAL: # If the camera is in orthogonal mode,
		$Heading/Pitch/Camera3D.position.z = 100 # lock down z-component of the node's position to avoid clipping
		$Heading/Pitch/Camera3D.size = _zoom # scale the size of the objects with the zoom value
	else:
		# Otherwise, the camera is in perspective mode
		# Update the position of the node's z-component with respect to the zoom value
		$Heading/Pitch/Camera3D.position.z = _zoom

# Rotate the camera around the node's x and y axes via the mouse's position	
func Orbit(direction: Vector2):
	
	# Horizontal rotation
	if direction.x !=0: # If there is a deviation from the initial location of the mouse's x-position,
		var headingSpeed = 2 # set the speed of the camera
		var headingAngle = $Heading.rotation.y # measure the degree of rotation from the y-axis
		headingAngle += direction.x * headingSpeed * get_process_delta_time() # update the angle as the mouse travels x-ward
		$Heading.rotation.y = headingAngle # rotate the camera around the y-axis
		
		# These while loops keep the rotation angle within the [-360, 360] degree range
		# Leaving the range unclamped allows the camera to make full rotations
		# $Heading.rotation requires radians, so conversion with deg_to_rad() is necessary
		while $Heading.rotation.y > deg_to_rad(360): # If the camera makes greater than a full positive rotation,
			$Heading.rotation.y -= deg_to_rad(720) # subtract two rotations from the node's position
		while $Heading.rotation.y < deg_to_rad(-360): # If the camera makes greater than a full negative rotation,
			$Heading.rotation.y += deg_to_rad(720) # add two rotation's to the node's position
	
	# Vertical rotation
	if direction.y != 0: # If there is a deviation from the initial location of the mouse's x-position,
		var orbitSpeed = 2 # set the speed of the camera
		var vAngle = direction.y # get the vertical angle from the mouse's y-position
		var orbitAngle = $Heading/Pitch.rotation.x # measure the degree of rotation from the x-axis
		orbitAngle += direction.y * orbitSpeed * get_process_delta_time() # update the angle as the mouse travels y-ward
		# Clamp the orbit angle so as to not rotate through the floor
		orbitAngle = clamp(orbitAngle, deg_to_rad(_minPitch), deg_to_rad(_maxPitch))
		$Heading/Pitch.rotation.x = orbitAngle # rotate around the x-axis

# Helper function to correctly orient directional input regardless of camera position
func AdjustedMovement(originalPoint: Vector2i):
	var angle = rad_to_deg($Heading.rotation.y) # Convert angle of rotation around the y-axis from radians to degrees
	
	# The code block below applies translation to directional input depending on the position of the camera
	if ((angle >= -45 && angle < 45) || (angle < -315 || angle >= 315)):
		return originalPoint # No translations necessary
	elif ((angle >= 45 && angle < 130) || (angle >= -315 && angle < -210)):
		return Vector2i(originalPoint.y, originalPoint.x * -1) # Reflect the x-component of the input
	elif ((angle >= 130 && angle < 210) || (angle >= -210 && angle < -130)):
		return Vector2i(originalPoint.x * -1, originalPoint.y * -1) # Reflect both the x and y-components of the input
	elif ((angle >= 210 && angle < 315) || (angle >= -130 && angle < -45)):
		return Vector2i(originalPoint.y * -1, originalPoint.x) # Reflects the y-component of the input
	else: # Otherwise, the camera's position should not effect the directional input
		print("Incorrect camera angle: " + str(angle))
		return originalPoint # No translations necessary
