package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class GameOverSubstate extends MusicBeatSubstate
{

	var bf:Boyfriend;
	var camFollow:FlxObject;

	var stageSuffix:String = "";
	
	public function new(x:Float, y:Float)
	{

		var daStage = PlayState.curStage;

		var dumbassSuffix:String = '';

		switch (daStage){
		case 'limo':
		dumbassSuffix = '-car';
		case 'mall' | 'mallEvil':
		dumbassSuffix = '-christmas';
		case 'school' | 'schoolEvil':
		dumbassSuffix = '-pixel';
		default:
		dumbassSuffix = '';
		}

		var daChar = PlayState.SONG.player1;
		var daBf:String = '';

		if (PlayState.bfMode == 'bf' && dumbassSuffix == '-pixel') {
			stageSuffix = '-pixel';
			daBf = 'bf-pixel-dead';
			}
		else if (PlayState.bfMode == 'bf-test' && dumbassSuffix == ''){
			daBf = 'bf-test';
			}
		else if (PlayState.bfMode == 'bf-test' && dumbassSuffix == '-car'){
			daBf = 'bf-test-car';
			}
		else if (PlayState.bfMode == 'bf-test' && dumbassSuffix == '-christmas'){
			daBf = 'bf-test-christmas';
			}
		else if (PlayState.bfMode == 'bf-test' && dumbassSuffix == '-pixel'){
			stageSuffix = '-pixel';
			daBf = 'bf-test-pixel';
			}
		else {
			daBf = 'bf';
			}

		super();

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, daBf);
		add(bf);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		FlxG.sound.play('assets/sounds/fnf_loss_sfx' + stageSuffix + TitleState.soundExt);
		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else if (PlayState.isTestStoryMode)
				FlxG.switchState(new TestStoryMenuState());
			else if (PlayState.isTestMode)
				if (PlayState.isTestStoryMode == true)
					FlxG.switchState(new TestStoryMenuState());
				else
					FlxG.switchState(new FreeplayState());
			else
				FlxG.switchState(new FreeplayState());

		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
		{
			FlxG.sound.playMusic('assets/music/gameOver' + stageSuffix + TitleState.soundExt);
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play('assets/music/gameOverEnd' + stageSuffix + TitleState.soundExt);
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					FlxG.switchState(new PlayState());
				});
			});
		}
	}
}
