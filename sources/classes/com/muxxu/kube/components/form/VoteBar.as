package com.muxxu.kube.components.form {	import com.muxxu.kube.components.tooltip.content.TTTextContent;	import com.muxxu.kube.controler.FrontControler;	import com.muxxu.kube.events.VoteBarEvent;	import com.muxxu.kube.graphics.VoteStar;	import com.muxxu.kube.vo.GalleryItem;	import com.muxxu.kube.vo.ToolTipMessage;	import com.nurun.components.text.CssTextField;	import com.nurun.structure.environnement.label.Label;	import flash.display.Shape;	import flash.display.Sprite;	import flash.events.MouseEvent;	import flash.filters.ColorMatrixFilter;	/**	 * Displays a vote bar.<br>	 * <br>	 * A vote bar is composed of 5 stars where the user can select a note.	 * 	 * @author  Francois	 */	public class VoteBar extends Sprite {				private var _selectedBar:Shape;		private var _totalBar:Shape;		private var _mask:Shape;		private var _total:int;		private var _votes:int;		private var _ttContent:TTTextContent;		private var _id:String;		private var _totalVotes:CssTextField;		private var _data:GalleryItem;
						/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>VoteBar</code>.		 */		public function VoteBar() {			initialize();		}						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */						/* ****** *		 * PUBLIC *		 * ****** */		/**		 * Populate the vote bar.		 */		public function populate(data:GalleryItem):void {			_data = data;			_id = data.id;			_total	= data.total;			_votes	= data.votes;			_totalVotes.text = Label.getLabel("galleryVoteTotal").replace(/\$\{nbr\}/gi, data.votes);			mouseEnabled = data.canVoteFor;			renderBar();		}								/* ******* *		 * PRIVATE *		 * ******* */		/**		 * Initializes the class.		 */		private function initialize():void {			var margin:int	= 6;			_ttContent		= new TTTextContent(false);			_totalBar		= addChild(new Shape()) as Shape;			_selectedBar	= addChild(new Shape()) as Shape;			_mask			= addChild(new Shape()) as Shape;			_totalVotes		= addChild(new CssTextField("voteLabel")) as CssTextField;						var star:VoteStar = new VoteStar(11,11);			_selectedBar.graphics.beginBitmapFill(star);			_selectedBar.graphics.drawRect(0, 0, 55, 11);						_totalBar.graphics.beginBitmapFill(star);			_totalBar.graphics.drawRect(0, 0, 55, 11);						_mask.graphics.beginFill(0xFF0000,0);			_mask.graphics.drawRect(0, 0, 55, 11);			_mask.scaleX = 0;						graphics.beginFill(0,0);			graphics.drawRect(0, 0, _selectedBar.width + margin * 2, _selectedBar.height + margin * 2);						buttonMode			= true;			mouseChildren		= false;			_selectedBar.x		= margin;			_selectedBar.y		= margin;			_totalBar.x			= margin;			_totalBar.y			= margin;			_mask.x				= margin;			_mask.y				= margin;			_selectedBar.mask	= _mask;			_totalBar.alpha		= .25;			_totalVotes.x		= Math.round(_selectedBar.width + 10);			_totalVotes.y		= Math.round((_selectedBar.height - _totalVotes.height) * .5 - 1);						addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);		}				/**		 * Renders the bar in function of the votes and total points.		 */		private function renderBar():void {			var m:Array;			if(_votes == 0){				_mask.scaleX	= 0;				m				= [	0.3086, 0.6094, 0.0820, 0, 0,									0.3086, 0.6094, 0.0820, 0, 0,									0.3086, 0.6094, 0.0820, 0, 0,									0, 0, 0, 1, 0];				_totalBar.filters = [new ColorMatrixFilter(m)];				_selectedBar.filters = [new ColorMatrixFilter(m)];			}else {				if(!mouseEnabled){					m			= [	1, 1, 1, 0, 0,										0.3086, 0.6094, 0.0820, 0, 0,										0.3086, 0.6094, 0.0820, 0, 0,										0, 0, 0, 1, 0];					_totalBar.filters = [new ColorMatrixFilter(m)];					_selectedBar.filters = [new ColorMatrixFilter(m)];				}else{					_totalBar.filters = [];					_selectedBar.filters = [];				}				_mask.scaleX	= _total / _votes * .01;			}					}		/**		 * Called when the component is rolled over.		 */		private function rollOverHandler(e:MouseEvent):void {			addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);			addEventListener(MouseEvent.CLICK, clickHandler);			FrontControler.getInstance().openToolTip(new ToolTipMessage(_ttContent, this));			mouseMoveHandler(e);		}		/**		 * Called when the component is rolled out.		 */		private function rollOutHandler(e:MouseEvent):void {			removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);			removeEventListener(MouseEvent.CLICK, clickHandler);			renderBar();//reset to old state.		}				/**		 * Called when moves over the component.		 */		private function mouseMoveHandler(e:MouseEvent):void {			var scale:Number = Math.round((mouseX - _selectedBar.x) / _selectedBar.width * 10) / 10;			_mask.scaleX = Math.max(0, Math.min(1, scale));			_ttContent.populate(Math.round(_mask.scaleX * 10)+"/10", "tooltipContentCenter", 40);			_selectedBar.filters = [];			_totalBar.filters = [];		}				/**		 * Called when the component is clicked.		 */		private function clickHandler(e:MouseEvent):void {			var value:int = Math.round(_mask.scaleX * 100);			mouseEnabled = false;			_total = _total + value;			_votes = _votes + 1;			_data.registerVote(value);			populate(_data);			dispatchEvent(new VoteBarEvent(VoteBarEvent.VOTE, value, _id));		}	}}