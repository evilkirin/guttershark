package net.guttershark.util 
{
	public class RandomArrayElement 
	{
		
		private var ar:Array;
		private var usd:Array;
		
		public function RandomArrayElement(array:Array)
		{
			ar = array;
			ArrayUtils.Shuffle(ar);
			usd = new Array();
		}
		
		public function getRandomElement():*
		{
			if(ar.length == 0)
			{
				ar = usd;
				ArrayUtils.Shuffle(ar);
				usd = new Array();
			}
			var el:* = ar.shift();
			usd.push(el);
			return el;
		}	}}