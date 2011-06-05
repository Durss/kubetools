package com.muxxu.kube.commands {
	import com.muxxu.kube.data.SharedObjectManager;
	import flash.net.URLRequestMethod;
	import com.muxxu.kube.utils.HTTPPath;
	import com.muxxu.kube.crypto.RequestEncrypter;
	import flash.net.URLVariables;
	import com.nurun.core.commands.AbstractCommand;
		private var _pubkey:String;
		private var _updateMode:Boolean;

			_uid = uid;
			if(_pubkey == null && _uid == null) {
					_pubkey = SharedObjectManager.getInstance().pubKey;
					_uid = SharedObjectManager.getInstance().userId;
				}
		override public function execute():void {
			if(_pubkey == null || _uid == null) {
		

				// Wrong arguments number
			data = RequestEncrypter.decrypt(data.child("result")[0]);
					SharedObjectManager.getInstance().userGender = data.child("user").@male == "true"? "m" : "f";
					SharedObjectManager.getInstance().userPoints = parseInt(data.child("user")[0].child("games").child("g").(@game == "kube").child("i").(@key == "Score")[0].replace(/[^0-9]/gi, ""));
				}catch(error:Error) {