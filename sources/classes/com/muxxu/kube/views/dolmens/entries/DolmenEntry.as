package com.muxxu.kube.views.dolmens.entries {	import com.muxxu.kube.components.map.icons.MapIconDolmen;
	import flash.geom.Point;
	import com.muxxu.kube.data.SharedObjectManager;
	import flash.geom.ColorTransform;	/**	 * 	 * @author  Francois	 */	public class DolmenEntry extends MapIconDolmen {				private var _pos:Point;						


		/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>DolmenEntry</code>.		 */
		public function DolmenEntry(hidden:Boolean, pos:Point) {
			_pos = pos;
			if(hidden) {				transform.colorTransform = new ColorTransform(8,2,8);			}			updateTouchedState();		}
						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */		/* ****** *		 * PUBLIC *		 * ****** */		/**		 * Updates the touched state.		 */		public function updateTouchedState():void {			if(SharedObjectManager.getInstance().isDolmenTouched(_pos)){				transform.colorTransform = new ColorTransform(5,8,5);			}		}						/* ******* *		 * PRIVATE *		 * ******* */			}}