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

package egg82.patterns.fsm {
	import egg82.patterns.fsm.interfaces.IFSM;
	import egg82.patterns.fsm.interfaces.IFSMState;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class FSM implements IFSM {
		//vars
		private var currentState:IFSMState = null;
		private var states:Array = new Array();
		
		//constructor
		public function FSM() {
		
		}
		
		//public
		public function initialize(initState:String):void {
			if (!initState || !states[initState]) {
				throw new Error("initState cannot be null");
			}
			
			currentState = states[initState];
			currentState.enter();
		}
		
		public function addState(name:String, state:Class):void {
			var temp:Object;
			var ns:IFSMState;
			
			if (!name || !state) {
				return;
			}
			
			temp = new state(this);
			if (!temp is IFSMState) {
				return;
			}
			
			ns = temp as IFSMState;
			
			if (states[name] && currentState === states[name]) {
				currentState = states[name] = ns;
			} else {
				states[name] = ns;
			}
		}
		public function removeState(name:String):void {
			if (!states[name]) {
				return;
			}
			
			states[name] = null;
		}
		
		public function update():void {
			if (!currentState) {
				return;
			}
			
			currentState.update();
		}
		public function draw():void {
			if (!currentState) {
				return;
			}
			
			currentState.draw();
		}
		
		public function swapStates(name:String):void {
			if (!states[name] || (currentState.exitStates.length > 0 && currentState.exitStates.indexOf(name) == -1)) {
				return;
			}
			
			currentState.exit();
			currentState = states[name] as IFSMState;
			currentState.enter();
		}
		
		//private
		
	}
}