package com.muxxu.kube.components.map.icons {

	import com.muxxu.kube.components.map.IZoomableMapItem;
	import com.muxxu.kube.graphics.MapCenter1Graphic;
	import com.muxxu.kube.graphics.MapCenter2Graphic;
	import com.muxxu.kube.graphics.MapCenter3Graphic;
	import com.muxxu.kube.graphics.MapCenter4Graphic;

	import flash.display.Sprite;		/**	 * 	 * @author Francois	 */	public class MapCenter extends Sprite implements IZoomableMapItem {										/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>MapCenter</code>.		 */		public function MapCenter() { }						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */		/* ****** *		 * PUBLIC *		 * ****** */		public function setImageByZoomLevel(zoom:int):void {			while(numChildren > 0) { removeChildAt(0); }						switch(zoom){				case 1:					addChild(new MapCenter1Graphic());					break;				case 2:					addChild(new MapCenter2Graphic());					break;				case 3:					addChild(new MapCenter3Graphic());					break;				default:				case 4:					addChild(new MapCenter4Graphic());					break;			}		}						/* ******* *		 * PRIVATE *		 * ******* */			}}