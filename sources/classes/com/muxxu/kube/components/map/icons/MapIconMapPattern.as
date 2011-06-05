package com.muxxu.kube.components.map.icons {

	import com.muxxu.kube.components.map.IZoomableMapItem;
	import com.muxxu.kube.graphics.MapPattern1Graphic;
	import com.muxxu.kube.graphics.MapPattern2Graphic;
	import com.muxxu.kube.graphics.MapPattern3Graphic;
	import com.muxxu.kube.graphics.MapPattern4Graphic;

	import flash.display.Sprite;
		/**	 * 	 * @author Francois	 */	public class MapIconMapPattern extends Sprite implements IZoomableMapItem {										/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>MapIconMapPattern</code>.		 */		public function MapIconMapPattern() { }						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */		/* ****** *		 * PUBLIC *		 * ****** */		public function setImageByZoomLevel(zoom:int):void {			while(numChildren > 0) { removeChildAt(0); }						switch(zoom){				case 1:					addChild(new MapPattern1Graphic());					break;				case 2:					addChild(new MapPattern2Graphic());					break;				case 3:					addChild(new MapPattern3Graphic());					break;				default:				case 4:					addChild(new MapPattern4Graphic());					break;			}		}						/* ******* *		 * PRIVATE *		 * ******* */			}}