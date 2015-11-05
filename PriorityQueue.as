package
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
			if (!(value in _indexs)) {
				return _heap[_indexs[value]]._priority;
			}
			return  -1;
		}
		
		public function remove(value:Object):Number {
			if (!(value  in _indexs)) {
				return -1;
			}
			var index:int = _indexs[value];
			var priority:Number = _heap[index]._priority;
			_heap[index] = _heap[_heap.length-1];
			--_heap.length;
			delete _indexs[value];
			shiftDown(index);
			return priority;
		}
		
		public function size():int {
			return _heap.length;
		}
		
		private function shiftUp(index:int):void {
			if (index <= 0 || index >= _heap.length) {
				return;
			}
			for (var pindex:int = (index -1) >> 1; pindex >= 0; index = (index -1) >> 1,  pindex = (index - 1) >> 1) {
				if ((!_littleEndian && _heap[index]._priority > _heap[pindex]._priority) ||_littleEndian && _heap[index]._priority < _heap[pindex]._priority) {
					swap(index, pindex);
				} else {
					break;
				}
			}
		}
		
		private function shiftDown(index:int):void {
			if (index < 0 || index >= (_heap.length >> 1)) {
				return;
			}
			var larger:int;
			for (var lcIndex:int = (index << 1) +1, rcIndex:int = (index << 1) + 2; lcIndex < _heap.length; index = larger, lcIndex = (index << 1)+1, rcIndex = (index << 1)+2){
				larger = (rcIndex < _heap.length)?((_heap[lcIndex]._priority > _heap[rcIndex]._priority)?lcIndex:rcIndex):lcIndex;
				if ((!_littleEndian && _heap[index]._priority < _heap[larger]._priority) || _littleEndian && _heap[index]._priority > _heap[larger]._priority) {
					swap(index, larger);
				} else {
					break;
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
				str += ("p:" + _heap[i]._priority + "\tv:" + _heap[i]._value + "\n");
			}
			return str;
		}
	}
}

internal class Element {
	public var _priority:Number;
	public var _value:Object;
	public function Element(value:Object, priority:Number):void {
		_priority = priority;
		_value = value;
	}
}