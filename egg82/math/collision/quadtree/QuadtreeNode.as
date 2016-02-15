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

package egg82.math.collision.quadtree {
	import egg82.events.math.collision.quadtree.QuadtreeNodeEvent;
	import egg82.patterns.Observer;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class QuadtreeNode {
		//vars
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		private var maxObjects:uint;
		private var level:uint;
		private var bounds:Rectangle;
		
		private var objects:Vector.<QuadtreeObject> = new Vector.<QuadtreeObject>();
		private var nodes:Vector.<QuadtreeNode> = new Vector.<QuadtreeNode>();
		
		//constructor
		public function QuadtreeNode(level:uint, bounds:Rectangle, maxObjects:uint) {
			this.level = level;
			this.bounds = bounds;
			this.maxObjects = maxObjects;
		}
		
		//public
		public function clear():void {
			objects = new Vector.<QuadtreeObject>();
			
			for (var i:uint = 0; i < nodes.length; i++) {
				nodes[i].clear();
			}
			nodes = new Vector.<QuadtreeNode>();
		}
		
		public function insert(obj:QuadtreeObject):void {
			var index:int;
			
			if (nodes.length > 0) {
				index = getIndex(obj);
				if (index != -1) {
					nodes[index].insert(obj);
					return;
				}
			}
			
			objects.push(obj);
			
			if (objects.length > maxObjects) {
				if (nodes.length == 0) {
					split();
				}
				
				var i:uint = 0;
				while (i < objects.length) {
					index = getIndex(objects[i]);
					if (index != -1) {
						nodes[index].insert(objects.splice(i, 1)[0]);
					} else {
						i++;
					}
				}
			}
		}
		
		public function getProbableCollisions(obj:QuadtreeObject):Vector.<QuadtreeObject> {
			var returnVec:Vector.<QuadtreeObject> = new Vector.<QuadtreeObject>();
			var tempVec:Vector.<QuadtreeObject>;
			var index:int = getIndex(obj);
			var i:uint;
			
			if (index != -1 && nodes.length > 0) {
				tempVec = nodes[index].getProbableCollisions(obj);
				for (i = 0; i < tempVec.length; i++) {
					returnVec.push(tempVec[i]);
				}
			}
			for (i = 0; i < objects.length; i++) {
				returnVec.push(objects[i]);
			}
			
			return returnVec;
		}
		
		//private
		private function split():void {
			var subWidth:Number = bounds.width / 2;
			var subHeight:Number = bounds.height / 2;
			var x:Number = bounds.x;
			var y:Number = bounds.y;
			
			nodes[0] = new QuadtreeNode(level + 1, new Rectangle(x + subWidth, y, subWidth, subHeight), maxObjects);
			nodes[1] = new QuadtreeNode(level + 1, new Rectangle(x, y, subWidth, subHeight), maxObjects);
			nodes[2] = new QuadtreeNode(level + 1, new Rectangle(x, y + subHeight, subWidth, subHeight), maxObjects);
			nodes[3] = new QuadtreeNode(level + 1, new Rectangle(x + subWidth, y + subHeight, subWidth, subHeight), maxObjects);
			
			dispatch(QuadtreeNodeEvent.SPLIT);
		}
		private function getIndex(obj:QuadtreeObject):int {
			var index:int = -1;
			var horiz:Number = bounds.x + bounds.width / 2;
			var vert:Number = bounds.y + bounds.height / 2;
			var topQuad:Boolean = obj.y + obj.height < horiz;
			var bottomQuad:Boolean = obj.y > horiz;
			
			if (obj.x + obj.width < vert) {
				if (topQuad) {
					index = 1
				} else if (bottomQuad) {
					index = 2;
				}
			} else if (obj.x > vert) {
				if (topQuad) {
					index = 0;
				} else if (bottomQuad) {
					index = 3;
				}
			}
			
			return index;
		}
		
		protected function dispatch(event:String, data:Object = null):void {
			Observer.dispatch(OBSERVERS, null, event, data);
		}
	}
}