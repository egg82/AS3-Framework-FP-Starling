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
	import egg82.enums.ServiceType;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistry;
	import egg82.startup.states.inits.InitState;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class BasePreInitState extends BaseState {
		//vars
		private var font:String = "visitor";
		private var loadingString:String = "Loading..";
		
		private var centerText:TextField;
		
		/**
		 * Easy access to the init registry.
		 */
		protected const INIT_REGISTRY:IRegistry = ServiceLocator.getService(ServiceType.INIT_REGISTRY) as IRegistry;
		
		//constructor
		public function BasePreInitState() {
			
		}
		
		//public
		/**
		 * Creates a quick loader on-screen, in case files need to be downloaded or something needs to happen externally.
		 * @param	args Optional parameters:
		 * url:String - The URL or path of the program. This is set by egg82.base.BasePreloader automatically.
		 */
		override public function create(args:Array = null):void {
			super.create(args);
			
			throwErrorOnArgsNull(args);
			INIT_REGISTRY.setRegister("url", getArg(args, "url") as String);
			
			centerText = new TextField(0, 0, loadingString + "\n0/0\n0.00%", font, 22, 0x000000, false);
			centerText.hAlign = HAlign.CENTER;
			centerText.vAlign = VAlign.CENTER;
			addChild(centerText);
			
			_nextState = InitState;
		}
		
		override public function resize():void {
			super.resize();
			
			if (centerText && stage) {
				centerText.width = stage.stageWidth;
				centerText.height = stage.stageHeight;
			}
		}
		
		//private
		/**
		 * Manually set the loaded/total of the progress bar. This is required (in this specific class) if you want to use this feature.
		 * 
		 * @param	loaded
		 * @param	total
		 */
		protected function setLoaded(loaded:uint, total:uint):void {
			centerText.text = loadingString + "\n" + loaded + "/" + total + "\n" + ((loaded / total) * 100).toFixed(2) + "%";
		}
	}
}