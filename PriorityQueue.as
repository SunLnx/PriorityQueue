package cn.vbyte.data
{
	import flash.utils.Dictionary;
	
	public class PriorityQueue
	{
		private var _littleEndian:Boolean;
		private var _heap:Array;
		private var _indexs:Dictionary;
		
		public function PriorityQueue(littleEndian:Boolean = false)
		{
			_littleEndian = littleEndian;
			_heap = [];
			_indexs = new Dictionary();
		}
		
		public function enQueue(value:Object, priority:Number):Boolean {
			if (value in _indexs) {
				return false;
			}
			_indexs[value] = _heap.length;
			_heap[_heap.length] = new Element(value, priority);
			shiftUp(_heap.length - 1);
			return true;
		}
		
		public function deQueue():Object {
			if (_heap.length > 0) {
				var value:Object = _heap[0]._value;
				if (_heap.length > 1) {
					_heap[0] = _heap[_heap.length - 1];
					_indexs[_heap[0]._value] = 0;
					shiftDown(0);
				}
				--_heap.length;
				delete _indexs[value];
				return value;
			}
			return null;
		}
		
		public function top():Object {
			return (_heap.length > 0)? _heap[0]._value:null;
		}
		
		public function repriority(value:Object, priority:Number):Boolean {
			if (!(value in _indexs)) {
				return false;
			}
			var oldPriority:Number = _heap[_indexs[value]]._priority;
			_heap[_indexs[value]]._priority = priority;
			if ((!_littleEndian && priority > oldPriority) || (_littleEndian && priority < oldPriority)) {
				shiftUp(_indexs[value]);
			} else if ((!_littleEndian && priority < oldPriority) || (_littleEndian && priority > oldPriority)){
				shiftDown(_indexs[value]);
			}
			return true;
		}
		
		public function priority(value:Object):Number {
			if (value in _indexs) {
				return _heap[_indexs[value]]._priority;
			}
			return  -1;
		}
		
		public function exist(value:Object):Boolean {
			return value in _indexs;
		}
		
		public function remove(value:Object):Number {
			if (!(value  in _indexs)) {
				return -1;
			}
			var index:int = _indexs[value];
			var priority:Number = _heap[index]._priority;
			delete _indexs[value];
			if (index != _heap.length -1) {
				_heap[index] = _heap[_heap.length-1];
				_indexs[_heap[index]._value] = index;
			}
			--_heap.length;
			shiftDown(index);
			return priority;
		}
		
		public function get size():int {
			return _heap.length;
		}
		
		public function clear():void {
			_heap.length = 0;
			_indexs = new Dictionary();
		}
		
		private function shiftUp(index:int):void {
			if (index <= 0 || index >= _heap.length) {
				return;
			}
			var pindex:int;
			if (!_littleEndian) {
				for (pindex= (index -1) >> 1; pindex >= 0; index = (index -1) >> 1,  pindex = (index - 1) >> 1) {
					if ( _heap[index]._priority > _heap[pindex]._priority) {
						swap(index, pindex);
					} else {
						break;
					}
				}
			} else {
				for (pindex = (index -1) >> 1; pindex >= 0; index = (index -1) >> 1,  pindex = (index - 1) >> 1) {
					if (_heap[index]._priority < _heap[pindex]._priority) {
						swap(index, pindex);
					} else {
						break;
					}
				}
			}
		}
		
		private function shiftDown(index:int):void {
			if (index < 0 || index >= (_heap.length >> 1)) {
				return;
			}
			var lcIndex:int, rcIndex:int;
			if (!_littleEndian) {
				var larger:int;
				for (lcIndex = (index << 1) +1, rcIndex = (index << 1) + 2; lcIndex < _heap.length; index = larger, lcIndex = (index << 1)+1, rcIndex = (index << 1)+2){
					larger = (rcIndex < _heap.length)?((_heap[lcIndex]._priority > _heap[rcIndex]._priority)?lcIndex:rcIndex):lcIndex;
					if (_heap[index]._priority < _heap[larger]._priority) {
						swap(index, larger);
					} else {
						break;
					}
				}
			} else {
				var smaller:int;
				for (lcIndex = (index << 1) +1, rcIndex = (index << 1) + 2; lcIndex < _heap.length; index = smaller, lcIndex = (index << 1)+1, rcIndex = (index << 1)+2){
					smaller = (rcIndex < _heap.length)?((_heap[lcIndex]._priority < _heap[rcIndex]._priority)?lcIndex:rcIndex):lcIndex;
					if (_heap[index]._priority > _heap[smaller]._priority) {
						swap(index, smaller);
					} else {
						break;
					}
				}
			}
		}
		
		private function swap(i:int, j:int):void {
			var temp:Element;
			temp = _heap[i];
			_heap[i] = _heap[j];
			_heap[j] = temp;
			_indexs[_heap[i]._value] = i;
			_indexs[_heap[j]._value] = j;
		}
		
		public function snapshot():String {
			var str:String = "";
			for (var i:int = 0; i < _heap.length; ++i) {
				str += ("p:" + _heap[i]._priority + "\tv:" + _heap[i]._value + "\tindex:"+ _indexs[_heap[i]._value] + "\n");
			}
			return str;
		}
	}
}

internal class Element {
	public var _priority:Number;
	public var _value:Object;
	public function Element(value:Object, priority:Number):void {
		_value = value;
		_priority = priority;
	}
}

internal class Iterate {
	public var _keys:Array
	public var _cursor:int;
	public function get next():Object {
		return null;
	}
	public function hasNext():Boolean {
		return false;
	}
}