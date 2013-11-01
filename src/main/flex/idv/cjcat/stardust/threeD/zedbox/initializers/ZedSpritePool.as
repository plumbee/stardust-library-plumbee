package idv.cjcat.stardust.threeD.zedbox.initializers {
	import idv.cjcat.zedbox.display.ZedSprite;
	
	internal class ZedSpritePool {
		
		private static var _vec:Array = [new ZedSprite()];
		private static var _position:int = 0;
		
		public static function get():ZedSprite {
			if (_position == _vec.length) {
				_vec.length <<= 1;
				
				//trace("ZedSpritePool expanded");
				
				for (var i:int = _position; i < _vec.length; i++) {
					_vec[i] = new ZedSprite();
				}
			}
			_position++;
			var obj:ZedSprite = _vec[_position - 1] as ZedSprite;
			return obj;
		}
		
		public static function recycle(obj:ZedSprite):void {
			if (_position == 0) return;
			if (!obj) return;
			
			_vec[_position - 1] = obj;
			_position--;
			if (_position < 0) _position = 0;
			
			if (_vec.length >= 16) {
				if (_position < (_vec.length >> 4)) {
					
					//trace("ZedSpritePool contracted");
					
					_vec.length >>= 1;
				}
			}
		}
	}
}