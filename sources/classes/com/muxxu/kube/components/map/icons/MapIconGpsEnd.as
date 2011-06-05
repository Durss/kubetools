package com.muxxu.kube.components.map.icons {

	import com.muxxu.kube.components.map.IZoomableMapItem;
	import com.muxxu.kube.graphics.MapIconEnd1Graphic;
	import com.muxxu.kube.graphics.MapIconEnd2Graphic;
	import com.muxxu.kube.graphics.MapIconEnd3Graphic;
	import com.muxxu.kube.graphics.MapIconEnd4Graphic;

	import flash.display.Sprite;
		/**	 * 	 * @author Francois	 */	public class MapIconGpsEnd extends Sprite implements IZoomableMapItem {										/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>MapIconGpsEnd</code>.		 */		public function MapIconGpsEnd() { }						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */		/* ****** *		 * PUBLIC *		 * ****** */		public function setImageByZoomLevel(zoom:int):void {			while(numChildren > 0) { removeChildAt(0); }						switch(zoom){				case 1:					addChild(new MapIconEnd1Graphic());					break;				case 2:					addChild(new MapIconEnd2Graphic());					break;				case 3:					addChild(new MapIconEnd3Graphic());					break;				default:				case 4:					addChild(new MapIconEnd4Graphic());					break;			}		}						/* ******* *		 * PRIVATE *		 * ******* */			}}