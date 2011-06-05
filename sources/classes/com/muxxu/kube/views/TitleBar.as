package com.muxxu.kube.views {	import com.muxxu.kube.data.SharedObjectManager;
	import com.muxxu.kube.graphics.LogoutIcon;
	import com.muxxu.kube.components.button.KubeButton;	import com.muxxu.kube.components.button.KubeToggleButton;	import com.muxxu.kube.graphics.window.CloseIcon;	import com.muxxu.kube.graphics.window.MaximizeIcon;	import com.muxxu.kube.graphics.window.MinimizeIcon;	import com.muxxu.kube.graphics.window.ReduceIcon;	import com.nurun.components.button.AbstractNurunButton;	import com.nurun.components.button.IconAlign;	import com.nurun.components.text.CssTextField;	import com.nurun.structure.environnement.label.Label;	import com.nurun.utils.text.TextBounds;	import flash.desktop.NativeApplication;	import flash.display.NativeWindowDisplayState;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.events.NativeWindowDisplayStateEvent;	import flash.geom.Rectangle;	import flash.ui.Mouse;	import flash.ui.MouseCursor;	/**	 * Displays the window's bar at the top of the application.	 * 	 * @author  Francois Dursus	 */	public class TitleBar extends Sprite {		private var _closeBt:KubeButton;		private var _minimize:KubeButton;		private var _maximize:KubeToggleButton;		private var _width:Number;		private var _title:CssTextField;
		private var _hitClose:Sprite;
		private var _logoutBt:KubeButton;
								/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>TitleBar</code>.		 */		public function TitleBar() {			initialize();		}						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */		/**		 * Sets the width of the component without simply scaling it.		 */		override public function set width(value:Number):void {			_width = value;			computePositions();		}				/**		 * Gets the virtual component's height.		 */		override public function get height():Number { 			return _closeBt.y * 2 + _closeBt.height + 1; 		}						/* ****** *		 * PUBLIC *		 * ****** */						/* ******* *		 * PRIVATE *		 * ******* */		/**		 * Initialize the class.		 */		private function initialize():void {			_title		= addChild(new CssTextField("windowTitle")) as CssTextField;			_closeBt	= addChild(new KubeButton("", new CloseIcon())) as KubeButton;			_logoutBt	= addChild(new KubeButton("", new LogoutIcon())) as KubeButton;			_minimize	= addChild(new KubeButton("", new MinimizeIcon())) as KubeButton;			_maximize	= addChild(new KubeToggleButton("", new MaximizeIcon(), new ReduceIcon())) as KubeToggleButton;			_hitClose	= addChild(new Sprite()) as Sprite;						_logoutBt.iconAlign = IconAlign.CENTER;			_closeBt.iconAlign = IconAlign.CENTER;			_minimize.iconAlign = IconAlign.CENTER;			_maximize.iconAlign = IconAlign.CENTER;						_logoutBt.width = _logoutBt.height = 16;			_closeBt.width = _closeBt.height = 16;			_minimize.width = _minimize.height = 16;			_maximize.width = _maximize.height = 16;						var descriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;			var ns:Namespace = descriptor.namespaceDeclarations()[0];			var version:String = descriptor.ns::version;			_title.text = Label.getLabel("windowTitle").replace(/\$\{version\}/gi, version);			_title.mouseEnabled = false;			doubleClickEnabled = true;						_hitClose.visible = false;			_hitClose.graphics.beginFill(0xff0000, 0);			_hitClose.graphics.drawRect(0, 0, 30, 30);			_closeBt.mapEvents(_hitClose);						addEventListener(MouseEvent.CLICK,		clickButtonHandler);			addEventListener(MouseEvent.MOUSE_DOWN,	mouseDownHandler);			addEventListener(MouseEvent.MOUSE_OVER,	mouseOverHandler);			addEventListener(MouseEvent.MOUSE_OUT,	mouseOutHandler);			addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);		}		/**		 * Resize and replace the elements.		 */		private function computePositions():void {			var bounds:Rectangle = TextBounds.getBounds(_title);			_closeBt.y	= _maximize.y = _minimize.y =  _logoutBt.y = 2;			_closeBt.x	= Math.round(_width - _closeBt.width - 5);			_maximize.x	= Math.round(_closeBt.x - 5 - _maximize.width);			_minimize.x	= Math.round(_maximize.x - 5 - _minimize.width);			_logoutBt.x	= Math.round(_minimize.x - 15 - _logoutBt.width);			_title.x	= -bounds.x + 5;			_title.y	= Math.round((height + 2 - bounds.height) * .5 - bounds.y) - 2;						graphics.clear();			graphics.beginFill(0xFFFFFF, .5);			graphics.drawRect(0, 0, _width, Math.round(_closeBt.y * 2 + _closeBt.height));			graphics.endFill();			graphics.lineStyle(0, 0x384294, 1);			graphics.moveTo(0, height - 1);			graphics.lineTo(_width, height - 1);						_hitClose.x = _width + Background.CELL_WIDTH - _hitClose.width;			_hitClose.y = -y;		}														//__________________________________________________________ WINDOW/STAGE EVENTS				/**		 * Called when the stage is available.		 */		private function addedToStageHandler(e:Event):void {			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);			stage.nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE, changeDisplayStateHandler);		}				/**		 * Called when the window's display state changes.		 */		private function changeDisplayStateHandler(e:NativeWindowDisplayStateEvent):void {			_maximize.selected = e.afterDisplayState == NativeWindowDisplayState.MAXIMIZED;			_hitClose.visible = _maximize.selected;		}																//__________________________________________________________ MOUSE EVENTS		/**		 * Called when title bar is pressed to drag the window.		 */		private function mouseDownHandler(e:MouseEvent):void {			if(!(e.target is AbstractNurunButton)){				stage.nativeWindow.startMove();			}		}		/**		 * Called when a button is clicked.		 */		private function clickButtonHandler(e:MouseEvent):void {			if(e.target == _closeBt || e.target == _hitClose) {				stage.nativeWindow.close();			}else if(e.target == _minimize){				stage.nativeWindow.minimize();			}else if(e.target == _logoutBt){				SharedObjectManager.getInstance().pubKey = null;				SharedObjectManager.getInstance().userId = null;				SharedObjectManager.getInstance().authenticated = false;				SharedObjectManager.getInstance().isEtnalta = false;				stage.nativeWindow.close();			}else if(e.target == _maximize){				if(_maximize.selected){					stage.nativeWindow.maximize();				}else{					stage.nativeWindow.restore();				}			}		}				/**		 * Called when the bar is rolled over.		 */		private function mouseOverHandler(e:MouseEvent):void {			if(e.target is AbstractNurunButton || stage.nativeWindow.displayState == NativeWindowDisplayState.MAXIMIZED) return;			Mouse.cursor = MouseCursor.HAND;		}		/**		 * Called when the bar is rolled out.		 */		private function mouseOutHandler(e:MouseEvent):void {			Mouse.cursor = MouseCursor.AUTO;		}				/**		 * Called whe the bar is double clicked.		 */		private function doubleClickHandler(e:MouseEvent):void {			if(e.target is AbstractNurunButton) return;			_maximize.selected = !_maximize.selected;			if(_maximize.selected){				stage.nativeWindow.maximize();			}else{				stage.nativeWindow.restore();			}		}	}}