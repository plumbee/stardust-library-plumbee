package idv.cjcat.stardustextended.twoD.utils {

import idv.cjcat.stardustextended.common.utils.construct;

public class GenericObjectPool {

	private static const DEFAULT_SIZE:int = 32;

	protected var _vec :Array = [];
	private var _class:Class;
	private var _params:Array;
	private var _position:int = 0;

	public function reset(c:Class, params:Array):void {
		_position = 0;
		_vec = new Array(DEFAULT_SIZE);
		_class = c;
		_params = params;
		for (var i:int = 0; i < DEFAULT_SIZE; i++) {
			_vec[i] = construct(_class, _params);
		}
	}

	public function get():* {
		if (_position == _vec.length) {
			_vec.length <<= 1;

			//trace("DisplayObjectPool expanded. New size:", _vec.length);

			for (var i:int = _position; i < _vec.length; i++) {
				_vec[i] = construct(_class, _params);
			}
		}
		_position++;
		return _vec[_position - 1];
	}

	public function recycle(obj:*):void {
		if (_position == 0) return;
		if (!obj) return;

		_vec[_position - 1] = obj;
		_position--;
		if (_position < 0) _position = 0;

		if (_vec.length > DEFAULT_SIZE * 2) {

			if (_position < (_vec.length >> 4)) {

				//trace("DisplayObjectPool contracted. New size:", _vec.length);

				_vec.length >>= 1;
			}
		}
	}
}
}