extends Node

signal player_set(p: Player)

var player : Player = null :
	set(value):
		player = value
		player_set.emit(player) 
