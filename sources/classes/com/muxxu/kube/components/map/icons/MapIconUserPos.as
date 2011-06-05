package com.muxxu.kube.components.map.icons {

	import com.muxxu.kube.components.map.IZoomableMapItem;
	import com.muxxu.kube.graphics.MapIconUserPosition1Graphic;
	import com.muxxu.kube.graphics.MapIconUserPosition2Graphic;
	import com.muxxu.kube.graphics.MapIconUserPosition3Graphic;
	import com.muxxu.kube.graphics.MapIconUserPosition4Graphic;

	import flash.display.Sprite;
		/**	 * 	 * @author Francois	 */	public class MapIconUserPos extends Sprite implements IZoomableMapItem {										/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>MapIconUserPos</code>.		 */		public function MapIconUserPos() { }						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */		/* ****** *		 * PUBLIC *		 * ****** */		public function setImageByZoomLevel(zoom:int):void {			while(numChildren > 0) { removeChildAt(0); }						switch(zoom){				case 1:					addChild(new MapIconUserPosition1Graphic());					break;				case 2:					addChild(new MapIconUserPosition2Graphic());					break;				case 3:					addChild(new MapIconUserPosition3Graphic());					break;				default:				case 4:					addChild(new MapIconUserPosition4Graphic());					break;			}		}						/* ******* *		 * PRIVATE *		 * ******* */			}}