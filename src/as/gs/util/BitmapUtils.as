package gs.util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	/**
	 * The BitmapUtils class contains utility methods for
	 * common bitmap operations.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class BitmapUtils
	{
		
		/**
		 * Copy a Bitmap.
		 * 
		 * @example Copying a bitmap.
		 * <listing>	
		 * import gs.util.BitmapUtils;
		 * var bmd:BitmapData=new BitmapData(50,50,false,0xFF0066);
		 * var bitmap1:Bitmap=new Bitmap(bmd);
		 * addChild(bitmap1);
		 * var bitmap2:Bitmap=BitmapUtils.CopyBitmap(bitmap1);
		 * bitmap2.x=100;
		 * bitmap2.y=100;
		 * addChild(bitmap2);
		 * </listing>
		 * 
		 * @param bitmapToCopy The bitmap to copy.
		 */
		public static function copyBitmap(bitmapToCopy:Bitmap):Bitmap
		{
			if(!bitmapToCopy) throw new ArgumentError("Parameter bitmapToCopy cannot be null");
			var b:Bitmap=new Bitmap(bitmapToCopy.bitmapData);
			return b;
		}
		
		/**
		 * Create a bitmap from a display object.
		 * 
		 * @param obj The object to bitmap.
		 */
		public static function bitmapDisplayObject(obj:DisplayObject):Bitmap
		{
			var bmpd:BitmapData = new BitmapData(obj.width,obj.height,true,0xff0000);
			bmpd.draw(obj);
			var bmp:Bitmap=new Bitmap(bmpd);
			bmp.smoothing=true;
			bmp.x=obj.x;
			bmp.y=obj.y;
			return bmp;
		}
		
		/**
		 * Draw a line into a bitmap data.
		 * 
		 * @param bmp bitmap to draw (alpha=true).
		 * @param x0 first point x coord.
		 * @param y0 first point y coord.
		 * @param x1 second point x coord.
		 * @param y1 second point y coord.
		 * @param c color (0xaarrggbb).
		 */
		public static function line(bmp:BitmapData, x0:int, y0:int, x1:int, y1:int, c:Number):void 
		{
			var dx:int;
			var dy:int;
			var i:int;
			var xinc:int;
			var yinc:int;
			var cumul:int;
			var x:int;
			var y:int;
			x=x0;
			y=y0;
			dx=x1 - x0;
			dy=y1 - y0;
			xinc=( dx > 0 ) ? 1 : -1;
			yinc=( dy > 0 ) ? 1 : -1;
			dx=Math.abs(dx);
			dy=Math.abs(dy);
			bmp.setPixel32(x,y,c);
			if(dx > dy)
			{
				cumul=dx / 2 ;
				for( i=1 ;i <= dx; i++ ) 
				{
					x += xinc;
					cumul += dy;
					if(cumul >= dx) 
					{
						cumul -= dx;
						y += yinc;
					}
					bmp.setPixel32(x,y,c);
				}
			}
			else 
			{
				cumul=dy / 2;
				i=1;
				for(;i<=dy;i++)
				{
					y += yinc;
					cumul += dx;
					if(cumul >= dy) 
					{
						cumul -= dy;
						x += xinc ;
					}
					bmp.setPixel32(x,y,c);
				}
			}
		}

		/**
		 * Draw a triangle into a bitmap data.
		 * 
		 * @param bmp Bitmap to draw into.
		 * @param x0 First point x coord.
		 * @param y0 First point y coord. 
		 * @param x1 Second point x coord.
		 * @param y1 Second point y coord.
		 * @param x2 Third point x coord.
		 * @param y2 Third point y coord.
		 * @param c Color (0xaarrggbb).
		 */
		public static function triangle(bmp:BitmapData, x0:int, y0:int, x1:int, y1:int, x2:int, y2:int, c:Number):void 
		{
			line(bmp,x0,y0,x1,y1,c);
			line(bmp,x1,y1,x2,y2,c);
			line(bmp,x2,y2,x0,y0,c);
		}

		/**
		 * Draw a filled triangle into a bitmap data.
		 * 
		 * @param bmp Bitmap to draw.
		 * @param x0 First point x coord.
		 * @param y0 First point y coord. 
		 * @param x1 Second point x coord.
		 * @param y1 Second point y coord.
		 * @param x2 Third point x coord.
		 * @param y2 Third point y coord.
		 * @param c Color (0xaarrggbb)
		 */
		public static function filledTri(bmp:BitmapData, x0:int, y0:int, x1:int, y1:int, x2:int, y2:int, c:Number):void 
		{
			var o:Object={};
			lineTri(o,bmp,x0,y0,x1,y1,c);
			lineTri(o,bmp,x1,y1,x2,y2,c);
			lineTri(o,bmp,x2,y2,x0,y0,c);
		}

		/**
		 * Draw a circle into a bitmap data.
		 * 
		 * @param bmp Bitmap to draw (alpha=true).
		 * @param px First point x coord.
		 * @param py First point y coord.
		 * @param r Radius.
		 * @param c Color (0xaarrvvbb).
		 */
		public static function circle(bmp:BitmapData, px:int, py:int, r:int, c:Number):void 
		{
			var x:int;
			var y:int;
			var d:int;
			x=0; y=r; d=1 - r;
			bmp.setPixel32(px + x,py + y,c);
			bmp.setPixel32(px + x,py - y,c);
			bmp.setPixel32(px - y,py + x,c);
			bmp.setPixel32(px + y,py + x,c);
			while(y>x) 
			{
				if(d<0)d+=2*x+3;	
				else 
				{
					d += 2 * (x - y) + 5;
					y--;
				}
				x++;
				bmp.setPixel32(px + x,py + y,c);
				bmp.setPixel32(px - x,py + y,c);
				bmp.setPixel32(px + x,py - y,c);
				bmp.setPixel32(px - x,py - y,c);
				bmp.setPixel32(px - y,py + x,c);
				bmp.setPixel32(px - y,py - x,c);
				bmp.setPixel32(px + y,py - x,c);
				bmp.setPixel32(px + y,py + x,c);
			}
		}

		/**
		 * Draw an anti-aliased circle into a bitmap data.
		 * 
		 * @param bmp Bitmap to draw (alpha=true).
		 * @param px First point x coord.
		 * @param py First point y coord. 
		 * @param r Radius.
		 * @param c Color (0xaarrggbb).
		 */
		public static function aaCircle(bmp:BitmapData, px:Number, py:Number, r:int, c:Number):void 
		{
			var vx:int;
			var vy:int;
			vx=r; vy=0;
			var t:Number=0;
			var dry:Number;
			var _sqrt:Function=Math.sqrt;
			var _ceil:Function=Math.ceil;
			bmp.setPixel(px + vx,py + vy,c);
			bmp.setPixel(px - vx,py + vy,c);
			bmp.setPixel(px + vy,py + vx,c);
			bmp.setPixel(px + vy,py - vx,c);
			while ( vx > vy + 1 ) 
			{
				vy++;
				dry=_ceil(_sqrt(r * r - vy * vy)) - _sqrt(r * r - vy * vy);
				if (dry < t) vx--;
				drawAlphaPixel(bmp,px + vx,py + vy,1 - dry,c);
				drawAlphaPixel(bmp,px + vx - 1,py + vy,dry,c);
				drawAlphaPixel(bmp,px - vx,py + vy,1 - dry,c);
				drawAlphaPixel(bmp,px - vx + 1,py + vy,dry,c);
				drawAlphaPixel(bmp,px + vx,py - vy,1 - dry,c);
				drawAlphaPixel(bmp,px + vx - 1,py - vy,dry,c);
				drawAlphaPixel(bmp,px - vx,py - vy,1 - dry,c);
				drawAlphaPixel(bmp,px - vx + 1,py - vy,dry,c);
				drawAlphaPixel(bmp,px + vy,py + vx,1 - dry,c);
				drawAlphaPixel(bmp,px + vy,py + vx - 1,dry,c);
				drawAlphaPixel(bmp,px - vy,py + vx,1 - dry,c);
				drawAlphaPixel(bmp,px - vy,py + vx - 1,dry,c);
				drawAlphaPixel(bmp,px + vy,py - vx,1 - dry,c);
				drawAlphaPixel(bmp,px + vy,py - vx + 1,dry,c);
				drawAlphaPixel(bmp,px - vy,py - vx,1 - dry,c);
				drawAlphaPixel(bmp,px - vy,py - vx + 1,dry,c);
				t=dry;
			}
		}

		/**
		 * Draw an anti-aliased line into a bitmap data.
		 * 
		 * @param bmp Bitmap to draw (alpha=true).
		 * @param x0 First point x coord.
		 * @param y0 First point y coord.
		 * @param x1 Second point x coord.
		 * @param y1 Second point y coord.
		 * @param c Color (0xaarrggbb).
		 */
		public static function aaLine(bmp:BitmapData, x1:int, y1:int, x2:int, y2:int, c:Number):void 
		{	
			var steep:Boolean=Math.abs(y2 - y1) > Math.abs(x2 - x1);
			var swap:int;
			if(steep) 
			{
				swap=x1; 
				x1=y1; 
				y1=swap;
				swap=x2; 
				x2=y2; 
				y2=swap;
			}
			if(x1>x2) 
			{
				swap=x1; 
				x1=x2; 
				x2=swap;
				swap=y1; 
				y1=y2; 
				y2=swap;
			}
			var dx:int=x2 - x1;
			var dy:int=y2 - y1;
			var gradient:Number=dy / dx;
			var xend:int=x1;
			var yend:Number=y1 + gradient * (xend - x1);
			var xgap:Number=1 - ((x1 + 0.5) % 1);
			var xpx1:int=xend;
			//var ypx1 : int=Math.floor( yend );
			var alpha:Number;
			alpha=(1 - ((yend) % 1)) * xgap;
			//if (steep) //drawAlphaPixel(bmp,ypx1,xpx1,alpha,c);
			//else //drawAlphaPixel(bmp,xpx1, ypx1,alpha,c);
			alpha=((yend) % 1) * xgap;
			//if (steep) //drawAlphaPixel(bmp,ypx1+1,xpx1,alpha,c);
			//else //drawAlphaPixel(bmp,xpx1, ypx1+1,alpha,c);
			var intery:Number=yend + gradient;
			xend=x2;
			yend=y2 + gradient * (xend - x2);
			xgap=(x2 + 0.5) % 1;
			var xpx2:int=xend; 
			var ypx2:int=Math.floor(yend);
			alpha=(1 - ((yend) % 1)) * xgap;
			if(steep) drawAlphaPixel(bmp,ypx2,xpx2,alpha,c);
			else drawAlphaPixel(bmp,xpx2,ypx2,alpha,c);
			alpha=((yend) % 1) * xgap;
			if (steep) drawAlphaPixel(bmp,ypx2 + 1,xpx2,alpha,c);
			else drawAlphaPixel(bmp,xpx2,ypx2 + 1,alpha,c);
			var x:int=xpx1;
			while (x++ < xpx2) 
			{
				alpha=1 - ((intery) % 1);
				if (steep) drawAlphaPixel(bmp,intery,x,alpha,c);
				else drawAlphaPixel(bmp,x,intery,alpha,c);
				alpha=intery % 1;
				if (steep) drawAlphaPixel(bmp,intery + 1,x,alpha,c);
				else drawAlphaPixel(bmp,x,intery + 1,alpha,c);
				intery=intery + gradient;
			}
		}

		/**
		 * Draws a Quadratic Bezier Curve (equivalent to a DisplayObject's graphics#curveTo).
		 * 
		 * @param bmp BimtapData to draw on (alpha set to true).
		 * @param x0 x position of first anchor.
		 * @param y0 y position of first anchor.
		 * @param x1 x position of control point.
		 * @param y1 y position of control point.
		 * @param x2 x position of second anchor.
		 * @param y2 y position of second anchor.
		 * @param c color
		 * @param resolution determines the accuracy of the curve's length (higher number=greater accuracy=longer process)
		 * */
		public static function quadBezier(bmp:BitmapData,x0:int,y0:int,x1:int,y1:int,x2:int,y2:int,c:Number,resolution:int=3):void 
		{
			var ox:Number=x0;
			var oy:Number=y0;
			var px:int;
			var py:int;
			var dist:Number=0;
			var inverse:Number=1 / resolution;
			var interval:Number;
			var intervalSq:Number;
			var diff:Number;
			var diffSq:Number;
			var i:int=0;
			while( ++i <= resolution ) 
			{
				interval=inverse * i;
				intervalSq=interval * interval;
				diff=1 - interval;
				diffSq=diff * diff;
				px=diffSq * x0 + 2 * interval * diff * x1 + intervalSq * x2;
				py=diffSq * y0 + 2 * interval * diff * y1 + intervalSq * y2;
				dist += Math.sqrt(( px - ox ) * ( px - ox ) + ( py - oy ) * ( py - oy ));
				ox=px;
				oy=py;
			}
			//approximates the length of the curve
			var curveLength:int=Math.floor(dist);
			inverse=1 / curveLength;
			var lastx:int=x0;
			var lasty:int=y0;
			i=-1;
			while( ++i <= curveLength ) 
			{
				interval=inverse * i;
				intervalSq=interval * interval;
				diff=1 - interval;
				diffSq=diff * diff;
				px=diffSq * x0 + 2 * interval * diff * x1 + intervalSq * x2;
				py=diffSq * y0 + 2 * interval * diff * y1 + intervalSq * y2;
				line(bmp,lastx,lasty,px,py,c);
				lastx=px;
				lasty=py;
			}
		}

		/**
		 * Draws a Cubic Bezier Curve into a bitmap data.
		 * 
		 * @param bmp BitmapData to draw on (alpha set to true).
		 * @param x0 x position of first anchor.
		 * @param y0 y position of first anchor.
		 * @param x1 x position of control point.
		 * @param y1 y position of control point.
		 * @param x2 x position of second control point.
		 * @param y2 y position of second control point.
		 * @param x3 x position of second anchor.
		 * @param y3 y position of second anchor.
		 * @param c color.
		 * @param resolution determines the accuracy of the curve's length (higher number=greater accuracy=longer process)
		 */
		public static function cubicBezier( bmp:BitmapData, x0:int, y0:int, x1:int, y1:int, x2:int, y2:int, x3:int, y3:int, c:Number, resolution:int=5 ):void 
		{
			var ox:Number=x0;
			var oy:Number=y0;
			var px:int;
			var py:int;
			var dist:Number=0;
			var inverse:Number=1 / resolution;
			var interval:Number;
			var intervalSq:Number;
			var intervalCu:Number;
			var diff:Number;
			var diffSq:Number;
			var diffCu:Number;
			var i:int=0;
			while( ++i <= resolution ) 
			{
				interval=inverse * i;
				intervalSq=interval * interval;
				intervalCu=intervalSq * interval;
				diff=1 - interval;
				diffSq=diff * diff;
				diffCu=diffSq * diff;
				px=diffCu * x0 + 3 * interval * diffSq * x1 + 3 * x2 * intervalSq * diff + x3 * intervalCu;
				py=diffCu * y0 + 3 * interval * diffSq * y1 + 3 * y2 * intervalSq * diff + y3 * intervalCu;
				dist += Math.sqrt(( px - ox ) * ( px - ox ) + ( py - oy ) * ( py - oy ));
				ox=px;
				oy=py;
			}
			//approximates the length of the curve
			var curveLength:int=Math.floor(dist);
			inverse=1 / curveLength;
			var lastx:int=x0;
			var lasty:int=y0;
			i=-1;
			while( ++i <= curveLength ) 
			{
				interval=inverse * i;
				intervalSq=interval * interval;
				intervalCu=intervalSq * interval;
				diff=1 - interval;
				diffSq=diff * diff;
				diffCu=diffSq * diff;
				px=diffCu * x0 + 3 * interval * diffSq * x1 + 3 * x2 * intervalSq * diff + x3 * intervalCu;
				py=diffCu * y0 + 3 * interval * diffSq * y1 + 3 * y2 * intervalSq * diff + y3 * intervalCu;
				line(bmp,lastx,lasty,px,py,c);
				lastx=px;
				lasty=py;
			}
		}

		/**
		 * Draw an alpha32 pixel.
		 */
		private static function drawAlphaPixel(bmp:BitmapData, x:int, y:int, a:Number, c:Number):void 
		{
			var g:uint=bmp.getPixel32(x,y);
			var r0:uint=((g & 0x00FF0000) >> 16);
			var g0:uint=((g & 0x0000FF00) >> 8);
			var b0:uint=((g & 0x000000FF));
			var r1:uint=((c & 0x00FF0000) >> 16);
			var g1:uint=((c & 0x0000FF00) >> 8);
			var b1:uint=((c & 0x000000FF));
			var ac:Number=0xFF;
			var rc:Number=r1 * a + r0 * (1 - a);
			var gc:Number=g1 * a + g0 * (1 - a);
			var bc:Number=b1 * a + b0 * (1 - a);
			var n:uint=(ac << 24) + (rc << 16) + (gc << 8) + bc;
			bmp.setPixel32(x,y,n);
		}

		/**
		 * Check a triangle line
		 */
		private static function checkLine(o:Object, x:int, y:int, bmp:BitmapData, c:int, r:Rectangle):void
		{
			if(o[y]) 
			{
				if(o[y] > x) 
				{
					r.width=o[y] - x;
					r.x=x;
					r.y=y;
					bmp.fillRect(r,c);
				}
				else 
				{
					r.width=x - o[y];
					r.x=o[y];
					r.y=y;
					bmp.fillRect(r,c);
				}
			}
			else o[y]=x;
		}

		/**
		 * Special line for filled triangle
		 */
		private static function lineTri(o:Object, bmp:BitmapData,x0:int, y0:int, x1:int, y1:int, c:Number):void 
		{
			var steep:Boolean=(y1 - y0) * (y1 - y0) > (x1 - x0) * (x1 - x0);
			var swap:int;
			if(steep)
			{
				swap=x0; 
				x0=y0; 
				y0=swap;
				swap=x1; 
				x1=y1; 
				y1=swap;
			}
			if(x0 > x1) 
			{
				x0 ^= x1; 
				x1 ^= x0; 
				x0 ^= x1;
				y0 ^= y1; 
				y1 ^= y0; 
				y0 ^= y1;
			}
			var deltax:int=x1 - x0;
			var deltay:int=Math.abs(y1 - y0);
			var error:int=0;
			var y:int=y0;			
			var ystep:int=y0 < y1 ? 1 : -1;
			var x:int=x0;
			var xend:int=x1 - (deltax >> 1);
			var fx:int=x1;
			var fy:int=y1;
			var r:Rectangle=new Rectangle();
			var px:int=0;
			r.x=0;
			r.y=0;
			r.width=0;
			r.height=1;
			while(x++ <= xend)
			{
				if(steep) 
				{
					checkLine(o,y,x,bmp,c,r);
					if (fx != x1 && fx != xend)checkLine(o,fy,fx + 1,bmp,c,r);
				}
				error += deltay;
				if((error << 1) >= deltax) 
				{
					if (!steep) 
					{
						checkLine(o,x - px + 1,y,bmp,c,r);
						if (fx != xend)checkLine(o,fx + 1,fy,bmp,c,r);
					}
					px=0;
					y += ystep;
					fy -= ystep;
					error -= deltax; 
				}
				px++;
				fx--;
			}
			if(!steep) checkLine(o,x-px + 1,y,bmp,c,r);
		}
	}
}