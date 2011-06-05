package com.muxxu.kube.views.gps.components {
	import com.muxxu.kube.components.map.MapEngine;
	import com.muxxu.kube.components.map.MapEngineEvent;
	import com.muxxu.kube.components.map.MapEntry;
	import com.muxxu.kube.components.tooltip.ToolTip;
	import com.muxxu.kube.components.tooltip.content.TTGpsInfoContent;
	import com.muxxu.kube.data.GPSData;
	import com.muxxu.kube.events.GPSDataEvent;
	import com.muxxu.kube.events.GPSMapDataEvent;
	import com.muxxu.kube.graphics.PencilIcon;
	import com.muxxu.kube.graphics.RubberIcon;
	import com.muxxu.kube.vo.ToolTipMessage;
	import com.nurun.components.form.events.FormComponentEvent;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;

	/**
	 * @author Francois
	 */
	public class GPSMap extends Sprite {
		
		private var _map:MapEngine;
		private var _width:int;
		private var _height:int;
		private var _eraseMode:Boolean;
		private var _infoMode:Boolean;
		private var _tooltip:ToolTip;
		private var _content:TTGpsInfoContent;
		private var _message:ToolTipMessage;
		private var _lastPos:Point;
		private var _rubberCursor:RubberIcon;
		private var _pencilCursor:PencilIcon;
		private var _enabled:Boolean;

		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>GPSMap</code>.
		 */
		public function GPSMap() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		/**
		 * Sets the component's width without simply scaling it.
		 */
		override public function set width(value:Number):void {
			_width = value;
			computePositions();
		}
		
		/**
		 * Sets the component's height without simply scaling it.
		 */
		override public function set height(value:Number):void {
			_height = value;
			computePositions();
		}
		
		/**
		 * Gets the virtual component's width.
		 */
		override public function get width():Number { return _width; }
		
		/**
		 * Gets the virtual component's height.
		 */
		override public function get height():Number { return _height; }

		
		
		/* ****** *
		 * PUBLIC *
		 * ****** */
		
		/**
		 * Enables rendering
		 */
		public function enable():void {
			var rect:Rectangle = new Rectangle(-100, -100, 200, 200);
			GPSData.getInstance().getZones(rect);
			_enabled = true;
		}

		/**
		 * Disables rendering
		 */
		public function disable():void {
			Mouse.show();
			_map.disable();			_enabled = false;
		}

		
		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initializes the class.
		 */
		private function initialize():void {
			_map		= addChild(new MapEngine()) as MapEngine;
			_tooltip	= addChild(new ToolTip()) as ToolTip;
			_content	= new TTGpsInfoContent();
			_message	= new ToolTipMessage(_content, _tooltip);
			_rubberCursor = addChild(new RubberIcon()) as RubberIcon;
			_pencilCursor = addChild(new PencilIcon()) as PencilIcon;
			
			_rubberCursor.visible = _pencilCursor.visible = false;
			
			addEventListener(Event.ADDED_TO_STAGE,					addedToStageHandler);
			_map.addEventListener(MouseEvent.CLICK,					clickMapHandler);
			_map.addEventListener(MapEngineEvent.DATA_NEEDED,		mapRequestDataHandler);
			_content.addEventListener(FormComponentEvent.SUBMIT,	submitInfosHandler);
			GPSData.getInstance().addEventListener(GPSDataEvent.ERASE_STATE_CHANGE,		eraseStateChangeHandler);			GPSData.getInstance().addEventListener(GPSDataEvent.ADD_INFOS_STATE_CHANGE,	addInfosStateChangeHandler);
			GPSData.getInstance().addEventListener(GPSMapDataEvent.LOAD_AREA_ERROR,		loadZonesErrorHandler);			GPSData.getInstance().addEventListener(GPSMapDataEvent.LOAD_AREA_COMPLETE,	loadZonesCompleteHandler);
		}

		/**
		 * Called when the stage is available.
		 */
		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE,		addedToStageHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,	mouseMoveHandler);
		}

		/**
		 * Resizes and replaces the elements.
		 */
		private function computePositions():void {
			_map.width	= Math.min(900, _width);
			_map.height	= Math.min(700, _height);
			_map.x		= Math.round((_width - _map.width) * .5);
			_map.y		= Math.round((_height - _map.height) * .5);
		}

		
		
		
		//__________________________________________________________ MOUSE EVENTS
		
		/**
		 * Called when the map is clicked.
		 */
		private function clickMapHandler(event:MouseEvent):void {			var coords:Point = _map.overCoordinates;
			if(_eraseMode){
				_map.removeEntry(coords.x, coords.y);
				GPSData.getInstance().removeEntry(coords.x, coords.y);
			}
			if(_infoMode) {
				var cell:MapEntry = _map.overCell;
				if(_lastPos == null || _lastPos.x != coords.x || _lastPos.y != coords.y) {
					_content.text = "";
				}
				if(cell != null && cell.rawData != null && cell.rawData.child("message") != undefined) {
					_content.text = cell.rawData.child("message")[0];
				}
				_lastPos = new Point(coords.x, coords.y);
				_content.setFocus();
				_tooltip.open(_message);
				_tooltip.x = Math.round(mouseX - _tooltip.width * .5);				_tooltip.y = Math.round(mouseY - _tooltip.height * .5);
				if(_tooltip.x < 0) _tooltip.x = 0;
				if(_tooltip.x > _width - _tooltip.width) _tooltip.x = _width - _tooltip.width;
				if(_tooltip.y < 0) _tooltip.y = 0;
				if(_tooltip.y > _height - _tooltip.height) _tooltip.y = _height - _tooltip.height;
				_map.closeToolTip();
				_infoMode = false;
			}
		}
		
		/**
		 * Called whent eh info tooltip is submitted.
		 */
		private function submitInfosHandler(event:FormComponentEvent):void {
			_tooltip.close();
			GPSData.getInstance().registerInfo(_lastPos, _content.text);
		}
		
		/**
		 * Called when the mouse moves.
		 */
		private function mouseMoveHandler(event:MouseEvent):void {
			if(!_enabled) return;
			if(	mouseX > _map.x
				&& mouseX < _map.x + _map.width
				&& mouseY > _map.y
				&& mouseY < _map.y + _map.height
				&& (_infoMode || _eraseMode)
				&& !(_tooltip.hitTestPoint(stage.mouseX, stage.mouseY) && _tooltip.visible)) {
				_pencilCursor.visible = _infoMode;				_rubberCursor.visible = _eraseMode;
				_pencilCursor.x = _rubberCursor.x = mouseX;				_pencilCursor.y = _rubberCursor.y = mouseY - _pencilCursor.height;
				Mouse.hide();			} else{
				_pencilCursor.visible = _rubberCursor.visible = false;
				Mouse.show();
			}
		}

		
		
		
		//__________________________________________________________ DATA EVENTS
		
		/**
		 * Called when erase mode changes.
		 */
		private function eraseStateChangeHandler(event:GPSDataEvent):void {
			_eraseMode = GPSData.getInstance().eraseMode;
			_map.lockScroll = _eraseMode;
		}
		
		/**
		 * Called when add infos data state change.
		 */
		private function addInfosStateChangeHandler(event:GPSDataEvent):void {
			_infoMode = GPSData.getInstance().addInfosMode;
		}

		
		
		
		//__________________________________________________________ SERVER RESULTS
		
		/**
		 * Called when new zones are loaded.
		 */
		private function loadZonesCompleteHandler(event:GPSMapDataEvent):void {
			_map.populate(event.zones, event.area);
			_map.enable();
			if(event.center != null) {
				_map.centerOn(new Point(event.center.x, event.center.y));
			}
			if(GPSData.getInstance().following) {
				GPSData.getInstance().setMapBmd(_map.getBmdOfCenter(5, 5));
			}
		}

		/**
		 * Called if zones loading failed
		 */
		private function loadZonesErrorHandler(event:GPSMapDataEvent):void {
			_map.enable();
		}
		
		/**
		 * Called when the map engine needs new data.
		 */
		private function mapRequestDataHandler(event:MapEngineEvent):void {
			GPSData.getInstance().getZones(event.dataRect);
		}
	}
}
