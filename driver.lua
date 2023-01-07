do -- globals
end

function OnDriverInit(driverInitType)
   dbg("OnDriverInit(" .. driverInitType .. ")")

   for k, v in pairs(Properties) do
      OnPropertyChanged(k)
   end
end

function OnDriverLateInit(driverInitType)
   dbg("OnDriverLateInit(" .. driverInitType .. ")")

   C4:UpdateProperty("Driver Version", C4:GetDriverConfigInfo("version"))
end

function OnDriverDestroyed(driverInitType)
   dbg("OnDriverDestroyed(" .. driverInitType .. ")")
end

function ExecuteCommand(strCommand, tParams)
   dbg("ExecuteCommand(" .. strCommand .. ", " .. dump(tParams) .. ")")

   if strCommand == "Set Entry" then
      C4:SendDataToUI("SET_ENTRY", tParams)
   elseif strCommand == "Request Update" then
      C4:FireEvent("Update Requested")
   end
end


function OnVariableChanged(sVariable)
   dbg("OnVariableChanged(" .. sVariable .. ")")
end


function OnPropertyChanged(sProperty)
   local value = Properties[sProperty] or ""
   dbg("OnPropertyChanged(" .. sProperty .. "), new value: " .. value)
end

-- Utility functions

function dbg(msg, ...)
   if Properties["Debug Mode"] == "On" then
      print(os.date("%x %X : ") .. (msg or ""), ...)
   end
end

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

