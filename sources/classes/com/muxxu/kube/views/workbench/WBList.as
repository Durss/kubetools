package com.muxxu.kube.views.workbench {

	import flash.display.DisplayObject;
	import com.nurun.structure.environnement.label.Label;
	import com.muxxu.kube.components.tooltip.content.TTTextContent;
	import com.muxxu.kube.vo.ToolTipMessage;
	import com.muxxu.kube.components.tooltip.ToolTip;
	import com.muxxu.kube.data.LocalConnectionManager;
	import com.muxxu.kube.events.LocalConnectionManagerEvent;
	import com.muxxu.kube.vo.Point3D;
	import com.nurun.utils.pos.PosUtils;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * 
	 * @author Francois
	 * @date 8 mars 2011;
	 */
	public class WBList extends Sprite {

		private var _items:Vector.<WBListItem>;
		private var _index:int;
		private var _width:Number;
		private var _startItem:WBListItem;
		private var _lineCtn:Shape;
		private var _lastOver:WBListItem;
		private var _toolTip:ToolTip;
		private var _ttContent:TTTextContent;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>WBList</code>.
		 */
		public function WBList() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		/**
		 * Sets the width of the component without simply scaling it.
		 */
		override public function set width(value:Number):void {
			_width = value;
			computePositions();
		}



		/* ****** *
		 * PUBLIC *
		 * ****** */


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			_items = new Vector.<WBListItem>();
			_lineCtn = addChild(new Shape()) as Shape;
			_toolTip = new ToolTip();
			_ttContent = new TTTextContent();
			_toolTip.open(new ToolTipMessage(_ttContent, null));
			
			LocalConnectionManager.getInstance().addEventListener(LocalConnectionManagerEvent.EXACT_COORDINATES, coordinatesHandler);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
//			var i:int, len:int, item:WBListItem;
//			len = 15;
//			for(i = 0; i < len; ++i) {
//				item = new WBListItem("N°" + (++_index), new Point3D(rand(), rand(), rand()));
//				_items.push(item);
//				addChildAt(item, 0);
//				item.addEventListener(Event.RESIZE, dispatchEvent);
//				item.addEventListener(Event.CLOSE, closeItemHandler);
//				item.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
//			}
			
			computePositions();
		}

//		private function rand():Number {
//			return Math.round((Math.random()-Math.random()) * 99999999);
//		}
		
		/**
		 * Called when the stage is available.
		 */
		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			computePositions();
		}
		
		/**
		 * Resizes and replaces the elements.
		 */
		private function computePositions():void {
			PosUtils.hDistribute(_items, _width, 5, 5);
		}
		
		/**
		 * Called when new coordinates are available.
		 */
		private function coordinatesHandler(event:LocalConnectionManagerEvent):void {
			var item:WBListItem = new WBListItem("N°" + (++_index), event.zone);
			_items.push(item);
			addChildAt(item, 0);
			item.addEventListener(Event.RESIZE, dispatchEvent);
			item.addEventListener(Event.CLOSE, closeItemHandler);
			item.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			computePositions();
		}
		
		/**
		 * Called when an item is closed
		 */
		private function closeItemHandler(event:Event):void {
			var item:WBListItem = event.currentTarget as WBListItem;
			item.removeEventListener(Event.RESIZE, dispatchEvent);
			item.removeEventListener(Event.CLOSE, closeItemHandler);
			item.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			var i:int, len:int;
			len = _items.length;
			for(i = 0; i < len; ++i) {
				if(_items[i] == item) {
					_items.splice(i, 1);
					break;
				}
			}
			removeChild(item);
			computePositions();
		}
		
		/**
		 * Called when the mouse is pressed
		 */
		private function mouseDownHandler(event:MouseEvent):void {
			_startItem = event.currentTarget as WBListItem;
			_startItem.alpha = 1;
		}

		/**
		 * Called when the mouse is released
		 */
		private function mouseUpHandler(event:MouseEvent):void {
//			if(_lastOver != null && _lastOver != _startItem) {
//				
//			}
			if(_lastOver == null || !contains(event.target as DisplayObject)) {
				_lineCtn.graphics.clear();
				if(contains(_toolTip)) removeChild(_toolTip);
				var i:int, len:int;
				len = _items.length;
				for(i = 0; i < len; ++i) {
					_items[i].alpha = 1;
				}
			}
			_startItem = null;
			_lastOver = null;
		}
		
		/**
		 * Called when the mouse moves
		 */
		private function mouseMoveHandler(event:MouseEvent):void {
			if(_startItem != null) {
				var i:int, len:int;
				len = _items.length;
				_lastOver = null;
				for(i = 0; i < len; ++i) {
					if(_items[i] == _startItem) continue;
					if(_items[i].hitTestPoint(stage.mouseX, stage.mouseY)) {
						_lastOver = _items[i];
						_lastOver.alpha = 1;
					}else {
						_items[i].alpha = .35;
					}
				}
				var endPos:Point = _lastOver == null? new Point(mouseX, mouseY) : new Point(_lastOver.x + 6, _lastOver.y + 8);
				var px:int = Math.min(_startItem.x, endPos.x) + Math.abs(_startItem.x - endPos.x) * .5;
				var py:int = Math.max(_startItem.y, endPos.y) + 50;
				_lineCtn.graphics.clear();
				_lineCtn.graphics.lineStyle(5, 0xffffff, 1);
				_lineCtn.graphics.moveTo(_startItem.x + 6, _startItem.y + 8);
				_lineCtn.graphics.curveTo(px, py, endPos.x, endPos.y);
				
				if(_lastOver != null) {
					addChild(_toolTip);
					var label:String = Label.getLabel("wbItemDistance");
					label = label.replace(/\{X\}/gi, Math.abs(_startItem.pos.x - _lastOver.pos.x)+1);
					label = label.replace(/\{Y\}/gi, Math.abs(_startItem.pos.y - _lastOver.pos.y)+1);
					label = label.replace(/\{Z\}/gi, Math.abs(_startItem.pos.z - _lastOver.pos.z)+1);
					_ttContent.populate(label);
					_toolTip.x = px - _toolTip.width * .5;
					_toolTip.y = Math.min(_startItem.y, endPos.y) + Math.abs(_startItem.y - endPos.y) * .5;
				}else if(contains(_toolTip)) {
					removeChild(_toolTip);
				}
			}
		}
		
	}
}