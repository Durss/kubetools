package com.muxxu.kube.components.map.icons {

	import com.muxxu.kube.components.map.IZoomableMapItem;
	import com.muxxu.kube.graphics.MapIconPath1Graphic;
	import com.muxxu.kube.graphics.MapIconPath2Graphic;
	import com.muxxu.kube.graphics.MapIconPath3Graphic;
	import com.muxxu.kube.graphics.MapIconPath4Graphic;

	import flash.display.Sprite;
		/**	 * 	 * @author Francois	 */	public class MapIconGpsPath extends Sprite implements IZoomableMapItem {										/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>MapIconGpsPath</code>.		 */		public function MapIconGpsPath() { }						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */		/* ****** *		 * PUBLIC *		 * ****** */		public function setImageByZoomLevel(zoom:int):void {			while(numChildren > 0) { removeChildAt(0); }						switch(zoom){				case 1:					addChild(new MapIconPath1Graphic());					break;				case 2:					addChild(new MapIconPath2Graphic());					break;				case 3:					addChild(new MapIconPath3Graphic());					break;				default:				case 4:					addChild(new MapIconPath4Graphic());					break;			}		}						/* ******* *		 * PRIVATE *		 * ******* */			}}