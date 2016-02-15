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

package egg82.intern {
	import egg82.patterns.prototype.interfaces.IPrototype;
	import egg82.enums.AudioFileType;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	import org.as3wavsound.WavSound;
	import org.as3wavsound.WavSoundChannel;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class Audio implements IPrototype {
		//vars
		public var name:String = "";
		public var fileType:String = "";
		public var audioType:String = "";
		public var data:ByteArray = null;
		public var repeat:Boolean = false;
		
		private var wavSound:WavSound = null;
		private var wavSoundChannel:WavSoundChannel = null;
		
		private var sound:Sound = null;
		private var soundChannel:SoundChannel = null;
		
		private var paused:Boolean = true;
		private var playbackStart:Number = 0;
		
		private var volume:Number = 1;
		
		//constructor
		public function Audio() {
			
		}
		
		//public
		public function get isPlaying():Boolean {
			return paused;
		}
		
		public function play():void {
			if (!data || !paused) {
				return;
			}
			paused = false;
			
			if (sound && soundChannel) {
				soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
				soundChannel = sound.play(playbackStart, 0, new SoundTransform(volume));
				soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
				return;
			} else if (wavSound && wavSoundChannel) {
				wavSoundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
				wavSoundChannel = wavSound.play(playbackStart, 0, new SoundTransform(volume));
				wavSoundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
				return;
			}
			
			if (fileType == AudioFileType.MP3) {
				sound = new Sound();
				sound.loadCompressedDataFromByteArray(data, data.length);
				soundChannel = sound.play(0, 0, new SoundTransform(volume));
				soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			} else if (fileType == AudioFileType.WAV) {
				wavSound = new WavSound(data);
				wavSoundChannel = wavSound.play(0, 0, new SoundTransform(volume));
				wavSoundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
		}
		public function pause():void {
			if (!data || paused) {
				return;
			}
			paused = true;
			
			if (sound && soundChannel) {
				soundChannel.stop();
				playbackStart = soundChannel.position;
			} else if (wavSound && wavSoundChannel) {
				wavSoundChannel.stop();
				playbackStart = wavSoundChannel.position;
			}
		}
		public function stop():void {
			if (!data || paused) {
				return;
			}
			paused = true;
			
			if (sound && soundChannel) {
				soundChannel.stop();
				playbackStart = 0;
			} else if (wavSound && wavSoundChannel) {
				wavSoundChannel.stop();
				playbackStart = 0;
			}
		}
		public function setPosition(val:Number):void {
			if (!data) {
				return;
			}
			
			//stop() sets paused to true, don't try to compact this
			if (!paused) {
				stop();
				playbackStart = val;
				play();
			} else {
				playbackStart = val;
			}
		}
		
		public function setVolume(val:Number):void {
			volume = val;
			
			if (sound && soundChannel) {
				soundChannel.soundTransform = new SoundTransform(volume);
			} else if (wavSound && wavSoundChannel) {
				if (!paused) {
					pause();
					play();
				}
			}
		}
		
		public function destroy():void {
			pause();
			
			if (soundChannel) {
				soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
			if (wavSoundChannel) {
				wavSoundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
			
			wavSound = null;
			wavSoundChannel = null;
			sound = null;
			soundChannel = null;
			paused = true;
			playbackStart = 0;
			volume = 1;
		}
		
		public function clone():IPrototype {
			return new Audio();
		}
		
		//private
		private function onSoundComplete(e:Event):void {
			if (repeat) {
				play();
			}
		}
	}
}