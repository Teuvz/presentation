package com.ukuleledog.games.presentation.core;
import flash.events.Event;
import phx.Body;
import phx.Shape;

/**
 * ...
 * @author Matt
 */
class PhysicObject extends AnimatedObject
{

	private var body:Body;
	private var shape:Shape;
	
	public function new() 
	{
		super();
	}
	
	public function initPhysics()
	{
		shape = phx.Shape.makeBox(width, height);
		body = new Body(x, y);
		body.addShape(shape);
		
		addEventListener( Event.ENTER_FRAME, alignPhysics );
	}
	
	public function killPhysics()
	{
		removeEventListener( Event.ENTER_FRAME, alignPhysics );
	}
	
	public function getBody()
	{
		return body;
	}
		
	private function alignPhysics( e:Event )
	{
		x = body.x;
		y = body.y;
	}
	
}