package com.muxxu.kube.utils {
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class ColorFunctions {
	
		private static var _LMAX:Number		= 240;
		private static var _HMAX:Number		= 240;
		private static var _SMAX:Number		= 240;
	
		private static var _RGBMAX:Number	= 255;
		
		private static var _DISTMAX:Number	= 255;
		
		private static var _lastColor:Number;
		private static var _lastHSL:Object;
	
	
	
	
	
		/*******************
		 *** CONSTRUCTOR ***
		 ******************/
		
		public function ColorFunctions() { }
		
		
		
		
		
		
		/*************************
		 *** GETTERS / SETTERS ***
		 ************************/
		/**
		 * Change the maximum value of luminosity
		 */
		public static function set LMAX(value:Number):void	{ _LMAX = value; }
		/**
		 * Get the maximum value of luminosity
		 */
		public static function get LMAX():Number			{ return _LMAX; }
	
		/**
		 * Change the maximum value of hue
		 */
		public static function set HMAX(value:Number):void	{ _HMAX = value; }
		/**
		 * Get the maximum value of hue
		 */
		public static function get HMAX():Number			{ return _HMAX; }
	
		/**
		 * Change the maximum value of saturation
		 */
		public static function set SMAX(value:Number):void	{ _SMAX = value; }
		/**
		 * Get the maximum value of saturation
		 */
		public static function get SMAX():Number			{ return _SMAX; }
	
		/**
		 * Change the maximum rgb value
		 */
		public static function set RGBMAX(value:Number):void	{ _RGBMAX = value; }
		/**
		 * Get the maximum rgb value
		 */
		public static function get RGBMAX():Number			{ return _RGBMAX; }
	
		/**
		 * Change the distance maximum value
		 */
		public static function set DISTMAX(value:Number):void	{ _DISTMAX = value; }
		/**
		 * Get the distance maximum value
		 */
		public static function get DISTMAX():Number			{ return _DISTMAX; }
		
		
		
		
		/**********************
		 *** PUBLIC METHODS ***
		 *********************/
		/**
		 * Compute the average between two colors
		 * 
		 * @param	c1 : color one
		 * @param	c2 : color two
		 * @return the average between colors
		 */
		public static function average(c1:Number, c2:Number):Number {
			var rgb1:Object = getRGB(c1);
			var rgb2:Object = getRGB(c2);
			var avgr:Number	= (rgb1.r + rgb2.r) / 2;
			var avgg:Number	= (rgb1.g + rgb2.g) / 2;
			var avgb:Number	= (rgb1.b + rgb2.b) / 2;
			return avgr << 16 | avgg << 8 | avgb;
		}
	
		/**
		 * Compute the average color of a bitmapData area
		 * 
		 * @param	bmpD					: The bitmapData
		 * @param	precision	[optional]	: Precision in percent of the average. Default value = .3.
		 * @param	rect		[optional]	: Area of the bitmapData 
		 * @param	alphaMin	[optional]	: minimum alpha value to check a pixel as valid. Under this value the pixel is considered as white and transparent.
		 * @return an ARGB average color.
		 */
		public static function bitmapDataAverage(bmpD:BitmapData, precision:Number = .3, rect:Rectangle = null, alphaMin:int = 0xA0):Number {
			var x:Number;
			var y:Number;
			var w:Number;
			var h:Number;
			var tot:Number	= 0;
			var sumA:Number	= 0;			var sumR:Number	= 0;
			var sumG:Number	= 0;
			var sumB:Number	= 0;
			precision = restrict(precision, 0, 1);
			if (rect != null) {
				x = rect.x;
				y = rect.y;
				w = x + rect.width;
				h = y + rect.height;
			}else {
				x = y = 0;
				w = bmpD.width;
				h = bmpD.height;
			}
			var incX:Number	= Math.round(w/(w*precision));
			var incY:Number	= Math.round(h/(h*precision));
			for (var i:Number = x; i < w; i += incX) {
				for (var j:Number = y; j < h; j += incY) {
					var pix:Number = bmpD.getPixel32(i, j);
					if((pix >> 24 & 0xFF) < alphaMin){
						pix = 0x00FFFFFF;
					}
					sumA += pix >> 24 & 0xFF;					sumR += pix >> 16 & 0xFF;
					sumG += pix >> 8 & 0xFF;
					sumB += pix & 0xFF;
					tot ++;
				}
			}
			var avga:Number	= sumA / tot;			var avgr:Number	= sumR / tot;
			var avgg:Number	= sumG / tot;
			var avgb:Number	= sumB / tot;
			return avga << 24 | avgr << 16 | avgg << 8 | avgb;
		}
	
		/**
		 * Transform an RGB color into an object containing thoses properties
		 * 
		 * r : Red
		 * g : Green
		 * b : Blue
		 * 
		 * @param	c : color to convert
		 * @return an object containing r, g and b properties
		 */
		public static function getRGB(c:Number):Object										{ return { r:getRed(c), g:getGreen(c), b:getBlue(c) }; }
	
		/**
		 * Convert an RGB color to HSL
		 * 
		 * @param	color : color to convert
		 * @return an object containing an h, l, and s properties.
		 */
		public static function convertToHSL(color:Number):Object							{ return toHSL(color); }
		/**
		 * Alias of convertToHSL
		 */
		public static function getHSL(color:Number):Object									{ return convertToHSL(color); }
	
		/**
		 * Convert an HSL color to RGB
		 * 
		 * @param	color : color to convert
		 * @return the RGB converted color.
		 */
		public static function convertHSLToRGB(h:Number, s:Number, l:Number):Number			{ return HSLtoRGB(h, s, l); }
	
		/**
		 * Convert an RGB color to YUV
		 * 
		 * @param	color : color to convert
		 * @return an object containing an y, u, and v properties.
		 */
		public static function convertToYUV(color:Number):Object							{ return toYUV(color); }
		/**
		 * Alias of convertToYUV
		 */
		public static function getYUV(color:Number):Object									{ return convertToYUV(color); }
	
		/**
		 * Convert an YUV color to RGB
		 * 
		 * @param	color : color to convert
		 * @return the RGB converted color.
		 */
		public static function convertYUVToRGB(h:Number, s:Number, l:Number):Number			{ return YUVtoRGB(h, s, l); }
	
	
		/**
		 * Convert an RGB color to CMYK
		 * 
		 * @param	color : color to convert
		 * @return an object containing a c, m, y, and k properties.
		 */
		public static function convertToCMYK(color:Number):Object							{ return toCMYK(color); }
	
		/**
		 * Convert a CMYK color to RGB
		 * 
		 * @param	color : color to convert
		 * @return the RGB converted color.
		 */
		public static function convertCMYKToRGB(c:Number, m:Number, y:Number, k:Number):Number	{ return CMYKtoRGB(c, m, y, k); }
	
		/**
		 * Set the red component to a specific value
		 * 
		 * @param	color : Color to change
		 * @param	value : new red value
		 * @return the new color
		 */
		public static function setRed(color:Number, value:Number):Number				{
			var rgb:Object = getRGB(color);
			rgb.r = value;
			return rgb.r << 16 | rgb.g << 8 | rgb.b;
		}
	
		/**
		 * Set the green component to a specific value
		 * 
		 * @param	color : Color to change
		 * @param	value : new gren value
		 * @return the new color
		 */
		public static function setGreen(color:Number, value:Number):Number 				{
			var rgb:Object = getRGB(color);
			rgb.g = value;
			return rgb.r << 16 | rgb.g << 8 | rgb.b;
		}
	
		/**
		 * Set the blue component to a specific value
		 * 
		 * @param	color : Color to change
		 * @param	value : new blue value
		 * @return the new color
		 */
		public static function setBlue(color:Number, value:Number):Number 				{
			var rgb:Object = getRGB(color);
			rgb.b = value;
			return rgb.r << 16 | rgb.g << 8 | rgb.b;
		}
	
		/**
		 * Set the contrast of a color
		 * 
		 * @param	color	: Color to change the contrast
		 * @param	value	: Contrast value
		 * @return the new RGB color
		 */
		public static function setRGBContrast(color:Number, value:Number):Number	{
			var hsl:Object = toHSL(color);
			hsl.h = (value > _HMAX)? _HMAX : (value < 0)? 0 : value;
			return HSLtoRGB(hsl.h, hsl.s, hsl.l);
		}
	
		/**
		 * Set the saturation of a color
		 * 
		 * @param	color	: Color to change the contrast
		 * @param	value	: Contrast value
		 * @return the new RGB color
		 */
		public static function setRGBSaturation(color:Number, value:Number):Number	{
			var hsl:Object = toHSL(color);
			hsl.s = (value > _SMAX)? _SMAX : (value < 0)? 0 : value;
			return HSLtoRGB(hsl.h, hsl.s, hsl.l);
		}
	
		/**
		 * Set the brighness of a color
		 * 
		 * @param	color	: Color to change the brightness
		 * @param	value	: Brightness value
		 * @return the new RGB color
		 */
		public static function setRGBBrightness(color:Number, value:Number):Number	{
			var hsl:Object = toHSL(color);
			hsl.l = (value > _LMAX)? _LMAX : (value < 0)? 0 : value;
			return HSLtoRGB(hsl.h, hsl.s, hsl.l);
		}
	
		/**
		 * Compute the hue of a color
		 * 
		 * @param	color : The color for which we want to get hue value
		 * @return the hue value between 0 and LMAX
		 */
		public static function getHue(color:Number):Number						{ return toHSL(color).h; }
	
		/**
		 * Compute the luminosty of a color
		 * 
		 * @param	color : The color for which we want to get luminosity value
		 * @return the luminosity value between 0 and LMAX
		 */
		public static function getLuminosity(color:Number):Number				{ return toHSL(color).l; }
	
		/**
		 * Compute the saturation of a color
		 * 
		 * @param	color : The color for which we want to get saturation value
		 * @return the saturation value between 0 and SMAX
		 */
		public static function getSaturation(color:Number):Number				{ return toHSL(color).s; }
	
		/**
		 * Get the red component of a color
		 * 
		 * @param	color : color from which extract the component
		 * @return the red component
		 */
		public static function getRed(color:Number):Number						{ return color >> 16 & 0xFF; }
	
		/**
		 * Get the green component of a color
		 * 
		 * @param	color : color from which extract the component
		 * @return the green component
		 */
		public static function getGreen(color:Number):Number					{ return color >> 8 & 0xFF; }
	
		/**
		 * Get the blue component of a color
		 * 
		 * @param	color : color from which extract the component
		 * @return the blue component
		 */
		public static function getBlue(color:Number):Number						{ return color & 0xFF; }
		
		/**
		 * Add the "add" value to all the color's components
		 * 
		 * @param	color	: color to decrement
		 * @param	add		: value to add to the components. An hexadecimal value
		 *       	   		  between 0x00 and 0xFF;
		 * @return the new color
		 */
		public static function add(color:Number, add:Number):Number				{
			add = (add << 16) | (add << 8) | add;
			var ret:Number = color + add;
			return (ret > 0xFFFFFF)? 0xFFFFFF : ret;
		}
		
		/**
		 * Substract the "sub" value to all the color's components
		 * 
		 * @param	color	: color to decrement
		 * @param	sub		: value to substract from the components. An hexadecimal value
		 *       	   		  between 0x00 and 0xFF;
		 * @return the new color
		 */
		public static function sub(color:Number, sub:Number):Number				{
			sub = (sub << 16) | (sub << 8) | sub;
			var ret:Number = color - sub;
			return (ret < 0)? 0x000000 : ret;
		}
		
		/**
		 * Add the "add" value to the red component of the color
		 * 
		 * @param	color	: color to increment
		 * @param	add		: value to add to the red component. An hexadecimal value
		 *       	   		  between 0x00 and 0xFF;
		 * @return the new color
		 */
		public static function addRed(color:Number, add:Number):Number			{ var ret:Number = color + (add << 16); return (ret > 0xFF)? 0xFF : ret; }
		
		/**
		 * Add the "add" value to the green component of the color
		 * 
		 * @param	color	: color to increment
		 * @param	add		: value to add to the green component. An hexadecimal value
		 *       	   		  between 0x00 and 0xFF;
		 * @return the new color
		 */
		public static function addGreen(color:Number, add:Number):Number		{ var ret:Number = color + (add << 8); return (ret > 0xFF)? 0xFF : ret; }
		
		/**
		 * Add the "add" value to the blue component of the color
		 * 
		 * @param	color	: color to increment
		 * @param	add		: value to add to the blue component. An hexadecimal value
		 *       	   		  between 0x00 and 0xFF;
		 * @return the new color
		 */
		public static function addBlue(color:Number, add:Number):Number			{ var ret:Number = color + add; return (ret > 0xFF)? 0xFF : ret; }
		
		/**
		 * Substract the "sub" value to the red component of the color
		 * 
		 * @param	color	: color to decrement
		 * @param	sub		: value to substract from the red component. An hexadecimal value
		 *       	   		  between 0x00 and 0xFF;
		 * @return the new color
		 */
		public static function subRed(color:Number, sub:Number):Number			{ var ret:Number = color - (sub << 16); return (ret < 0)? 0x00 : ret; }
		
		/**
		 * Substract the "sub" value to the green component of the color
		 * 
		 * @param	color	: color to decrement
		 * @param	sub		: value to substract from the green component. An hexadecimal value
		 *       	   		  between 0x00 and 0xFF;
		 * @return the new color
		 */
		public static function subGreen(color:Number, sub:Number):Number		{ var ret:Number = color - (sub << 8); return (ret < 0)? 0x00 : ret; }
		
		/**
		 * Substract the "sub" value to the blue component of the color
		 * 
		 * @param	color	: color to decrement
		 * @param	sub		: value to substract from the blue component. An hexadecimal value
		 *       	   		  between 0x00 and 0xFF;
		 * @return the new color
		 */
		public static function subBlue(color:Number, sub:Number):Number			{ var ret:Number = color - sub; return (ret < 0)? 0x00 : ret; }
	
		/**
		 * Compute the distance between two colors
		 * 
		 * @param	c1 : color one
		 * @param	c2 : color two
		 * @return the distance between two colors.
		 */
		public static function getDistanceBetweenColors(c1:Number, c2:Number):Number {
			var rgb1:Object = getRGB(c1);
			var rgb2:Object = getRGB(c2);
//			var dist:Number = Math.sqrt(Math.pow(rgb2.r - rgb1.r, 2) + Math.pow(rgb2.g - rgb1.g, 2) + Math.pow(rgb2.b - rgb1.b, 2));
//			dist			= dist / Math.sqrt(Math.pow(0xFF, 2)*3) * _DISTMAX;
//			return dist;
			
			var distance:Number = 0;
			
			distance += Math.pow( rgb1.r - rgb2.r, 2 );
			distance += Math.pow( rgb1.g - rgb2.g, 2 );
			distance += Math.pow( rgb1.b - rgb2.b, 2 );
			
			return distance;
		}
		
		 
		 
		 
		
		
		/***********************
		 *** PRIVATE METHODS ***
		 **********************/
	
		/**
		 * Convert an RGB color to HSL
		 * 
		 * @param	color : color to convert
		 * @return an object containing an h, l, and s properties.
		 */
		private static function toHSL(color:Number):Object {
			if (_lastColor == color) return _lastHSL;
			_lastColor			= color;
			var rgb:Object		= getRGB(color);
			var max:Number		= Math.max(rgb.r, Math.max(rgb.g, rgb.b));
			var min:Number		= Math.min(rgb.r, Math.min(rgb.g, rgb.b));
			var delta:Number	= max - min;
			var sum:Number		= max + min;
			var h:Number;
			//Hue
			if(delta != 0){
				var h0:Number;
				if (rgb.r >= rgb.b && rgb.r >= rgb.g) h0 = (rgb.g - rgb.b) / delta;
				if (rgb.g >= rgb.b && rgb.g >= rgb.r) h0 = (rgb.b - rgb.r) / delta + 2;
				if (rgb.b >= rgb.g && rgb.b >= rgb.r) h0 = (rgb.r - rgb.g) / delta + 4;
				h				= ((1 / 6) * (h0 * _HMAX)) % _HMAX;
			} else {
				h				= 160;
			}
			//Luminosity
			var l:Number		= (sum / (_RGBMAX*2)) * LMAX;
			//Saturation
			var s:Number		= (delta == 0)? 0 : (sum <= _SMAX)? delta / sum * _SMAX : delta / ((_RGBMAX*2) - sum) * _SMAX;
			_lastHSL			= { h:h, s:s, l:l };
			return _lastHSL;
		}
	
		/**
		 * Convert an HSL color to RGB
		 * 
		 * @param	color : color to convert
		 * @return the RGB converted value
		 */
		private static function HSLtoRGB(h:Number, s:Number, l:Number):Number {
			var r:Number;
			var g:Number;
			var b:Number;
			var max:Number;
			var min:Number;
			var delta:Number;
			var t0:Number	= (6 * h) / _HMAX;
			var s0:Number	= (s / _SMAX);
			var l0:Number	= (l / _LMAX);
			
			if (s == 0) {
				r = g = b = l;
			}else {
				if (l <= _LMAX / 2) {
					var base:Number	= _RGBMAX * l0;
					max				= base * (1 + s0);
					min				= base * (1 - s0);
				} else {
					max				= _RGBMAX * (l0 * (1 - s0) + s0);
					min				= _RGBMAX * (l0 * (1 + s0) - s0);
				}
				delta	= max - min;
	
				switch(t0 >> 0) {
					case 0:
						r = max;
						g = min + t0 * delta;
						b = min;
						break;
					case 1:
						r = min + (2 - t0) * delta;
						g = max;
						b = min;
						break;
					case 2:
						r = min;
						g = max;
						b = min + (t0 - 2) * delta;
						break;
					case 3:
						r = min;
						g = min + (4 - t0) * delta;
						b = max;
						break;
					case 4:
						r = min + (t0 - 4) * delta;
						g = min;
						b = max;
						break;
					case 5:
					case 6:
						r = max;
						g = min;
						b = min + (6 - t0) * delta;
						break;
				}
			}
			return r << 16 | g << 8 | b;
		}
	
		/**
		 * Convert an RGB color to YUV
		 * 
		 * @param	color : color to convert
		 * @return an object containing an y, u, and v properties.
		 */
		private static function toYUV(color:Number):Object {
			var rgb:Object	= getRGB(color);
			var y:Number	= ( (  66 * rgb.r + 129 * rgb.g +  25 * rgb.b + 128) >> 8) +  16;
			var u:Number	= ( ( -38 * rgb.r -  74 * rgb.g + 112 * rgb.b + 128) >> 8) + 128;
			var v:Number	= ( ( 112 * rgb.r -  94 * rgb.g -  18 * rgb.b + 128) >> 8) + 128;
			return { y:y, u:u, v:v };
		}
	
		/**
		 * Convert an RGB color to YUV
		 * 
		 * @param	color : color to convert
		 * @return the RGB converted value
		 */
		private static function YUVtoRGB(y:Number, u:Number, v:Number):Number {
			var c:Number	= y - 16;
			var d:Number	= u - 128;
			var e:Number	= v - 128;
	
			var r:Number	= restrict(( 298 * c           + 409 * e + 128) >> 8, 0, 255);
			var g:Number	= restrict(( 298 * c - 100 * d - 208 * e + 128) >> 8, 0, 255);
			var b:Number	= restrict(( 298 * c + 516 * d           + 128) >> 8, 0, 255);
	
			return r << 16 | g << 8 | b;
		}
	
		/**
		 * Restrict a number in range
		 * @param	value	: value to restrict
		 * @param	min		: minimum value
		 * @param	max		: maximum value
		 * @return the value restricted
		 */
		private static function restrict(value:Number, min:Number, max:Number):Number {
			return (value<min)? min : (value>max)? max : value;
		}
	
		/**
		 * Convert an RGB color to CMYK (CMJN)
		 * 
		 * @param	color : color to convert
		 * @return an object containing a c, m, y, and k properties.
		 */
		private static function toCMYK(color:Number):Object {
			var rgb:Object	= getRGB(color);
			var c:Number = ( _RGBMAX - rgb.r ) / _RGBMAX;
			var m:Number = ( _RGBMAX - rgb.g ) / _RGBMAX;
			var y:Number = ( _RGBMAX - rgb.b ) / _RGBMAX;
			var k:Number = Math.min(c, Math.min(m, y)); 
	
			return { c:Math.round(c* 100), m:Math.round(m* 100), y:Math.round(y* 100), k:Math.round(k* 100) };
		}
	
		/**
		 * Convert an RGB color to CMYK (CMJN)
		 * 
		 * @param	color : color to convert
		 * @return the RGB converted value
		 */
		private static function CMYKtoRGB(c:Number, m:Number, y:Number, k:Number):Number {
			c /= 100;
			m /= 100;
			y /= 100;
			k /= 100;
			c = ( c * ( 1 - k ) + k );
			m = ( m * ( 1 - k ) + k );
			y = ( y * ( 1 - k ) + k );
			var r:Number = ( 1 - c ) * 255;
			var g:Number = ( 1 - m ) * 255;
			var b:Number = ( 1 - y ) * 255;
	
			return r << 16 | g << 8 | b;
		}
	
	}
}