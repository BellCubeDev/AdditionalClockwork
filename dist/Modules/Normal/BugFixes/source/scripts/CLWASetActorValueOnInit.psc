Scriptname CLWASetActorValueOnInit extends Actor  
{Sets the specified actor values on init, up to 2}

String Property p01AVToSet  Auto
{ActorValue to set}
Float Property p01NewValue  Auto
{New value for the above-defined Actor Value}
String Property p02AVToSet  Auto
{ActorValue to set}
Float Property p02NewValue  Auto
{New value for the above-defined Actor Value}

Event OnInit()
    self.SetActorValue(p01AVToSet, p01NewValue)
    if p02AVToSet && p02NewValue
        self.SetActorValue(p02AVToSet, p02NewValue)
    endif
endevent
