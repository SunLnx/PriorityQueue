package cn.vbyte.data
{
	public class PriorityQueue_Test
	{
		public function PriorityQueue_Test()
		{
			var queue:PriorityQueue = new PriorityQueue();
			for (var i:int = 20; i > 0; i--) {
				queue.enQueue("value:" + i, 20-i);
			}
			for (var value:String = String(queue.deQueue()); value; value = String(queue.deQueue())) {
				trace(value);
			}
		}
	}
}