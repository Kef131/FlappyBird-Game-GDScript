#Copyright (c) 2017 Yakanda Studios | Mantra: Going to next level

#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.
extends Node

export(int) var limit_repeater_floor = 50
export(int) var limit_repeater_obstacule = 50
export(int) var limit_obstacules_in_screen = 10
export(int) var limit_floor_in_screen = 1
export(int) var quantity_obstacules = 3

var camera = null
var position_camera = null
var scene_obstacule_instance = null
var scene_floor_instance = null
var array_floors = []
var array_obstacules = []
var start_position_obs = 0
var start_position_floor = 0
var next_position_obstacule = Vector3(0,0,0)
var next_position_floor = Vector3(0,0,0)
var scene_obstacule = preload("res://Scenario/Obstacules.tscn")
var scene_floor = preload("res://Scenario/Floor.tscn")

const SCALE_FLOOR = Vector3(80,10,150)

func _ready():
	camera = get_node("../Camera")
	#Main objects to begin the escenario
	scene_floor_instance = scene_floor.instance()
	scene_floor_instance.set_scale(SCALE_FLOOR)
	array_floors.append(scene_floor_instance)
	add_child(scene_floor_instance)
	scene_obstacule_instance = scene_obstacule.instance()
	array_obstacules.append(scene_obstacule_instance)
	next_position_obstacule = scene_obstacule_instance.get_transform().origin
	add_child(scene_obstacule_instance)
	for i in range(3):
		scene_obstacule_instance = scene_obstacule.instance()
		array_obstacules.append(scene_obstacule_instance)
		next_position_obstacule.z  += 20
		scene_obstacule_instance.set_translation(next_position_obstacule)
		add_child(scene_obstacule_instance)
	#Getting inicial position of first object of floor and obstacule
	start_position_obs = camera.get_transform().origin.z
	start_position_floor = camera.get_transform().origin.z
	
#The camera moves in relation at the traslation of the camera, this involves the creation of the scenario too.
func _process(delta):
	position_camera = camera.get_transform().origin
	#Getting the distance between the initial and last position in order to generate new obstacules
	if ( difference(start_position_obs, round(position_camera.z)) == limit_repeater_obstacule):
		start_position_obs = round(position_camera.z)
		repeater_obstacule(quantity_obstacules)
	elif (difference(start_position_floor, round(position_camera.z)) == limit_repeater_floor):
		start_position_floor = round(position_camera.z)
		repeater_floor()
	
#	print("Obstacules: " + str(array_obstacules.size() ) )
	if ( array_obstacules.size() > limit_obstacules_in_screen ):
		delete_object(array_obstacules)
		 
	if( array_floors.size() > limit_floor_in_screen):
		delete_object(array_floors)
		
#Function to define hoy many obstacules you want to repeat
func repeater_obstacule(quantity_obstacules):
	for i in range(quantity_obstacules):
		next_position_obstacule.z += 20
		osbtacule_flappy(next_position_obstacule)

#Function to repeat the floor
func repeater_floor():
	next_position_floor.z += 50
	floor_flappy(next_position_floor)

#Function to create obstacules, it-s necessary move the new object to don't overlapping
func osbtacule_flappy(z_distance):
	scene_obstacule_instance = null
	scene_obstacule_instance = scene_obstacule.instance()
	scene_obstacule_instance.set_translation(z_distance)
	array_obstacules.append(scene_obstacule_instance)
	add_child(scene_obstacule_instance)
	
#Function to create floors, it-s necessary move and scale the new object to don't overlapping
func floor_flappy(z_distance):
	scene_floor_instance = null
	scene_floor_instance = scene_floor.instance()
	scene_floor_instance.set_translation(z_distance)
	scene_floor_instance.set_scale(SCALE_FLOOR)
	array_floors.append(scene_floor_instance)
	add_child(scene_floor_instance)

#Function to delete objects from the scene and array of objects
func delete_object(array_objects):
	var target_delete = array_objects.front()
	target_delete.free()
	array_objects.pop_front() 

#helper function to obtain the diference of distance , you can use the formula of distance that you desire
func difference(first_distance, second_distance):
	var dif = abs( ( first_distance - round(second_distance)) )
	return dif