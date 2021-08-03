Scriptname CLWAChangeGlobalOnAttachAndDetach extends ObjectReference  
{Changes a Global (variable) when the attached object's cell is attached or detached.
Globals and vlues to set are determined using properties 

For info on cell attachments/detachments, see https://www.creationkit.com/index.php?title=OnCellAttach_-_ObjectReference}

GlobalVariable Property AttachGlobal  auto  
{Global to set on attach}
Float Property AttachValue  auto  
{Value to set AttachGlobal to on attach}

GlobalVariable Property DetachGlobal  auto  
{Global to set on detach}
Float Property DetachValue  auto  
{(useless unless RevertToPreviousValue = false)
Value to set DetachGlobal to on detach}

Bool Property RevertToPreviousValue = true auto
{**ENABLED BY DEFAULT**
Whether or not to store the value of AttachGlobal when attached and set DetachGlobal to it when detached
(makes DetachValue useless)}

event OnCellAttach()
    if RevertToPreviousValue == true
        DetachValue = AttachGlobal.GetValue()
    endif
    AttachGlobal.SetValue(AttachValue)
endevent

event OnCellDetach()
    DetachGlobal.SetValue(DetachValue)
endevent