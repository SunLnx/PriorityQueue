package
{
	public class PriorityQueue_Test
	{
		public function PriorityQueue_Test()
		{
			var queue:PriorityQueue = new PriorityQueue(false);
			var v:Number;
			for (var i:int = 0; i < 8; i++) {
				v = Math.random();
				queue.enQueue("value:" + v, int(v * 4));
			}
			trace(queue.snapshot());
			var out:String = "";
			for (var o:Object = queue.deQueue(); o; o = queue.deQueue()) {
				out += (o + "  ");
			}
			trace(out);
		}
	}
}