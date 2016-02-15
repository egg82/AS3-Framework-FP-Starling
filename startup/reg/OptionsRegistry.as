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
	import egg82.enums.KeyCodes;
	import egg82.enums.OptionsRegistryType;
	import egg82.enums.XboxButtonCodes;
	import egg82.enums.XboxStickCodes;
	import egg82.registry.Registry;
	import flash.display.StageQuality;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class OptionsRegistry extends Registry {
		//vars
		
		//constructor
		public function OptionsRegistry() {
			
		}
		
		
		//public
		override public function initialize():void {
			if (initialized) {
				return;
			}
			super.initialize();
			
			setRegister(OptionsRegistryType.VIDEO, {
				"updateFps": 60,
				"drawFps": 60,
				"stageQuality": StageQuality.BEST,
				"antialiasing": 16,
				"filterQuality": 1,
				"mipmap": true,
				"textureFiltering": TextureSmoothing.TRILINEAR,
				"fullscreen": false,
				"vsync": true
			});
			setRegister(OptionsRegistryType.AUDIO, {
				"masterVolume": 1,
				"ambientVolume": 1,
				"musicVolume": 1,
				"sfxVolume": 1,
				"uiVolume": 1,
				"voiceVolume": 1
			});
			setRegister(OptionsRegistryType.KEYS, {
				"up": [KeyCodes.W, KeyCodes.UP, KeyCodes.NUMPAD_EIGHT],
				"down": [KeyCodes.S, KeyCodes.DOWN, KeyCodes.NUMPAD_TWO],
				"left": [KeyCodes.A, KeyCodes.LEFT, KeyCodes.NUMPAD_FOUR],
				"right": [KeyCodes.D, KeyCodes.RIGHT, KeyCodes.NUMPAD_FIVE],
				"continue": [KeyCodes.ENTER],
				"back": [KeyCodes.ESC, KeyCodes.BACKSPACE]
			});
			//TODO Allow stick positions as button codes
			setRegister(OptionsRegistryType.CONTROLLER, {
				"deadZone": 0.05,
				"up": [XboxButtonCodes.UP, XboxStickCodes.LEFT_N, XboxStickCodes.RIGHT_N],
				"down": [XboxButtonCodes.DOWN, XboxStickCodes.LEFT_S, XboxStickCodes.RIGHT_S],
				"left": [XboxButtonCodes.LEFT, XboxStickCodes.LEFT_W, XboxStickCodes.RIGHT_W],
				"right": [XboxButtonCodes.RIGHT, XboxStickCodes.LEFT_E, XboxStickCodes.RIGHT_E],
				"continue": [XboxButtonCodes.A, XboxButtonCodes.START],
				"back": [XboxButtonCodes.B, XboxButtonCodes.BACK]
			});
			setRegister(OptionsRegistryType.NETWORK, {
				"preloadTextures": false,
				"preloadAudio": false,
				"threads": 3,
				"maxRetry": 2
			});
			setRegister(OptionsRegistryType.PHYSICS, {
				"velocityAccuracy": 1,
				"positionAccuracy": 1,
				"shapeAccuracy": 1
			});
		}
		
		//private
		
	}
}