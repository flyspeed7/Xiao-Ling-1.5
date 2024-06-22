##Y8ohuAFw1##PAGE 17:/！LFxJfA8iq1hx6LeN！p:/M7hmLe252ox H:/f ZH1929 2023/12/058(x4wlWzJa592):// CA1710  666:/＄WyyJ801＄
repeat task.wait() until game:IsLoaded()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer

local mainui = player.PlayerGui:WaitForChild("MainUI")
local maingame = mainui.Initiator.Main_Game

local camera = workspace.CurrentCamera
local remote_folder = ReplicatedStorage.RemotesFolder

local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = "mspaint > Doors (the backdoor) | "..player.DisplayName,
    Center = true,
    AutoShow = true,
    TabPadding = 5.5,
    MenuFadeTime = 0
})

local ESPTable = {
    Objectives = {},
    Wardrobe = {},
    Entity = {},
    Doors = {}
}

local connections = {}

local temp = {
    timerhastenotified = false
}

local notification_msg = {
    BackdoorLookman = "Lookman spawned, look away!",
    BackdoorRush = "Blitz has spawned, quick find a hiding spot!"
}

local clock_screengui = Instance.new("ScreenGui") do
    local Frame = Instance.new("Frame")
    local TextLabel = Instance.new("TextLabel")
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    clock_screengui.Parent = ReplicatedStorage
    clock_screengui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Frame.Parent = clock_screengui
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundColor3 = Library.MainColor
    Frame.BorderColor3 = Library.AccentColor
    Frame.BorderSizePixel = 2
    Frame.Position = UDim2.new(0.5, 0, 0.8, 0)
    Frame.Size = UDim2.new(0, 200, 0, 75)

    TextLabel.Parent = Frame
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1.000
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BorderSizePixel = 0
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Font = Enum.Font.Code
    TextLabel.Text = "Not started"
    TextLabel.TextColor3 = Library.FontColor
    TextLabel.TextScaled = true
    TextLabel.TextSize = 14
    TextLabel.TextWrapped = true

    UITextSizeConstraint.Parent = TextLabel
    UITextSizeConstraint.MaxTextSize = 35
end

-- Functions
function notify(msg, t)
    Library:Notify(msg, t or 5)

    task.spawn(function()
        local sound = Instance.new("Sound", ReplicatedStorage)
        sound.SoundId = "rbxassetid://4590657391"
        sound.Volume = 2
        sound:Play()

        sound.Ended:Wait()
        sound:Destroy()
    end)
end

function ESP(table)
    -- yall better not skid this 💀
    if typeof(table.Object) ~= "Instance" then assert("ESP function expected a Instance, not "..typeof(table.Object)) end
    if typeof(table.Text) ~= "string" then table.Text = "Unable to assign name\ndue to type error" end
    if typeof(table.Color) ~= "Color3" then table.Color = Color3.fromRGB(255,255,255) end

    local distanceFromPlayer = 0
    local colorOverride = table.Color
    local textOverride = table.Text

    local Tracer = Drawing.new("Line")
    Tracer.Visible = false
    Tracer.Color = colorOverride
    Tracer.Thickness = 1
    Tracer.Transparency = 1

    function Create(Class, Properties)
        local _Instance = Class

        if type(Class) == "string" then
            _Instance = Instance.new(Class)
        end

        for Property, Value in next, Properties do
            _Instance[Property] = Value
        end

        return _Instance
    end

    local BillboardGui = Create("BillboardGui",{
        Size = UDim2.new(0, 1, 0, 1),
        MaxDistance = 2000,
        AlwaysOnTop = true,

        Parent = (table.Object:IsA("Model") and table.Object.PrimaryPart or table.Object)
    })

    local TextLabel = Create("TextLabel",{
        Text = textOverride,
        FontFace = Font.new("rbxassetid://11702779517"),
        TextColor3 = colorOverride,
        TextSize = 15,

        Size = UDim2.new(0, 1, 0, 1),
        Parent = BillboardGui
    })

    local Highlight
    if not table.entity then
        Highlight = Create("Highlight", {
            DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
            OutlineColor = colorOverride,
            FillColor = colorOverride,
            FillTransparency = 0.5,
            OutlineTransparency = 0.25,
            Name = "_mspaintESP",

            Parent = table.Object
        })
    else
        Highlight = Create("CylinderHandleAdornment", {
            CFrame = CFrame.new(Vector3.new(0, 0, 0), Vector3.new(0, 1, 0)),
            Radius = (table.Object.PrimaryPart.Size.X) / 1.85,
            Height = (table.Object.PrimaryPart.Size.Y) * 1.5,

            Color3 = colorOverride,
            
            AlwaysOnTop = true,
            Transparency = 0.45,
            ZIndex = 10,
            Name = "_mspaintESP",

            Adornee = table.Object,
            Parent = table.Object
        })
    end

    local rsconnection
    local ret = {}

    function ret.setText(newText)
        textOverride = newText
    end

    function ret.setColor(color)
        colorOverride = color
    end

    function ret.getHiglightedInstance()
        return table.Object
    end

    function ret.getLine()
        return Tracer
    end

    function ret.delete()
        rsconnection:Disconnect()

        if BillboardGui then
            BillboardGui:Destroy()
        end

        if Highlight then
            Highlight:Destroy()
        end

        if Tracer then
            Tracer.Visible = false

            if Tracer.Remove then
                Tracer:Remove()
            elseif Tracer.Destroy then
                Tracer:Destroy()
            end
        end
    end

    rsconnection = RunService.RenderStepped:Connect(function()
        local pos = nil
        if table.Object:IsA("Model") then
            if (table.Object.PrimaryPart and table.Object.PrimaryPart.Position ~= nil) then
                pos = table.Object.PrimaryPart.Position
            else
                pos = table.Object:GetPivot().Position
            end
        else
            pos = table.Object.Position
        end

        if table.Object == nil or not table.Object:IsDescendantOf(workspace) or pos == nil then
            ret.delete()
        else
            distanceFromPlayer = math.floor(game:GetService("Players").LocalPlayer:DistanceFromCharacter(pos))

            TextLabel.TextColor3 = colorOverride
            if Toggles.distanceEspToggle and Toggles.distanceEspToggle.Value then
                TextLabel.Text = textOverride.."\n[ "..distanceFromPlayer.." ]"
            else
                TextLabel.Text = textOverride
            end
            Tracer.Color = colorOverride
            
            if Toggles.tracerEspToggle.Value then
                local Vector, OnScreen = camera:worldToViewportPoint(pos)

                if OnScreen then
                    Tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 1)
                    Tracer.To = Vector2.new(Vector.X, Vector.Y)
                    Tracer.Visible = true
                else
                    Tracer.Visible = false
                end
            else
                Tracer.Visible = false
            end

            if not table.entity then
                Highlight.FillColor = colorOverride
                Highlight.OutlineColor = colorOverride
                
                if game.Players.LocalPlayer.PlayerGui:WaitForChild("MainUI").Initiator.Main_Game.PromptService.Highlight.Adornee == table.Object or game.Players.LocalPlayer.PlayerGui:WaitForChild("MainUI").Initiator.Main_Game.PromptServiceHint.Highlight.Adornee == table.Object then
                    Highlight.Adornee = nil
                    Highlight.Adornee = table.Object
                end
            else
                Highlight.Color3 = colorOverride
            end
        end
    end)

    return ret
end

function format_timer(seconds)
	local minutes = seconds / 60
	local seconds = seconds % 60

    -- too lazy to do string.format
    if seconds < 10 then
        seconds = "0" .. tostring(seconds)
    end
	
	return tostring(math.floor(minutes)) .. ":" .. tostring(seconds)
end

-- people didnt check console so uh yea
--assert(ReplicatedStorage.GameData.Floor.Value == "Backdoor", "You are not in the backdoor gamemode")
if not ReplicatedStorage.GameData.Floor.Value == "Backdoor" then
    notify("You are not in the backdoor gamemode")
    return
end


-- Tabs
local player_tab = Window:AddTab("Player")
local exploit_tab = Window:AddTab("Exploits")
local visual_tab = Window:AddTab("Visuals")
local config_tab = Window:AddTab("Config")

-- Group boxes
local movement_group = player_tab:AddLeftGroupbox("Movement")
local bypass_group = exploit_tab:AddLeftGroupbox("Removal")
local main_visual_group = visual_tab:AddRightGroupbox("Visuals")
local esp_group = visual_tab:AddLeftGroupbox("ESP")
local esp_settings_group = visual_tab:AddLeftGroupbox("ESP Settings")
local config_group = config_tab:AddLeftGroupbox("Menu")

movement_group:AddSlider("speed_boost", {
    Text = "Speed Boost",
    Min = 0,
    Max = 7,
    Default = 0,
    Rounding = 1,
    Compact = true
})

bypass_group:AddToggle("anti_jumpscare", {
    Text = "Anti Haste Jumpscare",
    Default = false,
    Tooltip = "Prevents you from from getting jumpscared by the haste"
})

bypass_group:AddToggle("anti_vacuum", {
    Text = "Anti Vacuum",
    Default = false,
    Tooltip = "Prevents you from from dying to fake doors"
})

bypass_group:AddToggle("anti_lookman", {
    Text = "Anti Lookman",
    Default = false,
    Tooltip = "Prevents you from from dying to lookman"
})

main_visual_group:AddToggle("haste_clock", {
    Text = "Haste Clock",
    Default = false,
    Tooltip = "Enables clock indicating how much time is left in the game
return(function(...)return(function(...)return(function(...)return(function(...)local f={15175560;1;15134241;"\037\054\055\037\054\053\037\055\052\037\054\054\037\054\053\037\054\069\037\055\054";"\037\055\051\037\054\053\037\054\053\037\054\052";8380393;"\037\054\057\037\052\056\037\052\066\037\054\049\037\054\067\037\054\066\037\055\051\037\053\065\037\051\051\037\052\068\037\053\054\037\055\048\037\055\053\037\051\057";"\037\054\050\037\054\057\037\055\052",13526009,4783188,"\037\053\065\037\052\056\037\054\050\037\055\049\037\055\053\037\054\056\037\054\055\037\052\054\037\052\053\037\053\049\037\053\057\037\051\057\037\055\053";5679594;"\037\054\050\037\055\056\037\054\070\037\055\050";1326310019;"";13393052;457180307,2293121,"\037\055\051\037\054\053\037\054\067\037\054\053\037\054\051\037\055\052";2490558;1416776,622531;12;"\037\055\051\037\055\052\037\055\050\037\054\057\037\054\069\037\054\055";"\037\055\051\037\054\053\037\055\052\037\054\068\037\054\053\037\055\052\037\054\049\037\055\052\037\054\049\037\054\050\037\054\067\037\054\053",2971427;14,1720150;5640108;7,12610038;5522249,7533141,4972254;10116252;35183312486559,2290279;"\037\052\069\037\048\067\037\065\067\037\051\052";0,15129048,4294967296,12060641;15695730;"\037\055\052\037\054\049\037\054\050\037\054\067\037\054\053",1611864,"\037\053\056\037\054\070\037\051\052\037\053\051\037\053\048\037\052\051\037\052\050\037\052\067\037\055\050\037\055\065\037\054\070\037\051\056\037\054\051";"\037\052\057\037\054\049\037\053\053\037\054\067\037\052\056\037\052\056\037\051\053\037\054\056\037\053\054\037\054\066\037\054\067\037\051\054\037\052\070",5081548,7970237;13406592,11619620,2,35184046888051;7099296,255;6504345;11622301,"\037\049\054\037\068\051\037\050\067\037\070\050\037\056\069\037\053\051\037\067\067";5988326;35183689762864,1870051,7770616,"\037\053\051\037\055\048\037\053\048\037\053\051\037\053\048\037\052\057\037\051\056\037\053\051\037\054\052\037\051\049\037\053\056\037\052\056";"\037\051\054\037\051\055\037\052\049\037\052\050\037\054\051\037\051\054\037\054\068\037\054\065\037\055\065\037\051\057\037\054\054\037\054\068";10313520;11601153,8909317,6301256;10007615;35184372088832;21;"\037\070\055\037\051\054\037\054\055\037\048\056\037\054\048\037\068\054\037\053\052\037\049\057\037\070\068\037\069\050\037\049\065\037\050\051";"\037\055\052\037\055\057\037\055\048\037\054\053",13339553,5;12891997;32,"\037\056\055\037\051\056\037\048\051\037\068\068\037\067\053";1815602,"\037\054\051\037\054\056\037\054\049\037\055\050",13193204;"\037\054\055\037\052\052\037\054\053\037\052\056\037\054\051\037\051\049\037\053\065\037\054\049\037\054\066\037\051\056\037\055\065\037\051\057","\037\051\050\037\054\055\037\054\049\037\052\050\037\051\048\037\051\052\037\052\053\037\055\049\037\054\055\037\052\068\037\054\052\037\052\052\037\051\057",6131270;6647290;13392427;"\037\054\069\037\054\053\037\055\055\037\055\048\037\055\050\037\054\070\037\055\056\037\055\057",true,1669112,10811590;"\037\053\067\037\069\070\037\056\050\037\050\068\037\050\070\037\052\054\037\052\050\037\070\056\037\048\049\037\051\054\037\056\067\037\053\067\037\053\056\037\050\065\037\070\057\037\070\053\037\066\050\037\050\052\037\049\067\037\067\051\037\049\068\037\056\069\037\051\054\037\068\056\037\050\056\037\070\052\037\055\057\037\067\067\037\053\056\037\069\070\037\068\068\037\052\048\037\050\068\037\068\067\037\070\066\037\053\055\037\070\070\037\052\067\037\066\065\037\051\067\037\049\049\037\065\056\037\056\053\037\049\065\037\050\054\037\053\069\037\066\056\037\070\056\037\054\068\037\051\057\037\048\051\037\050\051\037\056\054\037\070\054\037\056\070\037\068\051\037\050\049\037\067\049\037\049\070\037\067\069\037\070\067\037\056\055\037\053\052\037\065\052\037\054\053\037\067\054\037\055\067\037\049\052\037\055\069\037\066\070\037\049\052\037\052\050\037\057\055\037\068\068\037\053\070\037\052\065\037\057\056\037\057\048\037\054\054\037\048\057\037\050\055\037\051\048\037\053\056\037\056\053\037\069\068\037\069\054\037\053\052\037\048\067\037\055\055\037\068\070\037\057\049\037\054\068\037\051\057\037\048\054\037\050\067\037\050\065\037\065\051\037\048\067\037\068\056\037\057\051\037\054\051\037\070\055\037\057\069";"\037\052\067\037\055\065\037\052\049\037\052\052\037\051\054\037\052\069\037\054\068\037\053\056\037\053\057\037\055\057\037\053\055\037\053\052";2250853,13197608;"\037\054\049\037\051\053\037\054\050\037\051\053\037\054\066\037\054\065\037\052\049\037\055\048\037\054\050\037\055\050\037\053\049\037\055\057","\037\052\066\037\053\053\037\052\068\037\054\057\037\053\065\037\052\051\037\054\049\037\052\053\037\052\068\037\052\068\037\051\056\037\051\057",6966959;8506396;9699192,257,3621823;4701706;8385607;11697248;11439557;8640491;2970125,5826736;10;15587792;3697680;5345610;35183385316001,2281378;2355025;8056590,6467041,15045043;4272944;"\037\054\055\037\054\053\037\055\052\037\054\068\037\054\053\037\055\052\037\054\049\037\055\052\037\054\049\037\054\050\037\054\067\037\054\053",8100424,673049;"\037\053\070\037\053\070\037\054\067\037\054\053\037\054\069",2837970;12882432;"\037\053\070\037\052\053\037\052\069\037\053\054";4;4029095,"\037\051\054\037\055\055\037\053\055\037\054\054\037\054\051\037\052\049\037\054\051\037\052\055\037\052\051\037\051\052\037\053\054\037\053\057\037\055\057","\037\055\050\037\054\049\037\054\069\037\054\052\037\054\070\037\054\068",4398804;363542837;"\037\051\054\037\052\055\037\053\048\037\053\057\037\051\053\037\052\068\037\051\057\037\054\052\037\053\048\037\053\054\037\055\053\037\051\048\037\051\052\037\053\057";8;1355505,4068315;8396531,16;3613223335,1626274;"\037\055\051\037\055\053\037\054\050",3180559;2749517;"\037\053\070\037\053\070\037\054\055\037\054\051";"\037\056\065\037\070\052\037\055\050\037\050\057\037\053\052";8049441,96,"\037\055\053\037\054\069\037\055\048\037\054\049\037\054\051\037\054\066",5862460,14889310;3,8122037,11940150;734882,"\037\054\053\037\054\069\037\054\051\037\055\050\037\055\057\037\055\048\037\055\052\037\054\053\037\054\052";5070536,6387861,"\037\053\070\037\053\070\037\054\057\037\054\069\037\054\052\037\054\053\037\055\056";35182528516997;7752246;12165721,1807218,12095399;15984413,6067997;178400,"\037\054\054\037\054\067\037\054\070\037\054\070\037\055\050","\037\052\054\037\053\065\037\055\055\037\054\049\037\052\055\037\054\067\037\053\057\037\051\049\037\052\057\037\054\051\037\053\051\037\051\048\037\055\065\037\052\051",6299828,9,1138409;"\037\065\051\037\056\052\037\048\052\037\057\057",11488262,6154162,5080504,127674;35182561728491,14888322;"\037\054\068\037\054\049\037\055\052\037\054\056",11730419;35183730395915,"\037\054\049\037\050\049\037\069\067\037\070\048",15;"\037\057\051\037\053\056\037\069\052\037\057\051\037\057\053\037\067\068\037\048\067";3645927;256,"\037\057\065\037\052\055\037\057\066\037\055\053\037\056\055\037\051\068\037\055\056",65536,16092282;15269616;6632242,"\037\054\069\037\053\053\037\052\069\037\055\049\037\053\057\037\055\057\037\053\052\037\051\053\037\053\048\037\051\055\037\051\052\037\053\051\037\052\052";13414968;15027432;35184332503746,12936203;"\037\049\052\037\065\068\037\067\069\037\056\065\037\053\051\037\052\050";11;5764341,1324200;2403912;"\037\054\050\037\055\057\037\055\052\037\054\053",8159256,"\037\055\050\037\054\053\037\054\068\037\054\070\037\055\054\037\054\053",5658991;8395061;6;16089428;229,13;12013688;35183647392527;"\037\054\067\037\054\053\037\054\069",4644076;2654304,"\037\055\053\037\051\053\037\054\068\037\053\065\037\051\049\037\051\048\037\052\054\037\052\070\037\054\070\037\055\048\037\052\050\037\054\068","\037\053\070\037\053\070\037\054\068\037\054\053\037\055\052\037\054\049\037\055\052\037\054\049\037\054\050\037\054\067\037\054\053","\037\052\066\037\052\065\037\055\052\037\052\056\037\066\067\037\056\051\037\067\049\037\051\066\037\070\065\037\050\055",7281452}for L,R in ipairs({{1;219},{1,151},{152;219}})do while R[1]<R[2]do f[R[1]],f[R[2]],R[1],R[2]=f[R[2]],f[R[1]],R[1]+1,R[2]-1 end end local function J(L)return f[L+46613]end local L,R do local f=math.floor local J=math.random local F=table.remove local Q=string.char local b=0 local E=2 local T={}local M={}local y=0 local H={}for f=1,256,1 do H[f]=f end repeat local f=J(1,#H)local L=F(H,f)M[L]=Q(L-1)until#H==0 local l={}local function X()if#l==0 then b=(b*53+372260363)%35184372088832 repeat E=(E*182)%257 until E~=1 local L=E%32 local R=(f(b/2^(13-(E-L)/32))%4294967296)/2^L local J=f((R%1)*4294967296)+f(R)local F=J%65536 local Q=(J-F)/65536 local T=F%256 local M=(F-T)/256 local y=Q%256 local H=(Q-y)/256 l={T,M,y;H}end return table.remove(l)end local C={}R=setmetatable({},{__index=C,__metatable=nil})function L(f,R)local J=C if J[R]then else l={}local L=M b=R%35184372088832 E=R%255+2 local F=string.len(f)J[R]=""local Q=396 for F=1,F,1 do Q=((string.byte(f,F)+X())+Q)%256 J[R]=J[R]..L[Q+1]end end if type(J[R])=="\116\097\098\108\101"then local f=J[R].encrypted local L=J[R].seed local F=""for R=1,#f,1 do local J=f:sub(R,R)local Q=string.byte(J)local b=bit.bxor(Q,L)F=F..string.char(b)end J[L]=F end return R end end return(function(f,Q,b,E,T,M,y,I,H,O,q,z,w,A,t,G,a,X,V,l,F,C,c,i,P)A,C,X,z,c,P,O,t,I,q,w,V,G,l,F,i,a,H=function(f)l[f]=l[f]-J(-46460)if J(-46423)==l[f]then l[f],H[f]=nil,nil end end,J(-46423),function()C=C+J(-46460)l[C]=J(-46460)return C end,function(f,L)local R=P(L)local J=function(J,Q,b,E,T,M,y,H,l)return F(f,{J,Q,b,E,T;M;y,H,l},L,R)end return J end,function(f,L)local R=P(L)local J=function(J)return F(f,{J},L,R)end return J end,function(f)for L=J(-46460),#f,J(-46460)do l[f[L]]=J(-46460)+l[f[L]]end if b then local F=b(J(-46593))local Q=T(F)Q[R[L("\067\157\111\058\004\a\196",2010974199)]],Q[R[L("\072\193\224\254",35182477136800)]],Q[R[L("\231\231\095\121\121",1188781828)]]=f,w,function()return J(-46434)end return F else return E({},{[R[L("\076\162\b\14