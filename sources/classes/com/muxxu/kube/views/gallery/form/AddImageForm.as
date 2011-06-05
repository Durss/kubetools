package com.muxxu.kube.views.gallery.form {	import gs.TweenLite;	import com.muxxu.kube.components.LoaderSpinning;	import com.muxxu.kube.components.button.KubeButton;	import com.muxxu.kube.components.button.OpenCloseFormButton;	import com.muxxu.kube.components.form.KubeInput;	import com.muxxu.kube.components.form.KubeRadioButton;	import com.muxxu.kube.components.form.ZoneInput;	import com.muxxu.kube.data.GalleryData;	import com.muxxu.kube.events.GalleryDataEvent;	import com.nurun.components.form.FormComponentGroup;	import com.nurun.components.form.events.FormComponentEvent;	import com.nurun.components.text.CssTextField;	import com.nurun.components.vo.Margin;	import com.nurun.structure.environnement.label.Label;	import flash.display.Shape;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.events.TimerEvent;	import flash.filesystem.File;	import flash.net.FileFilter;	import flash.utils.Timer;	/**	 * Displays the add image form.<br>	 * <br>	 * The form provides the user to upload an image with some informations to	 * the server's database.	 * 	 * @author  Francois	 */	public class AddImageForm extends Sprite {		private var _width:Number;		private var _height:Number;		private var _openCloseBar:OpenCloseFormButton;		private var _nameInput:KubeInput;		private var _nameLabel:CssTextField;		private var _mask:Shape;		private var _opened:Boolean;		private var _authorLabel:CssTextField;		private var _authorInput:KubeInput;		private var _zoneLabel:CssTextField;		private var _zoneInput:ZoneInput;		private var _formCtn:Sprite;		private var _imageLabel:CssTextField;		private var _imageInput:KubeInput;		private var _file:File;		private var _submitButton:KubeButton;		private var _group:FormComponentGroup;		private var _pixelArtRb:KubeRadioButton;		private var _monumentRb:KubeRadioButton;		private var _spin:LoaderSpinning;		private var _resultTxt:CssTextField;		private var _timerClear:Timer;		private var _otherRb:KubeRadioButton;		private var _landscapeRb:KubeRadioButton;								/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>AddImageForm</code>.		 */		public function AddImageForm() {			initialize();		}						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */		/**		 * Sets the component's width without simply scaling it.		 */		override public function set width(value:Number):void {			_width = value;			computePositions();		}				/**		 * Sets the component's height without simply scaling it.		 */		override public function set height(value:Number):void {			_height = value;			computePositions();		}				/**		 * Gets the virtual component's width.		 */		override public function get width():Number { return _width; }				/**		 * Gets the virtual component's hright.		 */		override public function get height():Number { return _mask.height; }		/* ****** *		 * PUBLIC *		 * ****** */		/**		 * Opens the form.		 */		public function open():void {			_opened = true;			TweenLite.to(this, .5, {height:_formCtn.y + _formCtn.height, onUpdate:dispatchEvent, onUpdateParams:[new Event(Event.RESIZE)]});		}				/**		 * Closes the form.		 */		public function close():void {			_opened = false;			_resultTxt.text	= "";			TweenLite.to(this, .5, {height:_openCloseBar.height, onUpdate:dispatchEvent, onUpdateParams:[new Event(Event.RESIZE)]});		}						/* ******* *		 * PRIVATE *		 * ******* */		/**		 * Initialize the class.		 */		private function initialize():void {			_timerClear		= new Timer(5000, 1);			_file			= new File();			_group			= new FormComponentGroup();			_openCloseBar	= addChild(new OpenCloseFormButton(Label.getLabel("galleryFormOpener"))) as OpenCloseFormButton;			_formCtn		= addChild(new Sprite()) as Sprite;			_nameLabel		= _formCtn.addChild(new CssTextField("galleryFormLabel")) as CssTextField;			_nameInput		= _formCtn.addChild(new KubeInput()) as KubeInput;			_authorLabel	= _formCtn.addChild(new CssTextField("galleryFormLabel")) as CssTextField;			_authorInput	= _formCtn.addChild(new KubeInput()) as KubeInput;			_zoneLabel		= _formCtn.addChild(new CssTextField("galleryFormLabel")) as CssTextField;			_zoneInput		= _formCtn.addChild(new ZoneInput(true)) as ZoneInput;			_imageLabel		= _formCtn.addChild(new CssTextField("galleryFormLabel")) as CssTextField;			_imageInput		= _formCtn.addChild(new KubeInput()) as KubeInput;			_pixelArtRb		= _formCtn.addChild(new KubeRadioButton(Label.getLabel("galleryFormEntryTypePixelArt"), _group)) as KubeRadioButton;			_monumentRb		= _formCtn.addChild(new KubeRadioButton(Label.getLabel("galleryFormEntryTypeMonument"), _group)) as KubeRadioButton;			_landscapeRb	= _formCtn.addChild(new KubeRadioButton(Label.getLabel("galleryFormEntryTypeLandscape"), _group)) as KubeRadioButton;			_otherRb		= _formCtn.addChild(new KubeRadioButton(Label.getLabel("galleryFormEntryTypeOther"), _group)) as KubeRadioButton;			_submitButton	= _formCtn.addChild(new KubeButton(Label.getLabel("galleryFormSubmitLabel"))) as KubeButton;			_resultTxt		= _formCtn.addChild(new CssTextField()) as CssTextField;			_mask			= addChild(new Shape()) as Shape;			_spin			= addChild(new LoaderSpinning()) as LoaderSpinning;						_submitButton.contentMargin = new Margin(10, 4, 10, 4);			_nameLabel.text		= Label.getLabel("galleryFormNameLabel");			_authorLabel.text	= Label.getLabel("galleryFormAuthorLabel");			_zoneLabel.text		= Label.getLabel("galleryFormZoneLabel");			_imageLabel.text	= Label.getLabel("galleryFormImageLabel");			_height				= _openCloseBar.height;			_resultTxt.wordWrap	= true;			_pixelArtRb.selected= true;						_pixelArtRb.defaultStyle	= "radioButtonGallery";			_pixelArtRb.selectedStyle	= "radioButtonGallery";						_monumentRb.defaultStyle	= "radioButtonGallery";			_monumentRb.selectedStyle	= "radioButtonGallery";						_otherRb.defaultStyle		= "radioButtonGallery";			_otherRb.selectedStyle		= "radioButtonGallery";						_landscapeRb.defaultStyle	= "radioButtonGallery";			_landscapeRb.selectedStyle	= "radioButtonGallery";						var i:int = 0;			_nameInput.tabIndex		= i++;			_authorInput.tabIndex	= i++;			_zoneInput.tabIndex		= i++;			_imageInput.tabIndex	= i++;			_pixelArtRb.tabIndex	= i++;			_monumentRb.tabIndex	= i++;			_landscapeRb.tabIndex	= i++;			_otherRb.tabIndex		= i++;			_submitButton.tabIndex	= i++;						_imageInput.buttonMode		= true;			_imageInput.mouseChildren	= false;						_mask.graphics.beginFill(0xFFFFFF, 0);			_mask.graphics.drawRect(0, 0, 10, 10);			_formCtn.mask = _mask;						_timerClear.addEventListener(TimerEvent.TIMER_COMPLETE,		timerClearCompleteHandler);			_openCloseBar.addEventListener(MouseEvent.CLICK,			clickOpenCloseHandler);			_imageInput.addEventListener(MouseEvent.CLICK,				clickBrowseFieldHandler);			_submitButton.addEventListener(MouseEvent.CLICK,			clickSumbitHandler);			_file.addEventListener(Event.SELECT,						selectFileHandler);			_nameInput.addEventListener(FormComponentEvent.SUBMIT,		clickSumbitHandler);			_authorInput.addEventListener(FormComponentEvent.SUBMIT,	clickSumbitHandler);			_zoneInput.addEventListener(FormComponentEvent.SUBMIT,		clickSumbitHandler);			_imageInput.addEventListener(FormComponentEvent.SUBMIT,		clickSumbitHandler);			GalleryData.getInstance().addEventListener(GalleryDataEvent.IMAGE_SENT,				imageSendingResultHandler);			GalleryData.getInstance().addEventListener(GalleryDataEvent.IMAGE_SENDING_ERROR,	imageSendingResultHandler);		}		/**		 * Resize and replace the elements.		 */		private function computePositions():void {			_openCloseBar.width	= _width;			_openCloseBar.validate();			_mask.width			= _width;			_mask.height		= _height;						_formCtn.x			= 5;			_formCtn.y			= Math.round(_openCloseBar.y + _openCloseBar.height + 5);						_nameLabel.y		= 0;			_nameInput.y		= _nameLabel.y;						_authorLabel.y		= Math.round(_nameInput.y + _nameInput.height + 4);			_authorInput.y		= _authorLabel.y;						_zoneLabel.y		= Math.round(_authorInput.y + _authorInput.height + 4);			_zoneInput.y		= _zoneLabel.y;						_imageLabel.y		= Math.round(_zoneInput.y + _zoneInput.height + 4);			_imageInput.y		= _imageLabel.y;						_pixelArtRb.x		= _zoneInput.x;			_pixelArtRb.y		= Math.round(_imageInput.y + _imageInput.height + 4);			_monumentRb.y		= _pixelArtRb.y;			_monumentRb.x		= Math.round(_pixelArtRb.x + _pixelArtRb.width + 10);			_landscapeRb.y		= _monumentRb.y;			_landscapeRb.x		= Math.round(_monumentRb.x + _monumentRb.width + 10);			_otherRb.y			= _landscapeRb.y;			_otherRb.x			= Math.round(_landscapeRb.x + _landscapeRb.width + 10);						_submitButton.y		= Math.round(_pixelArtRb.y + _pixelArtRb.height + 4);			_submitButton.x		= Math.round((_width - _submitButton.width) * .5);						_resultTxt.y		= Math.round(_submitButton.y + _submitButton.height + 4);			_resultTxt.x		= 0;			_resultTxt.width	= _width;						var maxLabelW:int	= Math.max(_nameLabel.width, _authorLabel.width, _zoneLabel.width) + 5;			_zoneInput.width	= _authorInput.width = _nameInput.width = _imageInput.width = _width - maxLabelW - 10;			_nameInput.x		= _authorInput.x = _zoneInput.x =  _imageInput.x = maxLabelW;						_spin.x		= _width - _spin.width * .5 - 10;			_spin.y		= _height - _spin.height * .5 - 10;						graphics.clear();			graphics.beginFill(0xFFFFFF, .35);			graphics.drawRect(0, _openCloseBar.height, _width, _height - _openCloseBar.height);		}		/**		 * Called when the open/close button is clicked.		 */		private function clickOpenCloseHandler(e:MouseEvent = null):void {			if(_opened){				close();			}else{				open();			}		}				/**		 * Called when browse input is clicked.		 */		private function clickBrowseFieldHandler(e:MouseEvent):void {			_file.browse([new FileFilter("Image file", "*.jpg;*.jpeg;*.png")]);		}				/**		 * Called when submit button is clicked or when ENTER key is pressed on an input field.		 */		private function clickSumbitHandler(e:Event):void {			_nameLabel.style = "galleryFormLabel";			_authorLabel.style = "galleryFormLabel";			_zoneLabel.style = "galleryFormLabel";			_imageLabel.style = "galleryFormLabel";			if(!_submitButton.enabled) return;			if(_nameInput.text.length == 0 || _nameInput.text == _nameInput.defaultLabel) {				_nameLabel.style = "galleryFormLabelError";				return;			}			if(_authorInput.text.length == 0 || _authorInput.text == _authorInput.defaultLabel) {				_authorLabel.style = "galleryFormLabelError";				return;			}			if(isNaN(_zoneInput.xValue) || isNaN(_zoneInput.yValue)) {				_zoneLabel.style = "galleryFormLabelError";				return;			}			try {				_file.exists;			}catch(error:Error){				_imageLabel.style = "galleryFormLabelError";				return;			}			if(!_file.exists) {				_imageLabel.style = "galleryFormLabelError";				return;			}			var type:int = 0;			if(_monumentRb.selected) type = 1;			if(_landscapeRb.selected) type = 2;			if(_otherRb.selected) type = 3;			GalleryData.getInstance().postEntry(_file, _authorInput.text, _nameInput.text, _zoneInput.xValue+";"+_zoneInput.yValue, type);			_submitButton.enabled = false;			_spin.open();			timerClearCompleteHandler();		}				/**		 * Called when an image file is selected.		 */		private function selectFileHandler(e:Event):void {			_imageInput.text = _file.nativePath;		}				/**		 * Called on server's callback.		 */		private function imageSendingResultHandler(e:GalleryDataEvent):void {			if(e.errorCode == 0) {				_resultTxt.style = "galleryFormSuccess";				_resultTxt.text		= Label.getLabel("galleryFormSuccess");				_timerClear.reset();				_timerClear.start();			} else{				_resultTxt.style	= "galleryFormServerError";				_resultTxt.text		= Label.getLabel("galleryFormServerError"+e.errorCode);			}			open();						_submitButton.enabled = true;			_spin.close();		}				/**		 * Called when clear timer completes to hide success or error message.		 */		private function timerClearCompleteHandler(e:TimerEvent = null):void {			if(e != null && !_opened) return;			_resultTxt.text	= "";			open();		}	}}