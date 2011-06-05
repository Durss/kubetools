package com.muxxu.kube.events {
	import flash.events.Event;

	/**
	 * Event fired by the <code>GalleryEnlarge</code> component.
	 * 
	 * @author  Francois
	 */
	public class GalleryEnlargeEvent extends Event {

		public static const PREV_IMAGE:String	= "prevImage";		public static const NEXT_IMAGE:String	= "nextImage";
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>GalleryEnlargeEvent</code>.
		 */
		public function GalleryEnlargeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
		

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		
		


		/* ****** *
		 * PUBLIC *
		 * ****** */
		override public function clone():Event{
			return new GalleryEnlargeEvent(type, bubbles, cancelable);
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
	}
}