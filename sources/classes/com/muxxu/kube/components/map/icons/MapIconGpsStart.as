package com.muxxu.kube.components.map.icons {

	import com.muxxu.kube.components.map.IZoomableMapItem;
	import com.muxxu.kube.graphics.MapIconStart1Graphic;
	import com.muxxu.kube.graphics.MapIconStart2Graphic;
	import com.muxxu.kube.graphics.MapIconStart3Graphic;
	import com.muxxu.kube.graphics.MapIconStart4Graphic;

	import flash.display.Sprite;
		/**	 * 	 * @author Francois	 */	public class MapIconGpsStart extends Sprite implements IZoomableMapItem {										/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>MapIconGpsStart</code>.		 */		public function MapIconGpsStart() { }						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */		/* ****** *		 * PUBLIC *		 * ****** */		public function setImageByZoomLevel(zoom:int):void {			while(numChildren > 0) { removeChildAt(0); }						switch(zoom){				case 1:					addChild(new MapIconStart1Graphic());					break;				case 2:					addChild(new MapIconStart2Graphic());					break;				case 3:					addChild(new MapIconStart3Graphic());					break;				default:				case 4:					addChild(new MapIconStart4Graphic());					break;			}		}						/* ******* *		 * PRIVATE *		 * ******* */			}}