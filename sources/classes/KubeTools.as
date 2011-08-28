package {

	import com.muxxu.kube.views.workbench.WorkBenchView;	import gs.TweenLite;
	import gs.plugins.AutoAlphaPlugin;
	import gs.plugins.BlurFilterPlugin;
	import gs.plugins.ColorMatrixFilterPlugin;
	import gs.plugins.DropShadowFilterPlugin;
	import gs.plugins.FramePlugin;
	import gs.plugins.GlowFilterPlugin;
	import gs.plugins.ShortRotationPlugin;
	import gs.plugins.TweenPlugin;

	import net.hires.debug.Stats;

	import com.muxxu.kube.commands.CheckUserCmd;
	import com.muxxu.kube.commands.InitAtlCmd;
	import com.muxxu.kube.commands.LoadConfigsCmd;
	import com.muxxu.kube.commands.LoadCssCmd;
	import com.muxxu.kube.commands.LoadFontsCmd;
	import com.muxxu.kube.commands.LoadLabelsCmd;
	import com.muxxu.kube.commands.LoadTexturesCmd;
	import com.muxxu.kube.components.InitLoader;
	import com.muxxu.kube.components.tooltip.ToolTip;
	import com.muxxu.kube.controler.FrontControler;
	import com.muxxu.kube.data.SharedObjectManager;
	import com.muxxu.kube.events.KTModelEvent;
	import com.muxxu.kube.events.LoginEvent;
	import com.muxxu.kube.graphics.KeyFocusGraphics;
	import com.muxxu.kube.model.Model;
	import com.muxxu.kube.views.Background;
	import com.muxxu.kube.views.Menu;
	import com.muxxu.kube.views.TitleBar;
	import com.muxxu.kube.views.ads.AdsView;
	import com.muxxu.kube.views.atlantiser.Atlantiser;
	import com.muxxu.kube.views.dolmens.Dolmens;
	import com.muxxu.kube.views.gallery.Gallery;
	import com.muxxu.kube.views.generator.Generator;
	import com.muxxu.kube.views.generator.selector.TextureSelector;
	import com.muxxu.kube.views.gps.GPS;
	import com.muxxu.kube.views.login.Login;
	import com.muxxu.kube.views.options.Options;
	import com.muxxu.kube.views.popin.Popin;
	import com.muxxu.kube.views.syswindow.SystemWindowManager;
	import com.muxxu.kube.vo.Message;
	import com.muxxu.kube.vo.MessageIds;
	import com.muxxu.kube.vo.Templates;
	import com.muxxu.kube.vo.ToolTipMessage;
	import com.nurun.components.button.AbstractNurunButton;
	import com.nurun.components.button.focus.NurunButtonKeyFocusManager;
	import com.nurun.components.form.IFormComponent;
	import com.nurun.components.invalidator.Invalidator;
	import com.nurun.components.vo.Margin;
	import com.nurun.core.commands.SequentialCommand;
	import com.nurun.core.commands.events.CommandEvent;
	import com.nurun.structure.environnement.configuration.Config;
	import com.nurun.structure.mvc.model.events.ModelEvent;
	import com.nurun.structure.mvc.views.ViewLocator;
	import com.nurun.utils.input.keyboard.KeyboardSequenceDetector;
	import com.nurun.utils.input.keyboard.events.KeyboardSequenceEvent;

	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Screen;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.setTimeout;	
	/**	 * Bootstrap class of the application.	 * Must be set as the main class for the flex sdk compiler	 * but actually the real bootstrap class will be the factoryClass	 * designated in the metadata instruction.	 * 	 * @author Francois	 */	 	[SWF(width="860", height="680", backgroundColor="0xffffff", frameRate="31")]//	[Frame(factoryClass="ApplicationLoader")]	public class KubeTools extends MovieClip {		private var _menu:Menu;		private var _background:Background;		private var _selector:TextureSelector;		private var _model:Model;		private var _stats:Stats;		private var _generator:Generator;		private var _lastView:String;		private var _toolTip:ToolTip;		private var _gallery:Gallery;		private var _loader:InitLoader;		private var _titleBar:TitleBar;		private var _options:Options;		private var _sequenceDetector:KeyboardSequenceDetector;		private var _dolmens:Dolmens;
		private var _login:Login;
		private var _atlantiser:Atlantiser;
		private var _gps:GPS;
		private var _sysWindow:SystemWindowManager;
		private var _initCmds:SequentialCommand;
		private var _ads:AdsView;
		private var _window:NativeWindow;		private var _loaderbin:Loader;		private var _workbench:WorkBenchView;						/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>Application</code>.<br>		 */		public function KubeTools() {						TweenPlugin.activate([	FramePlugin,									AutoAlphaPlugin,									BlurFilterPlugin,									GlowFilterPlugin,									DropShadowFilterPlugin,									ColorMatrixFilterPlugin,									ShortRotationPlugin]);						Invalidator.globalEventType = Event.EXIT_FRAME;						//Removing watermark			while(numChildren > 0) { removeChildAt(0); }						_loaderbin = new Loader();			_initCmds = new SequentialCommand();			_initCmds.addCommand(new LoadConfigsCmd("xml/configs.xml"));			_initCmds.addCommand(new LoadCssCmd());			_initCmds.addCommand(new LoadFontsCmd());			_initCmds.addCommand(new LoadLabelsCmd());			_initCmds.addCommand(new LoadTexturesCmd());			_initCmds.addCommand(new InitAtlCmd());			_initCmds.addCommand(new CheckUserCmd());			_initCmds.addEventListener(CommandEvent.COMPLETE,	login);			_initCmds.addEventListener(CommandEvent.ERROR,		initErrorHandler);			_initCmds.execute();			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);						//Soooo dirty way to "hide" the window... but the "visible=false" doesn't seem to work :/			stage.nativeWindow.x = 1000000;			stage.nativeWindow.y = 1000000;			stage.nativeWindow.addEventListener(Event.ACTIVATE, activateHandler);						createLoaderWindow();		}						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */		/* ****** *		 * PUBLIC *		 * ****** */						/* ******* *		 * PRIVATE *		 * ******* */		/**		 * Called if font file isn't found.		 */		protected function initErrorHandler(e:CommandEvent):void {
			var tf:TextField = _window.stage.addChild(new TextField()) as TextField;			tf.autoSize = TextFieldAutoSize.LEFT;			tf.textColor = 0xcc0000;			tf.text = "ERROR : " + e.data;			tf.filters = [new GlowFilter(0xffffff,1,2,2,5,1)];			tf.x = Math.round((_window.stage.stageWidth - tf.width) * .5); 			tf.y = Math.round((_window.stage.stageHeight - tf.height) * .5) + 50; 			_initCmds.dispose();		}				/**		 * Asks for logins		 */		protected function login(e:CommandEvent):void {			_initCmds.dispose();			try {				SharedObjectManager.getInstance().dataVersion;			}catch(e:Error) {				var tf:TextField = addChild(new TextField()) as TextField;				tf.autoSize = TextFieldAutoSize.LEFT;				tf.textColor = 0xcc0000;				tf.multiline = true;				tf.htmlText = "<p align=\"center\"><b>ERROR : Local crypted data storage have been corrupted</b>.<br />Please uninstall then re-install the application.</p>";				tf.filters = [new GlowFilter(0xFFFFFF,1,2,2,5,1)];				tf.x = Math.round((stage.stageWidth - tf.width) * .5); 				tf.y = Math.round((stage.stageHeight - tf.height) * .5); 				return;			}			if(SharedObjectManager.getInstance().dataVersion != SharedObjectManager.CURRENT_DATA_VERSION) {				SharedObjectManager.getInstance().authenticated = false;			}			if(!SharedObjectManager.getInstance().authenticated) {				_login		= _window.stage.addChild(new Login()) as Login;				_login.x	= Math.round((_window.stage.nativeWindow.width - _login.width) * .5);				_login.y	= Math.round((_window.stage.nativeWindow.height - _login.height) * .5);				_login.addEventListener(LoginEvent.COMPLETE, initialize);			}else{				initialize(e);
			}						setTimeout(_loader.close, 500);			NurunButtonKeyFocusManager.getInstance().initialize(stage, new KeyFocusGraphics(), [AbstractNurunButton, IFormComponent], new Margin(2, 2, 2, 2));			addChild(NurunButtonKeyFocusManager.getInstance());		}				/**		 * Initialize the class.<br>		 */		protected function initialize(e:Event):void {
			SharedObjectManager.getInstance().dataVersion = SharedObjectManager.CURRENT_DATA_VERSION;			if(_login != null) {				_window.stage.removeChild(_login);
				_window.close();				_login.removeEventListener(CommandEvent.COMPLETE, initErrorHandler);			}						_window.stage.nativeWindow.removeEventListener(Event.CLOSE, closeApplicationHandler);						_model = new Model();			FrontControler.getInstance().initialise(_model);			ViewLocator.getInstance().initialise(_model);			
			//Security to prevent from adding this in XML.
			Config.addVariable("isEtnalta", "false");			Config.addVariable("isKm", "false");
						var uId:String = SharedObjectManager.getInstance().userId;
			var isEtnalta:Boolean = uId=="89" || uId=="274" || uId=="517" || uId=="336";
			isEtnalta = isEtnalta || uId=="130" || uId=="313" || uId=="311" || uId=="275";
			isEtnalta = isEtnalta || uId=="25" || uId=="519" || uId=="408" || uId=="162777";
			isEtnalta = isEtnalta || uId=="543" || uId=="665" || uId=="49710" || uId == "112";
			isEtnalta = isEtnalta || uId=="8661" || uId=="12832" || uId=="57" || uId=="12066";			isEtnalta = isEtnalta || uId=="462" || uId=="785";
			isEtnalta &&= SharedObjectManager.getInstance().isEtnalta;			Config.addVariable("isEtnalta", isEtnalta? "true" : "false");
			
			var isKm:Boolean = uId=="18728" || uId=="1419" || uId=="2869" || uId=="16674";
			isKm = isKm || uId=="49710" || uId=="13350" || uId=="50668" || uId=="4989";			isKm = isKm || uId=="147" || uId=="8603" || uId=="11682" || uId=="859";			isKm = isKm || uId=="502713" || uId=="110104" || uId=="10793" || uId=="60880" || uId=="13936";//			isKm &&= SharedObjectManager.getInstance().isKm;			Config.addVariable("isKm", isKm? "true" : "false");						_background	= addChild(new Background()) as Background;			_menu		= addChild(new Menu()) as Menu;			_titleBar	= addChild(new TitleBar()) as TitleBar;			_generator	= addChild(new Generator()) as Generator;			_selector	= addChild(new TextureSelector()) as TextureSelector;			_stats		= addChild(new Stats()) as Stats;			_gallery	= addChild(new Gallery()) as Gallery;			_dolmens	= addChild(new Dolmens()) as Dolmens;			_options	= addChild(new Options()) as Options;			_atlantiser	= addChild(new Atlantiser()) as Atlantiser;			_gps		= addChild(new GPS()) as GPS;			_ads		= addChild(new AdsView()) as AdsView;			_workbench	= addChild(new WorkBenchView()) as WorkBenchView;			_toolTip	= addChild(new ToolTip()) as ToolTip;			_sysWindow	= addChild(SystemWindowManager.getInstance()) as SystemWindowManager;						addChild(new Popin());			addChild(NurunButtonKeyFocusManager.getInstance());						_model.start();			_toolTip.mouseEnabled = _toolTip.mouseChildren = false;						_stats.visible = Config.getVariable("stats") == "true";			_background.localMode = SharedObjectManager.getInstance().localMode;						stage.addEventListener(Event.RESIZE, computePositions);			_model.addEventListener(ModelEvent.UPDATE, modelUpdateHandler);			_background.addEventListener(MouseEvent.MOUSE_DOWN, pressBackHandler);						computePositions();						stage.nativeWindow.x = Math.round((Screen.mainScreen.bounds.width - stage.nativeWindow.width) * .5);			stage.nativeWindow.y = Math.round((Screen.mainScreen.bounds.height - stage.nativeWindow.height) * .5);
			stage.nativeWindow.activate();
		}

		/**		 * Called when the main window is activated.		 */
		private function activateHandler(event:Event):void {
			if(!_window.closed) {
				_window.activate();
			}		}
		/**		 * Called when the stage is available		 */		private function addedToStageHandler(e:Event):void {			stage.align		= StageAlign.TOP_LEFT;			stage.scaleMode	= StageScaleMode.NO_SCALE;			stage.stageFocusRect = false;						_sequenceDetector = new KeyboardSequenceDetector(stage);			_sequenceDetector.addEventListener(KeyboardSequenceEvent.SEQUENCE, keyboardSequenceHandler);			_sequenceDetector.addSequence("local", [27,76,79,67,65,76,13]);// escape LOCAL + Enter			_sequenceDetector.addSequence("stats", [27,83,84,65,84,83,13]);// escape STATS + Enter			_sequenceDetector.addSequence("reset", [27,82,69,83,69,84,13]);// escape RESET + Enter						stage.nativeWindow.addEventListener(Event.CLOSE, closeApplicationHandler);		}				/**		 * Called when the application is closed to close the loader too.		 */		private function closeApplicationHandler(event:Event):void {
			if(!_window.closed) _window.close();
			if(!stage.nativeWindow.closed) stage.nativeWindow.close();		}				/**		 * Creates the transparent window that displays the loader.		 */		private function createLoaderWindow():void {			var options:NativeWindowInitOptions = new NativeWindowInitOptions();			options.maximizable		= false;			options.minimizable		= false;			options.resizable		= false;			options.systemChrome	= NativeWindowSystemChrome.NONE;			options.transparent		= true;			options.type			= NativeWindowType.LIGHTWEIGHT;						_window					= new NativeWindow(options);			_window.stage.scaleMode	= StageScaleMode.NO_SCALE;			_window.stage.align		= StageAlign.TOP_LEFT;			_window.visible			= true;			_window.width			= Screen.mainScreen.bounds.width;			_window.height			= Screen.mainScreen.bounds.height;			_window.x				= Screen.mainScreen.bounds.x;			_window.y				= Screen.mainScreen.bounds.y;						_loader = new InitLoader();			_window.stage.addChild(_loader);
			_window.stage.nativeWindow.addEventListener(Event.CLOSE, closeApplicationHandler);
			_loader.addEventListener(Event.CLOSE, closeLoaderHandler);
		}

		/**		 * Called when the loader is closed.		 */
		private function closeLoaderHandler(event:Event):void {			_loader.dispose();			_window.stage.removeChild(_loader);
			if(_login == null) {
				_window.close();
			}
		}
		/**		 * Called when a catchable keyboard sequence is written.		 */		private function keyboardSequenceHandler(e:KeyboardSequenceEvent):void {			//Toggle between offline and online mode			if(e.sequenceId == "local") {				var local:Boolean = !SharedObjectManager.getInstance().localMode;				SharedObjectManager.getInstance().localMode = local;				if(local) {					Config.addPath("server", Config.getVariable("serverOffline"));					TweenLite.to(this, .1, {colorMatrixFilter:{brightness:-.5, remove:true}});				}else{					Config.addPath("server", Config.getVariable("serverOnline"));					TweenLite.to(this, .1, {colorMatrixFilter:{brightness:2.5, remove:true}});				}				_background.localMode = local;			}else if(e.sequenceId == "stats") {				_stats.visible = !_stats.visible;			}else if(e.sequenceId == "reset") {				SharedObjectManager.getInstance().pubKey = null;				SharedObjectManager.getInstance().userId = null;				SharedObjectManager.getInstance().authenticated = false;				SharedObjectManager.getInstance().isEtnalta = false;				stage.nativeWindow.close();			}			TweenLite.to(this, .25, {colorMatrixFilter:{brightness:1, remove:true}, delay:.1, overwrite:0});		}		/**		 * Called on model's update.		 */		private function modelUpdateHandler(e:KTModelEvent):void {			var message:Message = e.message;			if(message.id == MessageIds.OPEN_TOOLTIP){				_toolTip.open(message.data as ToolTipMessage);			}			computePositions(e);		}		/**		 * Resize and replace the elements.<br>		 */		private function computePositions(e:Event = null):void {			if(e is KTModelEvent){				var message:Message = KTModelEvent(e).message;				if(message.id == MessageIds.CHANGE_VIEW){					if(_lastView == message.data) return;					_lastView = message.data;				}else{					return;				}			}						var ox:int = 0;			var oy:int = 0;			var w:int = stage.stageWidth;			var h:int = stage.stageHeight;						_background.x		= ox;			_background.y		= oy;			_background.width	= w;			_background.height	= h;			_titleBar.width		= w - Background.CELL_WIDTH * 2 - 1;			_titleBar.x			= Background.CELL_WIDTH + 1 + ox;			_titleBar.y			= Background.CELL_WIDTH + 1 + oy;						h -= Math.round(_titleBar.y + _titleBar.height);						//MENU			_menu.y			= Math.round(_titleBar.y + _titleBar.height);			_menu.x			= Background.CELL_WIDTH + 1 + ox;			_menu.height	= Math.round(h - Background.CELL_WIDTH - 1);			if(w < 300) {				_menu.width	= Math.min(_menu.widthMax, w * .5);			}else{				_menu.width	= _menu.widthMax;			}						//GENERATOR			_generator.x = _menu.x + _menu.width + 1;			_generator.y = _menu.y;			_generator.height	= _menu.height;			_generator.width	= Math.round(w - Background.CELL_WIDTH - _menu.width - _menu.x) - 1;						//SELECTOR			var selectorH:int = 140;			_selector.width	= w - (Background.CELL_WIDTH * 2) - 1;			if(h < 500) {				_selector.height	= Math.min(selectorH, h * .5);			}else{				_selector.height	= selectorH;			}						if(_lastView == Templates.GENERATOR){				_menu.height -= _selector.height;				_generator.height -= _selector.height;			}			_selector.x		= _menu.x;			_selector.y		= _menu.y + _menu.height;						//GALLERY			_gallery.x		= _generator.x;			_gallery.y		= _generator.y;			_gallery.width	= _generator.width;			_gallery.height	= _generator.height;						//GPS			_gps.x			= _generator.x;			_gps.y			= _generator.y;			_gps.width		= _generator.width;			_gps.height		= _generator.height;						//WORKBENCH			_workbench.x		= _generator.x;			_workbench.y		= _generator.y;			_workbench.width	= _generator.width;			_workbench.height	= _generator.height;						//ADS			_ads.x			= _generator.x;			_ads.y			= _generator.y;			_ads.width		= _generator.width;			_ads.height		= _generator.height;						//DOLMENS			_dolmens.x		= _generator.x;			_dolmens.y		= _generator.y;			_dolmens.width	= _generator.width;			_dolmens.height	= _generator.height;						//ATLANTISER			_atlantiser.x		= _generator.x;			_atlantiser.y		= _generator.y;			_atlantiser.width	= _generator.width;			_atlantiser.height	= _generator.height;						//STATS			_stats.y = _menu.height - _stats.height;			_stats.x = Math.round((_menu.widthMax - _stats.width) * .5);		}				/**		 * Called when the background is pressed to move it.		 */		private function pressBackHandler(e:MouseEvent):void {			var align:String = "";			if(mouseY < Background.CELL_WIDTH || mouseY > stage.stageHeight - Background.CELL_WIDTH){				align = (mouseY < Background.CELL_WIDTH) ? "T" : "B";			}			if(mouseX < Background.CELL_WIDTH || mouseX > stage.stageWidth - Background.CELL_WIDTH){				align += (mouseX < Background.CELL_WIDTH)? "L" : "R";			}			if(align.length > 0) {				stage.nativeWindow.startResize(align);			}else{				stage.nativeWindow.startMove();			}		}	}}