package com.muxxu.kube.crypto {
	import com.muxxu.kube.crypto.events.ATLEvent;

	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	[Event(name="encryptProgress", type="com.muxxu.kube.crypto.events.ATLEvent")]	[Event(name="encryptComplete", type="com.muxxu.kube.crypto.events.ATLEvent")]	[Event(name="decryptProgress", type="com.muxxu.kube.crypto.events.ATLEvent")]	[Event(name="decryptComplete", type="com.muxxu.kube.crypto.events.ATLEvent")]

	/**
	 * Provides methods to encrypt and decrypt strings.
	 * 
	 * @author  Francois
	 */
	public class ATL3 extends EventDispatcher {
		
		private var _chars:Array = ["ϴ","Ͼ","Ԏ","₪","Д","⌂","ᴪ","≡","≈","∩","⁞","ᴧ","Ԃ","ᴨ","╔","╕","∆","Ω","Ҩ","Ҵ","◌","◊","⸗","ⱴ","∂","‖","ג","ם","מ","ԓ","¤","¬","±","ƛ","ƣ","ʄ"];
		private var _additionals:Array = ["ծ", "ʉ", "ʘ", "Ռ", "ώ", "Щ", "פ"];
		private var _oldChars:Array = ["ѧ", "խ"];
		private var _charsToIndex:Array = [];
		private var _addSubValue:int = 3;
		private var _efTarget:Shape;
		private var _src:String;
		private var _key:String;
		private var _index:int;
		private var _each:int;

		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * 
		 */
		public function ATL3() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Encrypt a string.
		 * 
		 * @param src	string to encrypt
		 * @param key	key to use to encrypt the string
		 */
		public function encrypt(src:String, key:String):void {
			_index	= 0;
			_key	= key;
			_src	= src;
			_each	= parseInt(_key.charAt(Math.round(_key.length * .5)), 16);
			_each	= Math.max(_each, 1);
			
			_efTarget.removeEventListener(Event.ENTER_FRAME, processEncrypt);
			_efTarget.removeEventListener(Event.ENTER_FRAME, processDecrypt);
			
			_efTarget.addEventListener(Event.ENTER_FRAME, processEncrypt);
		}
		
		/**
		 * Decrypt a encrypted string.
		 * 
		 * @param src	string to decrypt
		 * @param key	key to use to de	crypt the string
		 */
		public function decrypt(src:String, key:String):void {
			_key	= key;
			_src	= src;
			_each	= parseInt(_key.charAt(Math.round(_key.length * .5)), 16);
			_each	= Math.max(_each, 1);
			_index	= _key.length - 1;
			_src	= ATLToLatin(_src);
			
			_efTarget.removeEventListener(Event.ENTER_FRAME, processEncrypt);
			_efTarget.removeEventListener(Event.ENTER_FRAME, processDecrypt);
			
			if(_key.length > 0) {
				_efTarget.addEventListener(Event.ENTER_FRAME, processDecrypt);
				dispatchEvent(new ATLEvent(ATLEvent.DECRYPT_PROGRESS, _src));
			} else {
				dispatchEvent(new ATLEvent(ATLEvent.DECRYPT_COMPLETE, _src));
			}
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize some statics
		 */
		private function initialize():void {
			_efTarget = new Shape();
			
			var i:int, len:int, chars:Array;
			chars = _chars.concat(_additionals, _oldChars);
			len = chars.length;
			for(i = 0; i < len; ++i) {
				if(_charsToIndex[chars[i]] != null) {
					trace("DOUBLON :: " + _chars[i] + " at index " + i);
				}
				_charsToIndex[_chars[i]] = i;
			}
		}
		
		/**
		 * Called on ENTER_FRAME event to process encryption.
		 */
		private function processEncrypt(event:Event):void {
			if(_index < _key.length) {
				var value:int = parseInt(_key.charAt(_index), 16);
				var exValue:int = Math.max(1, parseInt(_key.charAt(_index-1), 16));
				switch(value) {
					case 0:
					case 1:
						_src = sl(_src, exValue);
						break;
					case 2:
					case 3:
						_src = sr(_src, exValue);
						break;
					case 4:
					case 5:
						_src = pl(_src, exValue);
						break;
					case 6:
					case 7:
						_src = add(_src, exValue + _addSubValue, _each);
						break;
					case 8:
					case 9:
						_src = sl(_src, value);
						break;
					case 10:
					case 11:
						_src = sr(_src, value);
						break;
					case 12:
					case 13:
						_src = pl(_src, value);
						break;
					case 14:
					case 15:
					default:
						_src = add(_src, value + _addSubValue, _each);
						break;
				}
				_index ++;
				dispatchEvent(new ATLEvent(ATLEvent.ENCRYPT_PROGRESS, _src));
			}else {
				dispatchEvent(new ATLEvent(ATLEvent.ENCRYPT_COMPLETE, latinToATL(_src)));
				_efTarget.removeEventListener(Event.ENTER_FRAME, processEncrypt);
			}
		}
		
		/**
		 * Called on ENTER_FRAME event to process decryption.
		 */
		private function processDecrypt(event:Event):void {
			if(_index >= 0) {
				var value:int = parseInt(_key.charAt(_index), 16);
				var nextValue:int = Math.max(1, parseInt(_key.charAt(_index-1), 16));
				switch(value) {
					case 0:
					case 1:
						_src = sr(_src, nextValue);
						break;
					case 2:
					case 3:
						_src = sl(_src, nextValue);
						break;
					case 4:
					case 5:
						_src = pr(_src, nextValue);
						break;
					case 6:
					case 7:
						_src = sub(_src, nextValue + _addSubValue, _each);
						break;
					case 8:
					case 9:
						_src = sr(_src, value);
						break;
					case 10:
					case 11:
						_src = sl(_src, value);
						break;
					case 12:
					case 13:
						_src = pr(_src, value);
						break;
					case 14:
					case 15:
					default:
						_src = sub(_src, value + _addSubValue, _each);
						break;
				}
				_index --;
				dispatchEvent(new ATLEvent(ATLEvent.DECRYPT_PROGRESS, _src));
			} else{
				_efTarget.removeEventListener(Event.ENTER_FRAME, processDecrypt);
				dispatchEvent(new ATLEvent(ATLEvent.DECRYPT_COMPLETE, _src));
			}
		}
		
		/**
		 * Adds a value
		 */
		private function add(src:String, v:int, e:int):String {
			var i:int, len:int, values:Array;
			values = src.split("");
			len = values.length;
			for(i = 0; i < len; i+=e){
				values[i] = String.fromCharCode(String(values[i]).charCodeAt(0) + v);
			}
			return values.join("");
		}
		
		/**
		 * Substracts a value
		 */
		private function sub(src:String, v:int, e:int):String {
			var i:int, len:int, values:Array;
			values = src.split("");
			len = values.length;
			for(i = 0; i < len; i+=e){
				values[i] = String.fromCharCode(String(values[i]).charCodeAt(0) - v);
			}
			return values.join("");
		}
		
		/**
		 * Shift to the left X times
		 */
		private function sl(src:String, v:int):String {
			var i:int, strlen:Number;
			strlen = src.length;
			if(strlen < 2) return src;
			for(i = 0; i < v; ++i) {
				src = src.substr(1, strlen) + src.substr(0, 1);
			}
			return src;
		}
		
		/**
		 * Shift to the right X times
		 */
		private function sr(src:String, v:int):String {
			var i:int, strlen:Number;
			strlen = src.length;
			if(strlen < 2) return src;
			for(i = 0; i < v; ++i) {
				src = src.substr(strlen-1, 1) + src.substr(0, strlen-1);
			}
			return src;
		}
		
		/**
		 * Permutes each X numbers from left
		 */
		private function pl(src:String, v:int):String {
			var i:int, strlen:Number, chars:Array, tmp:String;
			strlen = src.length - v;
			chars = src.split("");
			if(strlen < 2) return src;
			for(i = 0; i < strlen; i+=v) {
				tmp = chars[i];
				chars[i] = chars[i+v];
				chars[i+v] = tmp;
			}
			return chars.join("");
		}
		
		/**
		 * Permutes each X numbers from right
		 */
		private function pr(src:String, v:int):String {
			var i:int, strlen:Number, chars:Array, tmp:String;
			strlen = Math.floor((src.length-1)/v)*v;
			chars = src.split("");
			if(strlen < 2) return src;
			for(i = strlen; i > 0; i-=v) {
				tmp = chars[i-v];
				chars[i-v] = chars[i];
				chars[i] = tmp;
			}
			return chars.join("");
		}
		
		/**
		 * Converts a latin string to ATL chars.
		 */
		private function latinToATL(src:String):String {
			var i:int, lenI:int, j:int, lenJ:int, k:int, res:String, codeStr:String, code:int;
			lenI = src.length;
			res = "";
			for(i = 0; i < lenI; ++i) {
				//Gets the current char code as a string
				codeStr = src.charCodeAt(i).toString();
				lenJ = codeStr.length;
				//Generate the correspondance of the current char in Atlante char.
				//Let's say the current char is "z".
				//It's char code is 122. The loops will check first if an Atlante char
				//exists in the "chars" array at the index 122. If not it will try with
				//the index 12, and if not with the index 1. Then it will do the same thing
				//with the rest of the car code. Si it will check if char exist at the index
				//22, and if not, at the index 2. And the last char index will be 2.
				//The current char's equivalent will be the concatenation of all the
				//chars fount.
				for(j = 0; j < lenJ;) {
					k = lenJ + 1;
					do {
						k --;
						code = parseInt(codeStr.substring(j, k));
					} while(code > _chars.length - 1 && k > 0);
					j += k-j;
					res += _chars[code];
				}
				if(i < lenI - 1) res += _additionals[Math.floor(code / _chars.length * _additionals.length)];
			}
			return res;
		}
		
		/**
		 * Converts a ATL string to latin chars.
		 */
		private function ATLToLatin(src:String):String {
			var i:int, lenI:int, res:String, reg:String, code:String;
			reg		= "[^" + _chars.join("") + _additionals.join("") + _oldChars.join("") + "]";
			src		= src.replace(/Ω/gi, "Ω");
			src		= src.replace(new RegExp(reg, "gi"), "");
			reg		= "[" + _additionals.join("") + _oldChars.join("") + "]+";
			src		= src.replace(new RegExp(reg, "gi"), "0");
			lenI	= src.length;
			res		= "";
			
			//Loop over all the chars
			var char:String;
			for(i = 0; i < lenI; ++i) {
				char = src.charAt(i);
				if(char == "0") {
					if(i > 0) {
						res += String.fromCharCode(parseInt(code));
						code = "";
					}
				}else{
					code += _charsToIndex[char];
				}
			}
				res += String.fromCharCode(parseInt(code));
			return res;
		}
		
	}
}