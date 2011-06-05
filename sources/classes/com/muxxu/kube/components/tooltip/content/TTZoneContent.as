package com.muxxu.kube.components.tooltip.content {
		private var _ok:BaseButton;
		private var _no:BaseButton;
		private var _thumbsCtn:Sprite;
		private var _loaderVote:URLLoader;
		private var _dolmenY:int;
		private var _dolmenX:int;
		private var _spin:LoaderSpinning;
		private var _pros:int;
		private var _removeBt:KubeButton;
		private var _isInteractive:Boolean;
		private var _touchedBt:BaseButton;

			if(contains(_touchedBt)) {
				_thumbsCtn.removeChild(_touchedBt);
			}
				if(!SharedObjectManager.getInstance().isDolmenTouched(new Point(data.x, data.y))) {
					_thumbsCtn.addChild(_touchedBt);
				}
				_isInteractive = true;
			
			_spin.alpha = 0;
			fv.addTarget(_touchedBt.icon as MovieClip);
			_touchedBt.accept(fv);
			_touchedBt.iconSpacing = 2;

			_no.x = Math.round(_ok.width + 10);
			_touchedBt.y = Math.round(_no.height + 4);
			_touchedBt.x = Math.round((_no.x + _no.width - _touchedBt.width) * .5);
			
				_removeBt.y = Math.round(_touchedBt.y + _touchedBt.height + 4);
			}

			_ok.x -= minX;
			_no.x -= minX;
			_touchedBt.x -= minX;
			var target:DisplayObject = event.target as BaseButton;
			if(target != _ok && target != _no && target != _removeBt && target != _touchedBt) return;
			} else if(target == _ok || target == _no) {
				SharedObjectManager.getInstance().flagDolmenAsTouched(new Point3D(_data.x, _data.y));
				DolmenEntry(_data.icon).updateTouchedState();
				DolmenData.getInstance().updateMap();
				dispatchEvent(new Event(Event.CLOSE));
				return;
			}