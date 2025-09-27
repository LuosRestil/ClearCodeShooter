extends CharacterBody2D

signal took_hit()

func take_hit():
	took_hit.emit()
