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

package egg82.engines {
	import egg82.engines.interfaces.IAudioEngine;
	import egg82.enums.OptionsRegistryType;
	import egg82.events.engines.AudioEngineEvent;
	import egg82.intern.Audio;
	import egg82.patterns.objectPool.DynamicObjectPool;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistryUtil;
	import egg82.registry.RegistryUtil;
	import egg82.enums.AudioFileType;
	import egg82.enums.AudioType;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class AudioEngine implements IAudioEngine {
		//vars
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		private var mp3AudioPool:DynamicObjectPool = new DynamicObjectPool("mp3", new Audio());
		private var wavAudioPool:DynamicObjectPool = new DynamicObjectPool("wav", new Audio());
		
		private var masterVolume:Number;
		private var ambientVolume:Number;
		private var musicVolume:Number;
		private var sfxVolume:Number;
		private var uiVolume:Number;
		private var voiceVolume:Number;
		
		private static var _initialized:Boolean = false;
		
		private var registryUtil:IRegistryUtil;
		
		private var registryUtilObserver:Observer = new Observer();
		
		//constructor
		public function AudioEngine() {
			
		}
		
		//public
		public function initialize():void {
			if (_initialized) {
				throw new Error("AudioEngine already initialized");
			}
			_initialized = true;
			
			mp3AudioPool.initialize(0);
			wavAudioPool.initialize(0);
			
			registryUtil = ServiceLocator.getService("registryUtil") as IRegistryUtil;
			
			masterVolume = registryUtil.getOption(OptionsRegistryType.AUDIO, "masterVolume") as Number;
			ambientVolume = registryUtil.getOption(OptionsRegistryType.AUDIO, "ambientVolume") as Number;
			musicVolume = registryUtil.getOption(OptionsRegistryType.AUDIO, "musicVolume") as Number;
			sfxVolume = registryUtil.getOption(OptionsRegistryType.AUDIO, "sfxVolume") as Number;
			uiVolume = registryUtil.getOption(OptionsRegistryType.AUDIO, "uiVolume") as Number;
			voiceVolume = registryUtil.getOption(OptionsRegistryType.AUDIO, "voiceVolume") as Number;
			
			registryUtilObserver.add(onRegistryUtilObserverNotify);
			Observer.add(RegistryUtil.OBSERVERS, registryUtilObserver);
			
			dispatch(AudioEngineEvent.INITIALIZE);
		}
		
		public function setAudio(name:String, fileType:String, audioType:String, data:ByteArray):void {
			var audio:Audio = null;
			
			removeAudio(name);
			
			if (fileType == AudioFileType.MP3) {
				audio = getAudioFromPool(name, mp3AudioPool);
				if (!audio) {
					audio = mp3AudioPool.getObject() as Audio;
				}
			} else if (fileType == AudioFileType.WAV) {
				audio = getAudioFromPool(name, wavAudioPool);
				if (!audio) {
					audio = wavAudioPool.getObject() as Audio;
				}
			}
			
			audio.name = name;
			audio.fileType = fileType;
			audio.audioType = audioType;
			audio.data = data;
			setVolume(audio);
		}
		public function getAudio(name:String):ByteArray {
			var audio:Audio = null;
			
			audio = getAudioFromPool(name, mp3AudioPool);
			if (!audio) {
				audio = getAudioFromPool(name, wavAudioPool);
			}
			
			return (audio) ? audio.data : null;
		}
		public function removeAudio(name:String):void {
			clearAudio(name, mp3AudioPool);
			clearAudio(name, wavAudioPool);
		}
		
		public function playAudio(name:String, repeat:Boolean = false):void {
			var audio:Audio = null;
			
			audio = getAudioFromPool(name, mp3AudioPool);
			if (!audio) {
				audio = getAudioFromPool(name, wavAudioPool);
			}
			if (!audio) {
				return;
			}
			
			audio.repeat = repeat;
			audio.play();
		}
		public function pauseAudio(name:String):void {
			var audio:Audio = null;
			
			audio = getAudioFromPool(name, mp3AudioPool);
			if (!audio) {
				audio = getAudioFromPool(name, wavAudioPool);
			}
			if (!audio) {
				return;
			}
			
			audio.pause();
		}
		public function stopAudio(name:String):void {
			var audio:Audio = null;
			
			audio = getAudioFromPool(name, mp3AudioPool);
			if (!audio) {
				audio = getAudioFromPool(name, wavAudioPool);
			}
			if (!audio) {
				return;
			}
			
			audio.stop();
		}
		public function setAudioPosition(name:String, position:Number):void {
			var audio:Audio = null;
			
			audio = getAudioFromPool(name, mp3AudioPool);
			if (!audio) {
				audio = getAudioFromPool(name, wavAudioPool);
			}
			if (!audio) {
				return;
			}
			
			audio.setPosition(position);
		}
		
		public function resetVolumes():void {
			var i:uint;
			
			for (i = 0; i < mp3AudioPool.usedPool.length; i++) {
				setVolume(mp3AudioPool.usedPool[i] as Audio);
			}
			for (i = 0; i < wavAudioPool.usedPool.length; i++) {
				setVolume(wavAudioPool.usedPool[i] as Audio);
			}
		}
		
		//private
		private function clearAudio(name:String, pool:DynamicObjectPool):void {
			var audio:Audio;
			
			for (var i:uint = 0; i < pool.usedPool.length; i++) {
				audio = pool.usedPool[i] as Audio;
				if (audio.name == name) {
					audio.destroy();
					pool.returnObject(audio);
					break;
				}
			}
			
			if (pool.freePool.length >= 5) {
				pool.gc();
			}
		}
		
		private function getAudioFromPool(name:String, pool:DynamicObjectPool):Audio {
			var retObj:Audio = null;
			
			for (var i:uint = 0; i < pool.usedPool.length; i++) {
				retObj = pool.usedPool[i] as Audio;
				if (retObj.name == name) {
					return retObj;
				}
			}
			
			return null;
		}
		
		private function setVolume(audio:Audio):void {
			if (audio.audioType == AudioType.AMBIENT) {
				audio.setVolume(ambientVolume * masterVolume);
			} else if (audio.audioType == AudioType.MUSIC) {
				audio.setVolume(musicVolume * masterVolume);
			} else if (audio.audioType == AudioType.SFX) {
				audio.setVolume(sfxVolume * masterVolume);
			} else if (audio.audioType == AudioType.UI) {
				audio.setVolume(uiVolume * masterVolume);
			} else if (audio.audioType == AudioType.VOICE) {
				audio.setVolume(voiceVolume * masterVolume);
			}
		}
		
		private function onRegistryUtilObserverNotify(sender:Object, event:String, data:Object):void {
			if (data.registry == "optionsRegistry") {
				checkOptions(data.type as String, data.name as String, data.value as Object);
			}
		}
		private function checkOptions(type:String, name:String, value:Object):void {
			if (type == OptionsRegistryType.AUDIO && name == "masterVolume") {
				masterVolume = value as Number;
			} else if (type == OptionsRegistryType.AUDIO && name == "ambientVolume") {
				ambientVolume = value as Number;
			} else if (type == OptionsRegistryType.AUDIO && name == "musicVolume") {
				musicVolume = value as Number;
			} else if (type == OptionsRegistryType.AUDIO && name == "sfxVolume") {
				sfxVolume = value as Number;
			} else if (type == OptionsRegistryType.AUDIO && name == "uiVolume") {
				uiVolume = value as Number;
			} else if (type == OptionsRegistryType.AUDIO && name == "voiceVolume") {
				voiceVolume = value as Number;
			}
			
			if (type == OptionsRegistryType.AUDIO) {
				resetVolumes();
			}
		}
		
		protected function dispatch(event:String, data:Object = null):void {
			Observer.dispatch(OBSERVERS, this, event, data);
		}
	}
}