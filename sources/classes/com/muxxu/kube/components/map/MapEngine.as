package com.muxxu.kube.components.map {

	import gs.TweenLite;
	import gs.easing.Sine;

	import com.muxxu.kube.components.LoaderSpinning;
	import com.muxxu.kube.components.button.KubeButton;
	import com.muxxu.kube.components.map.icons.MapCenter;
	import com.muxxu.kube.components.map.icons.MapIconMapPattern;
	import com.muxxu.kube.components.tooltip.ToolTip;
	import com.muxxu.kube.components.tooltip.content.TTZoneContent;
	import com.muxxu.kube.vo.ToolTipMessage;
	import com.nurun.components.invalidator.Invalidator;
	import com.nurun.components.invalidator.Validable;
	import com.nurun.utils.math.MathUtils;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	/**	 * Displays and manages a MAP.	 * 	 * @author  Francois	 */	public class MapEngine extends Sprite implements Validable {		private var _cellSize:int = 10;		private var _width:int;
		private var _height:int;
		private var _pattern:BitmapData;		private var _iconsCtn:Sprite;
		private var _dragOffset:Point;
		private var _posOffset:Point;
		private var _px:int;
		private var _py:int;
		private var _pressed:Boolean;
		private var _disableLayer:Sprite;
		private var _spin:LoaderSpinning;
		private var _currentArea:Rectangle;
		private var _tooltip:ToolTip;
		private var _ttContent:TTZoneContent;
		private var _ttMessage:ToolTipMessage;
		private var _square:Shape;
		private var _grid:Sprite;
		private var _ttLocked:Boolean;
		private var _entriesCoords:Array;
		private var _lastTTPos:Point;
		private var _zoomLevel:int;
		private var _iconToData:Dictionary;
		private var _entries:Vector.<MapEntry>;		private var _coeff:Number;		private var _gotoForm:GotoForm;
		private var _isMouseOver:Boolean;
		private var _invalidator:Invalidator;
		private var _enabled:Boolean;
		private var _pxCenter:int;
		private var _pyCenter:int;		private var _scrollLocked:Boolean;
								/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>MapEngine</code>.		 */		public function MapEngine() {			initialize();		}						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */		/**		 * Sets the component's width without simply scaling it.		 */		override public function set width(value:Number):void {			_width = value;			_invalidator.invalidate();		}		/**		 * Sets the component's height without simply scaling it.		 */		override public function set height(value:Number):void {			_height = value;			render(true);			_invalidator.invalidate();		}				/**		 * Gets the virtual component's width.		 */		override public function get width():Number { return _width; }				/**		 * Gets the virtual component's height.		 */		override public function get height():Number { return _height; }				/**		 * Gets the rolled over cell's coordinates.		 */		public function get overCell():MapEntry {			var pos:Point = overCoordinates;			return _entriesCoords[pos.x+"_"+pos.y];		}				/**		 * Gets the rolled over cell's coordinates.		 */		public function get overCoordinates():Point {			var res:Point = new Point();			res.x	= Math.floor((-_pxCenter + mouseX + 1) * _coeff);			res.y	= Math.floor((-_pyCenter + mouseY + 1) * _coeff);			return res;		}
		
		/**
		 * Sets if the map scroll with mouse should be locked or not.		 */
		public function set lockScroll(value:Boolean):void {
			_scrollLocked = value;
		}		/* ****** *		 * PUBLIC *		 * ****** */		/**		 * @inheritDoc		 */		public function validate():void {			_invalidator.flagAsValidated();
			render(true);
			checkForLoading();		}		/**		 * Populates the map with a vector of <code>MapEntry</code> value objects.		 * 		 * @param data		the data to display in the map.		 * @param dataRect	the loaded data rectangle. If the user drags the map outside of this rect, new data will have to be loaded.		 */		public function populate(data:Vector.<MapEntry>, dataRect:Rectangle):void {			var i:int, len:int, icon:DisplayObject, entry:MapEntry;			len = data.length;			//Create a clone of "data" param to prevent from modifying it.			_entries = new Vector.<MapEntry>();			_entriesCoords = [];			_iconToData = new Dictionary();			while(_iconsCtn.numChildren>0) _iconsCtn.removeChildAt(0);						for(i = 0; i < len; ++i) {				entry = data[i];				icon = _iconsCtn.addChild(entry.icon as DisplayObject);				icon.x = entry.x * _cellSize;				icon.y = entry.y * _cellSize;				_entriesCoords[entry.x+"_"+entry.y] = entry;				_iconToData[icon] = entry;				_entries.push(entry);			}						if(dataRect.left < 0 && dataRect.right > 0 && dataRect.top < 0 && dataRect.bottom > 0){				var center:MapCenter = new MapCenter();				center.mouseEnabled = false;				var centerEntry:MapEntry = new MapEntry(-1, -1, center, null);				icon = _iconsCtn.addChild(center);				icon.x = -_cellSize;				icon.y = -_cellSize;				_entriesCoords[-1+"_"+-1] = centerEntry;				_iconToData[icon] = centerEntry;				_entries.push(centerEntry);			}						_currentArea = dataRect;			wheelHandler();		}				/**		 * Centers the map on a specific point		 */		public function centerOn(pos:Point):void {			_px = -pos.x * _cellSize;			_py = -pos.y * _cellSize;			render(true);
			checkForLoading();		}				/**		 * Gets a bitmap data of the center.		 * 		 * @param w	number of zone in width to capture.		 * @param h number of zone in height to capture.		 */		public function getBmdOfCenter(w:int, h:int):BitmapData {			var bmd:BitmapData = new BitmapData(w * _cellSize + 1, h * _cellSize + 1, true, 0);			var m:Matrix = new Matrix();			var tx:int = -Math.round(_width * .5 * _coeff) * _cellSize + Math.floor(w * .5) * _cellSize;			var ty:int = -Math.round(_height * .5 * _coeff) * _cellSize + Math.floor(h * .5) * _cellSize;			m.translate(tx, ty);			removeChild(_tooltip);			bmd.draw(this, m);			addChild(_tooltip);			return bmd;		}				/**		 * Enables rendering		 */		public function enable(forceLoad:Boolean = false):void {			_enabled = true;
			mouseChildren = true;			_spin.close();			TweenLite.to(_disableLayer, .5, {autoAlpha:0});			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			if(forceLoad) {
				validate();
			}		}				/**		 * Disables rendering		 */		public function disable():void {			_enabled = false;			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);		}				/**		 * Removes an entry from the map.		 */		public function removeEntry(x:int, y:int):void {			var i:int, len:int, entry:MapEntry;			len = _entries.length;			delete _entriesCoords[x + "_" + y];			for(i = 0; i < len; ++i) {				entry = _entries[i];				if(entry.x == x && entry.y == y) {					_entries.splice(i, 1)[0];					_iconsCtn.removeChild(entry.icon as DisplayObject);					delete _iconToData[entry.icon];					len --;					i --;				}			}
			render(true);		}				/**		 * Closes the tooltip.		 */		public function closeToolTip():void {
			_ttLocked = false;
			_tooltip.mouseChildren = false;
			_tooltip.close();
		}
		
		/**
		 * Updates the map.
		 */
		public function update():void {
			wheelHandler();
		}
										/* ******* *		 * PRIVATE *		 * ******* */		/**		 * Initializes the class.		 */		private function initialize():void {			_invalidator	= new Invalidator(this);			_iconsCtn		= new Sprite();			_ttContent		= new TTZoneContent(false);			_ttMessage		= new ToolTipMessage(_ttContent, null);			_entries		= new Vector.<MapEntry>();			_grid			= addChild(new Sprite()) as Sprite;			_square			= addChild(new Shape()) as Shape;			_disableLayer	= addChild(new Sprite()) as Sprite;			_gotoForm		= addChild(new GotoForm(this)) as GotoForm;			_tooltip		= addChild(new ToolTip()) as ToolTip;			_spin			= _disableLayer.addChild(new LoaderSpinning()) as LoaderSpinning;						_zoomLevel = 4;
			var src:MapIconMapPattern = new MapIconMapPattern();			src.setImageByZoomLevel(_zoomLevel);			_pattern = new BitmapData(src.width, src.height, true, 0);			_pattern.draw(src);						_spin.open();						mouseChildren = false;						addEventListener(MouseEvent.CLICK, clickHandler);			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);			addEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler);			addEventListener(MouseEvent.MOUSE_OVER, mouseOutOverHandler);			addEventListener(MouseEvent.MOUSE_OUT, mouseOutOverHandler);			addEventListener(MouseEvent.ROLL_OUT, mouseOutOverHandler);
			_tooltip.addEventListener(MouseEvent.ROLL_OUT, rollOutToolTipHandler);
			_tooltip.addEventListener(Event.CLOSE, closeTooltipHandler);
			wheelHandler();		}
		
		/**
		 * Called when the tooltip is closed.
		 */
		private function closeTooltipHandler(event:Event):void {
			_ttLocked = false;
			_tooltip.mouseChildren = false;
		}
				/**		 * Called when the map is rolled over or rolled out.		 */		private function mouseOutOverHandler(event:MouseEvent):void {
			_isMouseOver = !_gotoForm.contains(event.target as DisplayObject);
			if(event.type == MouseEvent.ROLL_OUT && event.target == this) {
				_isMouseOver = false;
			}
		}
		/**		 * Called when the mouse's wheel is used.		 */
		private function wheelHandler(event:MouseEvent = null):void {
			if(event != null) {
				var oldZL:int = _zoomLevel;				_zoomLevel += event.delta / 3;				_zoomLevel = MathUtils.restrict(_zoomLevel, 1, 4);
				if(oldZL == _zoomLevel) return;
			}									var exSize:int = _cellSize;			_cellSize	= _zoomLevel * 2 + 2;			_coeff		= 1/_cellSize;						_square.graphics.clear();			_square.graphics.lineStyle(1);			_square.graphics.drawRect(0, 0, _cellSize, _cellSize);						var src:MapIconMapPattern = new MapIconMapPattern();
			src.setImageByZoomLevel(_zoomLevel);			_pattern = new BitmapData(src.width, src.height, true, 0);			_pattern.draw(src);						var i:int, len:int, icon:DisplayObject, moveCoeff:Number;			moveCoeff = _cellSize/exSize;			len = _entries.length;
			for(i = 0; i < len; ++i) {				icon = _entries[i].icon as DisplayObject;				icon.x *= moveCoeff;
				icon.y *= moveCoeff;
				IZoomableMapItem(icon).setImageByZoomLevel(_zoomLevel);
			}			_px *= moveCoeff;			_py *= moveCoeff;
			render(true);
			if(event != null) {
				checkForLoading();
			}		}
		/**		 * Resizes and replaces the elements.		 */		private function render(resize:Boolean = false):void {			if(_width < 1 || _height < 1) return;						if(resize) {				_disableLayer.graphics.clear();				_disableLayer.graphics.beginFill(0, .6);				_disableLayer.graphics.drawRect(0, 0, _width, _height);								_spin.x = _width * .5;				_spin.y = _height * .5;			}
			
			if(_isMouseOver
			&& mouseX < _width			&& mouseY < _height			&& mouseX > 0			&& mouseY > 0) {				var moduloX:int = _px % _cellSize;				var moduloY:int = _py % _cellSize;				var px:int = Math.floor((mouseX - moduloX) * _coeff) * _cellSize + moduloX;				var py:int = Math.floor((mouseY - moduloY) * _coeff) * _cellSize + moduloY;				_square.x = px;				_square.y = py;				_square.visible = true;								if(!_ttLocked) {					px		= Math.floor((-_pxCenter + mouseX + 1) * _coeff);					py		= Math.floor((-_pyCenter + mouseY + 1) * _coeff);					if((_lastTTPos == null || _lastTTPos.x != px || _lastTTPos.y != py) && _entriesCoords != null) {						_lastTTPos = new Point(px, py);						_ttContent.populate(px, py, _entriesCoords[px+"_"+py]);						_tooltip.open(_ttMessage);
						_tooltip.mouseChildren = false;
					}
					_tooltip.x = Math.round(mouseX - _tooltip.width * .5);					_tooltip.y = Math.round(mouseY - _tooltip.height - 10);				}
			} else {
				_square.visible = false;				_tooltip.close();				_ttLocked = false;				_tooltip.mouseChildren = false;			}
				
			_pxCenter = _px + Math.round(_width * .5 * _coeff) * _cellSize + 1;
			_pyCenter = _py + Math.round(_height * .5 * _coeff) * _cellSize + 1;						if((_pressed && !_scrollLocked) || resize) {				var m:Matrix = new Matrix();				m.tx = _px;				m.ty = _py;				_grid.graphics.clear();				_grid.graphics.beginBitmapFill(_pattern, m);				_grid.graphics.drawRect(0, 0, _width, _height);				_grid.graphics.endFill();								var bmd:BitmapData = new BitmapData(_width, _height, true, 0);				m = new Matrix();
				m.translate(_pxCenter, _pyCenter);				bmd.draw(_iconsCtn, m);				_grid.graphics.beginBitmapFill(bmd);				_grid.graphics.drawRect(0, 0, _width, _height);				_grid.graphics.endFill();			}		}				/**		 * Checks if data need to be loaded.		 */		private function checkForLoading():void {
			if(!_enabled) return;
			var zoneW:int = Math.round(_width * _coeff);			var zoneH:int = Math.round(_height * _coeff);			var marginX:Number = Math.round(zoneW * .3);			var marginY:Number = Math.round(zoneH * .3);			var rect:Rectangle = new Rectangle();			rect.left		= Math.round(-_pxCenter * _coeff);
			rect.top		= Math.round(-_pyCenter * _coeff);			rect.width		= zoneW;			rect.height		= zoneH;
						if(_currentArea == null			|| rect.x < _currentArea.left			|| rect.y < _currentArea.top			|| rect.x + rect.width > _currentArea.x + _currentArea.width			|| rect.y + rect.height > _currentArea.y + _currentArea.height) {				rect.left -= marginX;				rect.top -= marginY;				rect.width += marginX * 2;				rect.height += marginY * 2;				_spin.open();				TweenLite.to(_disableLayer, .5, {autoAlpha:1});				mouseChildren	= false;				_currentArea = rect;
				dispatchEvent(new MapEngineEvent(MapEngineEvent.DATA_NEEDED, rect));			}		}				/**		 * Called when the stage is available.		 */		private function addedToStageHandler(event:Event):void {			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);		}				/**		 * Called on ENTER_FRAME event.		 */		private function enterFrameHandler(event:Event):void {			if(_pressed && !_scrollLocked) {				_px = Math.round(mouseX - _dragOffset.x + _posOffset.x);				_py = Math.round(mouseY - _dragOffset.y + _posOffset.y);			}			render();		}								//__________________________________________________________ MOUSE EVENTS				/**		 * Called when the map is clicked.		 * It locks the tooltip to be able to use the options on it.		 */		private function clickHandler(event:MouseEvent):void {			if(event.target is KubeButton) return;			if(_ttLocked			|| Math.abs(_dragOffset.x - mouseX) > 2			|| Math.abs(_dragOffset.y - mouseY) > 2			|| !_ttContent.isInteractive) return;			_ttLocked = true;			_tooltip.mouseChildren = true;			TweenLite.to(_tooltip, .1, {x:Math.round(mouseX - _tooltip.width * .5), y:Math.round(mouseY - _tooltip.height * .5), ease:Sine.easeInOut});		}				/**		 * Called when the tooltip is rolled out.		 */
		private function rollOutToolTipHandler(event:MouseEvent):void {
			if(!_tooltip.mouseChildren) return;			_tooltip.close();			_ttLocked = false;
		}
		/**		 * Called when mouse is pressed.		 */		private function mouseDownHandler(event:MouseEvent):void {			if(_tooltip.contains(event.target as DisplayObject)) return;						_dragOffset	= new Point(mouseX, mouseY);			_posOffset	= new Point(_px, _py);			_pressed = true;		}				/**		 * Called when mouse is released.		 */		private function mouseUpHandler(event:MouseEvent):void {			if(!_pressed) return;			_pressed = false;			checkForLoading();		}
	}}