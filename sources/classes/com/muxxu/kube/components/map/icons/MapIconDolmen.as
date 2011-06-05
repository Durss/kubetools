package com.muxxu.kube.components.map.icons {

	import com.muxxu.kube.components.map.IZoomableMapItem;
	import com.muxxu.kube.graphics.MapIconDolmen1Graphic;
	import com.muxxu.kube.graphics.MapIconDolmen2Graphic;
	import com.muxxu.kube.graphics.MapIconDolmen3Graphic;
	import com.muxxu.kube.graphics.MapIconDolmen4Graphic;

	import flash.display.Sprite;
		/**	 * 	 * @author Francois	 */	public class MapIconDolmen extends Sprite implements IZoomableMapItem {										/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>MapDolmen</code>.		 */		public function MapIconDolmen() { }						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */		/* ****** *		 * PUBLIC *		 * ****** */		public function setImageByZoomLevel(zoom:int):void {			while(numChildren > 0) { removeChildAt(0); }						switch(zoom){				case 1:					addChild(new MapIconDolmen1Graphic());					break;				case 2:					addChild(new MapIconDolmen2Graphic());					break;				case 3:					addChild(new MapIconDolmen3Graphic());					break;				default:				case 4:					addChild(new MapIconDolmen4Graphic());					break;			}		}						/* ******* *		 * PRIVATE *		 * ******* */			}}