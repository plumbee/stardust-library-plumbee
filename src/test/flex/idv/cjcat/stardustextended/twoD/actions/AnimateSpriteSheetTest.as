package idv.cjcat.stardustextended.twoD.actions
{
import idv.cjcat.stardustextended.common.emitters.Emitter;
import idv.cjcat.stardustextended.common.particles.Particle;
import idv.cjcat.stardustextended.twoD.display.bitmapParticle.IAnimatedParticle;

import org.flexunit.rules.IMethodRule;
import org.mockito.integrations.flexunit4.MockitoRule;

import org.mockito.integrations.verify;

public class AnimateSpriteSheetTest
{

	[Rule]
	public var rule:IMethodRule = new MockitoRule();

	[Mock]
	public var animatedParticle:IAnimatedParticle;

	[Test]
	public function update_willUpdateAnimatableWithTimeDelta() : void
	{
		var a:AnimateSpriteSheet = new AnimateSpriteSheet();
		var emitter:Emitter = null;
		var particle:Particle = new Particle();
		particle.target = animatedParticle;
		var timeDelta:Number = 1;
		var currentTime:Number = 0;
		a.update(emitter,particle,timeDelta,currentTime);

		verify().that(animatedParticle.stepSpriteSheet(timeDelta));
	}
}
}
