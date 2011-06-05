package com.muxxu.kube.vo {	import com.muxxu.kube.data.SharedObjectManager;	import com.muxxu.kube.utils.HTTPPath;	import flash.geom.Point;	/**	 * Contains the data about a gallery item.	 * 	 * @author  Francois	 */	public class GalleryItem {		private var _id:String;		private var _name:String;		private var _author:String;		private var _zone:Point;		private var _type:int;		private var _image:String;		private var _oldWorld:String;		private var _total:int;		private var _votes:int;		private var _index:int;		private var _icon:*;		private var _loadedItems:int;
								/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>GalleryItem</code>.		 */		public function GalleryItem(data:XML, index:int, loadedItems:int) {			_index	= index;			_loadedItems = loadedItems;			_id		= data.child("id")[0];			_image	= data.child("image")[0];			_icon	= data.child("icon")[0];			_type	= data.child("type")[0];			_author	= data.child("author")[0];			_name	= data.child("name")[0];			_total	= parseInt(data.child("total")[0]);			_votes	= parseInt(data.child("votes")[0]);						var parts:Array = String(data.child("zone")[0]).split(";");			_zone	= new Point(parseInt(parts[0]), parseInt(parts[1]));			_oldWorld= data.child("oldWorld")[0];		}						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */				/**		 * Gets the item's index.		 */		public function get index():int { return _index; }				/**		 * Gets the number of items loaded.		 */		public function get loadedItems():int { return _loadedItems; }		/**		 * Gets the image's id.		 */		public function get id():String { return _id; }				/**		 * Gets the image's type.		 */		public function get type():int { return _type; }				/**		 * Gets the image's zone.		 */		public function get zone():Point { return _zone; }				/**		 * Gets the image's author.		 */		public function get author():String { return _author; }				/**		 * Gets the image's name.		 */		public function get name():String { return _name; }				/**		 * Gets the image's URL.		 */		public function get image():String { return HTTPPath.getPath("galleryImages") + _image; }				/**		 * Gets the icon's URL.		 */		public function get icon():String { return HTTPPath.getPath("galleryIcons") + _icon; }		/**		 * Gets the old world's index.		 */		public function get oldWorld():String { return _oldWorld; }				/**		 * Gets the total of points.		 */		public function get total():int { return _total; }				/**		 * Gets the total of votes.		 */		public function get votes():int { return _votes; }				/**		 * Gets if the user can vote for this entry.		 */		public function get canVoteFor():Boolean { return SharedObjectManager.getInstance().canVote(id); }		/* ****** *		 * PUBLIC *		 * ****** */		/**		 * Registers a vote to update the valueObject.		 */		public function registerVote(value:int):void {			_votes++;			_total += value;			SharedObjectManager.getInstance().vote(_id);		}						/* ******* *		 * PRIVATE *		 * ******* */			}}