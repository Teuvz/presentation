package com.ukuleledog.games.presentation.elements;

import com.ukuleledog.games.presentation.core.AnimatedObject;
import com.ukuleledog.games.presentation.core.PhysicsObject;

import flash.display.Bitmap;
import openfl.Assets;
import flash.events.Event;
import box2D.common.math.B2Vec2;

/**
 * ...
 * @author Matt
 */
class Mario extends PhysicsObject
{

	private var status:String = 'small';
	private var speed:UInt = 10;
	
	public var jumping:Bool = false;
	public var movingRight:Bool = false;
	public var movingLeft:Bool = false;
	
	public function new() 
	{
		super();
		this.dynamicBody = true;
		this.bmd = Assets.getBitmapData("img/mario-sprite.png",true);
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		createAnimation('small-idle', 0, 0, 1, 16, 16);
		createAnimation('small-walk', 0, 0, 2, 16, 16, 0.1);
		createAnimation('small-jump', 16, 0, 1, 16, 16);
		createAnimation('small-crouch', 0, 0, 1, 16, 16);
		
		createAnimation('super-idle', 0, 21, 1, 27, 16);
		createAnimation('super-walk', 0, 21, 3, 27, 16, 0.1);
		createAnimation('super-jump', 48, 21, 1, 27, 16);
		createAnimation('super-crouch', 64, 21, 1, 27, 16);
		
		animate('small-idle');
		
		//initPhysics();
		
		removeEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	public function stopMove()
	{
		setAnimation( status + '-idle' );
		
		movingRight = false;
		movingLeft = false;
		jumping = false;
		
		body.setLinearVelocity( new B2Vec2(0, body.getLinearVelocity().y ) );
	}
	
	public function moveRight()
	{
		if ( scaleX == -1 )
			this.x -= this.width;
		
		scaleX = 1;
		setAnimation( status + '-walk' );
		
		movingRight = true;
		
		body.applyForce( new B2Vec2(speed,0), body.getWorldCenter()  );
	}
	
	public function moveLeft()
	{
		if ( scaleX == 1 )
			this.x += this.width;
		
		scaleX = -1;
		setAnimation( status + '-walk' );
		
		movingLeft = true;
		
		body.applyForce( new B2Vec2(-speed,0), body.getWorldCenter()  );
	}
	
	public function jump()
	{
		if ( body.getLinearVelocity().y == 0 )
		{
			setAnimation( status + '-jump' );
			jumping = true;
			
			body.applyImpulse( new B2Vec2(0, -5), body.getWorldCenter()  );
		}
	}
	
}