/**
 * Copyright (c) 2015 egg82 (Alexander Mason)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package egg82.math {
	import flash.display.BitmapData;
	import starling.display.Graphics;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class Vector2D {
		//vars
		private var _x:Number;
		private var _y:Number;
		
		//constructor
		public function Vector2D(x:Number = 0, y:Number = 0) {
			_x = x;
			_y = y;
		}
		
		//public
		public function clone():Vector2D {
			return new Vector2D(_x, _y);
		}
		
		public function zero():void {
			_x = 0;
			_y = 0;
		}
		public function isZero():Boolean {
			return _x == 0 && _y == 0;
		}
		public function isNormalized():Boolean {
			return length == 1;
		}
		public function equals(vector:Vector2D):Boolean {
			return _x == vector.x && _y == vector.y;
		}
		
		public function get length():Number {
			return Math.sqrt(_x * _x + _y * _y);
		}
		public function set length(value:Number):void {
			var _angle:Number = angle;
			_x = Math.cos(_angle) * value;
			_y = Math.sin(_angle) * value;
			if(Math.abs(_x) < 0.00000001) _x = 0;
			if(Math.abs(_y) < 0.00000001) _y = 0;
		}
		
		public function get angle():Number {
			return Math.atan2(_y, _x);
		}
		public function set angle(value:Number):void {
			var len:Number = length;
			_x = Math.cos(value) * len;
			_y = Math.sin(value) * len;
		}
		
		public function normalize():void {
			if(length == 0){
				_x = 1;
				return;
			}
			
			var len:Number = length;
			_x /= len;
			_y /= len;
		}
		public function truncate(max:Number):void {
			length = Math.min(max, length);
		}
		public function reverse():void {
			_x = -_x;
			_y = -_y;
		}
		public static function distance(vector1:Vector2D, vector2:Vector2D):Number {
			var dx:Number = vector2.x - vector1.x;
			var dy:Number = vector2.y - vector1.y;
			
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		public function dotProduct(vector:Vector2D):Number {
			return _x * vector.x + _y * vector.y;
		}
		public function crossProduct(vector:Vector2D):Number {
			return _x * vector.y - _y * vector.x;
		}
		
		public static function angle(vector1:Vector2D, vector2:Vector2D):Number {
			if (!vector1.isNormalized()) {
				vector1 = vector1.clone();
				vector1.normalize();
			}
			
			if (!vector2.isNormalized()) {
				vector2 = vector2.clone();
				vector2.normalize();
			}
			
			return Math.acos(vector1.dotProduct(vector2));
		}
		public function sign(vector:Vector2D):int {
			return perpendicular.dotProduct(vector) < 0 ? -1 : 1;
		}
		public function get perpendicular():Vector2D {
			return new Vector2D(-_y, _x);
		}
		
		public function add(vector:Vector2D):void {
			_x += vector.x;
			_y += vector.y;
		}
		public function subtract(vector:Vector2D):void {
			_x -= vector.x;
			_y -= vector.y;
		}
		public function multiply(scalar:Number):void {
			_x *= scalar;
			_y *= scalar;
		}
		public function divide(scalar:Number):void {
			_x /= scalar;
			_y /= scalar;
		}
		
		public function get y():Number {
			return _y;
		}
		public function set y(value:Number):void {
			_y = value;
		}
		
		public function get x():Number {
			return _x;
		}
		public function set x(value:Number):void {
			_x = value;
		}
		
		public function fromString(string:String):void {
			var tx:Number;
			var ty:Number;
			
			tx = int(string.substr(string.indexOf("x:"),string.indexOf(",")));
			ty = int(string.substr(string.indexOf("y:")));
			
			_x = tx;
			_y = ty;
		}
		public function toString():String {
			return "Vector2D x:" + _x + ", y:" + _y;
		}
		
		public function draw(graphics:Graphics, color:uint = 0x00FF00):void {
			graphics.lineStyle(0, color);
			graphics.moveTo(0, 0);
			graphics.lineTo(_x, _y);
		}
		public function drawPoint(graphics:Graphics, color:uint = 0x00FF00):void {
			graphics.beginFill(color);
			graphics.drawRect(_x, _y, 1, 1);
			graphics.endFill();
		}
		
		public function drawBMD(bmd:BitmapData, color:uint = 0xFF00FF00):void {
			var shortLen:int = _y;
			var longLen:int = _x;
			var yLonger:Boolean = false;
			var i:int;
			
			if ((shortLen ^ (shortLen >> 31)) - (shortLen >> 31) > (longLen ^ (longLen >> 31)) - (longLen >> 31)) {
				shortLen ^= longLen;
				longLen ^= shortLen;
				shortLen ^= longLen;
				
				yLonger = true;
			}
			
			var inc:int = (longLen < 0) ? -1 : 1;
			var multDiff:Number = (longLen == 0) ? shortLen : shortLen / longLen;
			
			if (yLonger) {
				for (i = 0; i != longLen; i += inc) {
					bmd.setPixel32(i * multDiff, i, color);
				}
			} else {
				for (i = 0; i != longLen; i += inc) {
					bmd.setPixel32(i, i * multDiff, color);
				}
			}
		}
		public function drawPointBMD(bmd:BitmapData, color:uint = 0xFF00FF00):void {
			bmd.setPixel32(_x, _y, color);
		}
		
		//private
		
	}
}