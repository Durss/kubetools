package com.muxxu.kube.views.login.steps {	import com.adobe.crypto.MD5;	import com.muxxu.kube.components.button.KubeButton;	import com.muxxu.kube.data.SharedObjectManager;	import com.muxxu.kube.events.LoginEvent;	import com.nurun.components.text.CssTextField;	import com.nurun.components.vo.Margin;	import com.nurun.structure.environnement.configuration.Config;	import com.nurun.structure.environnement.label.Label;	import flash.display.Sprite;	import flash.events.MouseEvent;	/**	 * Displays the third login step.	 * @author  Francois	 */	public class LoginStep3 extends Sprite {		private var _label:CssTextField;
		private var _submit:KubeButton;
								/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>LoginStep3</code>.		 */		public function LoginStep3() {			initialize();		}						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */		override public function set visible(value:Boolean):void {			if(value) {				var label:String	= Label.getLabel("loginStep3");				var url:String		= Config.getPath("authentication");				var key:String		= MD5.hash(Config.getVariable("appKey")+"kube_user"+SharedObjectManager.getInstance().userId+"AUTH");				url		= url.replace(/\$\{user_id\}/gi, SharedObjectManager.getInstance().userId);				url		= url.replace(/\$\{key\}/gi, key);				label	= label.replace(/\$\{url\}/gi, url);				_label.text = label;			}			computePositions();			super.visible = value;		}		/* ****** *		 * PUBLIC *		 * ****** */						/* ******* *		 * PRIVATE *		 * ******* */		/**		 * Initializes the class.		 */		private function initialize():void {			_label	= addChild(new CssTextField("loginStepLabel")) as CssTextField;			_submit	= addChild(new KubeButton(Label.getLabel("loginPrevStep"))) as KubeButton;			_label.wordWrap = true;						_submit.contentMargin = new Margin(4, 4, 4, 4);						_submit.addEventListener(MouseEvent.CLICK, clickSubmitHandler);						computePositions();		}
		/**		 * Resizes and replaces the elements.		 */		private function computePositions():void {			_label.width = 270;			_submit.x = Math.round((270 - _submit.width) * .5);			_submit.y = Math.round(_label.y + _label.height);		}				/**		 * Called when submit button is clicked.		 */		private function clickSubmitHandler(event:MouseEvent):void {			dispatchEvent(new LoginEvent(LoginEvent.PREV_STEP));		}	}}