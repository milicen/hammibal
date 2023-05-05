extends Node

var _base62chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".split('')

func generate_uid(length):
	var sb = []

	for i in length:
		sb.append(_base62chars[randi() % 36])

	return ''.join(sb);
