package com.ukuleledog.games.presentation.states;
import com.ukuleledog.games.presentation.core.AnimatedObject;
import com.ukuleledog.games.presentation.elements.Celes;
import com.ukuleledog.games.presentation.elements.Edgar;
import com.ukuleledog.games.presentation.elements.Fire3;
import com.ukuleledog.games.presentation.elements.Fireball;
import com.ukuleledog.games.presentation.elements.Locke;
import com.ukuleledog.games.presentation.elements.Mario;
import com.ukuleledog.games.presentation.elements.SpikyShell;
import com.ukuleledog.games.presentation.elements.Star;
import com.ukuleledog.games.presentation.elements.Terra;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import com.ukuleledog.games.presentation.elements.SplashThree;
import flash.display.Bitmap;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Keyboard;
import flash.utils.Timer;
import motion.Actuate;
import motion.easing.Bounce;
import motion.easing.Elastic;
import motion.easing.Expo;
import openfl.Assets;

/**
 * ...
 * @author Matt
 */
class FightState extends State
{
	
	private var introTimer:Timer;
	
	private var background:Bitmap;
	
	private var hud:Bitmap;
	private var ennemyName:Bitmap;
	
	private var mario:Mario;
	private var tube:Bitmap;
	private var octo:Bitmap;
	private var terra:Terra;
	private var edgar:Edgar;
	private var locke:Locke;
	private var celes:Celes;
	
	private var lifeTerra:Bitmap;
	private var lifeEdgar:Bitmap;
	private var lifeLocke:Bitmap;
	private var lifeCeles:Bitmap;
	private var emptyLife:BitmapData;
	
	private var timerTerra:Timer;
	private var timerEdgar:Timer;
	private var timerLocke:Timer;
	private var timerCeles:Timer;
	private var timerMario:Timer;
	private var terraLoad:UInt = 0;
	private var edgarLoad:UInt = 0;
	private var lockeLoad:UInt = 0;
	private var celesLoad:UInt = 0;
	private var terraLoadBar:Bitmap;
	private var edgarLoadBar:Bitmap;
	private var lockeLoadBar:Bitmap;
	private var celesLoadBar:Bitmap;
	private var timerTerraAttack:Timer;
	private var timerEdgarAttack:Timer;
	private var timerLockeAttack:Timer;
	private var timerCelesAttack:Timer;
	private var terraAttackAnimation:Fire3;
	private var lockAttackAnimation:Bitmap;
	
	private var cursorPosition:UInt = 0;
	private var cursor:Bitmap;
	private var menuMain:Bitmap;
	private var menuPrizee:Bitmap;
	private var menuF4:Bitmap;
	private var menuUbi:Bitmap;
	
	private var attackCount:UInt = 0;
	private var star:Star;
	private var shell:Bitmap;
	private var spikyShell:SpikyShell;
	private var fireball:Fireball;
	private var stomp:Bitmap;
	
	public function new() 
	{
		super();
		
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		removeEventListener( Event.ADDED_TO_STAGE, init );
		
		var tempData:BitmapData = Assets.getBitmapData("img/ff6-sprite.png", true);
		
		var backgroundData:BitmapData = new BitmapData(240, 147, false);
		backgroundData.copyPixels(tempData, new Rectangle(0, 0, 240, 147), new Point(0, 0));
		background = new Bitmap(backgroundData);
		background.x = 7;
		background.y = 10;
		addChild(background);
		
		var tempOctoData:BitmapData = new BitmapData(64, 47, true);
		tempOctoData.copyPixels( tempData, new Rectangle(0, 195, 64, 47), new Point(0, 0) );
		octo = new Bitmap(tempOctoData);
		octo.y = 120;
		octo.x = 30;
		addChild(octo);
		
		mario = new Mario();
		addChild(mario);
		mario.setAnimation('super-jump');
		mario.x = 42;
		mario.y = 0;
		timerMario = new Timer(7500);
		timerMario.addEventListener( TimerEvent.TIMER, marioAttack );
				
		terra = new Terra();
		terra.x = 190;
		terra.y = 70;
		addChild( terra );
		timerTerra = new Timer(50);
		timerTerra.addEventListener( TimerEvent.TIMER, terraAttack );
				
		locke = new Locke();
		locke.x = 195;
		locke.y = 90;
		addChild( locke );
		timerLocke = new Timer(80);
		timerLocke.addEventListener( TimerEvent.TIMER, lockeAttack );
		
		celes = new Celes();
		celes.x = 200;
		celes.y = 110;
		addChild( celes );
		timerCeles = new Timer(120);
		timerCeles.addEventListener( TimerEvent.TIMER, celesAttack );
		
		edgar = new Edgar();
		edgar.x = 205;
		edgar.y = 130;
		addChild( edgar );
		timerEdgar = new Timer(60);
		timerEdgar.addEventListener( TimerEvent.TIMER, edgarAttack );
		
		var tempTubeData:BitmapData = new BitmapData(32, 48, true);
		tempTubeData.copyPixels( tempData, new Rectangle(0, 147,32,48), new Point(0,0) );
		tube = new Bitmap(tempTubeData);
		tube.scaleY = -1;
		tube.x = 35;
		tube.y = 26;
		addChild( tube );
		
		var tempData:BitmapData = Assets.getBitmapData("img/ff6-sprite.png", true);
		var tempIce:BitmapData = new BitmapData(80, 96, true);
		tempIce.copyPixels(tempData, new Rectangle(0, 656, 80, 96), new Point(0, 0) );
		lockAttackAnimation = new Bitmap(tempIce);
		lockAttackAnimation.alpha = 0.7;
		lockAttackAnimation.y = 80;
		lockAttackAnimation.x = 10;
		lockAttackAnimation.alpha = 0;
		addChild(lockAttackAnimation);
		
		var tempHudData:BitmapData = new BitmapData(240, 55, false);
		tempHudData.copyPixels( tempData, new Rectangle(0, 360, 240, 55), new Point(0, 0));
		hud = new Bitmap(tempHudData);
		hud.x = 7;
		hud.y = 160;
		addChild(hud);
		
		var tempEnnemy:BitmapData = new BitmapData(31, 8, true);
		tempEnnemy.copyPixels( tempData, new Rectangle(0, 420, 31, 8), new Point(0, 0) );
		ennemyName = new Bitmap(tempEnnemy);
		ennemyName.x = 15;
		ennemyName.y = 170;
		addChild(ennemyName);
		
		var tempMenuMain:BitmapData = new BitmapData(80, 55, true);
		tempMenuMain.copyPixels( tempData, new Rectangle(0, 460, 80, 55), new Point(0, 0) );
		menuMain = new Bitmap(tempMenuMain);
		menuMain.x = 20;
		menuMain.y = 165;
		
		var tempMenuPrizee:BitmapData = new BitmapData(80, 55, true);
		tempMenuPrizee.copyPixels( tempData, new Rectangle(80, 460, 80, 55), new Point(0, 0) );
		menuPrizee = new Bitmap(tempMenuPrizee);
		menuPrizee.x = 25;
		menuPrizee.y = 170;
		
		var tempMenuF4:BitmapData = new BitmapData(80, 55, true);
		tempMenuF4.copyPixels( tempData, new Rectangle(160, 460, 80, 55), new Point(0, 0) );
		menuF4 = new Bitmap(tempMenuF4);
		menuF4.x = 25;
		menuF4.y = 170;
		
		var tempMenuUbi:BitmapData = new BitmapData(80, 55, true);
		tempMenuUbi.copyPixels( tempData, new Rectangle(240, 460, 80, 55), new Point(0, 0) );
		menuUbi = new Bitmap(tempMenuUbi);
		menuUbi.x = 25;
		menuUbi.y = 170;
		
		var tempCursor:BitmapData = new BitmapData(16, 16, true);
		tempCursor.copyPixels( tempData, new Rectangle(0, 430, 16, 16), new Point(0, 0) );
		cursor = new Bitmap(tempCursor);
		cursor.x = 13;
		cursor.y = 169;
	
		var tempLife:BitmapData = new BitmapData(32, 8, true);
		tempLife.copyPixels( tempData, new Rectangle(60, 450, 32, 8), new Point(0, 0) );
		
		emptyLife = new BitmapData(32, 8, true);
		emptyLife.copyPixels( tempData, new Rectangle(20, 450, 32, 8), new Point(0, 0) );
		
		lifeTerra = new Bitmap(tempLife);
		lifeTerra.x = 150;
		lifeTerra.y = 170;
		addChild( lifeTerra );
		
		lifeEdgar = new Bitmap(tempLife);
		lifeEdgar.x = 150;
		lifeEdgar.y = 200;
		addChild( lifeEdgar );
		
		lifeLocke = new Bitmap(tempLife);
		lifeLocke.x = 150;
		lifeLocke.y = 180;
		addChild( lifeLocke );
		
		lifeCeles = new Bitmap(tempLife);
		lifeCeles.x = 150;
		lifeCeles.y = 190;
		addChild( lifeCeles );
		
		var tempLoadBar:BitmapData = new BitmapData(1, 3, false);
		tempLoadBar.copyPixels( tempData, new Rectangle(30, 430, 1, 3), new Point(0, 0) );
		
		terraLoadBar = new Bitmap(tempLoadBar);
		terraLoadBar.scaleX = 0;
		terraLoadBar.x = 190;
		terraLoadBar.y = 173;
		addChild(terraLoadBar);
		
		edgarLoadBar = new Bitmap(tempLoadBar);
		edgarLoadBar.scaleX = 0;
		edgarLoadBar.x = 190;
		edgarLoadBar.y = 203;
		addChild(edgarLoadBar);
		
		lockeLoadBar = new Bitmap(tempLoadBar);
		lockeLoadBar.scaleX = 0;
		lockeLoadBar.x = 190;
		lockeLoadBar.y = 183;
		addChild(lockeLoadBar);
		
		celesLoadBar = new Bitmap(tempLoadBar);
		celesLoadBar.scaleX = 0;
		celesLoadBar.x = 190;
		celesLoadBar.y = 193;
		addChild(celesLoadBar);
		
		this.scaleX = 2;
		this.scaleY = 2;
		
		musicChannel = Assets.getSound("snd/smb3_pipe.wav",true).play();
		musicChannel.addEventListener( Event.SOUND_COMPLETE, introTwo );
		Actuate.tween( mario, 1.5, { y : 25 } );
	}
	
	private function introTwo( e:Event )
	{
		musicChannel.removeEventListener( Event.SOUND_COMPLETE, introTwo );
		
		introTimer = new Timer(1000);
		introTimer.addEventListener( TimerEvent.TIMER, introThree );
		introTimer.start();
						
		Actuate.tween( mario, 1.5, { y : 120 } ).ease(Bounce.easeOut);
		Assets.getSound("snd/smb3_stomp.wav", true).play();
	}
	
	private function introThree( e:TimerEvent )
	{
		introTimer.removeEventListener( TimerEvent.TIMER, introThree );
		introTimer.stop();
		introTimer = null;
		
		Actuate.tween( octo, 0.5, { alpha: 0 } ).onComplete(introFour);
		Actuate.tween( ennemyName, 0.5, { alpha: 0 } );
		
		mario.setAnimation('super-idle');		
		
	}
	
	private function introFour()
	{
		Actuate.tween( tube, 2, { y:0 } );
		musicChannel = Assets.getMusic("music/ff6.mp3").play();
		
		removeChild(ennemyName);
		var tempData:BitmapData = Assets.getBitmapData("img/ff6-sprite.png", true);
		var tempEnnemy:BitmapData = new BitmapData(54, 8, true);
		tempEnnemy.copyPixels( tempData, new Rectangle(40, 420, 54, 8), new Point(0, 0) );
		ennemyName = new Bitmap(tempEnnemy);
		ennemyName.x = 15;
		ennemyName.y = 170;
		ennemyName.alpha = 0;
		addChild(ennemyName);
		Actuate.tween( ennemyName, 0.5, { alpha: 1 } );
		
		addChild(menuMain);
		addChild(cursor);
		
		stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandle );
	}
	
	private function resetCursor()
	{
		cursorPosition = 0;
		removeChild(cursor);
		cursor.x = 13;
		cursor.y = 169;
		addChild( cursor );
	}
	
	private function keyDownHandle( e:KeyboardEvent )
	{
	
		switch( cursorPosition )
		{
			
			case 0: // main prizee
				
				if ( e.keyCode == Keyboard.DOWN )
				{
					cursorPosition = 1;
					cursor.y = 179;
				} else if ( e.keyCode == Keyboard.SPACE )
				{
					removeChild(cursor);
					addChild( menuPrizee );
					cursorPosition = 3;
					cursor.y = 180;
					cursor.x = 16;
					addChild(cursor);
				}
			case 1: // main f4
				if ( e.keyCode == Keyboard.DOWN )
				{
					cursorPosition = 2;
					cursor.y = 189;
				} else if ( e.keyCode == Keyboard.UP )
				{
					cursorPosition = 0;
					cursor.y = 169;
				} else if ( e.keyCode == Keyboard.SPACE )
				{
					removeChild(cursor);
					addChild( menuF4 );
					cursorPosition = 5;
					cursor.y = 180;
					cursor.x = 16;
					addChild(cursor);
				}
			case 2: // main ubi
				if ( e.keyCode == Keyboard.UP )
				{
					cursorPosition = 1;
					cursor.y = 179;
				} else if ( e.keyCode == Keyboard.SPACE )
				{
					removeChild(cursor);
					addChild( menuUbi );
					cursorPosition = 6;
					cursor.y = 180;
					cursor.x = 16;
					addChild(cursor);
				}
			case 3: // prizee 1
				if ( e.keyCode == Keyboard.DOWN )
				{
					cursorPosition = 4;
					cursor.y = 200;
				} else if ( e.keyCode == Keyboard.ESCAPE )
				{
					removeChild(menuPrizee);
					resetCursor();
				} else if ( e.keyCode == Keyboard.SPACE )
				{
					removeChild(menuPrizee);
					attack(1);
				}
			case 4: // prizee 2
				if ( e.keyCode == Keyboard.UP )
				{
					cursorPosition = 3;
					cursor.y = 180;
				} else if ( e.keyCode == Keyboard.ESCAPE )
				{
					removeChild(menuPrizee);
					resetCursor();
				} else if ( e.keyCode == Keyboard.SPACE )
				{
					removeChild(menuPrizee);
					attack(2);
				}
			case 5: // f4 1
				if  ( e.keyCode == Keyboard.ESCAPE )
				{
					removeChild(menuF4);
					resetCursor();
				} else if ( e.keyCode == Keyboard.SPACE )
				{
					removeChild(menuF4);
					attack(3);
				}
			case 6: // ubi 1
				if  ( e.keyCode == Keyboard.DOWN )
				{
					cursorPosition = 7;
					cursor.y = 195;
				}  else if ( e.keyCode == Keyboard.ESCAPE )
				{
					removeChild(menuUbi);
					resetCursor();
				} else if ( e.keyCode == Keyboard.SPACE )
				{
					removeChild(menuUbi);
					attack(4);
				}
			case 7: // ubi 2
				if  ( e.keyCode == Keyboard.DOWN )
				{
					cursorPosition = 8;
					cursor.y = 205;
				}  else if  ( e.keyCode == Keyboard.UP )
				{
					cursorPosition = 6;
					cursor.y = 180;
				}  else if ( e.keyCode == Keyboard.ESCAPE )
				{
					removeChild(menuUbi);
					resetCursor();
				} else if ( e.keyCode == Keyboard.SPACE )
				{
					removeChild(menuUbi);
					attack(5);
				}
			case 8: // ubi3
				if  ( e.keyCode == Keyboard.UP )
				{
					cursorPosition = 7;
					cursor.y = 195;
				}  else if ( e.keyCode == Keyboard.ESCAPE )
				{
					removeChild(menuUbi);
					resetCursor();
				} else if ( e.keyCode == Keyboard.SPACE )
				{
					removeChild(menuUbi);
					attack(6);
				}
			
		}	
	
	}
	
	private function marioAttack( e:TimerEvent )
	{
		timerMario.stop();
		addChild(menuMain);
		addChild(cursor);
		stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandle );
	}
	
	private function attack( type:UInt )
	{
		stopTimers();
		stage.removeEventListener( KeyboardEvent.KEY_DOWN, keyDownHandle );
		resetCursor();
		removeChild(cursor);
		removeChild(menuMain);
		
		if ( attackCount == 0 )
		{
			
			star = new Star();
			star.x = 42;
			star.y = 0;
			addChild( star );
			
			Actuate.tween( star, 0.5, {y:120} ).onComplete(
				function() {
					removeChild( star );
					attackCount++;
					startTimers();
				}
			);
			
		}
		else if ( attackCount == 1 )
		{
			
			var tempData:BitmapData = Assets.getBitmapData("img/ff6-sprite.png", true);
			var tempShell:BitmapData = new BitmapData(16, 16, true);
			tempShell.copyPixels( tempData, new Rectangle(48, 515, 16, 16), new Point(0, 0) );
			shell = new Bitmap(tempShell);
			shell.x = 190;
			shell.y = -16;
			addChild(shell);
			
			terra.setAnimation('hurt');
			
			Actuate.tween(shell, 1, { y:70 } ).ease( Bounce.easeOut ).onComplete(function() {
				removeChild(shell);
				attackCount++;
				var index:Int = getChildIndex(lifeTerra);
				var myX:Float = lifeTerra.x;
				var myY:Float = lifeTerra.y;
				removeChild(lifeTerra);
				lifeTerra = new Bitmap(emptyLife);
				lifeTerra.x = myX;
				lifeTerra.y = myY;
				addChildAt(lifeTerra, index);
				terraLoadBar.scaleX = 0;
				startTimers();
			});
			
		}
		else if ( attackCount == 2 )
		{
			
			spikyShell = new SpikyShell();
			spikyShell.x = 195;
			spikyShell.y = -16;
			addChild(spikyShell);
			
			locke.setAnimation('hurt');
			
			Actuate.tween(spikyShell, 1, { y:90 } ).ease( Bounce.easeOut ).onComplete(function() {
				removeChild(spikyShell);
				attackCount++;
				var index:Int = getChildIndex(lifeLocke);
				var myX:Float = lifeLocke.x;
				var myY:Float = lifeLocke.y;
				removeChild(lifeLocke);
				lifeLocke = new Bitmap(emptyLife);
				lifeLocke.x = myX;
				lifeLocke.y = myY;
				addChildAt(lifeLocke, index);
				lockeLoadBar.scaleX = 0;
				startTimers();
			});
			
		}
		else if ( attackCount == 3 )
		{
			
			fireball = new Fireball();
			fireball.x = 200;
			fireball.y = -16;
			addChild(fireball);
			
			celes.setAnimation('hurt');
			
			Actuate.tween(fireball, 1, { y:110 } ).onComplete(function() {
				removeChild(fireball);
				attackCount++;
				var index:Int = getChildIndex(lifeCeles);
				var myX:Float = lifeCeles.x;
				var myY:Float = lifeCeles.y;
				removeChild(lifeCeles);
				lifeCeles = new Bitmap(emptyLife);
				lifeCeles.x = myX;
				lifeCeles.y = myY;
				addChildAt(lifeCeles, index);
				celesLoadBar.scaleX = 0;
				startTimers();
			});
			
		}
		else
		{
			
			var tempData:BitmapData = Assets.getBitmapData("img/ff6-sprite.png", true);
			var tempStomp:BitmapData = new BitmapData(24, 32, true);
			tempStomp.copyPixels( tempData, new Rectangle(0, 531, 24, 32), new Point(0, 0) );
			stomp = new Bitmap(tempStomp);
			stomp.x = 200;
			stomp.y = -16;
			addChild(stomp);
			
			edgar.setAnimation('hurt');
			
			Actuate.tween(stomp, 1, { y:130 } ).ease( Bounce.easeOut ).onComplete(function() {
				removeChild(stomp);
				attackCount++;
				var index:Int = getChildIndex(lifeEdgar);
				var myX:Float = lifeEdgar.x;
				var myY:Float = lifeEdgar.y;
				removeChild(lifeEdgar);
				lifeEdgar = new Bitmap(emptyLife);
				lifeEdgar.x = myX;
				lifeEdgar.y = myY;
				addChildAt(lifeEdgar, index);
				edgarLoadBar.scaleX = 0;
				startTimers();
			});
			
		}
		
	}
	
	private function startTimers()
	{
		timerTerra.start();
		timerEdgar.start();
		timerLocke.start();
		timerCeles.start();
		timerMario.start();
	}
	
	private function stopTimers()
	{
		timerTerra.stop();
		timerEdgar.stop();
		timerLocke.stop();
		timerCeles.stop();
		//timerMario.stop();
	}
	
	private function terraAttack( e:TimerEvent )
	{
		
		if ( attackCount >= 2 )
		{
			//timerTerra.removeEventListener(TimerEvent.TIMER, terraAttack);
			terra.setAnimation('dead');
			return;
		}
		
		terraLoad++;
		terraLoadBar.scaleX = (terraLoad * 43) / 100;
		
		if ( terraLoad == 100 )
		{
			terraLoad = 0;
			stopTimers();
			terra.setAnimation('fight');
			
			timerTerraAttack = new Timer(1000);
			timerTerraAttack.addEventListener( TimerEvent.TIMER, terraAttackEnd );
			timerTerraAttack.start();
			
			terraAttackAnimation = new Fire3();
			terraAttackAnimation.y = 80;
			addChild( terraAttackAnimation );
			
		}
	}
	
	private function terraAttackEnd( e:TimerEvent )
	{		
		timerTerraAttack.removeEventListener( TimerEvent.TIMER, terraAttackEnd );
		timerTerraAttack.stop();
		timerTerraAttack = null;
	
		terraLoadBar.scaleX = 0;
		
		Actuate.tween( terraAttackAnimation, 0.5, { alpha: 0 } ).onComplete(function() {
			removeChild( terraAttackAnimation );
		} );

		terra.setAnimation('idle');
		startTimers();
	}
	
	private function edgarAttack( e:TimerEvent )
	{
		if ( attackCount >= 5 )
		{
			//timerEdgar.removeEventListener(TimerEvent.TIMER, edgarAttack);
			edgar.setAnimation('dead');
			endState();
			return;
		}
		
		edgarLoad++;
		edgarLoadBar.scaleX = (edgarLoad * 43) / 100;
		
		if ( edgarLoad == 100 )
		{
			edgarLoad = 0;
			stopTimers();
			edgar.setAnimation('fight');
			
			timerEdgarAttack = new Timer(2000);
			timerEdgarAttack.addEventListener( TimerEvent.TIMER, edgarAttackEnd );
			timerEdgarAttack.start();
			
			Actuate.tween( edgar, 1, { x:40 } ).ease( Bounce.easeOut ).onComplete(function() {
				Actuate.tween(edgar, 1, { x:185 } ).onComplete(function() {
					edgar.x = 205;
				});
			});
			
		}
	}
	
	private function edgarAttackEnd( e:TimerEvent )
	{
		timerEdgarAttack.removeEventListener( TimerEvent.TIMER, edgarAttackEnd );
		timerEdgarAttack.stop();
		timerEdgarAttack = null;
		
		edgarLoadBar.scaleX = 0;
		edgar.setAnimation('idle');
		startTimers();
	}
	
	private function lockeAttack( e:TimerEvent )
	{
		
		if ( attackCount >= 3 )
		{
			//timerLocke.removeEventListener(TimerEvent.TIMER, lockeAttack);
			locke.setAnimation('dead');
			return;
		}
		
		lockeLoad++;
		lockeLoadBar.scaleX = (lockeLoad * 43) / 100;
		
		if ( lockeLoad == 100 )
		{
			lockeLoad = 0;
			stopTimers();
			locke.setAnimation('fight');
			
			timerLockeAttack = new Timer(2000);
			timerLockeAttack.addEventListener( TimerEvent.TIMER, lockeAttackEnd );
			timerLockeAttack.start();
			
			lockAttackAnimation.alpha = 0.7;
		}
	}
	
	private function lockeAttackEnd( e:TimerEvent )
	{
		timerLockeAttack.removeEventListener( TimerEvent.TIMER, lockeAttackEnd );
		timerLockeAttack.stop();
		timerLockeAttack = null;
		
		lockAttackAnimation.alpha = 0;
		
		lockeLoadBar.scaleX = 0;
		locke.setAnimation('idle');
		startTimers();
	}
	
	private function celesAttack( e:TimerEvent )
	{
		if ( attackCount >= 4 )
		{
			//timerCeles.removeEventListener(TimerEvent.TIMER, celesAttack);
			celes.setAnimation('dead');
			return;
		}
		
		celesLoad++;
		celesLoadBar.scaleX = (celesLoad * 43) / 100;
		
		if ( celesLoad == 100 )
		{
			celesLoad = 0;
			stopTimers();
			celes.setAnimation('fight');
			
			timerCelesAttack = new Timer(2000);
			timerCelesAttack.addEventListener( TimerEvent.TIMER, celesAttackEnd );
			timerCelesAttack.start();
		}
	}
	
	private function celesAttackEnd( e:TimerEvent )
	{
		timerCelesAttack.removeEventListener( TimerEvent.TIMER, celesAttackEnd );
		timerCelesAttack.stop();
		timerCelesAttack = null;
				
		celesLoadBar.scaleX = 0;
		celes.setAnimation('idle');
		startTimers();
	}
	
	private function endState()
	{
		timerMario.stop();
		stopTimers();
		
		var screen:Sprite = new Sprite();
		screen.graphics.beginFill(0x000000);
		screen.graphics.drawRect(0, 0, 256, 224);
		screen.alpha = 0;
		addChild(screen);
		
		Actuate.tween( terra, 2, { alpha:0 } ).ease(Bounce.easeOut);
		Actuate.tween( locke, 2, { alpha:0 } ).ease(Bounce.easeOut);
		Actuate.tween( celes, 2, { alpha:0 } ).ease(Bounce.easeOut);
		Actuate.tween( edgar, 2, { alpha:0 } ).ease(Bounce.easeOut).onComplete(function(){
		
			var tempData:BitmapData = Assets.getBitmapData("img/ff6-sprite.png", true);
			var tempOctoData:BitmapData = new BitmapData(64, 47, true);
			tempOctoData.copyPixels( tempData, new Rectangle(0, 195, 64, 47), new Point(0, 0) );
			octo = new Bitmap(tempOctoData);
			octo.y = 120;
			octo.x = -30;
			addChild(octo);
			
			mario.setAnimation('super-walk');
			Actuate.tween(mario, 5, { x:340 } );
			Actuate.tween(octo, 5, { x:280 } ).onComplete(function() {
				Actuate.tween(musicChannel.soundTransform, 2, { volume:0 } );
				Actuate.tween(screen, 5, { alpha:1 } ).onComplete(function() {
					musicChannel.stop();
					dispatchEvent(new Event(Event.COMPLETE));
				});
			});
		
		});
	}
	
}