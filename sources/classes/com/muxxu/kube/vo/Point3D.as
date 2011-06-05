package com.muxxu.kube.vo {
	
	/**
	 * 
	 * @author Francois
	 * @date 8 mars 2011;
	 */
	public class Point3D {
		
		private var _x:Number;
		private var _y:Number;
		private var _z:Number;
		
		
		

		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>Point3D</code>.
		 */
		public function Point3D(x:Number, y:Number, z:Number = 0) {
			_z = z;
			_y = y;
			_x = x;
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */

		public function get x():Number {
			return _x;
		}

		public function set x(x:Number):void {
			_x = x;
		}

		public function get y():Number {
			return _y;
		}

		public function set y(y:Number):void {
			_y = y;
		}

		public function get z():Number {
			return _z;
		}

		public function set z(z:Number):void {
			_z = z;
		}



		/* ****** *
		 * PUBLIC *
		 * ****** */


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		
	}
}