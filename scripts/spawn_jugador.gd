extends Area2D

var estaVacio: bool:
	get:
		return (!has_overlapping_areas() && !has_overlapping_bodies())
