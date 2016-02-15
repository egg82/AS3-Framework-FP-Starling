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
	import egg82.base.BaseState;
	import egg82.engines.interfaces.IAudioEngine;
	import egg82.engines.interfaces.IInputEngine;
	import egg82.engines.interfaces.IModEngine;
	import egg82.engines.interfaces.IPhysicsEngine;
	import egg82.engines.interfaces.IStateEngine;
	import egg82.enums.OptionsRegistryType;
	import egg82.enums.ServiceType;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistry;
	import egg82.utils.interfaces.ISettingsLoader;
	import flash.display.StageDisplayState;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class InitState extends BaseState {
		//vars
		private var inputEngine:IInputEngine = ServiceLocator.getService(ServiceType.INPUT_ENGINE) as IInputEngine;
		private var stateEngine:IStateEngine = ServiceLocator.getService(ServiceType.STATE_ENGINE) as IStateEngine;
		private var physicsEngine:IPhysicsEngine = ServiceLocator.getService(ServiceType.PHYSICS_ENGINE) as IPhysicsEngine;
		private var audioEngine:IAudioEngine = ServiceLocator.getService(ServiceType.AUDIO_ENGINE) as IAudioEngine;
		private var modEngine:IModEngine = ServiceLocator.getService(ServiceType.MOD_ENGINE) as IModEngine;
		
		private var settingsLoader:ISettingsLoader = ServiceLocator.getService(ServiceType.SETTINGS_LOADER) as ISettingsLoader;
		
		private var optionsRegistry:IRegistry = ServiceLocator.getService(ServiceType.OPTIONS_REGISTRY) as IRegistry;
		private var fontRegistry:IRegistry = ServiceLocator.getService(ServiceType.FONT_REGISTRY) as IRegistry;
		private var fileRegistry:IRegistry = ServiceLocator.getService(ServiceType.FILE_REGISTRY) as IRegistry;
		private var textureRegistry:IRegistry = ServiceLocator.getService(ServiceType.TEXTURE_REGISTRY) as IRegistry;
		private var initRegistry:IRegistry = ServiceLocator.getService(ServiceType.INIT_REGISTRY) as IRegistry;
		
		//constructor
		public function InitState() {
			
		}
		
		//public
		override public function create(args:Array = null):void {
			super.create(args);
			
			_nextState = TextureInitState;
			
			//CookieUtil.deleteCookie("options");
			if (!initRegistry.getRegister("debug")) {
				settingsLoader.loadSave("options", optionsRegistry);
			}
			
			//FileFinder.initialize(fileRegistry);
			
			Starling.all[0].nativeStage.displayState = (optionsRegistry.getRegister(OptionsRegistryType.VIDEO).fullscreen) ? StageDisplayState.FULL_SCREEN_INTERACTIVE : StageDisplayState.NORMAL;
			Starling.all[0].nativeStage.quality = optionsRegistry.getRegister(OptionsRegistryType.VIDEO).stageQuality;
			
			Starling.all[0].nativeStage.frameRate = optionsRegistry.getRegister(OptionsRegistryType.VIDEO).drawFps;
			stateEngine.updateFps = optionsRegistry.getRegister(OptionsRegistryType.VIDEO).updateFps;
			stateEngine.drawFps = optionsRegistry.getRegister(OptionsRegistryType.VIDEO).drawFps;
			Starling.all[0].antiAliasing = optionsRegistry.getRegister(OptionsRegistryType.VIDEO).antialiasing;
			
			inputEngine.initialize();
			physicsEngine.initialize();
			audioEngine.initialize();
			modEngine.initialize();
			
			nextState();
		}
		
		//private
		
	}
}