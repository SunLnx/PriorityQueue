package cn.vbyte.data
{
	public class PriorityQueue_Test
	{
		public function PriorityQueue_Test()
		{
			var queue:PriorityQueue = new PriorityQueue(false);
			var v:Number;
			var str:String = "";
			for (var i:int = 0; i < 8; i++) {
				v = int(Math.random() * 32);
				queue.enQueue( {value:v}, v);
				str += (v + " ");
			}
			trace(str);
			trace(queue.snapshot());
			
			
			var out:String = "";
			for (var o:Object = queue.top(); o; o = queue.top()) {
				out += (o.value + "  ");
				queue.remove(o);
			}
			trace(out);
		}
	}
}