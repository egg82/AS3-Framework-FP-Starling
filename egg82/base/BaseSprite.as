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

package egg82.base {
	import egg82.events.base.BaseSpriteEvent;
	import egg82.patterns.Observer;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Graphics;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class BaseSprite extends Sprite {
		//vars
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		private const _GRAPHICS:Graphics = new Graphics(this as DisplayObjectContainer);
		
		private var _valid:Boolean = true;
		
		//constructor
		public function BaseSprite() {
			
		}
		
		//public
		public function get isValid():Boolean {
			return _valid;
		}
		
		public function create(args:Array = null):void {
			dispatch(BaseSpriteEvent.CREATE);
		}
		public function destroy():void {
			_valid = false;
			removeEventListeners();
			
			for (var i:int = numChildren - 1; i >= 0; i--) {
				var child:DisplayObject = getChildAt(i);
				
				if (!child) {
					continue;
				}
				
				if ("destroy" in child && child["destroy"] is Function) {
					(child["destroy"] as Function).call();
				} else {
					child.dispose();
				}
			}
			
			removeChildren(0, -1, true);
			
			dispatch(BaseSpriteEvent.DESTROY);
		}
		
		public function update(deltaTime:Number):void {
			if (!_valid) {
				return;
			}
			
			dispatch(BaseSpriteEvent.UPDATE);
			
			for (var i:int = numChildren - 1; i >= 0; i--) {
				var child:DisplayObject = getChildAt(i);
				
				if (!child) {
					continue;
				}
				
				if ("update" in child && child["update"] is Function) {
					(child["update"] as Function).apply(null, [deltaTime]);
				}
			}
		}
		public function postUpdate():void {
			if (!_valid) {
				return;
			}
			
			dispatch(BaseSpriteEvent.POST_UPDATE);
			
			for (var i:int = numChildren - 1; i >= 0; i--) {
				var child:DisplayObject = getChildAt(i);
				
				if (!child) {
					continue;
				}
				
				if ("postUpdate" in child && child["postUpdate"] is Function) {
					(child["postUpdate"] as Function).call();
				}
			}
		}
		
		public function draw():void {
			if (!_valid) {
				return;
			}
			
			dispatch(BaseSpriteEvent.DRAW);
			
			for (var i:int = numChildren - 1; i >= 0; i--) {
				var child:DisplayObject = getChildAt(i);
				
				if (!child) {
					continue;
				}
				
				if ("draw" in child && child["draw"] is Function) {
					(child["draw"] as Function).call();
				}
			}
		}
		
		public function get graphics():Graphics {
			return (_valid) ? _GRAPHICS : null;
		}
		
		//private
		protected function dispatch(event:String, data:Object = null):void {
			Observer.dispatch(OBSERVERS, this, event, data);
		}
		
		protected function throwErrorOnArgsNull(args:Array):void {
			if (!args || args.length == 0 || !args[args.length - 1]) {
				throw new Error("args must be at least a length of 1");
			}
		}
		
		protected function addArg(args:Array, newArg:*):Array {
			if (!args) {
				args = new Array();
			}
			args.push(newArg);
			
			return args;
		}
		protected function getArg(args:Array, name:String):* {
			if (!args || args.length == 0) {
				return null;
			}
			
			for (var i:uint = args.length - 1; i >= 0; i--) {
				if (i > args.length - 1) {
					return null;
				}
				
				if (args[i][name]) {
					return args[i][name];
				}
			}
			
			return null;
		}
	}
}
