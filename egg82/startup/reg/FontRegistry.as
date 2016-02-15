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

package egg82.startup.reg {
	import egg82.registry.Registry;
	import flash.text.Font;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class FontRegistry extends Registry {
		//vars
		[Embed(source = "../../fonts/visitor.ttf", fontName = "visitor", mimeType = "application/x-font", fontWeight = "normal", fontStyle = "normal", unicodeRange = "U+0020-U+007e", advancedAntiAliasing = "true", embedAsCFF = "false")]
		private var VISITOR:Class; //Pretending we're a const (but actually not to satisfy ASDoc)
		
		//constructor
		public function FontRegistry() {
			
		}
		
		//public
		override public function initialize():void {
			if (initialized) {
				return;
			}
			super.initialize();
			
			Font.registerFont(VISITOR);
			setRegister("visitor", VISITOR);
		}
		
		//private
		
	}
}