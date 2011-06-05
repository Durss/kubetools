package com.muxxu.kube.components {

	import gs.TweenLite;
	import gs.TweenMax;
	import gs.easing.Quad;

	import com.muxxu.kube.events.LoadManagerEvent;
	import com.muxxu.kube.graphics.LoaderFaceBottomGraphic;
	import com.muxxu.kube.graphics.LoaderFaceFrontGraphic;
	import com.muxxu.kube.graphics.LoaderFaceRightGraphic;
	import com.muxxu.kube.graphics.LoaderFaceTopGraphic;
	import com.muxxu.kube.utils.LoadManager;
	import com.nurun.components.volume.Cube;
	import com.nurun.utils.math.MathUtils;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.PerspectiveProjection;
	import flash.utils.setTimeout;
		/**	 * Displays the loading.	 * 	 * @author  Francois Dursus	 */	public class InitLoader extends Sprite {				private var _stage:Stage;
		private var _cube:Cube;
		private var _top:LoaderFaceTopGraphic;
		private var _pressed:Boolean;
		
		private var _spring:Number = 0.3;
		private var _friction:Number = 0.8;
		private var _endRY:Number = 45;
		private var _vx:Number = 0;
				
						/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>TagLoader</code>.		 */		public function InitLoader() {			initialize();			addEventListener(Event.ADDED_TO_STAGE,		addedToStageHandler);		}						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */						/* ****** *		 * PUBLIC *		 * ****** */		/**		 * Makes the component garbage collectable.		 */		public function dispose():void {			filters = [];
			
			TweenLite.killTweensOf(this);
			TweenLite.killTweensOf(_cube);
			
			_cube.dispose();
						LoadManager.getInstance().removeEventListener(LoadManagerEvent.START,		startloadingHandler);			LoadManager.getInstance().removeEventListener(LoadManagerEvent.PROGRESS,	progressloadingHandler);			LoadManager.getInstance().removeEventListener(LoadManagerEvent.COMPLETE,	completeloadingHandler);
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			_cube.addEventListener(MouseEvent.MOUSE_DOWN, pressHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, releaseHandler);
			stage.removeEventListener(Event.RESIZE, computePositions);						_top = null;			_cube = null;			_stage = null;
		}

		/**
		 * Closes the loader
		 */
		public function close():void {
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			_cube.addEventListener(MouseEvent.MOUSE_DOWN, pressHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, releaseHandler);
			stage.removeEventListener(Event.RESIZE, computePositions);
			
			TweenLite.killTweensOf(_cube);
			TweenLite.to(_cube, .2, {rotationX:0, rotationZ:0});
			TweenLite.to(_cube, 1, {overwrite:0, delay:.1, autoAlpha:0, width:200, height:150, depth:200, y:-200, rotationY:720, ease:Quad.easeIn, onComplete:onTweenComplete});
		}
								/* ******* *		 * PRIVATE *		 * ******* */		/**		 * Initialize the class.		 */		private function initialize():void {			_cube = addChild(new Cube()) as Cube;
			_cube.frontFace = new LoaderFaceFrontGraphic();			_cube.backFace = new LoaderFaceFrontGraphic();			_cube.leftFace = new LoaderFaceRightGraphic();			_cube.rightFace = new LoaderFaceRightGraphic();			_cube.bottomFace = new LoaderFaceBottomGraphic();			_cube.topFace = _top = new LoaderFaceTopGraphic();
			_cube.height = 77;
			_cube.validate();
			
			_cube.x = 50;			_cube.y = 50;
			
			_cube.rotationX = 90;						filters = [new DropShadowFilter(0, 0, 0, 1, 30, 30, 1.2, 3)];						LoadManager.getInstance().addEventListener(LoadManagerEvent.START,		startloadingHandler);			LoadManager.getInstance().addEventListener(LoadManagerEvent.PROGRESS,	progressloadingHandler);			LoadManager.getInstance().addEventListener(LoadManagerEvent.COMPLETE,	completeloadingHandler);
			
			setTimeout(startEF, 1000);
			
			addEventListener(MouseEvent.CLICK, clickHandler);
		}

		/**
		 * Called when the cube is clicked.
		 */
		private function clickHandler(event:MouseEvent):void {
			_cube.width = _cube.depth = 100;
			_cube.height = 77;
			TweenMax.to(_cube, .1, {height:120, width:130, depth:130, yoyo:1});
		}
		
		/**
		 * Starts the ENTER_FRAME listener
		 */
		private function startEF():void {
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		/**
		 * Rotates the cube.
		 */		private function enterFrameHandler(event : Event) : void {
			if(_pressed) {
				_cube.rotationY += ((_endRY + MathUtils.restrict(- _cube.mouseX, -100, 100) / 100 * 90) - _cube.rotationY) * .2;
			}else{
				var ax:Number = (_endRY - _cube.rotationY) * _spring;
				_vx += ax;
				_vx *= _friction;
				_cube.rotationY += _vx;
			}
			_cube.rotationX = Math.cos(_cube.rotationY * MathUtils.DEG2RAD) * 45;			_cube.rotationZ = Math.sin(_cube.rotationY * MathUtils.DEG2RAD) * 33;
			_cube.validate();
		}
		/**		 * Resize and replace the elements.		 */		private function computePositions(e:Event = null):void {			x = Math.round((_stage.stageWidth - width) * .5);			y = Math.round((_stage.stageHeight - height) * .5);

			var pv:PerspectiveProjection = new PerspectiveProjection();
			pv.fieldOfView = 1;
			transform.perspectiveProjection = pv;
		}

		/**
		 * Called when the close tween completes.
		 */
		private function onTweenComplete():void {
			dispatchEvent(new Event(Event.CLOSE));
		}
								//__________________________________________________________ STAGE EVENTS		/**		 * Called when the component is added to the stage.		 */		private function addedToStageHandler(e:Event):void {			_stage = stage;
			_cube.addEventListener(MouseEvent.MOUSE_DOWN, pressHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, releaseHandler);			stage.addEventListener(Event.RESIZE, computePositions);			computePositions();
		}

		
		
		
		//__________________________________________________________ MOUSE EVENTS

		/**
		 * Called when the cube is pressed.
		 */
		private function pressHandler(event:MouseEvent):void {
			_pressed = true;
		}
		
		/**
		 * Called when the cube is released
		 */
		private function releaseHandler(event:MouseEvent):void {
			_pressed = false;
		}
								//__________________________________________________________ LOADING EVENTS				/**		 * Called when loading starts.		 */		private function startloadingHandler(e:LoadManagerEvent):void {			_top.disk.gotoAndStop(0);			TweenLite.from(this, .5, {autoAlpha:0});		}				/**		 * Called when during loading progression.		 */		private function progressloadingHandler(e:LoadManagerEvent):void {			_top.disk.gotoAndStop(Math.round(_top.disk.totalFrames * e.percent) + 2);//Add 2 frames to be sure the disk is totaly filled at the end :/		}				/**		 * Called when loading completes.		 */		private function completeloadingHandler(e:LoadManagerEvent):void {					}	}}