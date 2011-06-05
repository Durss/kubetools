package com.muxxu.kube.events {

	import com.muxxu.kube.components.map.MapEntry;
	import com.muxxu.kube.vo.Point3D;

	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * Event fired by the <code>GPSMapDataEvent</code> singleton.
	 * 
	 * @author  Francois
	 */
	public class GPSMapDataEvent extends Event {
		
		public static const LOAD_AREA_COMPLETE:String	= "loadAreaComplete";
		public static const LOAD_AREA_ERROR:String		= "loadAreaError";
		
		private var _resultCode:int;
		private var _area:Rectangle;
		private var _zones:Vector.<MapEntry>;
		private var _center:Point3D;
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>GPSMapDataEvent</code>.
		 */
		public function GPSMapDataEvent(type:String, resultCode:int = 0, area:Rectangle = null, zones:Vector.<MapEntry> = null, center:Point3D = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			_center = center;
			_zones = zones;
			_area = area;
			_resultCode = resultCode;
			super(type, bubbles, cancelable);
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		/**
		 * Gets the result code.
		 */
		public function get resultCode():int {
			return _resultCode;
		}
		
		/**
		 * Gets the area concerned by the loading.
		 */
		public function get area():Rectangle {
			return _area;
		}
		
		/**
		 * Gets the zones to add.
		 */
		public function get zones():Vector.<MapEntry> {
			return _zones;
		}
		
		/**
		 * Gets the point to center the map on.
		 */
		public function get center():Point3D {
			return _center;
		}



		/* ****** *
		 * PUBLIC *
		 * ****** */
		override public function clone():Event {
			return new GPSMapDataEvent(type, resultCode, area, zones, center, bubbles, cancelable);
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
	}
}