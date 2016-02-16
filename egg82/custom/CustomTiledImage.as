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

package egg82.custom {
	import egg82.enums.OptionsRegistryType;
	import egg82.enums.ServiceType;
	import egg82.events.custom.CustomTiledImageEvent;
	import egg82.events.ImageDecoderEvent;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistry;
	import egg82.utils.ImageDecoder;
	import egg82.utils.MathUtil;
	import egg82.utils.TextureUtil;
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class CustomTiledImage extends Image {
		//vars
		/**
		 * Observers for this class.
		 */
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		private var loader:ImageDecoder = new ImageDecoder();
		private var bitmaps:Vector.<BitmapData>;
		private var nullBMD:BitmapData;
		private var master:BitmapData;
		private var path2:String;
		
		private var atlasRows:uint;
		private var atlasCols:uint;
		private var rows:uint;
		private var cols:uint;
		private var tileWidth:uint;
		private var tileHeight:uint;
		
		private var tex:Vector.<Point> = new Vector.<Point>();
		
		private var _isLoaded:Boolean = false;
		private var _locked:Boolean = false;
		
		private var imageDecoderObserver:Observer = new Observer();
		
		private var optionsRegistry:IRegistry = ServiceLocator.getService(ServiceType.OPTIONS_REGISTRY) as IRegistry;
		private var textureRegistry:IRegistry = ServiceLocator.getService(ServiceType.TEXTURE_REGISTRY) as IRegistry;
		
		//constructor
		/**
		 * Downloads an image, or uses the registry if the image has already been downloaded.
		 * Then splits the image into "frames" (textures) via rows/columns and provides controls for those.
		 * This is a large area full of tiles.
		 * It takes the downloaded image, splits it into pieces, and puts those pieces in a single tile.
		 * It then takes that tile and multiplies it rows * columns times to get a large square of individual tiles.
		 * You are given control over the "frame"/texture of each tile.
		 * Like a tile sheet. In fact, this <i>is</i> a tile sheet.
		 * 
		 * @param	url The image URL.
		 * @param	atlasRows The rows (horizontal lines) to split the image on.
		 * @param	atlasCols The columns (vertical lines) to split the image on.
		 * @param	rows The number of rows (horizontal lines) this tile sheet has.
		 * @param	cols The numbers of columns (vertical lines) this tile sheet has.
		 * @param	tileWidth The width (in pixels) of each tile.
		 * @param	tileHeight The height (in pixels) of each tile.
		 */
		public function CustomTiledImage(url:String, atlasRows:uint, atlasCols:uint, rows:uint, cols:uint, tileWidth:uint, tileHeight:uint) {
			path2 = url.replace(/\W|_/g, "_");
			this.atlasRows = atlasRows;
			this.atlasCols = atlasCols;
			this.rows = rows;
			this.cols = cols;
			this.tileWidth = tileWidth;
			this.tileHeight = tileHeight;
			
			imageDecoderObserver.add(onImageDecoderObserverNotify);
			Observer.add(ImageDecoder.OBSERVERS, imageDecoderObserver);
			
			master = new BitmapData(cols * tileWidth, rows * tileHeight, true, 0x00000000);
			
			if (textureRegistry.getRegister(path2 + "_bmd")) {
				bitmaps = TextureUtil.splitBMD(textureRegistry.getRegister(path2 + "_bmd"), atlasRows, atlasCols);
				rescale();
				
				for (var i:uint = 0; i < cols * rows; i++) {
					tex.push(new Point(uint.MAX_VALUE, uint.MAX_VALUE));
				}
				
				_isLoaded = true;
				dispatch(CustomTiledImageEvent.COMPLETE);
			} else {
				loader.load(url);
			}
			
			super(starling.textures.Texture.fromBitmapData(master, optionsRegistry.getRegister("video").mipmap, true));
			
			smoothing = optionsRegistry.getRegister(OptionsRegistryType.VIDEO).textureFiltering;
			touchable = false;
		}
		
		//public
		/**
		 * Destroys the object.
		 */
		public function destroy():void {
			Observer.remove(ImageDecoder.OBSERVERS, imageDecoderObserver);
			
			if (master) {
				master.dispose();
				for (var i:uint = 0; i < bitmaps.length; i++) {
					bitmaps[i].dispose();
				}
			}
			
			dispose();
		}
		
		/**
		 * Sets the "frame"/texture of an individual tile to a specified row/column.
		 * 
		 * @param	row The row of the tile to set.
		 * @param	col The column of the tile to set.
		 * @param	texRow The tile's "frame"/texture row.
		 * @param	texCol The tile's "frame"/texture column.
		 */
		public function setTextureAt(row:uint, col:uint, texRow:uint, texCol:uint):void {
			var xy:uint = MathUtil.toXY(cols, col, row);
			
			if (!master || xy >= tex.length) {
				return;
			}
			
			tex[xy].x = texCol - 1;
			tex[xy].y = texRow - 1;
			
			if (!_locked) {
				var texXY:uint = MathUtil.toXY(atlasCols, texCol - 1, texRow - 1);
				var tempBMD:BitmapData;
				var rect:Rectangle = new Rectangle(0, 0, tileWidth, tileHeight);
				
				if (texXY >= bitmaps.length) {
					tempBMD = nullBMD;
				} else {
					tempBMD = bitmaps[texXY];
				}
				
				master.copyPixels(tempBMD, rect, new Point(col * tileWidth, row * tileHeight));
				
				(texture.base as flash.display3D.textures.Texture).uploadFromBitmapData(master);
			}
		}
		/**
		 * Get's the specified tile's current texture position.
		 * 
		 * @param	row The row of the tile to get.
		 * @param	col The column of the tile to get.
		 * @return The texture's egg82.util.MathUtil.toXY() position.
		 */
		public function getTextureAt(row:uint, col:uint):uint {
			var xy:uint = MathUtil.toXY(cols, col, row);
			
			if (!master || xy >= tex.length) {
				return 0;
			}
			
			var retP:Point = tex[xy];
			
			return MathUtil.toXY(atlasCols, retP.x + 1, retP.y + 1);
		}
		
		/**
		 * Locks the tile sheet. If any changes are made to the tiles while locked, they will not be reflected.
		 */
		public function lock():void {
			_locked = true;
		}
		/**
		 * Unlocks and updates the tile sheet. If any changes are made to the tiles while locked, they will not be reflected.
		 */
		public function unlock():void {
			if (!_locked) {
				return;
			}
			
			_locked = false;
			redraw();
		}
		/**
		 * Boolean flag indicating whether or not the tile sheet is locked. If any changes are made to the tiles while locked, they will not be reflected.
		 */
		public function get locked():Boolean {
			return _locked;
		}
		
		/**
		 * Forces the tile sheet to redraw itself, even if locked.
		 */
		public function redraw():void {
			if (!master) {
				return;
			}
			
			var rect:Rectangle = new Rectangle(0, 0, tileWidth, tileHeight);
			
			for (var i:uint = 0; i < tex.length; i++) {
				var x:uint = MathUtil.toX(cols, i);
				var y:uint = MathUtil.toY(cols, i);
				var texXY:uint = MathUtil.toXY(atlasCols, tex[i].x, tex[i].y);
				var tempBMD:BitmapData;
				
				if (texXY >= bitmaps.length) {
					tempBMD = nullBMD;
				} else {
					tempBMD = bitmaps[texXY];
				}
				
				master.copyPixels(tempBMD, rect, new Point(x * tileWidth, y * tileHeight));
			}
			
			(texture.base as flash.display3D.textures.Texture).uploadFromBitmapData(master);
		}
		
		/**
		 * Boolean flag indicating whether or not the texture has been loaded successfully.
		 */
		public function get isLoaded():Boolean {
			return _isLoaded;
		}
		
		/**
		 * The number of tiles the downloaded image has in total.
		 */
		public function get numAtlasTiles():uint {
			return atlasRows * atlasCols;
		}
		/**
		 * The number of tiles this sheet has in total.
		 */
		public function get numTiles():uint {
			return rows * cols;
		}
		
		//private
		private function onImageDecoderObserverNotify(sender:Object, event:String, data:Object):void {
			if (event == ImageDecoderEvent.COMPLETE) {
				onLoadComplete(data as BitmapData);
			} else if (event == ImageDecoderEvent.ERROR) {
				onLoadError(data as String);
			} else if (event == ImageDecoderEvent.PROGRESS) {
				
			}
		}
		
		private function onLoadError(error:String):void {
			dispatch(CustomTiledImageEvent.ERROR, error);
			
			var name:String = loader.file;
			name = name.replace(/\W|_/g, "_");
			
			if (!textureRegistry.getRegister(name + "_bmd")) {
				return;
			}
			
			bitmaps = TextureUtil.splitBMD(textureRegistry.getRegister(name + "_bmd") as BitmapData, atlasRows, atlasCols);
			rescale();
			
			for (var i:uint = 0; i < cols * rows; i++) {
				tex.push(new Point(uint.MAX_VALUE, uint.MAX_VALUE));
			}
			
			_isLoaded = true;
			dispatch(CustomTiledImageEvent.COMPLETE);
		}
		private function onLoadComplete(bmd:BitmapData):void {
			var name:String = loader.file;
			name = name.replace(/\W|_/g, "_");
			
			if (textureRegistry.getRegister(name + "_bmd")) {
				bmd.dispose();
			} else {
				textureRegistry.setRegister(name + "_bmd", bmd);
			}
			
			bitmaps = TextureUtil.splitBMD(textureRegistry.getRegister(name + "_bmd") as BitmapData, atlasRows, atlasCols);
			rescale();
			
			for (var i:uint = 0; i < cols * rows; i++) {
				tex.push(new Point(uint.MAX_VALUE, uint.MAX_VALUE));
			}
			
			_isLoaded = true;
			dispatch(CustomTiledImageEvent.COMPLETE);
		}
		
		private function rescale():void {
			for (var i:uint = 0; i < bitmaps.length; i++) {
				if (bitmaps[i].width != tileWidth || bitmaps[i].height != tileHeight) {
					bitmaps[i] = TextureUtil.resizeBMD(bitmaps[i], tileWidth, tileHeight);
				}
			}
			
			nullBMD = TextureUtil.resizeBMD(textureRegistry.getRegister("null_bmd") as BitmapData, tileWidth, tileHeight);
		}
		
		/**
		 * Dispatches an event.
		 * 
		 * @param	event The event's type.
		 * @param	data The event's data.
		 */
		protected function dispatch(event:String, data:Object = null):void {
			Observer.dispatch(OBSERVERS, this, event, data);
		}
	}
}