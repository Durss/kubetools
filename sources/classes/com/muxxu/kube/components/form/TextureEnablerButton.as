package com.muxxu.kube.components.form {	import flash.events.MouseEvent;	import com.muxxu.kube.controler.FrontControler;	import com.muxxu.kube.graphics.TextureDisabledButton;	import com.muxxu.kube.graphics.TextureEnabledButton;	import com.muxxu.kube.vo.MessageIds;	import com.muxxu.kube.vo.Texture;	import com.nurun.components.button.events.NurunButtonEvent;	import com.nurun.components.form.ToggleButton;	/**	 * Displays a small toggle button under the texture cubes when generating an image.	 * 	 * @author  Francois	 */	public class TextureEnablerButton extends ToggleButton {		private var _texture:Texture;										/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>TextureEnablerButton</code>.		 */		public function TextureEnablerButton(texture:Texture) {			_texture = texture;			super("","","", new TextureDisabledButton(), new TextureEnabledButton());			width = 20;			height = 8;			selected = texture.enabledForGeneration;			activateDefaultVisitor();			addEventListener(NurunButtonEvent.CLICK, clickHandler);		}						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */		/* ****** *		 * PUBLIC *		 * ****** */						/* ******* *		 * PRIVATE *		 * ******* */		override protected function clickHandler(e:MouseEvent):void {			super.clickHandler(e);			_texture.enabledForGeneration = selected;			validate();			FrontControler.getInstance().sendMessage(MessageIds.UPDATE_GRID);		}	}}