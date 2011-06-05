package com.muxxu.kube.components.tooltip.content {	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import com.muxxu.kube.components.KubeScrollbar;	import com.muxxu.kube.components.button.KubeButton;	import com.nurun.components.form.events.FormComponentEvent;	import com.nurun.components.scroll.ScrollPane;	import com.nurun.components.scroll.scrollable.ScrollableTextField;	import com.nurun.components.text.CssTextField;	import com.nurun.components.vo.Margin;	import com.nurun.core.lang.Disposable;	import com.nurun.structure.environnement.label.Label;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.text.TextFieldType;	//Called when the form is submited	[Event(name="onSubmitForm", type="com.nurun.components.form.events.FormComponentEvent")];			/**	 * Displays a textarea to write content on it.	 * 	 * @author  Francois	 */	public class TTGpsInfoContent extends Sprite implements ToolTipContent, Disposable {		private var _textfield:ScrollableTextField;
		private var _scrollpane:ScrollPane;
		private var _submit:KubeButton;
		private var _label:CssTextField;
								/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>TTGpsInfoContent</code>.		 */		public function TTGpsInfoContent() {			initialize();		}						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */				/**		 * Gets the text content.		 */		public function get text():String { return _textfield.text; }				/**		 * Sets the text content.		 */		public function set text(value:String):void { _textfield.text = value; }				/**		 * Gets the width of the component.		 */		override public function get width():Number { 			return _scrollpane.width; 		}		/**		 * Gets the height of the component.		 */		override public function get height():Number { 			return Math.round(_submit.y + _submit.height) + 5; 		}								/* ****** *		 * PUBLIC *		 * ****** */		/**		 * Makes the component garbage collectable.		 */		public function dispose():void {			while(numChildren > 0) {				if(getChildAt(0) is Disposable) Disposable(getChildAt(0)).dispose();				removeChildAt(0);			}			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);		}				/**		 * Sets the focus to the textfield		 */		public function setFocus():void {			if(stage != null) {				stage.focus = _textfield;
			}		}										/* ******* *		 * PRIVATE *		 * ******* */		/**		 * Initialize the class.		 */		private function initialize():void {			_label		= addChild(new CssTextField("windowTitle")) as CssTextField;			_textfield	= new ScrollableTextField("", "input");			_scrollpane	= addChild(new ScrollPane(_textfield, new KubeScrollbar())) as ScrollPane;			_submit		= addChild(new KubeButton(Label.getLabel("gpsFormInfosSubmit"))) as KubeButton;			_scrollpane.width = 300;			_scrollpane.height = 150;						_textfield.type = TextFieldType.INPUT;						_label.text		= Label.getLabel("gpsFormInfosTitle");			_label.width	= _scrollpane.width;			_scrollpane.y	= Math.round(_label.y + _label.height + 2);			_submit.y		= Math.round(_scrollpane.y + _scrollpane.height + 5);			_submit.x		= Math.round((_scrollpane.width - _submit.width) * .5);			_submit.contentMargin = new Margin(10, 4, 10, 4);						_textfield.tabIndex = 50;			_submit.tabIndex = 51;						graphics.beginFill(0, 0.1);			graphics.drawRect(_scrollpane.x, _scrollpane.y, _scrollpane.width, _scrollpane.height);			graphics.endFill();						_submit.addEventListener(MouseEvent.CLICK, clickSubmitHandler);			dispatchEvent(new Event(Event.RESIZE));			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);			addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);		}				/**		 * Called when the stage is available.		 */		private function addedToStageHandler(event:Event):void {			stage.focus = _textfield;		}				/**		 * Called when a key is released.		 */		private function keyUpHandler(event:KeyboardEvent):void {			if(event.keyCode == Keyboard.ESCAPE) {				dispatchEvent(new Event(Event.CLOSE));
			}		}
		/**		 * Called when the submit button is clicked.		 */		private function clickSubmitHandler(event:MouseEvent):void {			dispatchEvent(new FormComponentEvent(FormComponentEvent.SUBMIT));
		}
	}}