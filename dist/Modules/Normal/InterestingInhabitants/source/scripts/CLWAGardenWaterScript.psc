scriptName CLWAGardenWaterScript extends ObjectReference Conditional
{Took Antistar's hack of a vanilla script and optimized it and specialized it for my purposes.
Also made it conditional for the same reason.}

ObjectReference Property ObRef01 Auto
{Ref to enable and disable on valve turn}
ObjectReference Property ObDisable Auto
{Reference to disable on init}
Bool Property flip = False Auto Hidden Conditional

Event onInit()
	ObDisable.Disable()
endevent

Auto STATE Waiting
	Event OnBeginState()
		self.BlockActivation(false)
	endevent
	Event OnActivate(objectReference akActionRef)
		goToState("Processing")
	endevent
endState

state Processing
	Event OnBeginState()
		self.BlockActivation(true)
		if flip
			playAnimationAndWait("trigger02", "done")
			flip = false
			ObRef01.DisableNoWait()
		else
			playAnimationAndWait("trigger01", "done")
			flip = true
			ObRef01.EnableNoWait()
		endif
		goToState("Waiting")
	endevent
endstate