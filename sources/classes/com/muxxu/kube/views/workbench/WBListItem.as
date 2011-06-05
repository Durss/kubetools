package com.muxxu.kube.views.workbench {

	import flash.display.Shape;
	import com.muxxu.kube.components.button.KubeButton;
	import com.muxxu.kube.graphics.ButtonSkin;
	import com.muxxu.kube.graphics.window.CloseIcon;
	import com.muxxu.kube.vo.Point3D;
	import com.nurun.components.button.IconAlign;
	import com.nurun.components.text.CssTextField;
	import com.nurun.structure.environnement.label.Label;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	
	/**
	 * 
	 * @author Francois
	 * @date 8 mars 2011;
	 */
	public class WBListItem extends Sprite {
		
		private var _title:String;
		private var _pos:Point3D;
		private var _labelTf:CssTextField;
		private var _background:ButtonSkin;
		private var _deleteBt:KubeButton;
		private var _icon:Shape;
		
		
		

		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>WBListItem</code>.
		 */
		public function WBListItem(title:String, pos:Point3D) {
			_pos = pos;
			_title = title;
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		/**
		 * Gets the item's position
		 */
		public function get pos():Point3D { return _pos; }



		/* ****** *
		 * PUBLIC *
		 * ****** */


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			_background = addChild(new ButtonSkin()) as ButtonSkin;
			_labelTf = addChild(new CssTextField("wbListEntryLabel")) as CssTextField;
			_deleteBt = addChild(new KubeButton("", new CloseIcon())) as KubeButton;
			_icon = addChild(new Shape()) as Shape;
			
			_icon.graphics.beginFill(0x265367);
			_icon.graphics.drawCircle(4, 4, 4);
			
			_deleteBt.width = _deleteBt.height = 16;
			_deleteBt.iconAlign = IconAlign.CENTER;
			
			_background.stop();
			
			addEventListener(MouseEvent.CLICK, clickHandler);
			_labelTf.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			
			setLabel();
			
			computePositions();
		}
		
		/**
		 * Called when a key is released
		 */
		private function keyUpHandler(event:KeyboardEvent):void {
			if(_labelTf.type == TextFieldType.INPUT && event.keyCode == Keyboard.ENTER) {
				submitLabelChange();
			}
		}
		
		/**
		 * Called when label looses the focus
		 */
		private function focusOutHandler(event:FocusEvent):void {
			submitLabelChange();
		}
		
		/**
		 * Submits the label changing
		 */
		private function submitLabelChange():void {
			_labelTf.type = TextFieldType.DYNAMIC;
			_labelTf.background = false;
			_labelTf.border = false;
			_labelTf.selectable = false;
			if(_labelTf.text.length > 0) {
				_title = _labelTf.text;
			}
			setLabel();
			computePositions();
			_labelTf.removeEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
			dispatchEvent(new Event(Event.RESIZE));
		}

		private function clickHandler(event:MouseEvent):void {
			if(event.target == _labelTf && _labelTf.type != TextFieldType.INPUT) {
				_labelTf.type = TextFieldType.INPUT;
				_labelTf.text = _title;
				_labelTf.background = true;
				_labelTf.backgroundColor = 0xffffff;
				_labelTf.border = true;
				_labelTf.borderColor = 0;
				_labelTf.multiline = false;
				_labelTf.setSelection(0, _labelTf.text.length);
				stage.focus = _labelTf;
				_labelTf.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
			}else if(event.target == _deleteBt) {
				dispatchEvent(new Event(Event.CLOSE));
			}
		}
		
		/**
		 * Resizes and replaces the elements.
		 */
		private function computePositions():void {
			_icon.x = 2;
			_icon.y = Math.round((_deleteBt.height - _icon.height) * .5);
			_labelTf.x = 10;
			_deleteBt.x = Math.round(_labelTf.x + _labelTf.width + 5);
			_background.width = Math.round(_deleteBt.x + _deleteBt.width);
			_background.height = _labelTf.height;
		}
		
		/**
		 * Sets the label
		 */
		private function setLabel():void {
			var title:String = Label.getLabel("wbItemTitle").replace(/\{TITLE\}/gi, _title);
			title = title.replace(/\{X\}/gi, _pos.x);
			title = title.replace(/\{Y\}/gi, _pos.y);
			title = title.replace(/\{Z\}/gi, _pos.z);
			_labelTf.text = title;
		}
		
	}
}