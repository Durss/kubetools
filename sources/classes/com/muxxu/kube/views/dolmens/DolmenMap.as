package com.muxxu.kube.views.dolmens {
	import com.muxxu.kube.components.map.MapEngine;
		private var _height:int;
		private var _tooltip:ToolTip;


			DolmenData.getInstance().addEventListener(DolmenMapDataEvent.UPDATE_MAP, updateMapHandler);
		
		}

		}
		private function updateMapHandler(event:DolmenMapDataEvent):void {
			_map.update();
