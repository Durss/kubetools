package com.muxxu.kube.components.form {
	import com.muxxu.kube.components.KubeScrollbar;
	import com.muxxu.kube.graphics.InputSkin;
	import com.nurun.components.invalidator.Validable;
	import com.nurun.components.scroll.ScrollPane;
	import com.nurun.components.scroll.scrollable.ScrollableTextField;

	import flash.display.DisplayObject;
	import flash.text.TextFieldType;

	/**
	 * Creates a text area with only vertical scrollbar.
	 * 
	 * @author  Francois
	 */
	public class KubeTextArea extends ScrollPane {
		
		private var _background:InputSkin;
		private var _textfield:ScrollableTextField;

		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>KubeTextArea</code>.
		 */
		public function KubeTextArea(css:String = "input") {
			_textfield = new ScrollableTextField("", css);
			_textfield.wordWrap = true;
			_textfield.type	= TextFieldType.INPUT;
			super(_textfield, new KubeScrollbar());
			autoHideScrollers = true;
			height = 202;
			_background = addChildAt(new InputSkin(), 0) as InputSkin;
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		/**
		 * gets the textfield's reference.
		 */
		public function get textfield():ScrollableTextField {
			return _textfield;
		}
		
		/**
		 * Sets the component's tab index
		 */
		override public function set tabIndex(value:int):void {
			_textfield.tabIndex = value;
		}
		
		/**
		 * Gets the component's tab index
		 */
		override public function get tabIndex():int {
			return _textfield.tabIndex;
		}

		
		
		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Forces the component's rendering.
		 */
		override public function validate():void {
			super.validate();
			_background.width	= width;
			_background.height	= height;
			DisplayObject(vScroll).x -= 1;
			DisplayObject(vScroll).y = 1;
			DisplayObject(vScroll).height -= 2;			Validable(vScroll).validate();
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		
	}
}