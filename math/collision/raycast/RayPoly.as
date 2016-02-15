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
	import flash.geom.Point;
	import starling.display.Graphics;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class RayPoly extends RayShape {
		//vars
		public var vertices:Vector.<Vector2D> = new Vector.<Vector2D>();
		
		//constructor
		public function RayPoly(vertices:Array) {
			var iPoint:Point;
			
			for each (var i:Object in vertices) {
				if (i is Vector2D) {
					this.vertices.push(i as Vector2D);
				} else if (i is Point) {
					iPoint = i as Point;
					this.vertices.push(new Vector2D(iPoint.x, iPoint.y));
				}
			}
		}
		
		//public
		public function move(velocity:Vector2D):void {
			for (var i:uint = 0; i < vertices.length; i++) {
				vertices[i].add(velocity);
			}
		}
		public function setPosition(position:Vector2D):void {
			position.subtract(middle);
			
			for (var i:uint = 0; i < vertices.length; i++) {
				vertices[i].add(position);
			}
		}
		
		public function get middle():Vector2D {
			var mid:Vector2D = new Vector2D();
			
			for (var i:uint = 0; i < vertices.length; i++) {
				mid.add(vertices[i]);
			}
			mid.divide(vertices.length);
			
			return mid;
		}
		
		override public function draw(graphics:Graphics, color:uint = 0x00FF00):void {
			graphics.lineStyle(1, color);
			graphics.moveTo(vertices[0].x, vertices[0].y);
			
			for (var i:uint = 1; i < vertices.length; i++) {
				graphics.lineTo(vertices[i].x, vertices[i].y);
			}
			graphics.lineTo(vertices[0].x, vertices[0].y);
		}
		override public function drawPoint(graphics:Graphics, color:uint = 0x00FF00):void {
			throw new Error("drawPoint not yet implemented in RayPoly");
		}
		
		override public function drawBMD(bmd:BitmapData, color:uint = 0xFF00FF00):void {
			for (var i:uint = 1; i < vertices.length; i++) {
				drawLineBMD(bmd, vertices[i - 1], vertices[i], color);
			}
			drawLineBMD(bmd, vertices[i], vertices[0], color);
		}
		override public function drawPointBMD(bmd:BitmapData, color:uint = 0xFF00FF00):void {
			throw new Error("drawPointBMD not yet implemented in RayPoly");
		}
		
		//private
		private function drawLineBMD(bmd:BitmapData, start:Vector2D, end:Vector2D, color:uint):void {
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
	}
}