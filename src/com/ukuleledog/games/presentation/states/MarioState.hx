package com.ukuleledog.games.presentation.states;
import box2D.collision.shapes.B2PolygonShape;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;
import box2D.dynamics.B2Body;
import com.ukuleledog.games.presentation.core.PhysicsObject;
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

/**
 * ...
 * @author Matt
 */
class MarioState extends State
{

	private static var PHYSICS_SCALE:Float = 1 / 30;
	
	private var physicsDebug:Sprite;
	private var world:B2World;
	
	private var keyPressed:Bool = false;
	private var pressedKey:UInt = 0;
	
	private var level:Sprite;
	
	private var mario:Mario;
	private var marioBody:B2Body;
	
	public function new() 
	{
		super();
		
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
			
		mario = new Mario();
		mario.x = 10;
		mario.y = 410;
		level.addChild(mario);
		
		//musicChannel = Assets.getMusic("music/mario.mp3").play();
		
		initWorld();
			
		stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandle );
		stage.addEventListener( KeyboardEvent.KEY_UP, keyUpHandle );
		addEventListener( Event.ENTER_FRAME, loop );
	}
	
	private function initWorld()
	{
		world = new B2World (new B2Vec2 (0, 10.0), true);
		physicsDebug = new Sprite ();
		level.addChild(physicsDebug);
		
		var debugDraw = new B2DebugDraw ();
		debugDraw.setSprite (physicsDebug);
		debugDraw.setDrawScale (1 / PHYSICS_SCALE);
		debugDraw.setFlags (B2DebugDraw.e_shapeBit);
		
		world.setDebugDraw (debugDraw);
		
		createBox (0, 422, 4000, 10, false);
		//createBox (20, 100, 10, 10, true);
		marioBody = createBox (mario.x, mario.y, mario.width, mario.height, true);
	}
		
	private function createBox (x:Float, y:Float, width:Float, height:Float, dynamicBody:Bool):B2Body {
		
		var bodyDefinition = new B2BodyDef ();
		bodyDefinition.position.set (x * PHYSICS_SCALE, y * PHYSICS_SCALE);
		
		if (dynamicBody) {
			bodyDefinition.type = B2Body.b2_dynamicBody;			
		}
		
		var polygon = new B2PolygonShape ();
		polygon.setAsBox ((width / 2) * PHYSICS_SCALE, (height / 2) * PHYSICS_SCALE);
		
		var fixtureDefinition = new B2FixtureDef ();
		fixtureDefinition.shape = polygon;
		
		var body = world.createBody (bodyDefinition);
		body.createFixture (fixtureDefinition);
		
		return body;
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
		
		if ( keyPressed )
		{
			switch(pressedKey)
			{
				case Keyboard.RIGHT:
					marioBody.setLinearVelocity( new B2Vec2(10, 0) );
					mario.moveRight();
				case Keyboard.LEFT:
					marioBody.setLinearVelocity( new B2Vec2(-10, 0) );
					mario.moveLeft();
				case Keyboard.SPACE:
					if ( !mario.jumping ) {
						marioBody.applyImpulse( new B2Vec2(0, -2), marioBody.getWorldCenter() );
						mario.jump();
					}
			}
		} else {
						
			marioBody.setLinearVelocity( new B2Vec2(0,0) );
			mario.stopMove();
		}
		
		mario.x = (marioBody.getPosition().x / PHYSICS_SCALE) - (mario.width / 2);
		mario.y = (marioBody.getPosition().y / PHYSICS_SCALE) - (mario.height / 2);
		moveCamera();
		
		world.step (1 / 30, 10, 10);
		world.clearForces();
		//world.drawDebugData();
	}
	
	private function moveCamera()
	{
		level.x = -mario.x + 120;
		level.y = -mario.y + 140;
	}
	
}