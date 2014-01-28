package com.ukuleledog.games.presentation.elements;

import com.ukuleledog.games.presentation.core.AnimatedObject;

import flash.display.Bitmap;
import openfl.Assets;
import flash.events.Event;
import box2D.common.math.B2Vec2;

/**
 * ...
 * @author Matt
 */
class Mario extends AnimatedObject
{

	public var status:String = 'small';
	private var speed:UInt = 10;
	
	public var onFloor:Bool = true;
	public var jumping:Bool = false;
	private var jumpMax:UInt = 40;
	private var jumpMaxSuper:UInt = 70;
	private var jumpMaxCurrent:Float;
	private var rising:Bool = false;
	
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
		
		createAnimation('super-idle', 0, 21, 1, 27, 16);
		createAnimation('super-walk', 0, 21, 3, 27, 16, 0.1);
		createAnimation('super-jump', 48, 21, 1, 27, 16);
		createAnimation('super-crouch', 64, 21, 1, 27, 16);
		
		animate('small-idle');
		
		removeEventListener( Event.ADDED_TO_STAGE, init );
		
		addEventListener( Event.ENTER_FRAME, loop );
		
	}
	
	public function stopMove()
	{
		
		if ( jumping )
			return;
		
		setAnimation( status + '-idle' );
		
		movingRight = false;
		movingLeft = false;
	}
	
	public function moveRight()
	{
		if ( status == 'super' && x >= 1876 )
		{
			x = 1876;
			return;
		} else if ( status == 'small' && x > 1842 )
		{
			x = 1842;
			return;
		}
		
		if ( scaleX == -1 )
			this.x -= this.width;
		
		scaleX = 1;
		this.x += speed;
		
		if ( !jumping )
		setAnimation( status + '-walk' );
		
		movingRight = true;
	}
	
	public function moveLeft()
	{		
		if ( x <= 16 )
		{
			x = 16;
			return;
		}
		
		if ( scaleX == 1 )
			this.x += this.width;
		
		scaleX = -1;
		this.x -= speed;
		
		if ( !jumping )
		setAnimation( status + '-walk' );
		
		movingLeft = true;
	}
	
	public function jump()
	{
		
		if ( !jumping && onFloor )
		{
			setAnimation( status + '-jump' );
			jumping = true;
			rising = true;
			
			if ( status == 'small' )
			jumpMaxCurrent = y - jumpMax;
			else
			jumpMaxCurrent = y - jumpMaxSuper;
			
			Assets.getSound("snd/smb3_jump.wav", true).play();
		}
	}
	
	private function loop( e:Event )
	{
		if ( jumping && rising && this.y > jumpMaxCurrent )
			this.y -= 10;
		else if ( jumping && rising )
			rising = false;
		
		if ( jumping && !rising && onFloor )
			jumping = false;

	}
		
}