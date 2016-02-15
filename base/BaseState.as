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
	import egg82.engines.interfaces.IStateEngine;
	import egg82.enums.ServiceType;
	import egg82.events.base.BaseStateEvent;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistryUtil;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class BaseState extends BaseSprite {
		//vars
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		public var active:Boolean = true;
		public var forceUpdate:Boolean = false;
		
		protected var _prevState:Class;
		protected var _prevStateParams:Array;
		protected var _nextState:Class;
		protected var _nextStateParams:Array;
		
		protected const REGISTRY_UTIL:IRegistryUtil = ServiceLocator.getService(ServiceType.REGISTRY_UTIL) as IRegistryUtil;
		
		private var _stateEngine:IStateEngine = ServiceLocator.getService(ServiceType.STATE_ENGINE) as IStateEngine;
		
		//constructor
		public function BaseState() {
			
		}
		
		//public
		public function resize():void {
			dispatch(BaseStateEvent.RESIZE);
		}
		
		//private
		protected function prevState():void {
			if (!_prevState) {
				return;
			}
			
			dispatch(BaseStateEvent.PREV_STATE);
			
			_stateEngine.swapStates(_prevState, _prevStateParams);
		}
		protected function nextState():void {
			if (!_nextState) {
				return;
			}
			
			dispatch(BaseStateEvent.NEXT_STATE);
			
			_stateEngine.swapStates(_nextState, _nextStateParams);
		}
	}
}