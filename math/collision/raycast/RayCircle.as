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

package egg82.math.collision.raycast {
	import egg82.math.Vector2D;
	import flash.display.BitmapData;
	import starling.display.Graphics;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class RayCircle extends RayShape {
		//vars
		public var center:Vector2D;
		private var _radius:Number;
		
		//constructor
		public function RayCircle(center:Vector2D, radius:Number) {
			if (!center) {
				throw new Error("center cannot be null.");
			}
			if (radius < 0) {
				throw new Error("radius cannot be less than 0.");
			}
			
			_isPoly = false;
			
			this.center = center;
			_radius = radius;
		}
		
		//public
		public function get radius():Number {
			return _radius;
		}
		public function set radius(value:Number):void {
			if (value < 0) {
				throw new Error("radius cannot be less than 0.");
			}
			
			_radius = value;
		}
		
		override public function draw(graphics:Graphics, color:uint = 0x00FF00):void {
			graphics.lineStyle(1, color);
			graphics.drawCircle(center.x, center.y, _radius);
		}
		override public function drawPoint(graphics:Graphics, color:uint = 0x00FF00):void {
			center.drawPoint(graphics, color);
		}
		
		override public function drawBMD(bmd:BitmapData, color:uint = 0xFF00FF00):void {
			var sides:uint = 8;
			var i:uint;
			
			for (i = 1; i <= _radius; i++) {
				if ((i - 1) % 3 == 0) {
					sides += 8;
				} else {
					sides += 4;
				}
			}
			
			for (i = 0; i < sides; i++) {
				var ratio:Number = (i / sides) * 2 * Math.PI;
				bmd.setPixel32(center.x + Math.cos(ratio) * _radius, center.y + Math.sin(ratio) * _radius, color);
			}
		}
		override public function drawPointBMD(bmd:BitmapData, color:uint = 0xFF00FF00):void {
			center.drawPointBMD(bmd, color);
		}
		
		//private
		
	}
}