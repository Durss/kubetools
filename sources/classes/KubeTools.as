package {

	import com.muxxu.kube.views.workbench.WorkBenchView;
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

		private var _login:Login;
		private var _atlantiser:Atlantiser;
		private var _gps:GPS;
		private var _sysWindow:SystemWindowManager;
		private var _initCmds:SequentialCommand;
		private var _ads:AdsView;
		private var _window:NativeWindow;
			}
				_window.close();
			//Security to prevent from adding this in XML.
			Config.addVariable("isEtnalta", "false");
			
			var isEtnalta:Boolean = uId=="89" || uId=="274" || uId=="517" || uId=="336";
			isEtnalta = isEtnalta || uId=="130" || uId=="313" || uId=="311" || uId=="275";
			isEtnalta = isEtnalta || uId=="25" || uId=="519" || uId=="408" || uId=="162777";
			isEtnalta = isEtnalta || uId=="543" || uId=="665" || uId=="49710" || uId == "112";
			isEtnalta = isEtnalta || uId=="8661" || uId=="12832" || uId=="57" || uId=="12066";
			isEtnalta &&= SharedObjectManager.getInstance().isEtnalta;
			
			var isKm:Boolean = uId=="18728" || uId=="1419" || uId=="2869" || uId=="16674";
			isKm = isKm || uId=="49710" || uId=="13350" || uId=="50668" || uId=="4989";
			stage.nativeWindow.activate();
		}

		/**
		private function activateHandler(event:Event):void {
			if(!_window.closed) {
				_window.activate();
			}

			if(!_window.closed) _window.close();
			if(!stage.nativeWindow.closed) stage.nativeWindow.close();
			_window.stage.nativeWindow.addEventListener(Event.CLOSE, closeApplicationHandler);
			_loader.addEventListener(Event.CLOSE, closeLoaderHandler);
		}

		/**
		private function closeLoaderHandler(event:Event):void {
			if(_login == null) {
				_window.close();
			}
		}
