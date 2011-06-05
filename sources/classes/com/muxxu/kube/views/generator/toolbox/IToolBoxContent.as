package com.muxxu.kube.views.generator.toolbox {
	import com.muxxu.kube.vo.Message;

	/**
	 * @author Francois
	 */
	public interface IToolBoxContent {
		
		/**
		 * Updates the content and returns if the content should be displayed or not.
		 */
		function update(message:Message):Boolean;
		
		/**
		 * Gets the toolbox title.
		 */
		function get title():String;
		
	}
}
