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

package egg82.patterns.command {
	import egg82.events.patterns.command.CommandEvent;
	import egg82.patterns.Observer;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class NestedCommand extends Command {
		//vars
		private var command:Command;
		
		private var commandObserver:Observer = new Observer();
		
		//constructor
		public function NestedCommand(command:Command, delay:Number = 0) {
			super(0);
			this.command = command;
			
			commandObserver.add(onCommandObserverNotify);
		}
		
		//public
		
		//private
		override protected function execute():void {
			if (!command) {
				return;
			}
			
			Observer.add(Command.OBSERVERS, commandObserver);
			command.start();
		}
		
		protected function postExecute(data:Object):void {
			dispatch(CommandEvent.COMPLETE);
		}
		
		private function onCommandObserverNotify(sender:Object, event:String, data:Object):void {
			if (sender !== command) {
				return;
			}
			
			if (event == CommandEvent.COMPLETE) {
				Observer.remove(Command.OBSERVERS, commandObserver);
				postExecute(data);
			}
		}
	}
}