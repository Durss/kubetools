package com.muxxu.kube.components.map.icons {

	import com.muxxu.kube.components.map.IZoomableMapItem;
	import com.muxxu.kube.graphics.DolmenZone1Graphic;
	import com.muxxu.kube.graphics.DolmenZone2Graphic;
	import com.muxxu.kube.graphics.DolmenZone3Graphic;
	import com.muxxu.kube.graphics.DolmenZone4Graphic;

	import flash.display.Sprite;
		/**	 * 	 * @author Francois	 */	public class MapIconDolmenZone extends Sprite implements IZoomableMapItem {										/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>MapIconDolmenZone</code>.		 */		public function MapIconDolmenZone() { }						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */		/* ****** *		 * PUBLIC *		 * ****** */		public function setImageByZoomLevel(zoom:int):void {			while(numChildren > 0) { removeChildAt(0); }						switch(zoom){				case 1:					addChild(new DolmenZone1Graphic());					break;				case 2:					addChild(new DolmenZone2Graphic());					break;				case 3:					addChild(new DolmenZone3Graphic());					break;				default:				case 4:					addChild(new DolmenZone4Graphic());					break;			}		}						/* ******* *		 * PRIVATE *		 * ******* */			}}