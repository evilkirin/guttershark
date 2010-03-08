package 
{
	import gs.display.Scale3Clip;
	import flash.display.MovieClip;

	public class Main extends MovieClip
	{
		
		public var scale3Clip:Scale3Clip; //setup manually in flash IDE.
		
		public var left:MovieClip;
		public var right:MovieClip;
		public var mid:MovieClip;
		public var s3:Scale3Clip;
		
		public function Main()
		{
			s3=new Scale3Clip(); //dynamically create a new one
			s3.setRefs(left,mid,right);
			s3.width=200;
			s3.x=10;
			s3.y=10;
			s3.height=100;
			
			scale3Clip.width=100;
		}
	}
}