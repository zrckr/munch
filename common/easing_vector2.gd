## TERMS OF USE - EASING EQUATIONS
## Open source under the BSD License.
## Copyright (c) 2001 Robert Penner
## All rights reserved.
## Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
## Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
## Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
## Neither the name of the author nor the names of contributors may be used to endorse or promote products derived from this software without specific prior written permission.
## 
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
## THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE 
## FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES 
## LOSS OF USE, DATA, OR PROFITS OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
## (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

class_name EasingVector2

class Quad:
	static func ease_in(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Quad.ease_in(start.x, end.x, value),
			Easing.Quad.ease_in(start.y, end.y, value))

	static func ease_out(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Quad.ease_out(start.x, end.x, value),
			Easing.Quad.ease_out(start.y, end.y, value))

	static func ease_in_out(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Quad.ease_in_out(start.x, end.x, value),
			Easing.Quad.ease_in_out(start.y, end.y, value))


class Cubic:
	static func ease_in(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Cubic.ease_in(start.x, end.x, value),
			Easing.Cubic.ease_in(start.y, end.y, value))

	static func ease_out(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Cubic.ease_out(start.x, end.x, value),
			Easing.Cubic.ease_out(start.y, end.y, value))

	static func ease_in_out(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Cubic.ease_in_out(start.x, end.x, value),
			Easing.Cubic.ease_in_out(start.y, end.y, value))


class Quart:
	static func ease_in(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Quart.ease_in(start.x, end.x, value),
			Easing.Quart.ease_in(start.y, end.y, value))

	static func ease_out(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Quart.ease_out(start.x, end.x, value),
			Easing.Quart.ease_out(start.y, end.y, value))

	static func ease_in_out(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Quart.ease_in_out(start.x, end.x, value),
			Easing.Quart.ease_in_out(start.y, end.y, value))


class Quint:
	static func ease_in(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Quint.ease_in(start.x, end.x, value),
			Easing.Quint.ease_in(start.y, end.y, value))

	static func ease_out(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Quint.ease_out(start.x, end.x, value),
			Easing.Quint.ease_out(start.y, end.y, value))

	static func ease_in_out(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Quint.ease_in_out(start.x, end.x, value),
			Easing.Quint.ease_in_out(start.y, end.y, value))


class Sine:
	static func ease_in(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Sine.ease_in(start.x, end.x, value),
			Easing.Sine.ease_in(start.y, end.y, value))

	static func ease_out(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Sine.ease_out(start.x, end.x, value),
			Easing.Sine.ease_out(start.y, end.y, value))

	static func ease_in_out(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Sine.ease_in_out(start.x, end.x, value),
			Easing.Sine.ease_in_out(start.y, end.y, value))


class Expo:
	static func ease_in(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Expo.ease_in(start.x, end.x, value),
			Easing.Expo.ease_in(start.y, end.y, value))

	static func ease_out(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Expo.ease_out(start.x, end.x, value),
			Easing.Expo.ease_out(start.y, end.y, value))

	static func ease_in_out(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Expo.ease_in_out(start.x, end.x, value),
			Easing.Expo.ease_in_out(start.y, end.y, value))


class Circ:
	static func ease_in(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Circ.ease_in(start.x, end.x, value),
			Easing.Circ.ease_in(start.y, end.y, value))

	static func ease_out(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Circ.ease_out(start.x, end.x, value),
			Easing.Circ.ease_out(start.y, end.y, value))

	static func ease_in_out(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Circ.ease_in_out(start.x, end.x, value),
			Easing.Circ.ease_in_out(start.y, end.y, value))


class Linear:
	static func ease_in(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Linear.ease_in(start.x, end.x, value),
			Easing.Linear.ease_in(start.y, end.y, value))


class Spring:
	static func ease_in(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Linear.ease_in(start.x, end.x, value),
			Easing.Linear.ease_in(start.y, end.y, value))


class Bounce:
	static func ease_in(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Bounce.ease_in(start.x, end.x, value),
			Easing.Bounce.ease_in(start.y, end.y, value))

	static func ease_out(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Bounce.ease_out(start.x, end.x, value),
			Easing.Bounce.ease_out(start.y, end.y, value))

	static func ease_in_out(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Bounce.ease_in_out(start.x, end.x, value),
			Easing.Bounce.ease_in_out(start.y, end.y, value))


class Back:
	static func ease_in(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Back.ease_in(start.x, end.x, value),
			Easing.Back.ease_in(start.y, end.y, value))

	static func ease_out(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Back.ease_out(start.x, end.x, value),
			Easing.Back.ease_out(start.y, end.y, value))

	static func ease_in_out(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Back.ease_in_out(start.x, end.x, value),
			Easing.Back.ease_in_out(start.y, end.y, value))


class Elastic:
	static func ease_in(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Elastic.ease_in(start.x, end.x, value),
			Easing.Elastic.ease_in(start.y, end.y, value))

	static func ease_out(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Elastic.ease_out(start.x, end.x, value),
			Easing.Elastic.ease_out(start.y, end.y, value))

	static func ease_in_out(start: Vector2, end: Vector2, value: float) -> Vector2:
		return Vector2(
			Easing.Elastic.ease_in_out(start.x, end.x, value),
			Easing.Elastic.ease_in_out(start.y, end.y, value))
