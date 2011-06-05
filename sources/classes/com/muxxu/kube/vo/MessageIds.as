package com.muxxu.kube.vo {

	/**
	 * @author Francois
	 */
	public class MessageIds {
		
		public static const KPA_LOADED:String			= "kpaLoaded";		public static const IMAGE_LOADED:String			= "imageLoaded";		public static const GENERATE_IMAGE:String		= "generateImage";		public static const CHANGE_VIEW:String			= "changeView";		public static const CHANGE_TEXTURE:String		= "changeTexture";		public static const UPDATE_GRID:String			= "updateGrid";		public static const CLEAR_GRID:String			= "clearGrid";		public static const UPDATE_COUNTER:String		= "updateCounter";		public static const CHANGE_COLORS_MAX:String	= "changeColorsMax";		public static const SAVE_CURRENT_IMAGE:String	= "saveCurrentImage";
				public static const OPEN_TOOLTIP:String			= "openToolTip";
				public static const CLOSE_TOOLBOX:String		= "closeToolbox";		public static const SUBMIT_IMAGE_PARAMS:String	= "submitImageParams";		public static const DISPLAY_TOOLS_CAM:String	= "displayToolsCam";		public static const DISPLAY_TOOLS_IMAGE:String	= "displayToolsImage";		public static const DISPLAY_TOOLS_STATS:String	= "displayToolsStats";
		
		
		/**
		 * Gets if a message id is a tool box message
		 */
		public static function isToolBoxMessage(id:String):Boolean{
			return id.search(/^displayTools/i) > -1;
		}
		
	}
}
