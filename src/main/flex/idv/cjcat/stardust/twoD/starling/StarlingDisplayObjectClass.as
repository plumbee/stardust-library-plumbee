package idv.cjcat.stardust.twoD.starling 
{
  import idv.cjcat.stardust.common.initializers.Initializer;
  import idv.cjcat.stardust.common.particles.Particle;
  import idv.cjcat.stardust.common.utils.construct;
  import starling.display.DisplayObject;
  import starling.display.Image;
  
	public class StarlingDisplayObjectClass extends Initializer
  {
    public var displayObjectClass:Class;
    public var constructorParams:Array;
    
    public function StarlingDisplayObjectClass(displayObjectClass:Class, constructorParams:Array = null)
    {
      this.displayObjectClass = displayObjectClass;
      this.constructorParams = constructorParams;
    }
    
    override public function initialize(particle:Particle):void 
    {
      var target:DisplayObject = construct(displayObjectClass, constructorParams);
      target.pivotX = 0.5 * target.width;
      target.pivotY = 0.5 * target.height;
      particle.target = target;
    }
  }
}