package com.muxxu.kube.views.workbench {

	import com.muxxu.kube.vo.Point3D;
	import com.nurun.utils.pos.PosUtils;
	import com.nurun.structure.environnement.label.Label;
	import com.nurun.components.text.CssTextField;
	import com.muxxu.kube.events.KTModelEvent;
	import com.muxxu.kube.views.AbstractKTView;
	import com.muxxu.kube.vo.Message;
	import com.muxxu.kube.vo.MessageIds;
	import com.muxxu.kube.vo.Templates;
	import com.nurun.structure.mvc.model.events.IModelEvent;

	import flash.events.Event;
	
	/**
	 * 
	 * @author Francois
	 * @date 8 mars 2011;
	 */
	public class WorkBenchView extends AbstractKTView {

		private var _title:CssTextField;
		private var _description:CssTextField;
		private var _list:WBList;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>WorkBenchView</code>.
		 */
		public function WorkBenchView() {
			super();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Called when model's state changes
		 */
		override public function update(e:IModelEvent):void {
			var message:Message = KTModelEvent(e).message;
			
			if(message.id == MessageIds.CHANGE_VIEW){
				if(message.data == Templates.WORKBENCH) {
					show();
				}else {
					hide();
				}
			}
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		override protected function initialize():void {
			super.initialize();
			_title = addChild(new CssTextField("title")) as CssTextField;
			_description = addChild(new CssTextField("content")) as CssTextField;
			_list = addChild(new WBList()) as WBList;
			
			_title.text = Label.getLabel("wbTitle");
			_description.text = Label.getLabel("wbDescription");
			
			_list.addEventListener(Event.RESIZE, computePositions);
		}
		
		/**
		 * Resize and replace the elements.
		 */
		override protected function computePositions(e:Event = null):void {
			_title.width = _width;
			_description.width = _width;
			_list.width = _width;
			
			_list.x = 10;
			
			PosUtils.vPlaceNext(2, _title, _description, _list);
			_list.y += 20;
			super.computePositions();
		}
		
	}
}