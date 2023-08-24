getgenv().Config = {}
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/KvdzUwU/TrashHub/main/Mobile/Ui.lua"))()

local W = library:MakeWindow({
    Name = "Jerry Hub | Autoloot",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "JerryHubAutoloot",
    IntroText = "Jerry Hub",
    IntroIcon = "rbxassetid://14299284116",
    Icon = "rbxassetid://14299284116"
})
local A = W:MakeTab({
    Name = "Auto Loot",
    Icon = "rbxassetid://14299284116",
    PremiumOnly = false,
  })

A:AddToggle({
    Name = "Auto Loot",
    Default = getgenv().Config["Auto Loot"],
    Callback = function(v)
      getgenv().Config["Auto Loot"] = v
    end
})

A:AddTextbox({
    Name = "Webhook Url",
    Default = getgenv().Config["Webhook Url"],
    Callback = function(v)
        getgenv().Config["Webhook Url"] = v
    end
})

local function PostWebhook(data)
    local newdata = game:GetService("HttpService"):JSONEncode(data)
    local headers = {["content-type"] = "application/json"}
    request = http_request or request or HttpPost or syn.request
    local Require = {Url = getgenv().Config["Webhook Url"], Body = newdata, Method = "POST", Headers = headers}
    request(Require)
end

local function LootWebhook(drop)
local data = {
    ["content"] = "# <t:"..os.time()..":F #",
    ["username"] = "Hutao",
    ["avatar_url"] = "https://media.tenor.com/AbkJkB1pGr8AAAAC/hutao-money-rain.gif",
    ["embeds"] = {
        ["title"] = "Jerry Hub | Loot",
        ["type"] = "rich",
        ["color"] = tonumber(0x8B0000),
        ["fields"] = {
            {
                ["name"] = "Username:",
                ["value"] = "||"..game.Players.LocalPlayer.Name.."||",
                ["inline"] = true
            },
            {
                ["name"] = "Drop:",
                ["value"] = "||"..drop.."||",
                ["inline"] = true
            }
                },
                ["footer"] = {
                    ["text"] = "https://discord.gg/WeM3WuzdVH",
                    ["icon_url"] = "https://i.imgur.com/vRkv2ED.gif"
                }
            }
        }
        PostWebhook(data)
end

game:GetService("Workspace"):WaitForChild("Debree").ChildAdded:Connect(function(v)
    if getgenv().Config["Auto Loot"] and v.Name == "Loot_Chest" then 
        local Remote = v:WaitForChild("Add_To_Inventory")
        local Drops = v:WaitForChild("Drops")  
        repeat 
            for i,v in next, Drops:GetChildren() do 
                Remote:InvokeServer(v.Name)
                if getgenv().Config["Webhook Url"] ~= nil then   
                    LootWebhook(v.Name)
                end
            end
            wait(.1)
        until not v.Parent
    end
end)