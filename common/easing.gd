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

class_name Easing

const EPSILON := 1e-5

class Quad:
	static func ease_in(start: float, end: float, value: float) -> float:
		end -= start
		return end * value * value + start

	
	static func ease_out(start: float, end: float, value: float) -> float:
		end -= start
		return -end * value * (value - 2) + start

	
	static func ease_in_out(start: float, end: float, value: float) -> float:
		value /= 0.5
		end -= start
		
		if value < 1:
			return end * 0.5 * value * value + start
		
		value -= 1.0
		return -end * 0.5 * (value * (value - 2) - 1) + start


class Cubic:
	static func ease_in(start: float, end: float, value: float) -> float:
		end -= start
		return end * value * value * value + start

	
	static func ease_out(start: float, end: float, value: float) -> float:
		value -= 1.0
		end -= start
		return end * (value * value * value + 1) + start

	
	static func ease_in_out(start: float, end: float, value: float) -> float:
		value /= 0.5
		end -= start
		
		if value < 1:
			return end * 0.5 * value * value * value + start
		
		value -= 2
		return end * 0.5 * (value * value * value + 2) + start


class Quart:
	static func ease_in(start: float, end: float, value: float) -> float:
		end -= start
		return end * value * value * value * value + start

	
	static func ease_out(start: float, end: float, value: float) -> float:
		value -= 1.0
		end -= start
		return -end * (value * value * value * value - 1) + start

	
	static func ease_in_out(start: float, end: float, value: float) -> float:
		value /= 0.5
		end -= start
		
		if value < 1:
			return end * 0.5 * value * value * value * value + start
		
		value -= 2
		return -end * 0.5 * (value * value * value * value - 2) + start


class Quint:
	static func ease_in(start: float, end: float, value: float) -> float:
		end -= start
		return end * value * value * value * value * value + start

	
	static func ease_out(start: float, end: float, value: float) -> float:
		value -= 1.0
		end -= start
		return end * (value * value * value * value * value + 1) + start

	
	static func ease_in_out(start: float, end: float, value: float) -> float:
		value /= 0.5
		end -= start
		
		if value < 1:
			return end * 0.5 * value * value * value * value * value + start
		
		value -= 2
		return end * 0.5 * (value * value * value * value * value + 2) + start


class Sine:
	static func ease_in(start: float, end: float, value: float) -> float:
		end -= start
		return -end * cos(value * (PI * 0.5)) + end + start

	
	static func ease_out(start: float, end: float, value: float) -> float:
		end -= start
		return end * sin(value * (PI * 0.5)) + start

	
	static func ease_in_out(start: float, end: float, value: float) -> float:
		end -= start
		return -end * 0.5 * (cos(PI * value) - 1) + start


class Expo:
	static func ease_in(start: float, end: float, value: float) -> float:
		end -= start
		return end * pow(2, 10 * (value - 1)) + start

	
	static func ease_out(start: float, end: float, value: float) -> float:
		end -= start
		return end * (-pow(2, -10 * value) + 1) + start

	
	static func ease_in_out(start: float, end: float, value: float) -> float:
		value /= 0.5
		end -= start
		
		if value < 1:
			return end * 0.5 * pow(2, 10 * (value - 1)) + start
		
		value -= 1.0
		return end * 0.5 * (-pow(2, -10 * value) + 2) + start


class Circ:
	static func ease_in(start: float, end: float, value: float) -> float:
		end -= start
		return -end * (sqrt(1 - value * value) - 1) + start

	
	static func ease_out(start: float, end: float, value: float) -> float:
		value -= 1.0
		end -= start
		return end * sqrt(1 - value * value) + start

	
	static func ease_in_out(start: float, end: float, value: float) -> float:
		value /= 0.5
		end -= start
		
		if value < 1:
			return -end * 0.5 * (sqrt(1 - value * value) - 1) + start
		
		value -= 2
		return end * 0.5 * (sqrt(1 - value * value) + 1) + start


class Linear:
	static func ease_in(start: float, end: float, value: float) -> float:
		return lerp(start, end, value)


class Spring:
	static func ease_in(start: float, end: float, value: float) -> float:
		value = clamp(value, 0, 1)
		value = (sin(value * PI * (0.2 + 2.5 * value * value * value)) * pow(1 - value, 2.2) + value) * (1 + (1.2 * (1 - value)))
		return start + (end - start) * value


class Bounce:
	static func ease_in(start: float, end: float, value: float) -> float:
		end -= start
		var d := 1.0
		return end - ease_out(0, end, d - value) + start

	
	static func ease_out(start: float, end: float, value: float) -> float:
		value /= 1.0
		end -= start
		
		if value < (1 / 2.75):
			return end * (7.5625 * value * value) + start

		if value < (2 / 2.75):
			value -= 1.5 / 2.75
			return end * (7.5625 * (value) * value + 0.75) + start
		
		if value < (2.5 / 2.75):
			value -= 2.25 / 2.75
			return end * (7.5625 * (value) * value + 0.9375) + start
		
		value -= 2.625 / 2.75
		return end * (7.5625 * (value) * value + 0.984375) + start

	
	static func ease_in_out(start: float, end: float, value: float) -> float:
		end -= start
		var d := 1.0

		if value < d * 0.5:
			return ease_in(0, end, value * 2) * 0.5 + start

		return ease_out(0, end, value * 2 - d) * 0.5 + end * 0.5 + start


class Back:
	static func ease_in(start: float, end: float, value: float) -> float:
		end -= start
		value /= 1.0
		var s := 1.70158

		return end * (value) * value * ((s + 1) * value - s) + start

	
	static func ease_out(start: float, end: float, value: float) -> float:
		var s := 1.70158
		end -= start
		value -= 1
		return end * ((value) * value * ((s + 1) * value + s) + 1) + start

	
	static func ease_in_out(start: float, end: float, value: float) -> float:
		var s := 1.70158
		end -= start
		value /= 0.5
		
		if value < 1:
			s *= 1.525
			return end * 0.5 * (value * value * (((s) + 1) * value - s)) + start
		
		value -= 2
		s *= 1.525
		return end * 0.5 * ((value) * value * (((s) + 1) * value + s) + 2) + start


class Elastic:
	static func ease_in(start: float, end: float, value: float) -> float:
		end -= start

		var d := 1.0
		var p := d * 0.3
		var s := 0.0
		var a := 0.0

		if abs(value) < EPSILON:
			return start

		value /= d
		if abs(value - 1) < EPSILON:
			return start + end

		if abs(a) < EPSILON or a < abs(end):
			a = end
			s = p / 4
		else:
			s = p / (2 * PI) * asin(end / a)

		var v =	value - 1
		return -(a * pow(2, 10 * v) * sin((value * d - s) * (2 * PI) / p)) + start

	
	static func ease_out(start: float, end: float, value: float) -> float:
		end -= start

		var d := 1.0
		var p := d * 0.3
		var s := 0.0
		var a := 0.0

		if abs(value) < EPSILON:
			return start

		value /= d
		if abs(value - 1) < EPSILON:
			return start + end

		if abs(a) < EPSILON or a < abs(end):
			a = end
			s = p / 4
		else:
			s = p / (2 * PI) * asin(end / a)

		return a * pow(2, -10 * value) * sin((value * d - s) * (2 * PI) / p) + end + start

	
	static func ease_in_out(start: float, end: float, value: float) -> float:
		end -= start

		var d := 1.0
		var p := d * 0.3
		var s := 0.0
		var a := 0.0

		if abs(value) < EPSILON:
			return start

		value /= d
		if abs((value * 0.5) - 2) < EPSILON:
			return start + end

		if abs(a) < EPSILON or a < abs(end):
			a = end
			s = p / 4
		else:
			s = p / (2 * PI) * asin(end / a)

		if value < 1:
			var v =	value - 1
			return -0.5 * (a * pow(2, 10 * v) * sin((value * d - s) * (2 * PI) / p)) + start
		
		var v =	value - 1
		return a * pow(2, -10 * v) * sin((value * d - s) * (2 * PI) / p) * 0.5 + end + start
