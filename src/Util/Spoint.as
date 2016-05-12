package Util
{
	public class Spoint
	{
		private var _x:Number;
		 
		private var _y:Number;
		
		
		
		public function set x(x:Number):void{
			this._x = x>int(x)?int(x)+1:int(x);
		}
		public function set y(y:Number):void{
			this._y = y>int(y)?int(y)+1:int(y);
		}
		public function get x():Number{
			return _x;
		}
		public function get y():Number{
			return _y;
		}
		
		
		
		
		public function Spoint()
		{
		
		}
	}
}