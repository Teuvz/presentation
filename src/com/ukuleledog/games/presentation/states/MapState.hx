package com.ukuleledog.games.presentation.states;
import com.ukuleledog.games.presentation.elements.Cactus;
import com.ukuleledog.games.presentation.elements.Hammer;
import com.ukuleledog.games.presentation.elements.HelpCry;
import com.ukuleledog.games.presentation.elements.MapMario;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.net.URLRequest;
import flash.ui.Keyboard;
import flash.utils.Timer;
import motion.Actuate;
import openfl.Assets;

/**
 * ...
 * @author Matt
 */
class MapState extends State
{
	
	private var mario:MapMario;
	private var position:UInt = 0;
	
	private var background:Sprite;
	
	private var hammer:Hammer;
	private var hammerTimer:Timer;
	private var hammerPosition:UInt = 0;
	
	private var closingMask:Sprite;
	
	public function new() 
	{
		super();
		
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		removeEventListener( Event.ADDED_TO_STAGE, init );
		
		var tempData:BitmapData = Assets.getBitmapData("img/map-sprite.png",true);
		
		var backgroundData:BitmapData = new BitmapData(234, 162, true);
		backgroundData.copyPixels(tempData, new Rectangle(0, 64, 234, 162), new Point(0, 0) );
		background = new Sprite();
		background.addChild( new Bitmap(backgroundData) );
		background.x = 10;
		background.y = 15;
		addChild(background);
		
		mario = new MapMario();
		mario.x = 31;
		mario.y = 52;
		addChild(mario);
		
		generateCactus();
		
		hammer = new Hammer();
		hammer.x = 135;
		hammer.y = 118;
		addChild( hammer );
		
		hammerTimer = new Timer(2000);
		hammerTimer.addEventListener( TimerEvent.TIMER, hammerHandle );
		hammerTimer.start();
		
		var help:HelpCry = new HelpCry();
		help.x = 200;
		help.y = 100;
		addChild(help);
		
		musicChannel = Assets.getMusic("music/map.mp3").play();
		
		Assets.getSound("snd/smb3_hammer_bros_shuffle.wav").play();
		
		closingMask = new Sprite();
		closingMask.graphics.beginFill(0x000000);
		closingMask.graphics.drawRect(-256, -224, 512, 448);
		closingMask.graphics.endFill();
		closingMask.x = 128;
		closingMask.y = 112;
		
		stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandle );
	}
	
	private function close()
	{	
		addChild(closingMask);
		this.mask = closingMask;
		Actuate.tween (closingMask, 1, { width: 0, height: 0 } ).onComplete (end);
		musicChannel.stop();
		Assets.getSound("snd/smb3_enter_level.wav").play();
	}
	
	private function end()
	{
		dispatchEvent(new Event(Event.COMPLETE));
	}
	
	private function hammerHandle( e:TimerEvent )
	{
		
		switch( hammerPosition )
		{
			case 0:
				Actuate.tween( hammer, 2, { x: 165 } );
				hammerPosition = 1;
			case 1:
				hammer.scaleX = -1;
				Actuate.tween( hammer, 2, { x: 145 } );
				hammerPosition = 2;
			case 2:
				Actuate.tween( hammer, 2, { y: 147 } );
				hammerPosition = 3;
			case 3:
				Actuate.tween( hammer, 2, { x: 110 } );
				hammerPosition = 4;
			case 4:
				hammer.scaleX = 1;
				Actuate.tween( hammer, 2, { x: 135 } );
				hammerPosition = 5;
			case 5:
				hammer.scaleX = 1;
				Actuate.tween( hammer, 2, { y: 118 } );
				hammerPosition = 0;
		}
	}
	
	private function keyDownHandle( e:KeyboardEvent )
	{
		if ( e.keyCode == Keyboard.RIGHT && position == 0 )
		{
			Actuate.tween(mario, 1, { x: 63 } );
			position = 1;
			Assets.getSound("snd/smb3_map_travel.wav",true).play();
		} else if ( e.keyCode == Keyboard.UP && position == 1 )
		{
			Actuate.tween(mario, 1, { y: 20 } );
			position = 2;
			Assets.getSound("snd/smb3_map_travel.wav",true).play();
		} else if ( e.keyCode == Keyboard.DOWN && position == 2 )
		{
			Actuate.tween(mario, 1, { y: 52 } );
			position = 1;
			Assets.getSound("snd/smb3_map_travel.wav",true).play();
		}  else if ( e.keyCode == Keyboard.LEFT && position == 1 )
		{
			Actuate.tween(mario, 1, { x: 31 } );
			position = 0;
			Assets.getSound("snd/smb3_map_travel.wav",true).play();
		} else if ( e.keyCode == Keyboard.SPACE && position == 2 ) {
			stage.removeEventListener( KeyboardEvent.KEY_DOWN, keyDownHandle );
			close();
		}
	}
		
	private function generateCactus()
	{
		var cactus11:Cactus = new Cactus();
		cactus11.x = 5;
		cactus11.y = 6;
		background.addChild(cactus11);
		
		var cactus12:Cactus = new Cactus();
		cactus12.x = 21;
		cactus12.y = 6;
		background.addChild(cactus12);
		
		var cactus13:Cactus = new Cactus();
		cactus13.x = 37;
		cactus13.y = 6;
		background.addChild(cactus13);
		
		var cactus14:Cactus = new Cactus();
		cactus14.x = 197;
		cactus14.y = 6;
		background.addChild(cactus14);
		
		var cactus15:Cactus = new Cactus();
		cactus15.x = 213;
		cactus15.y = 6;
		background.addChild(cactus15);
		
		//////////////////////////////
		
		var cactus21:Cactus = new Cactus();
		cactus21.x = 5;
		cactus21.y = 22;
		background.addChild(cactus21);
		
		var cactus22:Cactus = new Cactus();
		cactus22.x = 21;
		cactus22.y = 22;
		background.addChild(cactus22);
		
		var cactus23:Cactus = new Cactus();
		cactus23.x = 37;
		cactus23.y = 22;
		background.addChild(cactus23);
		
		var cactus24:Cactus = new Cactus();
		cactus24.x = 69;
		cactus24.y = 22;
		background.addChild(cactus24);
		
		var cactus25:Cactus = new Cactus();
		cactus25.x = 85;
		cactus25.y = 22;
		background.addChild(cactus25);
		
		var cactus26:Cactus = new Cactus();
		cactus26.x = 101;
		cactus26.y = 22;
		background.addChild(cactus26);
		
		var cactus27:Cactus = new Cactus();
		cactus27.x = 133;
		cactus27.y = 22;
		background.addChild(cactus27);
		
		var cactus28:Cactus = new Cactus();
		cactus28.x = 149;
		cactus28.y = 22;
		background.addChild(cactus28);
		
		var cactus29:Cactus = new Cactus();
		cactus29.x = 165;
		cactus29.y = 22;
		background.addChild(cactus29);
		
		var cactus210:Cactus = new Cactus();
		cactus210.x = 197;
		cactus210.y = 22;
		background.addChild(cactus210);
		
		var cactus211:Cactus = new Cactus();
		cactus211.x = 213;
		cactus211.y = 22;
		background.addChild(cactus211);
		
		//////////////////////////////
		
		var cactus31:Cactus = new Cactus();
		cactus31.x = 69;
		cactus31.y = 38;
		background.addChild(cactus31);
		
		var cactus32:Cactus = new Cactus();
		cactus32.x = 85;
		cactus32.y = 38;
		background.addChild(cactus32);
		
		var cactus33:Cactus = new Cactus();
		cactus33.x = 101;
		cactus33.y = 38;
		background.addChild(cactus33);
		
		var cactus34:Cactus = new Cactus();
		cactus34.x = 197;
		cactus34.y = 38;
		background.addChild(cactus34);
		
		var cactus35:Cactus = new Cactus();
		cactus35.x = 213;
		cactus35.y = 38;
		background.addChild(cactus35);
		
		//////////////////////////////
		
		var cactus41:Cactus = new Cactus();
		cactus41.x = 5;
		cactus41.y = 54;
		background.addChild(cactus41);
		
		var cactus42:Cactus = new Cactus();
		cactus42.x = 21;
		cactus42.y = 54;
		background.addChild(cactus42);
		
		var cactus43:Cactus = new Cactus();
		cactus43.x = 37;
		cactus43.y = 54;
		background.addChild(cactus43);
		
		var cactus44:Cactus = new Cactus();
		cactus44.x = 69;
		cactus44.y = 54;
		background.addChild(cactus44);
		
		var cactus45:Cactus = new Cactus();
		cactus45.x = 85;
		cactus45.y = 54;
		background.addChild(cactus45);
		
		var cactus46:Cactus = new Cactus();
		cactus46.x = 101;
		cactus46.y = 54;
		background.addChild(cactus46);
		
		var cactus47:Cactus = new Cactus();
		cactus47.x = 133;
		cactus47.y = 54;
		background.addChild(cactus47);
		
		var cactus48:Cactus = new Cactus();
		cactus48.x = 149;
		cactus48.y = 54;
		background.addChild(cactus48);
		
		var cactus49:Cactus = new Cactus();
		cactus49.x = 165;
		cactus49.y = 54;
		background.addChild(cactus49);
		
		var cactus410:Cactus = new Cactus();
		cactus410.x = 197;
		cactus410.y = 54;
		background.addChild(cactus410);
		
		var cactus411:Cactus = new Cactus();
		cactus411.x = 181;
		cactus411.y = 54;
		background.addChild(cactus411);
		
		var cactus412:Cactus = new Cactus();
		cactus412.x = 213;
		cactus412.y = 54;
		background.addChild(cactus412);
		
		//////////////////////////////
		
		var cactus51:Cactus = new Cactus();
		cactus51.x = 5;
		cactus51.y = 70;
		background.addChild(cactus51);
		
		var cactus52:Cactus = new Cactus();
		cactus52.x = 21;
		cactus52.y = 70;
		background.addChild(cactus52);
		
		var cactus53:Cactus = new Cactus();
		cactus53.x = 37;
		cactus53.y = 70;
		background.addChild(cactus53);
		
		var cactus54:Cactus = new Cactus();
		cactus54.x = 133;
		cactus54.y = 70;
		background.addChild(cactus54);
		
		var cactus55:Cactus = new Cactus();
		cactus55.x = 149;
		cactus55.y = 70;
		background.addChild(cactus55);
		
		var cactus56:Cactus = new Cactus();
		cactus56.x = 213;
		cactus56.y = 70;
		background.addChild(cactus56);
		
		//////////////////////////////
		
		var cactus61:Cactus = new Cactus();
		cactus61.x = 5;
		cactus61.y = 86;
		background.addChild(cactus61);
		
		var cactus62:Cactus = new Cactus();
		cactus62.x = 69;
		cactus62.y = 86;
		background.addChild(cactus62);
		
		var cactus63:Cactus = new Cactus();
		cactus63.x = 85;
		cactus63.y = 86;
		background.addChild(cactus63);
		
		var cactus64:Cactus = new Cactus();
		cactus64.x = 101;
		cactus64.y = 86;
		background.addChild(cactus64);
		
		var cactus65:Cactus = new Cactus();
		cactus65.x = 117;
		cactus65.y = 86;
		background.addChild(cactus65);
		
		var cactus66:Cactus = new Cactus();
		cactus66.x = 213;
		cactus66.y = 86;
		background.addChild(cactus66);
	
		//////////////////////////////
		
		var cactus71:Cactus = new Cactus();
		cactus71.x = 213;
		cactus71.y = 102;
		background.addChild(cactus71);
		
		//////////////////////////////
		
		var cactus81:Cactus = new Cactus();
		cactus81.x = 213;
		cactus81.y = 118;
		background.addChild(cactus81);
		
		//////////////////////////////
		
		var cactus91:Cactus = new Cactus();
		cactus91.x = 213;
		cactus91.y = 134;
		background.addChild(cactus91);
		
	}
	
}