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

package egg82.startup {
	import egg82.base.BaseSprite;
	import egg82.engines.InputEngine;
	import egg82.engines.interfaces.IStateEngine;
	import egg82.engines.loggers.LoggingInputEngine;
	import egg82.engines.loggers.LoggingModEngine;
	import egg82.engines.loggers.LoggingPhysicsEngine;
	import egg82.engines.loggers.LoggingAudioEngine;
	import egg82.engines.loggers.LoggingStateEngine;
	import egg82.engines.ModEngine;
	import egg82.engines.PhysicsEngine;
	import egg82.engines.AudioEngine;
	import egg82.engines.StateEngine;
	import egg82.enums.ServiceType;
	import egg82.log.Logger;
	import egg82.patterns.prototype.PrototypeFactory;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistryUtil;
	import egg82.startup.reg.FileRegistry;
	import egg82.startup.reg.FontRegistry;
	import egg82.startup.reg.InitRegistry;
	import egg82.startup.reg.OptionsRegistry;
	import egg82.startup.reg.TextureRegistry;
	import egg82.startup.states.inits.InitState;
	import egg82.registry.interfaces.IRegistry;
	import egg82.utils.loggers.LoggingSettingsLoader;
	import egg82.registry.RegistryUtil;
	import egg82.utils.SettingsLoader;
	import flash.display.Sprite;
	import flash.events.Event;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class Start extends Sprite {
		//vars
		private var initRegistry:IRegistry = null;
		private var registryUtil:IRegistryUtil = null;
		
		//constructor
		public function Start(preInitState:Class, preInitStateArgs:Array, postInitState:Class, postInitStateArgs:Array) {
			ServiceLocator.provideService(ServiceType.INIT_REGISTRY, InitRegistry, false);
			initRegistry = ServiceLocator.getService(ServiceType.INIT_REGISTRY) as IRegistry;
			
			initRegistry.initialize();
			
			initRegistry.setRegister("preInitState", preInitState);
			initRegistry.setRegister("preInitStateArgs", preInitStateArgs);
			initRegistry.setRegister("postInitState", postInitState);
			initRegistry.setRegister("postInitStateArgs", postInitStateArgs);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		//public
		public function init(e:Event):void {
			var starling:Starling;
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			Starling.handleLostContext = true;
			Starling.multitouchEnabled = true;
			starling = new Starling(BaseSprite, stage, null, null, "auto", "auto");
			starling.showStats = initRegistry.getRegister("debug");
			starling.simulateMultitouch = true;
			
			ServiceLocator.provideService(ServiceType.LOGGER, Logger);
			
			if (initRegistry.getRegister("logging")) {
				ServiceLocator.provideService(ServiceType.STATE_ENGINE, LoggingStateEngine);
				ServiceLocator.provideService(ServiceType.AUDIO_ENGINE, LoggingAudioEngine);
				ServiceLocator.provideService(ServiceType.INPUT_ENGINE, LoggingInputEngine);
				ServiceLocator.provideService(ServiceType.PHYSICS_ENGINE, LoggingPhysicsEngine);
				ServiceLocator.provideService(ServiceType.MOD_ENGINE, LoggingModEngine);
				
				ServiceLocator.provideService(ServiceType.SETTINGS_LOADER, LoggingSettingsLoader);
			} else {
				ServiceLocator.provideService(ServiceType.STATE_ENGINE, StateEngine);
				ServiceLocator.provideService(ServiceType.AUDIO_ENGINE, AudioEngine);
				ServiceLocator.provideService(ServiceType.INPUT_ENGINE, InputEngine);
				ServiceLocator.provideService(ServiceType.PHYSICS_ENGINE, PhysicsEngine);
				ServiceLocator.provideService(ServiceType.MOD_ENGINE, ModEngine);
				
				ServiceLocator.provideService(ServiceType.SETTINGS_LOADER, SettingsLoader);
			}
			
			ServiceLocator.provideService(ServiceType.FONT_REGISTRY, FontRegistry, false);
			ServiceLocator.provideService(ServiceType.FILE_REGISTRY, FileRegistry, false);
			ServiceLocator.provideService(ServiceType.TEXTURE_REGISTRY, TextureRegistry, false);
			ServiceLocator.provideService(ServiceType.OPTIONS_REGISTRY, OptionsRegistry, false);
			
			ServiceLocator.provideService(ServiceType.REGISTRY_UTIL, RegistryUtil);
			registryUtil = ServiceLocator.getService(ServiceType.REGISTRY_UTIL) as IRegistryUtil;
			registryUtil.initialize();
			
			ServiceLocator.provideService(ServiceType.PROTOTYPE_FACTORY, PrototypeFactory);
			
			(ServiceLocator.getService(ServiceType.STATE_ENGINE) as IStateEngine).initialize(initRegistry.getRegister("preInitState") as Class, initRegistry.getRegister("preInitStateArgs") as Array);
			
			starling.start();
		}
		
		//private
		
	}
}