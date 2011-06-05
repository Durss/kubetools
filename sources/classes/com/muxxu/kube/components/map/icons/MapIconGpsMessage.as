package com.muxxu.kube.components.map.icons {

	import com.muxxu.kube.components.map.IZoomableMapItem;
	import com.muxxu.kube.graphics.MapIconMessage1Graphic;
	import com.muxxu.kube.graphics.MapIconMessage2Graphic;
	import com.muxxu.kube.graphics.MapIconMessage3Graphic;
	import com.muxxu.kube.graphics.MapIconMessage4Graphic;

	import flash.display.Sprite;
		/**	 * 	 * @author Francois	 */	public class MapIconGpsMessage extends Sprite implements IZoomableMapItem {										/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>MapIconGpsMessage</code>.		 */		public function MapIconGpsMessage() { }						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */		/* ****** *		 * PUBLIC *		 * ****** */		public function setImageByZoomLevel(zoom:int):void {			while(numChildren > 0) { removeChildAt(0); }						switch(zoom){				case 1:					addChild(new MapIconMessage1Graphic());					break;				case 2:					addChild(new MapIconMessage2Graphic());					break;				case 3:					addChild(new MapIconMessage3Graphic());					break;				default:				case 4:					addChild(new MapIconMessage4Graphic());					break;			}		}						/* ******* *		 * PRIVATE *		 * ******* */			}}