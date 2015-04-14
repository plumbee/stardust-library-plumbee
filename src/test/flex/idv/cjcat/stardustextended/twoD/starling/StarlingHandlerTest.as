/**
 * Created by guymclean on 14/04/2015.
 */
package idv.cjcat.stardustextended.twoD.starling
{
import flash.display.BlendMode;

import idv.cjcat.stardustextended.twoD.utils.BlendModeSets;

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;

[RunWith("org.flexunit.runners.Parameterized")]
public class StarlingHandlerTest
{
	public static function ATF_STARLING_SET_DATA(): Array
	{
		var data: Array = [];
		for each(var validBlendMode: String in BlendModeSets.STARLING_ATF_BLEND_MODES)
		{
			data.push([validBlendMode])
		}
		return data;
	}

	public static function REGULAR_STARLING_SET_DATA(): Array
	{
		var data: Array = [];
		for each(var validBlendMode: String in BlendModeSets.STARLING_REGULAR_BLEND_MODES)
		{
			data.push([validBlendMode])
		}
		return data;
	}

	[Test(dataProvider="ATF_STARLING_SET_DATA")]
	public function atfModeGivenAsTrue_validBlendModesSetToStarlingATFSet(givenBlendMode: String) : void
	{
		var handler = new StarlingHandler(new Object(), givenBlendMode, 0, true);
		assertThat(handler.blendMode, equalTo(givenBlendMode));
	}

	[Test(dataProvider="REGULAR_STARLING_SET_DATA")]
	public function atfModeGivenAsFalse_validBlendModesSetToStarlingRegularSet(givenBlendMode: String) : void
	{
		var handler = new StarlingHandler(new Object(), givenBlendMode, 0, false);
		assertThat(handler.blendMode, equalTo(givenBlendMode));
	}

	[Test]
	public function attemptToSetBlendModeTo_ADD_whenATFModeTrue_autoCorrectsToBlendModeSets_ATF_ADD(): void
	{
		var handler: StarlingHandler = new StarlingHandler(new Object(), BlendMode.ADD, 0, true);
		assertThat(handler.blendMode, equalTo(BlendModeSets.ATF_ADD_ID));
	}

	[Test]
	public function attemptToSetBlendModeTo_ADD_whenATFModeFalse_staysADD(): void
	{
		var handler: StarlingHandler = new StarlingHandler(new Object(), BlendMode.ADD, 0, false);
		assertThat(handler.blendMode, equalTo(BlendMode.ADD));
	}

}
}
