
package;


import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import flixel.util.FlxTimer;



import flixel.graphics.frames.FlxAtlasFrames;




typedef TestCharacterMenuStory = {
	var name:String;
	var characterName:String;
	//var portrait:String;
}

class TestCharMenuStory extends MusicBeatState
{
	var menuItems:Array<String> = ['BOYFRIEND', 'BOYFRIENDTEST'];
	var curSelected:Int = 0;
	var txtDescription:FlxText;
	var idleCharacter:FlxSprite;
	var menuBG:FlxSprite;
	var menuIcon:FlxSprite;
	public static var isStoryMode:Bool = false;
	public static var isTestStoryMode:Bool = false;

	public var targetY:Float = 0;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;
	public static var characterShit:Array<TestCharacterMenuStory>;


	

	private var grpMenuShit:FlxTypedGroup<Alphabet>;
	private var grpMenuShiz:FlxTypedGroup<FlxSprite>;
	var alreadySelectedShit:Bool = false;
	// magnus sux

	var shittyNames:Array<String> = [
		"Boyfriend",
		"Test",

		//No secrets here :D
		
	];

	var txtOptionTitle:FlxText;

	override function create()
	{
		menuBG = new FlxSprite().loadGraphic('assets/images/charSelect/BG1.png');
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		grpMenuShiz = new FlxTypedGroup<FlxSprite>();
		add(grpMenuShiz);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
		
			songText.screenCenter(X);
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		txtDescription = new FlxText(FlxG.width * 0.075, menuBG.y + 200, 0, "", 32);
		txtDescription.alignment = CENTER;
		txtDescription.setFormat("assets/fonts/vcr.ttf", 32);
		txtDescription.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1.5, 1);
		txtDescription.color = FlxColor.WHITE;
		add(txtDescription);

		idleCharacter = new FlxSprite(0, -20);
		idleCharacter.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/selectbf.png', 'assets/images/charSelect/selectbf.xml');
		idleCharacter.animation.addByPrefix('regboyfriendidle', 'regbf instance 1', 24);
		idleCharacter.animation.addByPrefix('testidle', 'testbf instance 1', 24);
		idleCharacter.animation.addByPrefix('regboyfriendselect', 'regbfselect instance 1', 24);
		idleCharacter.animation.addByPrefix('testselect', 'testbfselect instance 1', 24);
		
		idleCharacter.animation.play('regboyfriendidle');
		idleCharacter.scale.set(0.7, 0.7);
		idleCharacter.updateHitbox();
		idleCharacter.screenCenter(XY);
		idleCharacter.antialiasing = true;
		
		add(idleCharacter);

		menuIcon = new FlxSprite();
		menuIcon.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/icons.png', 'assets/images/charSelect/icons.xml');
		menuIcon.x = idleCharacter.x + 60;
		menuIcon.y = idleCharacter.y + 300;
		menuIcon.antialiasing = true;
		menuIcon.animation.addByPrefix('regbf', 'reg bf', 1);
		menuIcon.animation.addByPrefix('testbf', 'test bf', 1);
		add(menuIcon);

		

		//idleCharacterBetter = new Boyfriend(0, 0, 'bf');

		var charSelHeaderText:Alphabet = new Alphabet(0, 50, 'CHARACTER SELECT', true, false);
		charSelHeaderText.screenCenter(X);
		add(charSelHeaderText);

		var selectionArrows:FlxSprite = new FlxSprite().loadGraphic('assets/images/charSelect/arrowsz.png');
		selectionArrows.screenCenter();
		selectionArrows.antialiasing = true;
		add(selectionArrows);

		txtOptionTitle = new FlxText(FlxG.width * 0.7, 10, 0, "dfgdfgdg", 32);
		txtOptionTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtOptionTitle.alpha = 0.7;
		add(txtOptionTitle);

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		super.create();
	}

	override function update(elapsed:Float)
	{
		txtOptionTitle.text = shittyNames[curSelected].toUpperCase();
		txtOptionTitle.x = FlxG.width - (txtOptionTitle.width + 10);
		if (txtOptionTitle.text == '')
		{
		
			txtOptionTitle.text = 'NO DESCRIPTION';
		}

		var upP = controls.LEFT_P;
		var downP = controls.RIGHT_P;
		var accepted = controls.ACCEPT;

		if (!alreadySelectedShit)
		{
			if (upP)
				{
					changeSelection(-1);
				}
				if (downP)
				{
					changeSelection(1);
				}
		
				if (accepted)
				{
					alreadySelectedShit = true;
					var daSelected:String = menuItems[curSelected];
					FlxFlicker.flicker(idleCharacter, 0);
				
					
					//Selection and loading for them
					switch (daSelected)
					{
						case "BOYFRIEND":
							FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);
							idleCharacter.animation.play('regboyfriendselect');
							FlxFlicker.flicker(grpMenuShit.members[curSelected],0);
						//	FlxG.sound.music.stop();
							PlayState.bfMode = 'bf';
							TestStoryMenuState.suffixThing = '';
							
							PlayState.isTestMode = true;
							PlayState.testMode = 'test';
							
							
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								FlxG.switchState(new TestStoryMenuState());
							});
						case "BOYFRIENDTEST":
							FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);
							idleCharacter.animation.play('testselect');
							idleCharacter.y -= 30;
							idleCharacter.x -= 10;
							FlxFlicker.flicker(grpMenuShit.members[curSelected],0);
						//	FlxG.sound.music.stop();
							PlayState.bfMode = 'bf-test';
							TestStoryMenuState.suffixThing = '-test';

							PlayState.isTestMode = true;
							PlayState.testMode = 'test';

					
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								FlxG.switchState(new TestStoryMenuState());
								
							});
					
						
						default:
							// so it doesnt crash lol
							
					}
				}
		
				if (controls.BACK)
				{
					
					FlxG.switchState(new ModeMenuStory());
				}
		}

		super.update(elapsed);
	}

	function changeSelection(change:Int = 0):Void
	{
		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, 0.4);

		curSelected += change;
	
		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;
	
		var bullShit:Int = 0;
	
		for (item in grpMenuShit.members)
		{
			item.x = bullShit - curSelected;
			bullShit++;

			item.alpha = 0;
			// item.setGraphicSize(Std.int(item.width * 0.8));
	
			if (item.x == 0)
			{
				// item.setGraphicSize(Std.int(item.width));
			}
		}

		charCheckLmao();
	}

	function charCheckLmao()
	{
		var daSelected:String = menuItems[curSelected];
	
		

		switch (daSelected)
		{
			case "BOYFRIEND":
				idleCharacter.animation.play('regboyfriendidle');
				idleCharacter.screenCenter(XY);
				menuBG.loadGraphic('assets/images/charSelect/BG1.png');
				menuIcon.animation.play('regbf');
				menuBG.color = 0xFFFFFF;
			case "BOYFRIENDTEST":
				idleCharacter.animation.play('testidle');
				idleCharacter.screenCenter(XY);
				menuBG.loadGraphic('assets/images/charSelect/BG2.png');
				menuIcon.animation.play('testbf');
				menuBG.color = 0xFFFFFF;
		}
	
	}
	
}