package com.muxxu.kube.views.login.steps {
		private var _uid:KubeInput;
		private var _pubkey:KubeInput;
		private var _submit:KubeButton;
		private var _spin:LoaderSpinning;
		private var _ks:KeyboardSequenceDetector;
		private var _code:KubeInput;
		private var _error:CssTextField;

			_uid.textfield.restrict = "[0-9]";
			_uid.setErrorState(null, "inputError");
		
			}

			_spin.y = Math.round(_submit.y + _submit.height * .5);
			_error.y = Math.round(_submit.y + _submit.height + 5);
		}
				_uid.text = _uid.defaultLabel;
				_pubkey.error = "xxx";
				_pubkey.text = _pubkey.defaultLabel;