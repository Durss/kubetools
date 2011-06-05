package com.muxxu.kube.crypto {
	import com.muxxu.kube.crypto.events.ATLEvent;
	import com.nurun.utils.crypto.XOR;

	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;

	[Event(name="encryptProgress", type="com.muxxu.kube.crypto.events.ATLEvent")]
	[Event(name="encryptComplete", type="com.muxxu.kube.crypto.events.ATLEvent")]
	[Event(name="decryptProgress", type="com.muxxu.kube.crypto.events.ATLEvent")]
	[Event(name="decryptComplete", type="com.muxxu.kube.crypto.events.ATLEvent")]

	/**
	 * Provides methods to encrypt and decrypt strings.
	 * 
	 * @author Francois
	 */
	public class AMK2 extends EventDispatcher {
		
		private var _chars:Array = ["─", "━", "│", "┃", "┄", "┅", "┆", "┇", "┈", "┉", "┊", "┋", "┌", "┍", "┎", "┏", "┐", "┑", "┒", "┓", "└", "┕", "┖", "┗", "┘", "┙", "┚", "┛", "├", "┝", "┞", "┟", "┠", "┡", "┢", "┣", "┤", "┥", "┦", "┧", "┨", "┩", "┪", "┫", "┬", "┭", "┯", "┮", "┰", "┱", "┲", "┳", "┵", "┶", "┷", "┸", "┹", "┺", "┻", "┼", "┽", "┾", "┿", "╀", "╁", "╂", "╃", "╄", "╌", "╍", "╎", "╏", "═", "║", "╒", "╓", "╔", "╕", "╖", "╗", "╘", "╙", "╚", "╛", "╜", "╝", "╞", "╟", "╠", "╡", "╢", "╣", "╤", "╥", "╦", "╧", "╨", "╩", "╪", "╫", "╬", "☰", "☱", "☲", "☳", "☴", "☵", "☶", "☷", "▲", "△", "▴", "▵", "▶", "▷", "▸", "▹", "►", "▻", "▼", "▽", "▾", "▿", "◀", "◁", "◂", "◃", "◄", "◅"];
		private var _additionals:Array = ["╅", "╆", "╇", "╈", "╉", "╊", "╋"];
		private var _charsToIndex:Array = [];
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>AMK2</code>.
		 */
		public function AMK2() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Encrypts an latin string into an AMK2 string.
		 * 
		 * @param str	string to encrypt.
		 * @param key	encryption key
		 * 
		 * @return void.
		 */
		public function encrypt(str:String, key:String):void {
			var i:int, len:int;
			len = _chars.length;
			for(i = 0; i < len; ++i) {
				_charsToIndex[_chars[i]] = i;
			}
			var ba:ByteArray = new ByteArray();
			ba.writeUTF(str);
			ba.deflate();
			XOR(ba, key);
			dispatchEvent(new ATLEvent(ATLEvent.ENCRYPT_COMPLETE, strToAMK(convertToString(ba))));
		}
		
		/**
		 * Decrypts an AMK2 encoded string.
		 * 
		 * @param str	string to decrypt.
		 * @param key	encryption key
		 * 
		 * @return void.
		 */
		public function decrypt(str:String, key:String):void {
			try {
				var ba:ByteArray = convertToByteArray(AMKoStr(str));
				XOR(ba, key);
				ba.inflate();
				ba.position = 0;
			}catch(error:Error) {
				dispatchEvent(new ATLEvent(ATLEvent.DECRYPT_COMPLETE, "???"));
				return;
			}
			dispatchEvent(new ATLEvent(ATLEvent.DECRYPT_COMPLETE, ba.readUTF()));
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initializes the class.
		 */
		private function initialize():void {
			var i:int, len:int, chars:Array;
			chars = _chars.concat(_additionals);
			len = chars.length;
			for(i = 0; i < len; ++i) {
				if(_charsToIndex[chars[i]] != null) {
					trace("DOUBLON :: " + _chars[i] + " at index " + i);
				}
				_charsToIndex[_chars[i]] = i;
			}
		}
		
		/**
		 * Converts a ByteArray to a string of char codes. 
		 */
		private function convertToString(ba:ByteArray):String {
			var i:int, len:int, ret:String;
			len = ba.length;
			ret = "";
			ba.position = 0;
			for(i = 0; i < len; ++i) {
				ret += ba.readUnsignedByte().toString(10);
				if(i<len-1) ret += "_";
			}
			return ret;
		}
		
		/**
		 * Converts a string of char codes to a ByteArray.
		 */
		private function convertToByteArray(src:String):ByteArray {
			var i:int, len:int, ret:ByteArray, codes:Array;
			codes = src.split("_");
			len = codes.length;
			ret = new ByteArray();
			for(i = 0; i < len; ++i) {
				ret[i] = codes[i];
			}
			return ret;
		}
		
		
		/**
		 * Converts a latin string to AMK2 chars.
		 */
		private function strToAMK(src:String):String {
			var i:int, lenI:int, lenJ:int, j:int, k:int, res:String, chars:Array, code:int, codeStr:String;
			chars = src.split("_");
			lenI = chars.length;
			res = "";
			for(i = 0; i < lenI; ++i) {
				//Gets the current char code
				codeStr = chars[i];
				lenJ = codeStr.length;
				//Generate the correspondance of the current char in AMK char.
				//Let's say the current char is "z".
				//It's char code is 122. The loops will check first if an AMK char
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
				if(i < lenI - 1) res += _additionals[Math.floor(Math.random() * _additionals.length)];
			}
			return res;
		}
		
		/**
		 * Converts an AMK string to latin chars.
		 */
		private function AMKoStr(src:String):String {
			var i:int, lenI:int, res:String, reg:String, char:String;
			reg		= "[^" + _chars.join("") + _additionals.join("") + "]";
			src		= src.replace(/Ω/gi, "Ω");
			src		= src.replace(new RegExp(reg, "gi"), "");
			reg		= "[" + _additionals.join("") + "]+";
			src		= src.replace(new RegExp(reg, "gi"), "_");
			lenI	= src.length;
			res		= "";
			
			//Loop over all the chars
			for(i = 0; i < lenI; ++i) {
				char = src.charAt(i);
				if(char == "_") {
					res += "_";
				}else{
					res += _charsToIndex[char];
				}
			}
			return res;
		}
		
	}
}