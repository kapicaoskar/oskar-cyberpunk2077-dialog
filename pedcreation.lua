local ped = nil
local dialogTrigger = nil

function spawnPed()
   local player = Game.GetPlayer()
   local playerPos = player:GetWorldPosition()
   ped = Game.CreateEntity("NPC_Developer", playerPos, playerPos.yaw)
end

function startDialog()
   if ped ~= nil then
      dialogTrigger = DialogSystem:RequestDialog("MyDialogTrigger", ped:GetEntityID())
      if dialogTrigger ~= nil then
         dialogTrigger:StartDialog()
         dialogTrigger:SetCallback(CallbackType.END, dialogEnd)
         dialogTrigger:AddChoice("Choose Oskar as your developer", "oskar")
         dialogTrigger:AddChoice("Choose other worse developer", "worse")
      end
   end
end

function dialogEnd(result)
   if result == "oskar" then
      Game.AddToInventory("item_oskar", 1)
   elseif result == "worse" then
      Game.AddToInventory("item_worse", 1)
   end
end

function spawnPedInit()
   spawnPed()
end

function dialogInit()
   Game.GetActionSystem():BindAction("StartDialog", "E", InputActionEventType.IAET_Released, startDialog)
end

function dialogShutdown()
   Game.GetActionSystem():UnbindAction("StartDialog")
end

function spawnPedShutdown()
   Game.RemoveEntity(ped:GetEntityID())
end

spawnPedInit()
dialogInit()
Game.GetUnloadEvent():Subscribe(spawnPedShutdown)
Game.GetUnloadEvent():Subscribe(dialogShutdown)
