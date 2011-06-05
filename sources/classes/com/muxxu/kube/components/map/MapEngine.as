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

		private var _height:int;
		private var _pattern:BitmapData;
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
		private var _entries:Vector.<MapEntry>;
		private var _isMouseOver:Boolean;
		private var _invalidator:Invalidator;
		private var _enabled:Boolean;
		private var _pxCenter:int;
		private var _pyCenter:int;

		
		/**
		 * Sets if the map scroll with mouse should be locked or not.
		public function set lockScroll(value:Boolean):void {
			_scrollLocked = value;
		}
			render(true);
			checkForLoading();
			checkForLoading();
			mouseChildren = true;
			if(forceLoad) {
				validate();
			}
			render(true);
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

			var src:MapIconMapPattern = new MapIconMapPattern();
			_tooltip.addEventListener(MouseEvent.ROLL_OUT, rollOutToolTipHandler);
			_tooltip.addEventListener(Event.CLOSE, closeTooltipHandler);
			wheelHandler();
		
		/**
		 * Called when the tooltip is closed.
		 */
		private function closeTooltipHandler(event:Event):void {
			_ttLocked = false;
			_tooltip.mouseChildren = false;
		}
		
			_isMouseOver = !_gotoForm.contains(event.target as DisplayObject);
			if(event.type == MouseEvent.ROLL_OUT && event.target == this) {
				_isMouseOver = false;
			}
		}

		private function wheelHandler(event:MouseEvent = null):void {
			if(event != null) {
				var oldZL:int = _zoomLevel;
				if(oldZL == _zoomLevel) return;
			}
			src.setImageByZoomLevel(_zoomLevel);
			for(i = 0; i < len; ++i) {
				icon.y *= moveCoeff;
				IZoomableMapItem(icon).setImageByZoomLevel(_zoomLevel);
			}
			render(true);
			if(event != null) {
				checkForLoading();
			}

			
			if(_isMouseOver
			&& mouseX < _width
						_tooltip.mouseChildren = false;
					}
					_tooltip.x = Math.round(mouseX - _tooltip.width * .5);
			} else {
				_square.visible = false;
				
			_pxCenter = _px + Math.round(_width * .5 * _coeff) * _cellSize + 1;
			_pyCenter = _py + Math.round(_height * .5 * _coeff) * _cellSize + 1;
				m.translate(_pxCenter, _pyCenter);
			if(!_enabled) return;
			var zoneW:int = Math.round(_width * _coeff);
			rect.top		= Math.round(-_pyCenter * _coeff);
			
				dispatchEvent(new MapEngineEvent(MapEngineEvent.DATA_NEEDED, rect));
		private function rollOutToolTipHandler(event:MouseEvent):void {
			if(!_tooltip.mouseChildren) return;
		}

	}