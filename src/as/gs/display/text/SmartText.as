package gs.display.text 
{
	import gs.util.BitmapUtils;
	import gs.util.FontUtils;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.Font;
	import flash.text.TextField;
	
	/**
	 * The SmartText class contains a text field and
	 * manages using embedded fonts or bitmapping the
	 * text field after rendering system fonts.
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class SmartText extends Sprite
	{
		
		/**
		 * The text field.
		 */
		public var field:TextField;
		
		/**
		 * Whether or not the bitmapped version is
		 * shown.
		 */
		public var isBitmapped:Boolean;
		
		/**
		 * bitmap.
		 */
		private var bmp:Bitmap;
		
		/**
		 * Constructor for SmartText instances.
		 * 
		 * @param field The text field.
		 */
		public function SmartText(_field:TextField=null)
		{
			if(!_field)return;
			this.field=_field;
			this.x=field.x;
			this.y=field.y;
			field.x=0;
			field.y=0;
			addChild(field);
		}
		
		/**
		 * @private
		 */
		public function testBitmap():void
		{
			addBitmap();
		}
		
		/**
		 * Text value.
		 * 
		 * <p>Use this method to set the text on the text field. If
		 * the text can't be displayed in the text field because of
		 * missing glyphs, then the textfield is rendered with system
		 * fonts, and bitmapped. The bitmapped display object is added
		 * to the display list, and the text field is removed. They
		 * will the two will swap depending on if the text can
		 * be displayed in the text field.</p>
		 */
		public function set text(val:String):void
		{
			if(field.text==val)return;
			if(!field)
			{
				trace("WARNING: SmartText instance's field property is null, not doing anything.");
				return;
			}
			var f:Font=FontUtils.getFontFromTextFormat(field.defaultTextFormat);
			if(!f || !f.hasGlyphs(val))
			{
				field.embedFonts=false;
				field.text=val;
				addBitmap();
			}
			else
			{
				field.embedFonts=true;
				field.text=val;
				removeBitmap();
			}
		}
		
		/**
		 * Text value.
		 * 
		 * <p>Use this method to set the text on the text field. If
		 * the text can't be displayed in the text field because of
		 * missing glyphs, then the textfield is rendered with system
		 * fonts, and bitmapped. The bitmapped display object is added
		 * to the display list, and the text field is removed. The
		 * two will swap depending on if the text can be displayed in
		 * the text field.</p>
		 */
		public function get text():String
		{
			return field.text;
		}
		
		/**
		 * Removes the bitmap and shows the text field.
		 */
		private function removeBitmap():void
		{
			if(bmp)removeChild(bmp);
			field.x=0;
			field.y=0;
			addChild(field);
			isBitmapped=false;
		}
		
		/**
		 * Removes the label and shows the bitmap.
		 */
		private function addBitmap():void
		{
			bmp=BitmapUtils.bitmapDisplayObject(field);
			bmp.x=0;
			bmp.y=0;
			addChild(bmp);
			removeChild(field);
			isBitmapped=true;
		}
	}
}