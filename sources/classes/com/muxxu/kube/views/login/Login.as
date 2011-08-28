package com.muxxu.kube.views.login {	import flash.ui.MouseCursor;
	import com.muxxu.kube.components.button.KubeButton;	import com.muxxu.kube.data.SharedObjectManager;	import com.muxxu.kube.events.LoginEvent;	import com.muxxu.kube.graphics.window.CloseIcon;	import com.muxxu.kube.views.Background;	import com.muxxu.kube.views.login.steps.LoginStep1;	import com.muxxu.kube.views.login.steps.LoginStep2;	import com.muxxu.kube.views.login.steps.LoginStep3;	import com.nurun.components.text.CssTextField;	import com.nurun.structure.environnement.label.Label;	import flash.display.DisplayObject;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.geom.Point;	import flash.geom.Rectangle;	import flash.ui.Mouse;	/**	 * Displays the login form.	 * 	 * @author  Francois	 */	public class Login extends Sprite {				private var _background:Background;
		private var _title:CssTextField;
		private var _currentStep:int;
		private var _stepsCtn:Sprite;
		private var _steps:Vector.<DisplayObject>;
		private var _closeBt:KubeButton;
		private var _offsetDrag:Point;
								/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>Login</code>.		 */		public function Login() {			initialize();		}						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */		/* ****** *		 * PUBLIC *		 * ****** */								/* ******* *		 * PRIVATE *		 * ******* */		/**		 * Initializes the class.		 */		private function initialize():void {			_background	= addChild(new Background()) as Background;			_title		= addChild(new CssTextField("loginStepTitle")) as CssTextField;			_stepsCtn	= addChild(new Sprite()) as Sprite;			_closeBt	= addChild(new KubeButton("", new CloseIcon())) as KubeButton;						_currentStep = 0;			_title.text = Label.getLabel("loginStepTitle").replace(/\$\{nbr\}/gi, 1);			_title.wordWrap = true;			_title.background = true;			_title.backgroundColor = 0xA9D5E7;			_closeBt.width = _closeBt.height = 15;						computePositions();						var i:int, len:int, step:DisplayObject;			_steps = new Vector.<DisplayObject>();						_steps.push(new LoginStep1());			_steps.push(new LoginStep2());			_steps.push(new LoginStep3());						len = _steps.length;			for(i = 0; i < len; ++i) {				step = _stepsCtn.addChild(_steps[i]);				step.addEventListener(LoginEvent.NEXT_STEP,	nextStepHandler);				step.addEventListener(LoginEvent.PREV_STEP,	prevStepHandler);				step.addEventListener(LoginEvent.COMPLETE,	completeHandler);				step.addEventListener(LoginEvent.ABORT,	completeHandler);				step.x = Background.CELL_WIDTH + 10;				step.y = Math.round(_title.y + _title.height + 2);				step.visible = false;			}			_steps[_currentStep].visible = true;						_closeBt.addEventListener(MouseEvent.CLICK, closeHandler);			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);		}				/**		 * Called when the stage is available.		 */		private function addedToStageHandler(event:Event):void {			removeEventListener(Event.ADDED_TO_STAGE,		addedToStageHandler);			stage.addEventListener(MouseEvent.MOUSE_UP,		releaseHandler);			_title.addEventListener(MouseEvent.MOUSE_DOWN,	pressHandler);			_title.addEventListener(MouseEvent.MOUSE_OVER,	overTitleHandler);			_title.addEventListener(MouseEvent.MOUSE_OUT,	outTitleHandler);		}
		/**		 * Resizes and replaces the elements.		 */		private function computePositions():void {			_title.x = Background.CELL_WIDTH + 1;			_title.y = Background.CELL_WIDTH + 1;			_title.width = 300 - _title.x * 2 + 1;						_background.width	= 300;			_background.height	= 220;			_background.scrollRect = new Rectangle(0,0,_background.width,_background.height);						_closeBt.x = _background.width - Background.CELL_WIDTH - _closeBt.width - 3;			_closeBt.y = _title.y + Math.round((_title.height - _closeBt.height) * .5);		}		/**		 * Called when close button is clicked.		 */		private function closeHandler(event:MouseEvent):void {			stage.nativeWindow.close();		}		/**		 * Called when next step should be displayed.		 */		private function nextStepHandler(event:LoginEvent):void {			_currentStep ++;			var i:int, len:int;			len = _steps.length;			for(i = 0; i < len; ++i) {				_steps[i].visible = i == _currentStep;			}			_title.text = Label.getLabel("loginStepTitle").replace(/\$\{nbr\}/gi, _currentStep + 1);			stage.focus = null;
		}
				/**		 * Called when prev step should be displayed.		 */		private function prevStepHandler(event:LoginEvent):void {			_currentStep -= 2;			nextStepHandler(event);		}		/**		 * Called when everything is complete.		 */		private function completeHandler(event:LoginEvent):void {			if(event.type == LoginEvent.ABORT) {				SharedObjectManager.getInstance().userId	= "-1";				SharedObjectManager.getInstance().pubKey	= "-1";			}			SharedObjectManager.getInstance().authenticated = true;			dispatchEvent(new LoginEvent(LoginEvent.COMPLETE));		}								//__________________________________________________________ MOUSE EVENTS				/**		 * Called when the title bar is rolled over.		 */		private function overTitleHandler(event:MouseEvent):void { Mouse.cursor = MouseCursor.HAND; }		/**		 * Called when the title bar is rolled out.		 */		private function outTitleHandler(event:MouseEvent):void { Mouse.cursor = MouseCursor.AUTO; }		/**		 * Called when the title bar is released. Stops the window's drag.		 */		private function releaseHandler(event:MouseEvent):void {			removeEventListener(Event.ENTER_FRAME, dragEnterFrameHandler);		}		/**		 * Called when the title bar is pressed. Starts the window's drag.		 */		private function pressHandler(event:MouseEvent):void {			_offsetDrag = new Point(_title.mouseX, _title.mouseY);			addEventListener(Event.ENTER_FRAME, dragEnterFrameHandler);		}				/**		 * Called to drag the window.		 */		private function dragEnterFrameHandler(event:Event):void {			x = stage.mouseX - _offsetDrag.x - _title.x;			y = stage.mouseY - _offsetDrag.y - _title.y;		}			}}