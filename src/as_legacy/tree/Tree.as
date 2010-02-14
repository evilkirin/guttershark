package net.guttershark.ui.controls.tree
{

	import flash.display.MovieClip;
	
	import net.guttershark.core.IDataProviderConsumer;
	import net.guttershark.util.FlashLibrary;
	
	public class Tree extends MovieClip implements IDataProviderConsumer
	{

		private var _dataProvider:*;
		
		private var rootTreeNode:TreeNode;
		
		private var defaultTreeRenderer:String;

		public function Tree()
		{
			super();
			rootTreeNode = new TreeNode();
			addChild(rootTreeNode);
		}

		public function set dataProvider(data:*):void
		{
			_dataProvider = data;
			if(data.@renderer == undefined) throw new Error("You must define the 'renderer' attribute on the root node.");
			defaultTreeRenderer = data.@renderer;
			createTree(rootTreeNode,new XMLList(_dataProvider),0);
		}
		
		public function get dataProvider():*
		{
			return _dataProvider;
		}
		
		private function createTree(holder:TreeNode, xml:XMLList, level:int):TreeNode
		{
			for each(var item:XML in xml)
			{
				//skip this item if it is a "data" item, it was already used
				//in the previous recursion call.
				if(item.name() == "data") continue;
				
				//create node
				var tn:TreeNode = new TreeNode();
				tn.previous = holder;
				tn.level = level;
				if(item.@collapseSiblings == "true") tn.collapseSiblings = true;
				
				//create renderer for this tree node
				var renderer:TreeNodeRenderer;
				if(item.@renderer == undefined) renderer = FlashLibrary.GetMovieClip(defaultTreeRenderer) as TreeNodeRenderer;
				else renderer = FlashLibrary.GetMovieClip(item.@renderer) as TreeNodeRenderer;
				if(item.data != undefined) renderer.dataProvider = item.data;
				tn.renderer = renderer;
				
				level++;
				var recurse:Boolean = (item.node != undefined) ? true : false;
				if(recurse)
				{
					var n:TreeNode = createTree(tn, item.children(), level);
					if(!holder.next) holder.next = n;
				}
				level--;
				holder.addTreeNode(tn);
			}
			return holder;
		}	}}