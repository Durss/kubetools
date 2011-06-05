package com.muxxu.kube.vo {

	/**
	 * @author Francois
	 */
	public class MessageIds {
		
		public static const KPA_LOADED:String			= "kpaLoaded";
		
		
		
		
		/**
		 * Gets if a message id is a tool box message
		 */
		public static function isToolBoxMessage(id:String):Boolean{
			return id.search(/^displayTools/i) > -1;
		}
		
	}
}