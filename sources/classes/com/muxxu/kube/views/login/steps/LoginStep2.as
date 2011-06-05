package com.muxxu.kube.views.login.steps {	import com.muxxu.kube.commands.CheckUserCmd;	import com.muxxu.kube.components.LoaderSpinning;	import com.muxxu.kube.components.button.KubeButton;	import com.muxxu.kube.components.form.KubeInput;	import com.muxxu.kube.data.SharedObjectManager;	import com.muxxu.kube.events.LoginEvent;	import com.nurun.components.form.events.FormComponentEvent;	import com.nurun.components.text.CssTextField;	import com.nurun.components.vo.Margin;	import com.nurun.core.commands.events.CommandEvent;	import com.nurun.structure.environnement.label.Label;	import com.nurun.utils.input.keyboard.KeyboardSequenceDetector;	import com.nurun.utils.input.keyboard.events.KeyboardSequenceEvent;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;	/**	 * Displays the second login step.	 * 	 * @author  Francois	 */	public class LoginStep2 extends Sprite {				private var _label:CssTextField;
		private var _uid:KubeInput;
		private var _pubkey:KubeInput;
		private var _submit:KubeButton;
		private var _spin:LoaderSpinning;
		private var _ks:KeyboardSequenceDetector;
		private var _code:KubeInput;
		private var _error:CssTextField;
								/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>LoginStep2</code>.		 */		public function LoginStep2() {			initialize();		}						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */		/* ****** *		 * PUBLIC *		 * ****** */						/* ******* *		 * PRIVATE *		 * ******* */		/**		 * Initializes the class.		 */		private function initialize():void {			_label	= addChild(new CssTextField("loginStepLabel")) as CssTextField;			_uid	= addChild(new KubeInput(Label.getLabel("loginStep2UID"))) as KubeInput;			_pubkey	= addChild(new KubeInput(Label.getLabel("loginStep2PubKey"))) as KubeInput;			_submit	= addChild(new KubeButton(Label.getLabel("loginNextStep"))) as KubeButton;			_spin	= addChild(new LoaderSpinning()) as LoaderSpinning;			_code	= new KubeInput("Secret code...");			_error	= addChild(new CssTextField("error")) as CssTextField;						_error.visible = false;			_error.selectable = true;			_label.text = Label.getLabel("loginStep2");			_label.wordWrap = true;
			_uid.textfield.restrict = "[0-9]";			
			_uid.setErrorState(null, "inputError");			_pubkey.setErrorState(null, "inputError");						var enabled:Boolean = false;			if(SharedObjectManager.getInstance().userId != null) {				_uid.text = SharedObjectManager.getInstance().userId;				enabled = true;			}			if(SharedObjectManager.getInstance().pubKey != null) {				_pubkey.text = SharedObjectManager.getInstance().pubKey;			}						_uid.textfield.addEventListener(Event.CHANGE, changeHandler);			_pubkey.textfield.addEventListener(Event.CHANGE, changeHandler);			_uid.addEventListener(FormComponentEvent.SUBMIT, submitHandler);			_pubkey.addEventListener(FormComponentEvent.SUBMIT, submitHandler);			_code.addEventListener(FormComponentEvent.SUBMIT, submitHandler);			_submit.addEventListener(MouseEvent.CLICK, submitHandler);						_submit.enabled = enabled;			_submit.contentMargin = new Margin(4, 4, 4, 4);						computePositions();						addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);		}				/**		 * Called when the stage is available.		 */		private function addedToStageHandler(event:Event):void {			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);			_ks = new KeyboardSequenceDetector(stage);			_ks.addSequence("atlante", [27,65,84,76,65,78,84,69,13]);			_ks.addEventListener(KeyboardSequenceEvent.SEQUENCE, keySequenceHandler);		}
				/**		 * Called when a keyboard sequence is detected.		 */		private function keySequenceHandler(event:KeyboardSequenceEvent):void {			if(event.sequenceId == "atlante"){				addChild(_code);				computePositions();
			}		}
		/**		 * Resizes and replaces the elements.		 */		private function computePositions():void {			_label.width	=			_uid.width		=			_pubkey.width	=			_code.width		=			_error.width	= 270;						_uid.y		= Math.round(_label.y + _label.height + 10);			_pubkey.y	= Math.round(_uid.y + _uid.height + 10);			if(contains(_code)) {				_code.y		= Math.round(_pubkey.y + _pubkey.height + 10);				_submit.y	= Math.round(_code.y + _code.height + 15);			}else{				_submit.y	= Math.round(_pubkey.y + _pubkey.height + 15);			}						_submit.x = Math.round((270 - _submit.width) * .5);			_spin.x = Math.round(_submit.x + _submit.width * .5);
			_spin.y = Math.round(_submit.y + _submit.height * .5);
			_error.y = Math.round(_submit.y + _submit.height + 5);		}		/**		 * Called when form is submitted.		 */		private function submitHandler(event:Event):void {			if(!_submit.enabled) return;			if(_uid.text == _uid.defaultLabel || _uid.text.length == 0) return;			if(_pubkey.text == _pubkey.defaultLabel || _pubkey.text.length == 0) return;			_spin.open();			_uid.enabled = false;			_pubkey.enabled = false;			_submit.enabled = false;			_code.enabled = false;			stage.focus = null;						SharedObjectManager.getInstance().userId	= _uid.text;			SharedObjectManager.getInstance().pubKey	= _pubkey.text;			var cmd:CheckUserCmd = new CheckUserCmd(_uid.text, _pubkey.text);			cmd.addEventListener(CommandEvent.COMPLETE, loadCompleteHandler);			cmd.addEventListener(CommandEvent.ERROR, loadErrorHandler);			cmd.execute();
		}		/**		 * Called when an input's value changes.		 */		private function changeHandler(event:Event):void {			_submit.enabled = (_uid.text != _uid.defaultLabel && _uid.text.length > 0) && (_pubkey.text != _pubkey.defaultLabel && _pubkey.text.length > 0);		}				/**		 * Called when check login loading completes.		 */		private function loadCompleteHandler(event:CommandEvent):void {			SharedObjectManager.getInstance().isEtnalta = _code.text == "s9fd48T4BDs52inds52454dfsuh283nFG";			_uid.defaultStyle = "inputDefault";			_uid.defaultLabel = Label.getLabel("loginStep2UID");			_uid.enabled = true;			_pubkey.enabled = true;			_submit.enabled = true;			_code.enabled = true;			_spin.close();			dispatchEvent(new LoginEvent(LoginEvent.COMPLETE));		}		/**		 * Called if check login loading fails.		 */		private function loadErrorHandler(event:CommandEvent):void {			if(event.data === false) {				_uid.error = "xxx";
				_uid.text = _uid.defaultLabel;
				_pubkey.error = "xxx";
				_pubkey.text = _pubkey.defaultLabel;			}else{				_error.visible = true;				_error.text += "<br /><br />"+Label.getLabel("loginNetworkError")+" :: " + event.data;			}			_uid.enabled = true;			_pubkey.enabled = true;			_submit.enabled = true;			_code.enabled = true;			_spin.close();		}	}}