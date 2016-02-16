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
		/**
		 * Observers for this class.
		 */
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		private const _GRAPHICS:Graphics = new Graphics(this as DisplayObjectContainer);
		
		private var _valid:Boolean = true;
		
		//constructor
		/**
		 * The base of everything you want to add to the stage.
		 */
		public function BaseSprite() {
			
		}
		
		//public
		/**
		 * Boolean flag indicating whether or not this object has been destroyed.
		 */
		public function get isValid():Boolean {
			return _valid;
		}
		
		/**
		 * Creates the object. Use this instead of constructors.
		 * 
		 * @param	args Array of optional arguments. Use egg82.base.BaseSprite.addArg() and egg82.base.BaseSprite.getArg() for getting and setting arguments.
		 */
		public function create(args:Array = null):void {
			dispatch(BaseSpriteEvent.CREATE);
		}
		/**
		 * Destroys the object.
		 */
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
		
		/**
		 * Updates the sprite and its children.
		 * Called automatically by egg82.engines.StateEngine
		 * 
		 * @param	deltaTime The number of milliseconds since the last frame.
		 */
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
		/**
		 * Runs on itself and all its children after all updates have been applied. Useful for double-buffering.
		 * Called automatically by egg82.engines.StateEngine
		 */
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
		
		/**
		 * Draws its and its children's content onto the screen.
		 * Draw and update functions are on two seperately-controllable timers.
		 * Called automatically by egg82.engines.StateEngine
		 */
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
		
		/**
		 * Exactly like Flash's graphics API.
		 */
		public function get graphics():Graphics {
			return (_valid) ? _GRAPHICS : null;
		}
		
		//private
		/**
		 * Dispatches an event.
		 * 
		 * @param	event The event's type.
		 * @param	data The event's data.
		 */
		protected function dispatch(event:String, data:Object = null):void {
			Observer.dispatch(OBSERVERS, this, event, data);
		}
		
		/**
		 * Thorws an error if the supplied arguments are null or blank, or the first argument supplied is null.
		 * @param	args The arguments to check.
		 */
		protected function throwErrorOnArgsNull(args:Array):void {
			if (!args || args.length == 0 || !args[args.length - 1]) {
				throw new Error("args must be at least a length of 1");
			}
		}
		
		/**
		 * Adds an additional argument to the arguments given and returns it.
		 * 
		 * @param	args The old argument array.
		 * @param	newArg The new argument to add to the array.
		 * @return The new argument array.
		 */
		protected function addArg(args:Array, newArg:*):Array {
			if (!args) {
				args = new Array();
			}
			args.push(newArg);
			
			return args;
		}
		/**
		 * Gets an argument from the supplied array.
		 * 
		 * @param	args The argument array.
		 * @param	name The name of the argument to get.
		 * @return The argument, or null.
		 */
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
