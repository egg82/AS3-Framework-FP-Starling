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
	import egg82.enums.OptionsRegistryType;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistry;
	import egg82.registry.Registry;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class TextureRegistry extends Registry {
		//vars
		private var optionsRegistry:IRegistry;
		
		//constructor
		public function TextureRegistry() {
			
		}
		
		//public
		override public function initialize():void {
			if (initialized) {
				return;
			}
			super.initialize();
			
			optionsRegistry = ServiceLocator.getService("optionsRegistry") as IRegistry;
		}
		
		override public function setRegister(type:String, data:*):void {
			if (registry[type]) {
				if ("dispose" in registry[type] && registry[type]["dispose"] is Function) {
					(registry[type]["dispose"] as Function).call();
				}
			}
			
			super.setRegister(type, data);
		}
		
		override public function resetRegistry():void {
			for (var i:String in registry) {
				 if (registry[i] is Texture) {
					 registry[i].mipMapping = optionsRegistry.getRegister(OptionsRegistryType.VIDEO).mipmap as Boolean;
				 } else if (registry[i] is TextureAtlas) {
					 registry[i].texture.mipMapping = optionsRegistry.getRegister(OptionsRegistryType.VIDEO).mipmap as Boolean;
				 }
			}
		}
		
		override public function clearRegistry():void {
			for (var i:String in registry) {
				if ("dispose" in registry[i] && registry[i]["dispose"] is Function) {
					(registry[i]["dispose"] as Function).call();
				}
			}
			
			super.clearRegistry();
		}
		
		//private
		
	}
}