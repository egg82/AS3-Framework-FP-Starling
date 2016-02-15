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
	
	public class FSMState implements IFSMState {
		//vars
		private var _exitStates:Vector.<String> = new Vector.<String>();
		
		protected var machine:IFSM = null;
		
		//constructor
		public function FSMState(machine:IFSM) {
			this.machine = machine;
		}
		
		//public
		public function enter():void {
			
		}
		public function update():void {
			
		}
		public function draw():void {
			
		}
		public function exit():void {
			
		}
		
		public function get exitStates():Vector.<String> {
			return _exitStates;
		}
		
		public function addExitState(name:String):void {
			if (_exitStates.indexOf(name) > -1) {
				return;
			}
			
			_exitStates.push(name);
		}
		public function removeExitState(name:String):void {
			var index:int = _exitStates.indexOf(name);
			
			if (index == -1) {
				return;
			}
			
			_exitStates.splice(index, 1);
		}
		
		//private
		
	}
}