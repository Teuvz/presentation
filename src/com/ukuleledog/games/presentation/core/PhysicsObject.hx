package com.ukuleledog.games.presentation.core;
import box2D.collision.shapes.B2PolygonShape;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;
import flash.events.Event;

/**
 * ...
 * @author ...
 */
class PhysicsObject extends AnimatedObject
{

	private var body:B2Body;
	public var dynamicBody:Bool = true;
	
	public function new() 
	{
		super();
	}
	
	public function getBody() : B2Body
	{
		return body;
	}
	
	public function setBody( body:B2Body )
	{
		if ( this.body == null )
		{
			this.body = body;
			addEventListener( Event.ENTER_FRAME, physicsLoop );
		}
		else
		{
			this.body = body;
		}
	}
	
	private function physicsLoop( e:Event )
	{
		var vec:B2Vec2 = body.getPosition();
		this.x = vec.x;
		this.y = vec.y;
	}
	
}