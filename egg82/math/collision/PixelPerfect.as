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

package egg82.math.collision {
	import egg82.math.Vector2D;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class PixelPerfect {
		//vars
		
		//constructor
		public function PixelPerfect() {
			
		}
		
		//public
		public static function fastCollides(obj1:DisplayObject, obj2:DisplayObject, threshold:uint = 0, quality:Boolean = true):Boolean {
			var bmd1:BitmapData = new BitmapData(obj1.width, obj1.height, true, 0x00000000);
			var bmd2:BitmapData = new BitmapData(obj2.width, obj2.height, true, 0x00000000);
			
			if (quality) {
				bmd1.drawWithQuality(obj1, null, null, null, null, true);
				bmd2.drawWithQuality(obj2, null, null, null, null, true);
			} else {
				bmd1.draw(obj1);
				bmd2.draw(obj2);
			}
			
			return fastCollidesBMD(bmd1, new Vector2D(obj1.x, obj1.y), bmd2, new Vector2D(obj2.x, obj2.y), threshold);
		}
		public static function fastCollidesBMD(bmd1:BitmapData, pos1:Vector2D, bmd2:BitmapData, pos2:Vector2D, threshold:uint = 0):Boolean {
			var sourceRect:Rectangle;
			var collideBMD1:BitmapData;
			var collideBMD2:BitmapData;
			
			if (pos1.x + bmd1.width < pos2.x || pos1.x > pos2.x + bmd2.width) {
				return false;
			}
			if (pos1.y + bmd1.height < pos2.y || pos1.y > pos2.y + bmd2.height) {
				return false;
			}
			
			sourceRect = new Rectangle(Math.abs(pos2.x - pos1.x), Math.abs(pos2.y - pos1.y), Math.abs((pos1.x + bmd1.width) - pos2.x), Math.abs((pos1.y + bmd1.height) - pos2.y));
			collideBMD1 = new BitmapData(sourceRect.width, sourceRect.height, true, 0x00000000);
			collideBMD2 = new BitmapData(sourceRect.width, sourceRect.height, true, 0x00000000);
			
			collideBMD1.copyChannel(bmd1, sourceRect, new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
			
			sourceRect.x += (pos1.x < pos2.x) ? pos2.x : pos1.x;
			sourceRect.y += (pos1.y < pos2.y) ? pos2.y : pos1.y;
			
			collideBMD2.copyChannel(bmd2, sourceRect, new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
			
			var returnVec1:Vector.<uint> = collideBMD1.getVector(collideBMD1.rect);
			var returnVec2:Vector.<uint> = collideBMD2.getVector(collideBMD2.rect);
			
			for (var i:uint = 0; i < returnVec1.length; i++) {
				if (returnVec1[i] + returnVec2[i] >= returnVec1[i] + threshold && returnVec1[i] + returnVec2[i] >= returnVec2[i] + threshold) {
					return true;
				}
			}
			
			return false;
		}

		public static function collides(obj1:DisplayObject, obj2:DisplayObject, threshold:uint = 0, quality:Boolean = true):Vector.<Point> {
			var bmd1:BitmapData = new BitmapData(obj1.width, obj1.height, true, 0x00000000);
			var bmd2:BitmapData = new BitmapData(obj2.width, obj2.height, true, 0x00000000);
			
			if (quality) {
				bmd1.drawWithQuality(obj1, null, null, null, null, true);
				bmd2.drawWithQuality(obj2, null, null, null, null, true);
			} else {
				bmd1.draw(obj1);
				bmd2.draw(obj2);
			}
			
			return collidesBMD(bmd1, new Vector2D(obj1.x, obj1.y), bmd2, new Vector2D(obj2.x, obj2.y), threshold);
		}
		public static function collidesBMD(bmd1:BitmapData, pos1:Vector2D, bmd2:BitmapData, pos2:Vector2D, threshold:uint = 0):Vector.<Point> {
			var sourceRect:Rectangle;
			var collideBMD1:BitmapData;
			var collideBMD2:BitmapData;
			var returnVec:Vector.<Point> = new Vector.<Point>();
			
			if (pos1.x + bmd1.width < pos2.x || pos1.x > pos2.x + bmd2.width) {
				return null;
			}
			if (pos1.y + bmd1.height < pos2.y || pos1.y > pos2.y + bmd2.height) {
				return null;
			}
			
			sourceRect = new Rectangle(Math.abs(pos2.x - pos1.x), Math.abs(pos2.y - pos1.y), Math.abs((pos1.x + bmd1.width) - pos2.x), Math.abs((pos1.y + bmd1.height) - pos2.y));
			collideBMD1 = new BitmapData(sourceRect.width, sourceRect.height, true, 0x00000000);
			collideBMD2 = new BitmapData(sourceRect.width, sourceRect.height, true, 0x00000000);
			
			collideBMD1.copyChannel(bmd1, sourceRect, new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
			
			sourceRect.x += (pos1.x < pos2.x) ? pos2.x : pos1.x;
			sourceRect.y += (pos1.y < pos2.y) ? pos2.y : pos1.y;
			
			collideBMD2.copyChannel(bmd2, sourceRect, new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
			
			sourceRect.x -= (pos1.x < pos2.x) ? pos2.x : pos1.x;
			sourceRect.y -= (pos1.y < pos2.y) ? pos2.y : pos1.y;
			
			var returnVec1:Vector.<uint> = collideBMD1.getVector(collideBMD1.rect);
			var returnVec2:Vector.<uint> = collideBMD2.getVector(collideBMD2.rect);
			
			for (var i:uint = 0; i < returnVec1.length; i++) {
				if (returnVec1[i] + returnVec2[i] >= returnVec1[i] + threshold && returnVec1[i] + returnVec2[i] >= returnVec2[i] + threshold) {
					returnVec.push(new Point(pos1.x + (i % sourceRect.width), pos1.y + Math.floor(i / sourceRect.width)));
				}
			}
			
			return returnVec;
		}
		
		//private
		
	}
}