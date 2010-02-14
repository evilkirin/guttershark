package net.guttershark.ui.controls.tree
{
	
	import fl.motion.easing.Quadratic;	
	
	import flash.events.MouseEvent;	
	import flash.display.MovieClip;	
	
	import gs.TweenMax;
	
	public class TreeNode extends MovieClip
	{
		
		/**
		 * The level corresponds to the recursion level,
		 * or branch level. 0 being the top most node,
		 * 1 being a child of the top node, etc..
		 */
		private var _level:int;
		
		/**
		 * The renderer for this TreeNode.
		 */
		private var _renderer:TreeNodeRenderer;
		
		/**
		 * Indicates that when this node is toggled, it's siblings
		 * should be collapsed.
		 */
		public var collapseSiblings:Boolean = false;
		
		/**
		 * @private
		 * The next TreeNode, if any.
		 */
		public var next:TreeNode;
		
		/**
		 * @private
		 * The parent TreeNext if any.
		 */
		public var previous:TreeNode;
		
		/**
		 * The index of this TreeNode in the parent nodes
		 * children array.
		 */
		public var index:int;
		
		/**
		 * A locked flag for any tweening, so that the menu
		 * is locked during tweens.
		 */
		private var locked:Boolean;
		
		/**
		 * Flag to keep track of if this node is open.
		 */
		private var isOpen:Boolean;
		
		/**
		 * Children TreeNodes
		 */
		private var children:Array;
		
		/**
		 * A container for children TreeNodes
		 */
		private var childContainer:MovieClip;
		
		/**
		 * THe total height for all children TreeNodes, of this TreeNode.
		 */
		private var childrenHeightTotal:Number;
		
		/**
		 * Constructor for Tree instances.
		 */
		public function TreeNode()
		{
			super();
			children = [];
			childContainer = new MovieClip();
			childrenHeightTotal = 0;
		}
		
		/**
		 * Set's the level that this TreeNode is at.
		 */
		public function set level(index:int):void
		{
			_level = index;
			this.x = _level * 10;
		}
		
		/**
		 * Set's the renderer on this TreeNode.
		 */
		public function set renderer(ni:TreeNodeRenderer):void
		{
			_renderer = ni;
			_renderer.addEventListener(MouseEvent.CLICK,onItemClick);
			_renderer.addEventListener(MouseEvent.MOUSE_OVER,onItemOver);
			addChild(_renderer);
		}
		
		/**
		 * Get the renderer
		 */
		public function get renderer():TreeNodeRenderer
		{
			return _renderer;
		}
		
		/**
		 * @private
		 * Lock this node.. (for tweens)
		 */
		public function lock():void
		{
			locked = true;
			//if(next) next.lock();
		}
		
		/**
		 * @private
		 * Unlock this node.. (for tweens)
		 */
		public function unlock():void
		{
			locked = false;
			//if(previous) previous.unlock();
		}
		
		/**
		 * On mouse over of the renderer
		 */
		private function onItemOver(me:MouseEvent):void
		{
			var nt:String;
			if(children.length < 1) nt = TreeNodeTypes.LEAF;
			else nt = TreeNodeTypes.BRANCH;
			var state:String = isOpen ? TreeNodeStates.OPEN : TreeNodeStates.CLOSED;
			dispatchEvent(new TreeEvent(TreeEvent.OVER,state,nt,_renderer.dataProvider,true,false));
		}
		
		/**
		 * On click of the renderer
		 */
		private function onItemClick(me:MouseEvent):void
		{
			if(locked) return;
			if(collapseSiblings) previous.closeSiblings(index);
			var state:String = isOpen ? TreeNodeStates.CLOSED : TreeNodeStates.OPEN;
			var nt:String = (children.length < 1) ? TreeNodeTypes.LEAF : TreeNodeTypes.BRANCH;
			dispatchEvent(new TreeEvent(TreeEvent.SELECT,state,nt,_renderer.dataProvider,true,false));
			if(children.length < 1) return;
			if(!isOpen) openChildren(childrenHeightTotal);
			else if(isOpen) closeChildren();
		}
		
		/**
		 * @private
		 * 
		 * The logic that moves this node, up to the top root node
		 * items down, that creates space for this nodes children
		 * when opened.
		 */
		public function moveDown(amount:Number, inx:int):void
		{
			if(previous) previous.moveDown(amount, index);
			if(inx >= children.length) return;
			lock();
			for(var i:int = (inx+1); i < children.length; i++)
			{
				if(i == children.length-1) TweenMax.to(children[i],.2,{y:amount.toString(),ease:Quadratic.easeOut,onComplete:unlock});
				else TweenMax.to(children[i],.2,{y:amount.toString(),ease:Quadratic.easeOut});
			}
		}
		
		/**
		 * Open this nodes children.
		 */
		public function openChildren(amount:Number):void
		{
			isOpen = true;
			if(!contains(childContainer)) addChild(childContainer);
			if(previous) previous.moveDown(amount,index);
			var prevItem:TreeNode = null;
			var delay:int = .8;
			lock();
			for(var i:int = 0; i < children.length; i++)
			{
				if(prevItem != null) children[i].y = prevItem.y + prevItem.height;
				else children[i].y = _renderer.height;
				children[i].alpha = 0;
				if(i == (children.length - 1)) TweenMax.to(children[i],.3,{delay:(i * .07),autoAlpha:1,ease:Quadratic.easeOut,onComplete:unlock});
				else TweenMax.to(children[i],.3,{delay:(i * .07),autoAlpha:1,ease:Quadratic.easeOut});
				prevItem = children[i];
				delay += .9;
			}
		}
		
		/**
		 * @private
		 * 
		 * The logic that closes this child, and all of it's children
		 * if opened.
		 */
		public function moveUp(inx:int):void
		{
			var prevItem:TreeNode = children[inx];
			for(var i:int = inx; i < children.length; i++)
			{
				var hm:Number = (i == inx) ? prevItem.y : (prevItem.y + prevItem.height);
				children[i].y = hm;
				prevItem = children[i];
			}
			if(previous) previous.moveUp(index);
		}
		
		/**
		 * Closes this nodes children.
		 */
		public function closeChildren():void
		{
			if(children.length < 1) return;
			if(!isOpen) return;
			isOpen = false;
			lock();
			for(var i:int = children.length-1; i >= 0; i--)
			{
				children[i].closeChildren();
				children[i].visible = false;
			}
			unlock();
			if(contains(childContainer)) removeChild(childContainer);
			if(previous) previous.moveUp(index);
		}
		
		/**
		 * Close this nodes sibling children.
		 */
		public function closeSiblings(inx:int):void
		{
			for(var i:int = 0; i < children.length; i++)
			{
				if(i == inx) continue;
				else children[i].closeChildren();
			}
		}
		
		/**
		 * Add a TreeNode to this TreeNode.
		 */
		public function addTreeNode(treeNode:TreeNode):void
		{
			if(!contains(childContainer)) addChild(childContainer);
			treeNode.index = children.length;
			children.push(treeNode);
			if(!previous) treeNode.y = this.height + this.y; //top level nodes.
			else treeNode.visible = false; //all other nodes.
			childrenHeightTotal += treeNode.height;
			childContainer.addChild(treeNode);
		}	}}