package com.ukuleledog.games.presentation.elements;

import com.ukuleledog.games.presentation.core.AnimatedObject;
import com.ukuleledog.games.presentation.core.PhysicsObject;

import flash.display.Bitmap;
import openfl.Assets;
import flash.events.Event;

/**
 * ...
 * @author Matt
 */
class Mario extends PhysicsObject
{

	private var status:String = 'small';
	private var speed:UInt = 3;
	
	public var jumping:Bool = false;
	public var movingRight:Bool = false;
	public var movingLeft:Bool = false;
	
	public function new() 
	{
		super();
		this.bmd = Assets.getBitmapData("img/mario-sprite.png",true);
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		createAnimation('small-idle', 0, 0, 1, 16, 16);
		createAnimation('small-walk', 0, 0, 2, 16, 16, 0.1);
		createAnimation('small-jump', 16, 0, 1, 16, 16);
		createAnimation('small-crouch', 0, 0, 1, 16, 16);
		animate('small-idle');
		
		removeEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	public function stopMove()
	{
		setAnimation( status + '-idle' );
		
		movingRight = false;
		movingLeft = false;
		jumping = false;
	}
	
	public function moveRight()
	{
		if ( scaleX == -1 )
			this.x -= this.width;
		
		scaleX = 1;
		setAnimation( status + '-walk' );
		
		movingRight = true;
	}
	
	public function moveLeft()
	{
		if ( scaleX == 1 )
			this.x += this.width;
		
		scaleX = -1;
		setAnimation( status + '-walk' );
		
		movingLeft = true;
	}
	
	public function jump()
	{
		setAnimation( status + '-jump' );
		jumping = true;
	}
	
}