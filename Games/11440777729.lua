local Items = {}

for _, Item in ipairs(game:GetService("ReplicatedStorage").Items:GetChildren()) do
    table.insert(Items, Item.Name)
end

local Fluent = loadstring(game:HttpGet("https://github.com/DarkNetworks/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/DarkNetworks/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/DarkNetworks/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Nexus | Try To Die",
    SubTitle = "by Dark Networks",
     TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Darker"
})

local Tabs = {
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
	ItemsTab = Window:AddTab({ Title = "Items", Icon = "pencil" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options
local selectedItem

do
	Tabs.Player:AddButton({
        Title = "Kill Player",
        Description = "Kills The Player",
        Callback = function()
			local Player = game.Players.LocalPlayer
			local Character = Player.Character
		
			Character.Humanoid.Health = 0
        end
    })

	Tabs.Player:AddButton({
        Title = "Void Player",
        Description = "Lets player die to void",
        Callback = function()
			local HumanoidRootPart = game.Players.LocalPlayer.Character.HumanoidRootPart
    
			HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, -5, 0)
        end
    })

    Tabs.Player:AddParagraph({
        Title = "Level 108 Code",
        Content = "Code: 2059"
    })

	local ItemsDropdown = Tabs.ItemsTab:AddDropdown("Dropdown", {
        Title = "Select Item",
        Values = Items,
        Multi = false,
        Default = 1,
    })

	ItemsDropdown:OnChanged(function(Value)
        selectedItem = Value
    end)

	Tabs.ItemsTab:AddButton({
        Title = "Give Item",
        Description = "Gives selected item to player",
        Callback = function()
			local Items = game:GetService("ReplicatedStorage").Items

			Items[selectedItem]:Clone().Parent = game.Players.LocalPlayer.Backpack
        end
    })
end


-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("NexusScriptHub")
SaveManager:SetFolder("NexusScriptHub/Try-To-Die")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "Nexus | Notification",
    Content = "The script has been loaded.",
    Duration = 5
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()