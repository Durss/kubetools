package com.muxxu.kube.data {
		private var _lastArea:Rectangle;
		private var _lastDolmenAdded:Point;
		private var _lastCoords:Point3D;
		private var _window:SystemWindow;
		private var _windowContent:SystemWindowDolmens;
		private var _lastPlayerMove:int;
		private var _dolmens:Vector.<MapEntry>;

		public function updateMap():void {
			dispatchEvent(new DolmenMapDataEvent(DolmenMapDataEvent.UPDATE_MAP));
		}

		}
