package com.muxxu.kube.views.generator.grid {	import com.muxxu.kube.controler.FrontControler;	import com.muxxu.kube.data.TexturesData;	import com.muxxu.kube.events.ViewEvent;	import com.muxxu.kube.metrics.GeneratorGridMetrics;	import com.muxxu.kube.utils.ImagePixelliser;	import com.muxxu.kube.vo.Message;	import com.muxxu.kube.vo.MessageIds;	import com.muxxu.kube.vo.Texture;	import com.nurun.structure.mvc.views.ViewLocator;	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.Graphics;	import flash.display.Shape;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.events.TimerEvent;	import flash.filters.ColorMatrixFilter;	import flash.geom.Point;	import flash.utils.ByteArray;	import flash.utils.Timer;	/**	 * Displays the generator's grid.	 * 	 * @author  Francois	 */	public class Grid extends Sprite {				private var _grid:Shape;		private var _currentTexture:Texture;		private var _bmpsCtn:Sprite;		private var _rollBmp:Bitmap;		private var _pressed:Boolean;		private var _lastDrawingPos:Point;		private var _bitmaps:Vector.<Bitmap>;		private var _textures:Vector.<Texture>;		private var _eraseMode:Boolean;		private var _inactivityTimer:Timer;		private var _pixeliser:ImagePixelliser;		private var _flattenRatio:Number;		private var _lastBitmap:BitmapData;		private var _changeOccurs:Boolean;								/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>Grid</code>.		 */		public function Grid() {			initialize();			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);		}						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */						/* ****** *		 * PUBLIC *		 * ****** */		/**		 * Called when model's state changes		 */		public function update(message:Message):void {			var i:int, len:int, colors:Vector.<uint>, items:Vector.<Texture>, texturesRelations:Array;			var x:int, lenX:int, y:int, lenY:int, index:int, matrix:Array, data:ByteArray, texture:Texture;							//Clear grid			if(message.id == MessageIds.CLEAR_GRID) {				clear();			}						//If the toolbox is closed is because the image drawing is validated			//or canceled, the image should not exist anymore.			if(message.id == MessageIds.SUBMIT_IMAGE_PARAMS || (MessageIds.isToolBoxMessage(message.id) && message.id != MessageIds.DISPLAY_TOOLS_IMAGE)) {				_lastBitmap = null;			}						//Texture change			if(message.id == MessageIds.CHANGE_TEXTURE){				_currentTexture = message.data as Texture;				if(_currentTexture == null){					_rollBmp.bitmapData = new BitmapData(1, 1, true, 0);				}else{					_rollBmp.bitmapData = _currentTexture.selectedFace;				}				_rollBmp.width	= GeneratorGridMetrics.CELL_WIDTH;				_rollBmp.height	= GeneratorGridMetrics.CELL_HEIGHT;			}						//Called when the user wants to save the current image.			if(message.id == MessageIds.SAVE_CURRENT_IMAGE) {				var tmp:Array, obj:Object;				tmp = [];				len = _textures.length;				for(i = 0; i < len; ++i) {					if(_textures[i] != null){						obj = {};						obj.x = Math.round(_bitmaps[i].x / GeneratorGridMetrics.CELL_WIDTH);						obj.y = Math.round(_bitmaps[i].y / GeneratorGridMetrics.CELL_HEIGHT);						obj.texture = _textures[i].id;						tmp.push(obj);					}				}				data = new ByteArray();				data.writeObject(tmp);				FrontControler.getInstance().saveImage(data);			}						//Called when the user loads an image.			if(message.id == MessageIds.KPA_LOADED) {				data = message.data as ByteArray;				var cells:Array = data.readObject() as Array;				var cell:Object;				len = cells.length;				if(len > 0){					for(i = 0; i < len; ++i) {						cell = cells[i];						texture = TexturesData.getInstance().getTextureById(cell.texture);						if(texture != null){							fillCell(cell.x, cell.y, texture);						}					}					updateCounter();				}			}						//Called to update the grid, for exemple when the user changes the			//cubes side to display in the selector.			if(message.id == MessageIds.UPDATE_GRID && _lastBitmap == null) {				for(i = 0; i < GeneratorGridMetrics.COLS * GeneratorGridMetrics.ROWS; ++i) {					if(_textures[i] != null){						_bitmaps[i].bitmapData = _textures[i].selectedFace;					}				}			}						//Called when the maximum number of colors is changed on the image's tooltip.			if(message.id == MessageIds.CHANGE_COLORS_MAX) {				_flattenRatio = message.data as Number;			}						//Called when the user generates the grid from an image.			if(message.id == MessageIds.GENERATE_IMAGE || (_lastBitmap != null && (message.id == MessageIds.CHANGE_COLORS_MAX || message.id == MessageIds.UPDATE_GRID))) {				FrontControler.getInstance().sendMessage(MessageIds.CLEAR_GRID);								items = TexturesData.getInstance().textures;				len = items.length;				colors = new Vector.<uint>();				texturesRelations = [];				for(i = 0; i < len; ++i) {					if(items[i].enabledForGeneration) {						texturesRelations.push(items[i]);						colors.push(items[i].averageColor);					}				}				if(colors.length == 0) {					return;				}				_pixeliser.paletteSource = colors;								//Generates the pixelized image.				if(message.id == MessageIds.GENERATE_IMAGE) {					_lastBitmap = message.data as BitmapData;				}				matrix	= _pixeliser.pixelate(_lastBitmap, GeneratorGridMetrics.CELL_WIDTH, _flattenRatio);				lenX	= matrix[0].length;				lenY	= matrix.length;				for(x = 0; x < lenX; ++x) {					for(y = 0; y < lenY; ++y) {						index = matrix[y][x];						if(index > -1){							fillCell(x, y, texturesRelations[index]);						}else{							emptyCell(x, y);						}					}				}				texturesRelations = null;				updateCounter();			}		}						/* ******* *		 * PRIVATE *		 * ******* */		/**		 * Initialize the class.		 */		private function initialize():void {			_pixeliser	= new ImagePixelliser();			_grid		= addChild(new Shape()) as Shape;			_bmpsCtn	= addChild(new Sprite()) as Sprite;			_rollBmp	= addChild(new Bitmap()) as Bitmap;						_inactivityTimer = new Timer(250, 1);			_inactivityTimer.addEventListener(TimerEvent.TIMER_COMPLETE, updateCounter);						var m:Array =	[1,0,0,0,40,							 0,1,0,0,40,							 0,0,1,0,40,							 0,0,0,.7,0];	 					_rollBmp.filters= [new ColorMatrixFilter(m)];			_bitmaps		= new Vector.<Bitmap>(GeneratorGridMetrics.COLS * GeneratorGridMetrics.ROWS, true);			_textures		= new Vector.<Texture>(GeneratorGridMetrics.COLS * GeneratorGridMetrics.ROWS, true);			_lastDrawingPos	= new Point();			mouseChildren	= false;						addEventListener(MouseEvent.MOUSE_DOWN,	mouseDownHandler);			addEventListener(MouseEvent.MOUSE_UP,	mouseUpHandler);						computePositions();		}		/**		 * Called when the stage is available.		 */		private function addedToStageHandler(e:Event):void {			removeEventListener(Event.ADDED_TO_STAGE,		addedToStageHandler);			stage.addEventListener(MouseEvent.MOUSE_MOVE,	mouseMoveHandler);			stage.addEventListener(MouseEvent.MOUSE_UP,		mouseUpHandler);		}				/**		 * Resize and replace the elements.		 */		private function computePositions():void {			var g:Graphics = _grid.graphics;			g.clear();			g.lineStyle(1, 0xFFFFFF, .5);						var x:int, y:int, bmp:Bitmap;						//DRAW GRID			for(x = 0; x < GeneratorGridMetrics.COLS + 1; ++x) {				g.moveTo(x * GeneratorGridMetrics.CELL_WIDTH, 0);				g.lineTo(x * GeneratorGridMetrics.CELL_WIDTH, GeneratorGridMetrics.CELL_HEIGHT * GeneratorGridMetrics.COLS);			}			for(y = 0; y < GeneratorGridMetrics.ROWS + 1; ++y) {				g.moveTo(0, y * GeneratorGridMetrics.CELL_HEIGHT);				g.lineTo(GeneratorGridMetrics.CELL_WIDTH * GeneratorGridMetrics.ROWS, y * GeneratorGridMetrics.CELL_HEIGHT);			}						//CREATE EMPTY BITMAPS			for(x = 0; x < GeneratorGridMetrics.COLS; ++x) {				for(y = 0; y < GeneratorGridMetrics.ROWS; ++y) {					bmp = _bmpsCtn.addChild(new Bitmap()) as Bitmap;					bmp.x = GeneratorGridMetrics.CELL_WIDTH * x;					bmp.y = GeneratorGridMetrics.CELL_HEIGHT * y;					_bitmaps[x + (y * GeneratorGridMetrics.ROWS)] = bmp;				}			}						graphics.clear();			graphics.beginFill(0xFF0000, 0);			graphics.drawRect(0, 0, GeneratorGridMetrics.CELL_WIDTH * GeneratorGridMetrics.COLS, GeneratorGridMetrics.CELL_HEIGHT * GeneratorGridMetrics.ROWS);		}				/**		 * Clears the grid.		 */		private function clear():void {			var i:int, len:int;			len = _bitmaps.length;			for(i = 0; i < len; ++i) {				_bitmaps[i].bitmapData = null;			}			_textures = new Vector.<Texture>(GeneratorGridMetrics.COLS * GeneratorGridMetrics.ROWS, true);		}				/**		 * Fills the current rolled over cell.		 * 		 * @return if a cell has been erased.		 */		private function drawCurrentCell(firstPress:Boolean = false):Boolean {			if(!_rollBmp.visible || _currentTexture == null) return false;						var x:int = Math.round(_rollBmp.x / GeneratorGridMetrics.CELL_WIDTH);			var y:int = Math.round(_rollBmp.y / GeneratorGridMetrics.CELL_HEIGHT);			var newPos:Point	= new Point(x, y);			var sameBmp:Boolean	= _bitmaps[x + (y * GeneratorGridMetrics.ROWS)].bitmapData == _currentTexture.selectedFace;			var samePos:Boolean	= _lastDrawingPos.x == newPos.x && _lastDrawingPos.y == newPos.y;						if((sameBmp && firstPress) || _eraseMode){				emptyCell(x, y);				return true;			}						if(_pressed && (!samePos || !sameBmp)) {				if(_textures[x + (y * GeneratorGridMetrics.ROWS)] != null){					ViewLocator.getInstance().dispatchToViews(new ViewEvent(ViewEvent.EMPTY_CELL, _textures[x + (y * GeneratorGridMetrics.ROWS)]));				}				_lastDrawingPos = newPos;				fillCell(x, y, _currentTexture);			}			return false;		}				/**		 * Fills a grid's cell.		 */		private function fillCell(x:int, y:int, texture:Texture):void {			_bitmaps[x + (y * GeneratorGridMetrics.ROWS)].bitmapData = texture.selectedFace;			_textures[x + (y * GeneratorGridMetrics.ROWS)] = texture;			_changeOccurs = true;			ViewLocator.getInstance().dispatchToViews(new ViewEvent(ViewEvent.FILL_CELL, texture));		}		/**		 * Empty a grid's cell.		 */		private function emptyCell(x:int, y:int):void {			ViewLocator.getInstance().dispatchToViews(new ViewEvent(ViewEvent.EMPTY_CELL, _textures[x + (y * GeneratorGridMetrics.ROWS)]));			_bitmaps[x + (y * GeneratorGridMetrics.ROWS)].bitmapData = null;			_textures[x + (y * GeneratorGridMetrics.ROWS)] = null;			_changeOccurs = true;		}												//__________________________________________________________ MOUSE EVENTS				/**		 * Called when mouse moves.		 */		private function mouseMoveHandler(e:MouseEvent):void {			if(e.target != this) {				_rollBmp.visible = false;				return;			}						_rollBmp.x	= Math.floor(mouseX / GeneratorGridMetrics.CELL_WIDTH) * GeneratorGridMetrics.CELL_WIDTH;			_rollBmp.y	= Math.floor(mouseY / GeneratorGridMetrics.CELL_HEIGHT) * GeneratorGridMetrics.CELL_HEIGHT;			_rollBmp.visible = isOverGrid();						if(_pressed) {				_inactivityTimer.reset();				_inactivityTimer.start();				drawCurrentCell();			}		}				/**		 * Called when the mouse button is pressed.		 */		private function mouseDownHandler(e:MouseEvent):void {			if(!isOverGrid()) return;			_eraseMode	= false;			_pressed	= true;			_eraseMode	= drawCurrentCell(true);		}		/**		 * Called when the mouse button is released.		 */		private function mouseUpHandler(e:MouseEvent):void {			_eraseMode	= false;			_pressed	= false;			if(e.currentTarget != stage && _changeOccurs){				updateCounter();			}			_changeOccurs = false;		}				/**		 * Makes the counter update.		 */		private function updateCounter(e:TimerEvent = null):void {			FrontControler.getInstance().sendMessage(MessageIds.UPDATE_COUNTER);		}		/**		 * Gets if the cursor is over the grid.		 */		private function isOverGrid():Boolean{			return mouseX > _grid.x && mouseX < _grid.x + _grid.width - 1 && mouseY > _grid.y && mouseY < _grid.y + _grid.height - 1;		}			}}