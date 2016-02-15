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

package egg82.patterns.objectPool {
	import egg82.patterns.prototype.interfaces.IPrototype;
	import egg82.patterns.prototype.interfaces.IPrototypeFactory;
	import egg82.patterns.ServiceLocator;
	import flash.system.System;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class DynamicObjectPool {
		//vars
		private var prototypeFactory:IPrototypeFactory = ServiceLocator.getService("prototypeFactory") as IPrototypeFactory;
		private var prototypeName:String = null;
		
		private var _usedPool:Vector.<IPrototype> = new Vector.<IPrototype>();
		private var _freePool:Vector.<IPrototype> = new Vector.<IPrototype>();
		
		//constructor
		public function DynamicObjectPool(prototypeName:String, prototype:IPrototype) {
			if (!prototypeName || prototypeName == "") {
				throw new Error("prototypeName cannot be null");
			}
			if (!prototype) {
				throw new Error("prototype cannot be null");
			}
			
			this.prototypeName = prototypeName;
			prototypeFactory.addPrototype(prototypeName, prototype);
		}
		
		//public
		public function initialize(numObjects:uint = 1):void {
			for (var i:uint = 0; i < numObjects; i++) {
				_freePool.push(prototypeFactory.createInstance(prototypeName));
			}
		}
		
		public function getObject():IPrototype {
			_usedPool.push((_freePool.length == 0) ? prototypeFactory.createInstance(prototypeName) : _freePool.splice(0, 1)[0]);
			return _usedPool[_usedPool.length - 1];
		}
		public function returnObject(obj:IPrototype):void {
			for (var i:uint = 0; i < _usedPool.length; i++) {
				if (obj === _usedPool[i]) {
					_freePool.push(_usedPool.splice(i, 1)[0]);
					return;
				}
			}
		}
		
		public function get usedPool():Vector.<IPrototype> {
			return _usedPool;
		}
		public function get freePool():Vector.<IPrototype> {
			return _freePool;
		}
		
		public function get size():uint {
			return _usedPool.length + _freePool.length;
		}
		
		public function clear():void {
			for (var i:uint = 0; i < _usedPool.length; i++) {
				if ("destroy" in _usedPool[i] && _usedPool[i]["destroy"] is Function) {
					(_usedPool[i]["destroy"] as Function).call();
				}
			}
			
			_usedPool = new Vector.<IPrototype>();
			gc();
		}
		public function gc():void {
			for (var i:uint = 0; i < _freePool.length; i++) {
				if ("destroy" in _freePool[i] && _freePool[i]["destroy"] is Function) {
					(_freePool[i]["destroy"] as Function).call();
				}
			}
			
			_freePool = new Vector.<IPrototype>();
			System.pauseForGCIfCollectionImminent();
		}
		public function resize(to:uint, hard:Boolean = false):void {
			var i:int;
			
			if (to == _usedPool.length + _freePool.length) {
				return;
			} else if (to > _usedPool.length + _freePool.length) {
				for (i = _usedPool.length + _freePool.length; i < to; i++) {
					_freePool.push(prototypeFactory.createInstance(prototypeName));
				}
				
				return;
			} else if (to == 0 && hard) {
				_freePool = new Vector.<IPrototype>();
				_usedPool = new Vector.<IPrototype>();
			}
			
			for (i = _freePool.length - 1; i >= 0; i--) {
				_freePool.splice(i, 1);
				
				if (_usedPool.length + _freePool.length == to) {
					return;
				}
			}
			
			if (!hard) {
				return;
			}
			
			for (i = _usedPool.length - 1; i >= 0; i--) {
				_usedPool.splice(i, 1);
				
				if (_usedPool.length == to) {
					return;
				}
			}
		}
		
		//private
		
	}
}