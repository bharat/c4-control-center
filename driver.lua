-- TODO(bharat): add a timer to turn off debug after a reasonable interval

do -- globals
  if (C4.GetDriverConfigInfo) then
    VERSION = C4:GetDriverConfigInfo ("version")
  else
    VERSION = "Incompatible with this OS"
  end
  C4:AddVariable("STATE", "", "STRING")
end


function dbg(msg, ...)
   if Properties["Debug Mode"] == "On" then
      print(os.date("%x %X : ") .. (msg or ""), ...)
   end
end

function ExecuteCommand(strCommand, tParams)
   dbg("ExecuteCommand function called with : " .. strCommand)

   if strCommand == "Set State" then
      dbg("Set state to '" .. tParams.state .. "' (x)")
      UpdateState(tParams.state)
   end
end


function OnVariableChanged(sVariable)
   dbg("OnVariableChanged(" .. sVariable .. ")")
   if (sVariable == "STATE") then
      UpdateState(Variables["State"])
   end
end


function OnPropertyChanged(sProperty)
   dbg("OnPropertyChanged(" .. sProperty .. "), new value is " .. Properties["Select State Now"])
   if sProperty == "Select State Now" then
      UpdateState(Properties["Select State Now"])
   end
end


function UpdateState(sNewState)
   C4:UpdateProperty("Current State", sNewState)
   C4:SetVariable("STATE", sNewState)
   UpdateIcon()
end


function UpdateIcon()
   dbg("UpdateIcon()")
   local state = Variables["STATE"]
   C4:FireEvent(state)
   C4:SendToProxy(5001, "ICON_CHANGED", {icon=state, icon_description=state})
end
