package com.muxxu.kube.vo {	import com.muxxu.kube.commands.LoadKUBTextureCmd;	import com.muxxu.kube.utils.ColorFunctions;	import com.nurun.core.commands.Command;	import flash.display.BitmapData;	import flash.events.TimerEvent;	import flash.geom.ColorTransform;	import flash.geom.Point;	import flash.geom.Rectangle;	import flash.utils.Dictionary;	import flash.utils.Timer;	/**	 * Contains a cube's textures data.	 * 	 * @author  Francois	 */	public class Texture {		private var _xml:XML;		private var _timer:Timer;		private var _top:BitmapData;		private var _bottom:BitmapData;		private var _front:BitmapData;		private var _back:BitmapData;		private var _left:BitmapData;		private var _right:BitmapData;		private var _selectedFace:BitmapData;		private var _preview:BitmapData;		private var _averages:Dictionary;		private var _landScapeUrl:String;		private var _landScapeID:String;		private var _name:String;		private var _enabledForGeneration:Boolean;		private var _alpha:Number;		private var _colorTransform:ColorTransform;
		private var _scrollX:int;
		private var _scrollY:int;
								/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>Texture</code>.		 */		public function Texture(xml:XML, landScapeID:String, landScapeUrl:String) {			_xml = xml;			_name = xml.@name;			_landScapeID = landScapeID;			_landScapeUrl = landScapeUrl;			initialize();		}						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */		/**		 * Gets the top face texture.		 */		public function get top():BitmapData { return _top; }				/**		 * Gets the left, right, front and back faces texture.		 */		public function get side():BitmapData { return _front; }				/**		 * Gets the bottom face texture.		 */		public function get bottom():BitmapData { return _bottom; }				/**		 * Gets the selected side.		 */		public function get selectedFace():BitmapData { return _selectedFace; }				/**		 * Gets the average color of the selected side.		 */		public function get averageColor():uint { return _averages[selectedFace]; }				/**		 * Gets the landscape's image URL.		 */		public function get landScapeURL():String { return _landScapeUrl; }				/**		 * Gets the landscape's ID.		 */		public function get landScapeID():String { return _landScapeID; }				/**		 * Gets the texture's ID.		 */		public function get id():String { return _xml.@id; }				/**		 * Gets if the texture is enabled for image generation.		 */		public function get enabledForGeneration():Boolean { return _enabledForGeneration; }				/**		 * Gets if the texture is enabled for image generation.		 */		public function set enabledForGeneration(value:Boolean):void { _enabledForGeneration = value; }				/**		 * Gets the preview's reference.		 */		public function get preview():BitmapData { return _preview; }				/**		 * Gets the kube's name.		 */		public function get name():String { return _name; }						/* ****** *		 * PUBLIC *		 * ****** */		/**		 * Gets the command that will load the images.		 */		public function get loadCommand():Command {			return new LoadKUBTextureCmd(_xml[0], registerData);		}				/**		 * Selects the top face.<br>		 * <br>		 * Called by the <code>TextureCube</code> class to activate the currently		 * displayed face. That, the <code>Grid</code> class knows which face it		 * should draw by using the <code>selectedSide</code> property.		 */		public function selectTop():void {			_selectedFace = _top;		}		/**		 * Selects the front face.<br>		 * <br>		 * Called by the <code>TextureCube</code> class to activate the currently		 * displayed face. That, the <code>Grid</code> class knows which face it		 * should draw by using the <code>selectedSide</code> property.		 */		public function selectSide():void {			_selectedFace = _front;		}		/**		 * Selects the bottom face.<br>		 * <br>		 * Called by the <code>TextureCube</code> class to activate the currently		 * displayed face. That, the <code>Grid</code> class knows which face it		 * should draw by using the <code>selectedSide</code> property.		 */		public function selectBottom():void {			_selectedFace = _bottom;		}								/* ******* *		 * PRIVATE *		 * ******* */		/**		 * Initializes data.		 */		private function initialize():void {			_averages = new Dictionary();			_enabledForGeneration = _landScapeID != "special";			_alpha	= parseFloat(_xml.@alpha);			if(isNaN(_alpha)) _alpha = 1;			_colorTransform = new ColorTransform(1, 1, 1, _alpha);		}				/**		 * Registers the kubes data		 */		private function registerData(data:Array):void {			_front		= data[0];			_back		= data[1];			_left		= data[2];			_right		= data[3];			_top		= data[4];			_bottom		= data[5];			_preview	= data[8];						_averages[_top] = ColorFunctions.bitmapDataAverage(_top);			_averages[_bottom] = ColorFunctions.bitmapDataAverage(_bottom);			_averages[_front] = ColorFunctions.bitmapDataAverage(_front);			if(_alpha < 1) {				_front.colorTransform(_front.rect, _colorTransform);				_top.colorTransform(_top.rect, _colorTransform);				_bottom.colorTransform(_bottom.rect, _colorTransform);			}						_scrollX	= data[6];			_scrollY	= data[7];			if(_scrollX != 0 || _scrollY != 0) {				_timer = new Timer(160);				_timer.addEventListener(TimerEvent.TIMER, ticTimerHandler);				_timer.start();			}						data = null;		}										//__________________________________________________________ SCROLL METHODS				/**		 * Called on timer's tic to scroll the faces.		 */		private function ticTimerHandler(e:TimerEvent):void {			if(_top != null) scrollBitmapData(_top);			if(_front != null && _front != _top) scrollBitmapData(_front);			if(_bottom != null && _bottom != _top && _bottom != _front) scrollBitmapData(_bottom);		}				/**		 * Scrolls a bitmap data by one pixel down.		 */		private function scrollBitmapData(bmd:BitmapData):void {			if(_scrollX == 0 && _scrollY == 0) return;			var tmp:BitmapData;			var rect:Rectangle, pos:Point;			bmd.lock();						if(_scrollX != 0) {				tmp = bmd.clone();				tmp.lock();				bmd.scroll(_scrollX, 0);				if(_scrollX > 0){					rect = new Rectangle(tmp.width - _scrollX, 0, _scrollX, tmp.height);					pos = new Point(0, 0);				}else{					rect = new Rectangle(0, 0, _scrollX, tmp.height);					pos = new Point(tmp.width - _scrollX, 0);				}				bmd.copyPixels(tmp, rect, pos);				tmp.dispose();			}						if(_scrollY != 0) {				tmp = bmd.clone();				tmp.lock();				bmd.scroll(0, _scrollY);				if(_scrollY > 0){					rect = new Rectangle(0, tmp.height - _scrollY, tmp.width, _scrollY);					pos = new Point(0, 0);				}else{					rect = new Rectangle(0, 0, tmp.width, _scrollY);					pos = new Point(0, tmp.height - _scrollY);				}				bmd.copyPixels(tmp, rect, pos);				tmp.dispose();			}							bmd.unlock();		}	}}