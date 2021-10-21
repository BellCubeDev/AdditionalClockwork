Scriptname CLWA_SKSE_SendEventOnLoad Extends Actor
{Attach to player.
Sends the specified mod event on game load}

String Property pEventName  Auto
String Property pStringArgument  Auto
Float Property pFloatArgument  Auto

Event OnPlayerLoadGame()
    SendModEvent(pEventName, pStringArgument, pFloatArgument)
endevent
