class_name SplashText
extends Node2D

var _original_text: String

var _final_text: String

var _skew_enabled: bool

var _skew_amount: float

var _exit_tween: Tween

@onready
var _duration_timer: Timer = $DurationTimer

@onready
var _exit_timer: Timer = $ExitTimer

@onready
var _rich_text_label: RichTextLabel = $RichTextLabel


func _ready() -> void:
	_duration_timer.start()
	if _final_text:
		_final_text = '[center]%s[/center]' % _final_text
		_rich_text_label.clear()
		_rich_text_label.append_text(_final_text)


func _process(delta: float) -> void:
	if _skew_enabled:
		_skew_amount += delta * 2.0
		skew = cos(_skew_amount) / 3.0


func set_text(text: String) -> SplashText:
	_original_text = text
	_final_text = tr(text)
	return self


func set_skew_effect() -> SplashText:
	_skew_enabled = true
	return self


func set_wave(freq: int, amp: int) -> SplashText:
	_final_text = "[wave freq=%d amp=%d]%s[/wave]" % \
		[freq, amp, _final_text]
	return self


func set_rainbow(freq: float, sat: float, val: float) -> SplashText:
	_final_text = "[rainbow freq=%.2f sat=%.2f val=%.2f]%s[/rainbow]" % \
		[freq, sat, val, _final_text]
	return self


func _on_duration_timer_timeout() -> void:
	_exit_timer.start()
	
	_exit_tween = create_tween() \
		.set_pause_mode(Tween.TWEEN_PAUSE_BOUND) \
		.set_process_mode(Tween.TWEEN_PROCESS_IDLE) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_LINEAR)
	
	_exit_tween \
		.tween_property(self, 'modulate:a', 0.0, _exit_timer.wait_time)


func _on_exit_timer_timeout() -> void:
	queue_free()
