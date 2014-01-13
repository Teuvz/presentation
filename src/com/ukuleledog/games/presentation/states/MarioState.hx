package com.ukuleledog.games.presentation.states;
import com.ukuleledog.games.presentation.elements.Mario;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.media.SoundChannel;
import flash.ui.Keyboard;
import openfl.Assets;
import phx.col.AABB;
import phx.World;

/**
 * ...
 * @author Matt
 */
class MarioState extends State
{

	private var keyPressed:Bool = false;
	private var pressedKey:UInt = 0;
	
	private var world:World;
	
	private var level:Sprite;
	private var mario:Mario;
	
	public function new() 
	{
		super();
		
		initWorld();
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		removeEventListener( Event.ADDED_TO_STAGE, init );	
		
		var tempData:BitmapData = Assets.getBitmapData("img/mario-sprite.png", true);
		
		var backgroundData:BitmapData = new BitmapData(2000,432, false);
		backgroundData.copyPixels(tempData, new Rectangle(0, 272, 2000, 432), new Point(0, 0));
		level = new Sprite();
		level.addChild( new Bitmap(backgroundData) );
		addChild(level);
		
		var floor = phx.Shape.makeBox(2000,50,0,116);
        world.addStaticShape(floor);
		
		mario = new Mario();
		level.addChild(mario);
		world.addBody(mario.getBody());
			
		//musicChannel = Assets.getMusic("music/mario.mp3").play();
		
		stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandle );
		stage.addEventListener( KeyboardEvent.KEY_UP, keyUpHandle );
		addEventListener( Event.ENTER_FRAME, loop );
	}
	
	private function initWorld()
	{
		var size = new phx.col.AABB(0, 0, 2000, 2000);
        var bf = new phx.col.SortedList();
        world = new phx.World(size, bf);
		world.gravity = new phx.Vector(0,0.9);
		//world.debug = true;
	}
	
	private function keyDownHandle( e:KeyboardEvent )
	{
		keyPressed = true;
		pressedKey = e.keyCode;
	}
	
	private function keyUpHandle( e:KeyboardEvent )
	{
		keyPressed = false;
	}
	
	private function loop( e:Event )
	{	
		// physics		
		world.step(1,20);
        var g = flash.Lib.current.graphics;
        g.clear();
        var fd = new phx.FlashDraw(g);
        fd.drawCircleRotation = true;
        fd.drawWorld(world);
		
		moveCamera();
	}
	
	private function moveCamera()
	{
		level.x = mario.x + 128;
		level.y = (mario.y * -1) + 128;
		trace(mario.y);
	}
	
}