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
	 * @author ...
	 */
	
	public class ParallelCommand extends Command {
		//vars
		private var commands:Array;
		private var completed:uint;
		
		private var commandObserver:Observer = new Observer();
		
		//constructor
		public function ParallelCommand(delay:Number = 0, commands:Array = null) {
			super(delay);
			this.commands = commands;
			
			commandObserver.add(onCommandObserverNotify);
		}
		
		//public
		
		//private
		override protected function execute():void {
			if (!commands || commands.length == 0) {
				dispatch(CommandEvent.COMPLETE);
				return;
			}
			
			Observer.add(Command.OBSERVERS, commandObserver);
			
			completed = 0;
			
			for (var i:uint = 0; i < commands.length; i++) {
				if (!(commands[i] is Command)) {
					completed++;
					continue;
				}
				
				var command:Command = commands[i] as Command;
				command.start();
			}
			
			if (completed == commands.length) {
				Observer.remove(Command.OBSERVERS, commandObserver);
				dispatch(CommandEvent.COMPLETE);
			}
		}
		
		private function onCommandObserverNotify(sender:Object, event:String, data:Object):void {
			var isInArr:Boolean = false;
			for (var i:uint = 0; i < commands.length; i++) {
				if (sender === commands[i]) {
					isInArr = true;
					break;
				}
			}
			
			if (!isInArr) {
				return;
			}
			
			if (event == CommandEvent.COMPLETE) {
				completed++;
				
				if (completed == commands.length) {
					Observer.remove(Command.OBSERVERS, commandObserver);
					dispatch(CommandEvent.COMPLETE);
				}
			} else if (event == CommandEvent.ERROR) {
				dispatch(CommandEvent.ERROR, data);
				
				completed++;
				
				if (completed == commands.length) {
					Observer.remove(Command.OBSERVERS, commandObserver);
					dispatch(CommandEvent.COMPLETE);
				}
			}
		}
	}
}