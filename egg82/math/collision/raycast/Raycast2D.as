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
	
	public class Raycast2D {
		//vars
		
		//constructor
		public function Raycast2D() {
			
		}
		
		//public
		public static function fastIntersects(start:Vector2D, end:Vector2D, shapes:Array = null):Vector2D {
			if (!start) {
				throw new Error("start cannot be null.");
			}
			if (!end) {
				throw new Error("end cannot be null.");
			}
			
			if (!shapes || shapes.length == 0) {
				return null;
			}
			
			var iShape:RayShape;
			var iCircle:RayCircle;
			var iPoly:RayPoly;
			var ray:Vector.<Vector2D> = drawLine(start, end);
			var j:uint;
			
			for (j = 0; j < ray.length; j++) {
				for each (var i:Object in shapes) {
					if (i is RayShape) {
						iShape = i as RayShape;
						
						if (iShape.isPoly) {
							iPoly = iShape as RayPoly;
							
							var l:int = iPoly.vertices.length - 1;
							var oddNodes:Boolean = false;
							
							for (var k:uint = 0; k < iPoly.vertices.length; k++) {
								if ((iPoly.vertices[k].y < ray[j].y && iPoly.vertices[l].y >= ray[j].y) || (iPoly.vertices[l].y < ray[j].y && iPoly.vertices[k].y >= ray[j].y)) {
									if (iPoly.vertices[k].x + (ray[j].y - iPoly.vertices[k].y) / (iPoly.vertices[l].y - iPoly.vertices[k].y) * (iPoly.vertices[l].x - iPoly.vertices[k].x) < ray[j].x) {
										oddNodes = !oddNodes;
									}
								}
								
								l = k;
							}
							
							if (oddNodes) {
								return ray[j];
							}
						} else {
							iCircle = iShape as RayCircle;
							
							var d:Number = Vector2D.distance(ray[j], iCircle.center);
							
							if (d <= iCircle.radius) {
								return ray[j];
							}
						}
					}
				}
			}
			
			return null;
		}
		public static function intersects(start:Vector2D, end:Vector2D, shapes:Array = null):Vector.<Vector2D> {
			var points:Vector.<Vector2D> = new Vector.<Vector2D>();
			
			if (!start) {
				throw new Error("start cannot be null.");
			}
			if (!end) {
				throw new Error("end cannot be null.");
			}
			
			if (!shapes || shapes.length == 0) {
				return points;
			}
			
			var iShape:RayShape;
			var iCircle:RayCircle;
			var iPoly:RayPoly;
			var ray:Vector.<Vector2D> = drawLine(start, end);
			var j:uint;
			
			for each (var i:Object in shapes) {
				if (i is RayShape) {
					iShape = i as RayShape;
					
					if (iShape.isPoly) {
						iPoly = iShape as RayPoly;
						
						var l:int = iPoly.vertices.length - 1;
						var oddNodes:Boolean;
						
						for (j = 0; j < ray.length; j++) {
							oddNodes = false;
							
							for (var k:uint = 0; k < iPoly.vertices.length; k++) {
								if ((iPoly.vertices[k].y < ray[j].y && iPoly.vertices[l].y >= ray[j].y) || (iPoly.vertices[l].y < ray[j].y && iPoly.vertices[k].y >= ray[j].y)) {
									if (iPoly.vertices[k].x + (ray[j].y - iPoly.vertices[k].y) / (iPoly.vertices[l].y - iPoly.vertices[k].y) * (iPoly.vertices[l].x - iPoly.vertices[k].x) < ray[j].x) {
										oddNodes = !oddNodes;
									}
								}
								
								l = k;
							}
							
							if (oddNodes) {
								points.push(ray[j]);
							}
						}
					} else {
						iCircle = iShape as RayCircle;
						
						var d:Number;
						
						for (j = 0; j < ray.length; j++) {
							d = Vector2D.distance(ray[j], iCircle.center);
							
							if (d <= iCircle.radius) {
								points.push(ray[j]);
							}
						}
					}
				}
			}
			
			return points;
		}
		
		public static function draw(graphics:Graphics, start:Vector2D, end:Vector2D, color:uint = 0x00FF00):void {
			graphics.lineStyle(0, color);
			graphics.moveTo(start.x, start.y);
			graphics.lineTo(end.x, end.y);
		}
		public static function drawBMD(bmd:BitmapData, start:Vector2D, end:Vector2D, color:uint = 0xFF00FF00):void {
			var shortLen:int = end.y - start.y;
			var longLen:int = end.x - start.x;
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
					bmd.setPixel32(start.x + i * multDiff, start.y + i, color);
				}
			} else {
				for (i = 0; i != longLen; i += inc) {
					bmd.setPixel32(start.x + i, start.y + i * multDiff, color);
				}
			}
		}
		
		//private
		private static function drawLine(start:Vector2D, end:Vector2D):Vector.<Vector2D> {
			var points:Vector.<Vector2D> = new Vector.<Vector2D>();
			
			var steep:Boolean = Math.abs(end.y - start.y) > Math.abs(end.x - start.x);
			var swapped:Boolean = false;
			
			if (steep) {
				start = swap(start.x, start.y);
				end = swap(end.x, end.y);
			}
			if (start.x > end.x) {
				var t:Number = start.x;
				
				start.x = end.x;
				end.x = t;
				
				t = start.y;
				start.y = end.y;
				end.y = t;
				
				swapped = true;
			}
			
			var deltaX:Number = end.x - start.x;
			var deltaY:Number = Math.abs(end.y - start.y);
			var error:Number = deltaX / 2;
			var yStep:Number = (start.y < end.y) ? 1 : -1;
			var y:Number = start.y;
			
			for (var x:int = start.x; x < end.x; x++) {
				if (steep) {
					points.push(new Vector2D(y, x));
				} else {
					points.push(new Vector2D(x, y));
				}
				
				error -= deltaY;
				
				if (error < 0) {
					y += yStep;
					error += deltaX;
				}
			}
			
			if (swapped) {
				points.reverse();
			}
			
			return points;
		}
		private static function swap(x:Number, y:Number):Vector2D {
			return new Vector2D(y, x);
		}
	}
}