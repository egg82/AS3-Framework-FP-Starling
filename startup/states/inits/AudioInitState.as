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

package egg82.startup.states.inits {
	import egg82.base.BaseLoadingState;
	import egg82.enums.FileRegistryType;
	import egg82.enums.OptionsRegistryType;
	import egg82.enums.ServiceType;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistry;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class AudioInitState extends BaseLoadingState {
		//vars
		private var initRegistry:IRegistry = ServiceLocator.getService(ServiceType.INIT_REGISTRY) as IRegistry;
		private var fileRegistry:IRegistry = ServiceLocator.getService(ServiceType.FILE_REGISTRY) as IRegistry;
		
		//constructor
		public function AudioInitState() {
			super();
		}
		
		//public
		override public function create(args:Array = null):void {
			_nextState = initRegistry.getRegister("postInitState") as Class;
			
			if (!REGISTRY_UTIL.getOption(OptionsRegistryType.NETWORK, "preloadAudio") as Boolean || (fileRegistry.getRegister(FileRegistryType.AUDIO) as Array).length == 0) {
				nextState();
				return;
			}
			
			args = addArg(args, {
				"fileArr": fileRegistry.getRegister(FileRegistryType.AUDIO) as Array
			});
			super.create(args);
		}
		
		//private
		
	}
}