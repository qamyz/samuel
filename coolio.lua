local library = {
    Color = Color3.fromRGB(255, 197, 245),
    Keybind = Enum.KeyCode.P,
}

local MouseBehavior = game.UserInputService.MouseBehavior

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui")

local UIHolder = Instance.new("ScreenGui")
UIHolder.Name = "UIHolder"
UIHolder.Parent = RunService:IsStudio() and game.Players.LocalPlayer:WaitForChild("PlayerGui") or CoreGui
UIHolder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local windows = 0

local ColorCounterRainbow = 0
    local ColorPickerHuePosition = 0

    spawn(function()
        while wait() do
            ColorCounterRainbow = ColorCounterRainbow + 1/255
            if ColorCounterRainbow >= 1 then
                ColorCounterRainbow = 0
            end
            ColorPickerHuePosition = ColorPickerHuePosition + 1
            if ColorPickerHuePosition == 201 then
                ColorPickerHuePosition = 0
            end
        end
    end)

function library:CreateWindow(title)
    local function draggable(obj)
        local globals = {}
        globals.dragging=nil
        globals.uiorigin=nil
        globals.morigin=nil
        obj.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                globals.dragging = true
                globals.uiorigin = obj.Position
                globals.morigin = input.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        globals.dragging = false
                    end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and globals.dragging then
                local change = input.Position - globals.morigin
                TweenService:Create(obj, TweenInfo.new(0.5, Enum.EasingStyle.Exponential,Enum.EasingDirection.Out), {Position = UDim2.new(globals.uiorigin.X.Scale,globals.uiorigin.X.Offset+change.X,globals.uiorigin.Y.Scale,globals.uiorigin.Y.Offset+change.Y)}):Play()
            end
        end)
    end

    windows = windows + 1
    local window = {}
    local stuffs = 0
    local minimized = false
    local WINDOWSIZE = 0
    local dropdownopen = false
    local CLIPPPPP = false
    title = title or "Title"
    local closed = false

    local WindowMain = Instance.new("Frame")
    local MainHolder = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    local ColorBar = Instance.new("Frame")
    local MinimizeButton = Instance.new("TextButton")
    local Title = Instance.new("TextLabel")

    WindowMain.Name = "WindowMain"
    WindowMain.Parent = UIHolder
    WindowMain.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
    WindowMain.BorderSizePixel = 0
    WindowMain.Position = UDim2.new(0, (15 + (239 * windows) - 239), 0, 20)
    WindowMain.Size = UDim2.new(0, 229, 0, 23)

    draggable(WindowMain)

    MainHolder.Name = "MainHolder"
    MainHolder.Parent = WindowMain
    MainHolder.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
    MainHolder.BorderSizePixel = 0
    --MainHolder.ClipsDescendants = true
    MainHolder.Position = UDim2.new(0, 0, 1, 0)
    MainHolder.Size = UDim2.new(0, 229, 0, 0)

    UIListLayout.Parent = MainHolder
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    ColorBar.Name = "ColorBar"
    ColorBar.Parent = WindowMain
    RunService.RenderStepped:Connect(function()
        ColorBar.BackgroundColor3 = library.Color
    end)
    ColorBar.BorderSizePixel = 0
    ColorBar.Position = UDim2.new(0, 0, 1, 0)
    ColorBar.Size = UDim2.new(0, 229, 0, 1)

    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = WindowMain
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.BackgroundTransparency = 1.000
    MinimizeButton.Position = UDim2.new(0.886462867, 0, 0, 0)
    MinimizeButton.Size = UDim2.new(0, 26, 0, 23)
    MinimizeButton.Font = Enum.Font.GothamSemibold
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 14.000

    Title.Name = "Title"
    Title.Parent = WindowMain
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.Position = UDim2.new(0.113537118, 0, 0, 0)
    Title.Size = UDim2.new(0, 177, 0, 23)
    Title.Font = Enum.Font.GothamSemibold
    Title.Text = title
    RunService.RenderStepped:Connect(function()
        Title.TextColor3 = library.Color
    end)
    Title.TextSize = 12.000

    MinimizeButton.MouseButton1Down:Connect(function()
        if MainHolder.Size.Y.Offset == 0 then
            minimized = false
            TweenService:Create(MainHolder, TweenInfo.new(0.1, Enum.EasingStyle.Exponential,Enum.EasingDirection.Out), {Size = UDim2.new(0, MainHolder.Size.X.Offset, 0, WINDOWSIZE + 5)}):Play()
            MainHolder.ClipsDescendants = false
        else
            minimized = true
            TweenService:Create(MainHolder, TweenInfo.new(0.1, Enum.EasingStyle.Exponential,Enum.EasingDirection.Out), {Size = UDim2.new(0, MainHolder.Size.X.Offset, 0, 0)}):Play()
            for i, v in pairs(WindowMain:GetChildren()) do
                if v.Name == "ColorPickerPickerMain" then
                    TweenService:Create(v, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, v.Size.Y.Offset)}):Play()
                end
            end
            MainHolder.ClipsDescendants = true
        end
    end)

    function window:CreateSection(title)
        stuffs = stuffs + 1
        local section = {}
        title = title or "Title"
        local SectionMain = Instance.new("Frame")
        local SectionTItle = Instance.new("TextLabel")

        SectionMain.Name = "SectionMain"
        SectionMain.Parent = MainHolder
        SectionMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SectionMain.BackgroundTransparency = 1.000
        SectionMain.Position = UDim2.new(0, 0, 0.00999999978, 0)
        SectionMain.Size = UDim2.new(0, 229, 0, 22)

        SectionTItle.Name = "SectionTItle"
        SectionTItle.Parent = SectionMain
        SectionTItle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SectionTItle.BackgroundTransparency = 1.000
        SectionTItle.Position = UDim2.new(0.0262008738, 0, 0.0434782617, 0)
        SectionTItle.Size = UDim2.new(0, 223, 0, 22)
        SectionTItle.Font = Enum.Font.GothamSemibold
        SectionTItle.Text = "> "..title
        RunService.RenderStepped:Connect(function()
            SectionTItle.TextColor3 = library.Color
        end)
        SectionTItle.TextSize = 12.000
        SectionTItle.TextXAlignment = Enum.TextXAlignment.Left

        function section:SetText(text)
            SectionTItle.Text = "> "..text
        end

        return section
    end

    function window:CreateLabel(title)
        stuffs = stuffs + 1
        local label = {}
        title = title or "Title"
        local LabelMain = Instance.new("Frame")
        local LabelText = Instance.new("TextLabel")

        LabelMain.Name = "LabelMain"
        LabelMain.Parent = MainHolder
        LabelMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        LabelMain.BackgroundTransparency = 1.000
        LabelMain.Size = UDim2.new(0, 229, 0, 23)

        LabelText.Name = "LabelText"
        LabelText.Parent = LabelMain
        LabelText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        LabelText.BackgroundTransparency = 1.000
        LabelText.Position = UDim2.new(0.0262008738, 0, 0, 0)
        LabelText.Size = UDim2.new(0, 223, 0, 23)
        LabelText.Font = Enum.Font.GothamSemibold
        LabelText.TextColor3 = Color3.fromRGB(255, 255, 255)
        LabelText.TextSize = 11.000
        LabelText.TextXAlignment = Enum.TextXAlignment.Left
        LabelText.Text = title

        function label:SetText(text)
            LabelText.Text = text
        end

        return label
    end

    function window:CreateButton(title, callback)
        stuffs = stuffs + 1
        local button = {}
        if type(title) == "function" then   
            callback = title
            title = "Title"
        end
        title = title or "Title"
        callback = callback or function() end

        local ButtonMain = Instance.new("TextButton")
        local ButtonTitle = Instance.new("TextLabel")

        ButtonMain.Name = "ButtonMain"
        ButtonMain.Parent = MainHolder
        ButtonMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ButtonMain.BackgroundTransparency = 1.000
        ButtonMain.Position = UDim2.new(0, 0, 0.142857149, 0)
        ButtonMain.Size = UDim2.new(0, 229, 0, 23)
        ButtonMain.Font = Enum.Font.SourceSans
        ButtonMain.Text = ""
        ButtonMain.TextColor3 = Color3.fromRGB(0, 0, 0)
        ButtonMain.TextSize = 14.000

        ButtonTitle.Name = "ButtonTitle"
        ButtonTitle.Parent = ButtonMain
        ButtonTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ButtonTitle.BackgroundTransparency = 1.000
        ButtonTitle.Position = UDim2.new(0.0262008738, 0, 0, 0)
        ButtonTitle.Size = UDim2.new(0, 223, 0, 23)
        ButtonTitle.Font = Enum.Font.GothamSemibold
        ButtonTitle.Text = title
        ButtonTitle.TextColor3 = Color3.fromRGB(210, 210, 210)
        ButtonTitle.TextSize = 11.000
        ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left

        ButtonMain.MouseButton1Down:Connect(function()
            TweenService:Create(ButtonTitle, TweenInfo.new(0.5, Enum.EasingStyle.Sine,Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            wait(0.5)
            TweenService:Create(ButtonTitle, TweenInfo.new(0.5, Enum.EasingStyle.Sine,Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
            callback()
        end)

        function button:Press()
            TweenService:Create(ButtonTitle, TweenInfo.new(0.5, Enum.EasingStyle.Sine,Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            wait(0.5)
            TweenService:Create(ButtonTitle, TweenInfo.new(0.5, Enum.EasingStyle.Sine,Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
            callback()
        end

        function button:SetText(text)
            ButtonTitle.Text = text
        end

        return button
    end

    function window:CreateToggle(title, default, callback)
        stuffs = stuffs + 1
        if type(default) == "function" then
            callback = default
            default = false
        end
        title = title or "Title"
        default = default or false
        callback = callback or function() end

        local toggle = {
            Toggled = default
        }

        local ToggleMain = Instance.new("TextButton")
        local ToggleTitle = Instance.new("TextLabel")
        local ToggleIndicator = Instance.new("TextButton")

        ToggleMain.Name = "ToggleMain"
        ToggleMain.Parent = MainHolder
        ToggleMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleMain.BackgroundTransparency = 1.000
        ToggleMain.Position = UDim2.new(0, 0, 0.142857149, 0)
        ToggleMain.Size = UDim2.new(0, 229, 0, 23)
        ToggleMain.Font = Enum.Font.SourceSans
        ToggleMain.Text = ""
        ToggleMain.TextColor3 = Color3.fromRGB(0, 0, 0)
        ToggleMain.TextSize = 14.000

        ToggleTitle.Name = "ToggleTitle"
        ToggleTitle.Parent = ToggleMain
        ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleTitle.BackgroundTransparency = 1.000
        ToggleTitle.Position = UDim2.new(0.0262008738, 0, 0, 0)
        ToggleTitle.Size = UDim2.new(0, 223, 0, 23)
        ToggleTitle.Font = Enum.Font.GothamSemibold
        ToggleTitle.Text = title
        ToggleTitle.TextColor3 = default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(210, 210, 210)
        ToggleTitle.TextSize = 11.000
        ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

        ToggleIndicator.Name = "ToggleIndicator"
        ToggleIndicator.Parent = ToggleTitle
        ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleIndicator.BackgroundTransparency = 1.000
        ToggleIndicator.Position = UDim2.new(0.896860957, 0, 0, 0)
        ToggleIndicator.Size = UDim2.new(0, 23, 0, 23)
        ToggleIndicator.Font = Enum.Font.SourceSans
        ToggleIndicator.Text = default and "✓" or "x"
        ToggleIndicator.TextColor3 = default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(210, 210, 210)
        ToggleIndicator.TextSize = 14.000

        ToggleMain.MouseButton1Down:Connect(function()
            if not toggle.Toggled then
                ToggleIndicator.Text = "✓"
                TweenService:Create(ToggleTitle, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                TweenService:Create(ToggleTitle.ToggleIndicator, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                callback(true)
                toggle.Toggled = true
            else
                ToggleIndicator.Text = "x"
                TweenService:Create(ToggleTitle, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
                TweenService:Create(ToggleIndicator, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
                callback(false)
                toggle.Toggled = false
            end
        end)
        
        ToggleIndicator.MouseButton1Down:Connect(function()
            if not toggle.Toggled then
                ToggleIndicator.Text = "✓"
                TweenService:Create(ToggleTitle, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                TweenService:Create(ToggleTitle.ToggleIndicator, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                callback(true)
                toggle.Toggled = true
            else
                ToggleIndicator.Text = "x"
                TweenService:Create(ToggleTitle, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
                TweenService:Create(ToggleIndicator, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
                callback(false)
                toggle.Toggled = false
            end
        end)

        function toggle:SetToggled(toggled)
            if not toggled then
                ToggleIndicator.Text = "x"
                TweenService:Create(ToggleTitle, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
                TweenService:Create(ToggleIndicator, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
                callback(false)
                toggle.Toggled =  false
            else
                ToggleIndicator.Text = "✓"
                TweenService:Create(ToggleTitle, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                TweenService:Create(ToggleTitle.ToggleIndicator, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                callback(true)
                toggle.Toggled = true
            end
        end

        function toggle:GetToggled()
            return toggle.Toggled
        end

        return toggle
    end

    function window:CreateTextbox(title, placeholder, text, callback)
        stuffs = stuffs + 1
        local textbox = {}
        title = title or "Title"
        placeholder = placeholder or ""
        text = text or ""
        callback = callback or function() end
        local TextboxMain = Instance.new("Frame")
        local Textbox = Instance.new("TextBox")
        local TextLabel = Instance.new("TextLabel")

        TextboxMain.Name = "TextboxMain"
        TextboxMain.Parent = MainHolder
        TextboxMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextboxMain.BackgroundTransparency = 1.000
        TextboxMain.Position = UDim2.new(0, 0, 0.4375, 0)
        TextboxMain.Size = UDim2.new(0, 229, 0, 23)

        Textbox.Name = "Textbox"
        Textbox.Parent = TextboxMain
        Textbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Textbox.BackgroundTransparency = 1.000
        Textbox.Position = UDim2.new(0.248908296, 0, 0, 0)
        Textbox.Size = UDim2.new(0, 172, 0, 23)
        Textbox.ClearTextOnFocus = false
        Textbox.Font = Enum.Font.GothamSemibold
        Textbox.PlaceholderText = placeholder
        Textbox.Text = text
        Textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
        Textbox.TextSize = 11.000
        Textbox.TextXAlignment = Enum.TextXAlignment.Left

        TextLabel.Parent = TextboxMain
        TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.BackgroundTransparency = 1.000
        TextLabel.Size = UDim2.new(0, 57, 0, 23)
        TextLabel.Font = Enum.Font.GothamSemibold
        TextLabel.Text = title
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.TextSize = 11.000
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.Position = UDim2.new(0.026, 0,0, 0)

        Textbox.FocusLost:Connect(function()
            callback(Textbox.Text)
        end)

        function textbox:SetText(text)
            callback(text)
            Textbox.Text = text
        end

        function textbox:GetText()
            return Textbox.Text
        end

        return textbox
    end

    function window:CreateKeybind(title, default, callback)
        stuffs = stuffs + 1
        local keybind= {}
        if type(default) == "string" then
            default = Enum.KeyCode[default]
        end
        title = title or "Title"
        default = default or Enum.Keycode.X

        local KeybindMain = Instance.new("TextButton")
        local KeybindValue = Instance.new("TextLabel")
        local KeybindTitle = Instance.new("TextLabel")

        KeybindMain.Name = "KeybindMain"
        KeybindMain.Parent = MainHolder
        KeybindMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        KeybindMain.BackgroundTransparency = 1.000
        KeybindMain.Position = UDim2.new(0, 0, 0.517361104, 0)
        KeybindMain.Size = UDim2.new(0, 229, 0, 23)
        KeybindMain.Font = Enum.Font.SourceSans
        KeybindMain.Text = ""
        KeybindMain.TextColor3 = Color3.fromRGB(0, 0, 0)
        KeybindMain.TextSize = 14.000

        KeybindValue.Name = "KeybindValue"
        KeybindValue.Parent = KeybindMain
        KeybindValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        KeybindValue.BackgroundTransparency = 1.000
        KeybindValue.Position = UDim2.new(0.899563313, 0, 0, 0)
        KeybindValue.Size = UDim2.new(0, 23, 0, 23)
        KeybindValue.Font = Enum.Font.GothamSemibold
        KeybindValue.Text = tostring(default):gsub("Enum.KeyCode.", "")
        KeybindValue.TextColor3 = Color3.fromRGB(255, 255, 255)
        KeybindValue.TextSize = 11.000

        KeybindTitle.Name = "KeybindTitle"
        KeybindTitle.Parent = KeybindMain
        KeybindTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        KeybindTitle.BackgroundTransparency = 1.000
        KeybindTitle.Size = UDim2.new(0, 51, 0, 23)
        KeybindTitle.Font = Enum.Font.GothamSemibold
        KeybindTitle.Text = title
        KeybindTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        KeybindTitle.TextSize = 11.000
        KeybindTitle.Position = UDim2.new(0.026, 0, 0, 0)
        KeybindTitle.TextXAlignment = Enum.TextXAlignment.Left

        function parse(keycode)
            return tostring(keycode):gsub("Enum.KeyCode.", "")
        end

        local LastBindText = parse(default)
        local BindedKey = default
        local JustBinded = false

        KeybindMain.MouseButton1Click:Connect(function()
            KeybindValue.Text = ". . ."
            IsKeyBinding = true

            UISConnection = game:GetService("UserInputService").InputBegan:Connect(function(input)
                BindedKey = input.KeyCode
                KeybindValue.Text = parse(BindedKey)
                LastBindText = KeybindValue.Text

                JustBinded = true
                IsKeyBinding = false
                UISConnection:Disconnect()
            end)
        end)

        game:GetService("UserInputService").InputBegan:Connect(function()
            if not JustBinded then
                callback(BindedKey)
            end

            if JustBinded then
                JustBinded = false
            end
        end)

        KeybindMain.MouseLeave:Connect(function()
            KeybindValue.Text = LastBindText
            IsKeyBinding = false
        end)

        function keybind:SetKey(key)
            callback(key)
            KeybindMain.Text = parse(key)
        end

        function keybind:GetKey()
            return BindedKey
        end
        
        return keybind
    end

    function window:CreateSlider(title, min, max, default, round, callback)
        stuffs = stuffs + 1
        local slider = {}
        title = title or "Title"
        min = min or 0
        max = max or 100
        default = default or 0
        round = round or false
        callback = callback or function() end

        local SliderMain = Instance.new("Frame")
        local SliderTitle = Instance.new("TextLabel")
        local SliderValue = Instance.new("TextBox")
        local SliderBack = Instance.new("TextButton")
        local SliderButton = Instance.new("TextButton")

        SliderMain.Name = "SliderMain"
        SliderMain.Parent = MainHolder
        SliderMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SliderMain.BackgroundTransparency = 1.000
        SliderMain.Position = UDim2.new(0, 0, 0.493506491, 0)
        SliderMain.Size = UDim2.new(0, 229, 0, 35)

        SliderTitle.Name = "SliderTitle"
        SliderTitle.Parent = SliderMain
        SliderTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SliderTitle.BackgroundTransparency = 1.000
        SliderTitle.Position = UDim2.new(0.0262008738, 0, 0, 0)
        SliderTitle.Size = UDim2.new(0, 223, 0, 23)
        SliderTitle.Font = Enum.Font.GothamSemibold
        SliderTitle.Text = title
        SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        SliderTitle.TextSize = 11.000
        SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

        SliderValue.Name = "SliderValue"
        SliderValue.Parent = SliderTitle
        SliderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SliderValue.BackgroundTransparency = 1.000
        SliderValue.Position = UDim2.new(0.820627809, 0, 0, 0)
        SliderValue.Size = UDim2.new(0, 40, 0, 23)
        SliderValue.Font = Enum.Font.GothamSemibold
        SliderValue.Text = default
        SliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
        SliderValue.TextSize = 11.000

        SliderBack.Name = "SliderBack"
        SliderBack.Parent = SliderMain
        SliderBack.BackgroundColor3 = Color3.fromRGB(67, 67, 67)
        SliderBack.BorderSizePixel = 0
        SliderBack.Position = UDim2.new(0.030567687, 0, 0.828571439, 0)
        SliderBack.Size = UDim2.new(0, 214, 0, 4)
        SliderBack.ZIndex = 2
        SliderBack.AutoButtonColor = false
        SliderBack.Font = Enum.Font.SourceSans
        SliderBack.Text = ""
        SliderBack.TextColor3 = Color3.fromRGB(0, 0, 0)
        SliderBack.TextSize = 14.000
        SliderBack.ClipsDescendants = true

        SliderButton.Name = "SliderButton"
        SliderButton.Parent = SliderBack
        RunService.RenderStepped:Connect(function()
        SliderButton.BackgroundColor3 = library.Color
        end)
        SliderButton.BorderSizePixel = 0
        SliderButton.Size = UDim2.new((default - min) / (max - min), 0, 0, 4)
        SliderButton.ZIndex = 2
        SliderButton.AutoButtonColor = false
        SliderButton.Font = Enum.Font.SourceSans
        SliderButton.Text = ""
        SliderButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        SliderButton.TextSize = 14.000

        callback(default)

        local MouseDown = false
        local value = default
                
        function map(x, in_min, in_max, out_min, out_max)
            return out_min + (x - in_min)*(out_max - out_min)/(in_max - in_min)
        end
                
        SliderButton.MouseButton1Down:Connect(function()
            MouseDown = true
        end)

        SliderBack.MouseButton1Down:Connect(function()
            MouseDown = true
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                MouseDown = false
            end
        end)
                
        RunService.RenderStepped:Connect(function()
            local UIStart = SliderBack.AbsolutePosition.X
            local UIEnd = SliderBack.AbsolutePosition.X + SliderBack.AbsoluteSize.X
            if MouseDown then
                local range = map(Mouse.X, UIStart, UIEnd, 0, 1)
                range = math.clamp(range, 0, 1)
                if not round then
                    value = math.floor(map(range, 0, 1, min, max) * 100) / 100
                else
                    value = math.floor(map(range, 0, 1, min, max))
                end
                SliderButton:TweenSize(UDim2.new(range,0,0,4), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, .2, true)
                SliderValue.Text = value
                callback(value)
            end
        end)

                function slider:SetValue(val)
                    if val > max then
                        SliderButton.Size = UDim2.new(((max) - min) / (max - min), 0, 0, 4)
                        value = max
                        callback(max)
                        SliderValue.Text = max
                    elseif val < max and val > min then
                        SliderButton.Size = UDim2.new(((val) - min) / (max - min), 0, 0, 4)
                        value = val
                        callback(val)
                    elseif val < min then
                        SliderButton.Size = UDim2.new(((min) - min) / (max - min), 0, 0, 4)
                        value = min
                        callback(min)
                        SliderValue.Text = min
                    end
                end

                function slider:GetValue()
                    return value
                end

                local Change = false
                SliderValue.Focused:Connect(function()
                    Change = true
                end)

                SliderValue.FocusLost:Connect(function()
                    Change = false
                end)

                game:GetService("RunService").RenderStepped:Connect(function()
                    if Change then
                        slider:SetValue(tonumber(SliderValue.Text))
                    end
                end)

        return slider
    end

    function window:CreateDropdown(title, options, default, callback)
        stuffs = stuffs + 1
        title = title or "Title"
        options = options or {}
        default = default or 1
        multi = multi or false
        callback = callback or function() end

        local dropdown = {}
        local selected = default

        local DropdownMain = Instance.new("TextButton")
        local DropdownTitle = Instance.new("TextLabel")
        local DropdownButton = Instance.new("TextButton")
        local DropdownOptionsHolder = Instance.new("Frame")
        local UIListLayout_2 = Instance.new("UIListLayout")

        DropdownMain.Name = "DropdownMain"
        DropdownMain.Parent = MainHolder
        DropdownMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        DropdownMain.BackgroundTransparency = 1.000
        DropdownMain.Position = UDim2.new(0, 0, 0.597222209, 0)
        DropdownMain.Size = UDim2.new(0, 229, 0, 23)
        DropdownMain.ZIndex = 2
        DropdownMain.Font = Enum.Font.GothamSemibold
        DropdownMain.Text = ""
        DropdownMain.TextColor3 = Color3.fromRGB(0, 0, 0)
        DropdownMain.TextSize = 14.000
        DropdownMain.ZIndex = 1

        DropdownTitle.Name = "DropdownTitle"
        DropdownTitle.Parent = DropdownMain
        DropdownTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        DropdownTitle.BackgroundTransparency = 1.000
        DropdownTitle.Position = UDim2.new(0.0262008738, 0, 0, 0)
        DropdownTitle.Size = UDim2.new(0, 223, 0, 23)
        DropdownTitle.Font = Enum.Font.SourceSans
        DropdownTitle.Text = title
        DropdownTitle.TextColor3 = Color3.fromRGB(210, 210, 210)
        DropdownTitle.TextSize = 14.000
        DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
        DropdownTitle.ZIndex = 1

        DropdownButton.Name = "DropdownButton"
        DropdownButton.Parent = DropdownTitle
        DropdownButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        DropdownButton.BackgroundTransparency = 1.000
        DropdownButton.Position = UDim2.new(0.896860957, 0, 0, 0)
        DropdownButton.Size = UDim2.new(0, 23, 0, 23)
        DropdownButton.Font = Enum.Font.SourceSans
        DropdownButton.Text = "v"
        DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        DropdownButton.TextSize = 14.000
        DropdownButton.ZIndex = 1

        DropdownOptionsHolder.Name = "DropdownOptionsHolder"
        DropdownOptionsHolder.Parent = DropdownMain
        DropdownOptionsHolder.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
        DropdownOptionsHolder.BorderColor3 = Color3.fromRGB(255, 197, 245)
        DropdownOptionsHolder.BorderSizePixel = 0
        DropdownOptionsHolder.ClipsDescendants = true
        DropdownOptionsHolder.Position = UDim2.new(0, 0, 1, 0)
        DropdownOptionsHolder.Size = UDim2.new(0, 229, 0, 0)
        DropdownOptionsHolder.ZIndex = 1

        UIListLayout_2.Parent = DropdownOptionsHolder
        UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder

        DropdownMain.MouseButton1Down:Connect(function()
            if DropdownOptionsHolder.Size.Y.Offset == 0 then
                for i, v in pairs(MainHolder:GetChildren()) do
                    if v.Name == "DropdownMain" and v ~= DropdownMain then
                        v.ZIndex = 0
                        TweenService:Create(v.DropdownOptionsHolder, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0, v.DropdownOptionsHolder.Size.X.Offset, 0, 0)}):Play()	
                    elseif v == DropdownMain then
                        v.ZIndex = 2
                    end
                end

                local newsize = 0
                for i, v in pairs(DropdownOptionsHolder:GetChildren()) do
                    if v:IsA("TextButton") then
                        newsize = newsize + v.Size.Y.Offset
                    end
                end

                TweenService:Create(DropdownButton, TweenInfo.new(0.1, Enum.EasingStyle.Exponential,Enum.EasingDirection.Out), {TextColor3 = library.Color}):Play()
                TweenService:Create(DropdownTitle, TweenInfo.new(0.1, Enum.EasingStyle.Exponential,Enum.EasingDirection.Out), {TextColor3 = Color3.new(1, 1, 1)}):Play()
                if stuffs == 1 then
                    TweenService:Create(MainHolder, TweenInfo.new(0.1, Enum.EasingStyle.Exponential,Enum.EasingDirection.Out), {Size = UDim2.new(0, MainHolder.Size.X.Offset, 0, WINDOWSIZE + newsize)}):Play()
                end
                TweenService:Create(DropdownOptionsHolder, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0, DropdownOptionsHolder.Size.X.Offset, 0, newsize)}):Play()	
                dropdownopen = true
            else
                for i, v in pairs(MainHolder:GetChildren()) do
                    if v.Name == "DropdownMain" and v ~= DropdownMain then
                        v.ZIndex = 1
                    end
                end

                TweenService:Create(DropdownTitle, TweenInfo.new(0.1, Enum.EasingStyle.Exponential,Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
        
                TweenService:Create(DropdownButton, TweenInfo.new(0.1, Enum.EasingStyle.Exponential,Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        
                if stuffs == 1 then
                    TweenService:Create(MainHolder, TweenInfo.new(0.1, Enum.EasingStyle.Exponential,Enum.EasingDirection.Out), {Size = UDim2.new(0, MainHolder.Size.X.Offset, 0, WINDOWSIZE)}):Play()
                end
        
                TweenService:Create(DropdownOptionsHolder, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0, DropdownOptionsHolder.Size.X.Offset, 0, 0)}):Play()
                dropdownopen = false
            end
        end)

        function dropdown:Refresh(options)
            for i, v in pairs(DropdownOptionsHolder:GetChildren()) do
                if v:IsA("TextButton") then
                    v:Destroy()
                end
            end

            for i, v in pairs(options) do
                local DropdownOptionMain = Instance.new("TextButton")
                local DropdownOptionTitle = Instance.new("TextLabel")
                local DropdownOptionIndicator = Instance.new("TextButton")

                DropdownOptionMain.Name = "DropdownOptionMain"
                DropdownOptionMain.Parent = DropdownOptionsHolder
                DropdownOptionMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                DropdownOptionMain.BackgroundTransparency = 1.000
                DropdownOptionMain.Position = UDim2.new(0, 0, 0.142857149, 0)
                DropdownOptionMain.Size = UDim2.new(0, 229, 0, 23)
                DropdownOptionMain.Font = Enum.Font.SourceSans
                DropdownOptionMain.Text = ""
                DropdownOptionMain.TextColor3 = Color3.fromRGB(0, 0, 0)
                DropdownOptionMain.TextSize = 14.000

                DropdownOptionTitle.Name = "DropdownOptionTitle"
                DropdownOptionTitle.Parent = DropdownOptionMain
                DropdownOptionTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                DropdownOptionTitle.BackgroundTransparency = 1.000
                DropdownOptionTitle.Position = UDim2.new(0.0262008738, 0, 0, 0)
                DropdownOptionTitle.Size = UDim2.new(0, 223, 0, 23)
                DropdownOptionTitle.Font = Enum.Font.GothamSemibold
                DropdownOptionTitle.Text = v
                DropdownOptionTitle.TextColor3 = default == i and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(210, 210, 210)
                DropdownOptionTitle.TextSize = 11.000
                DropdownOptionTitle.TextXAlignment = Enum.TextXAlignment.Left

                DropdownOptionIndicator.Name = "DropdownOptionIndicator"
                DropdownOptionIndicator.Parent = DropdownOptionTitle
                DropdownOptionIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                DropdownOptionIndicator.BackgroundTransparency = 1.000
                DropdownOptionIndicator.Position = UDim2.new(0.896860957, 0, 0, 0)
                DropdownOptionIndicator.Size = UDim2.new(0, 23, 0, 23)
                DropdownOptionIndicator.Font = Enum.Font.SourceSans
                DropdownOptionIndicator.Text = default == i and "✓" or "x"
                DropdownOptionIndicator.TextColor3 = default == i and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(210, 210, 210)
                DropdownOptionIndicator.TextSize = 14.000

                DropdownOptionMain.MouseButton1Down:Connect(function()
                    if selected ~= v then
                        selected = v
                        DropdownOptionIndicator.Text = "✓"
                        TweenService:Create(DropdownOptionTitle, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                        TweenService:Create(DropdownOptionIndicator, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                    
                        for i, v in pairs(DropdownOptionsHolder:GetChildren()) do
                            if v ~= DropdownOptionMain and v:IsA("TextButton") then
                                v.DropdownOptionTitle.DropdownOptionIndicator.Text = "x"
                                TweenService:Create(v.DropdownOptionTitle, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
                                TweenService:Create(v.DropdownOptionTitle.DropdownOptionIndicator, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
                            end
                        end
                        callback(v)
                    end
                end)

                DropdownOptionIndicator.MouseButton1Down:Connect(function()
                    if selected ~= v then
                        selected = v
                        DropdownOptionIndicator.Text = "✓"
                        TweenService:Create(DropdownOptionTitle, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                        TweenService:Create(DropdownOptionIndicator, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                    
                        for i, v in pairs(DropdownOptionsHolder:GetChildren()) do
                            if v ~= DropdownOptionMain and v:IsA("TextButton") then
                                v.DropdownOptionTitle.DropdownOptionIndicator.Text = "x"
                                TweenService:Create(v.DropdownOptionTitle, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
                                TweenService:Create(v.DropdownOptionTitle.DropdownOptionIndicator, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
                            end
                        end
                        callback(v)
                    end
                end)
            end
        end

        dropdown:Refresh(options)

        return dropdown
    end

    function window:CreateColorPicker(title, default, callback)
        stuffs = stuffs + 1
        title = title or "Title"
        default = default or Color3.fromRGB(255, 255, 255)
        callback = callback or function() end

        local colorpicker = {}

        local ColorPickerMain = Instance.new("TextButton")
        local ColorPickerTitle = Instance.new("TextLabel")
        local ColorPickerCurrentColor = Instance.new("TextButton")
        local ColorPickerPickerMain = Instance.new("Frame")
        local ColorPickerPickerBackFrame = Instance.new("Frame")
        local ColorPickerMainColor = Instance.new("ImageButton")
        local ColorPickerMainHandle = Instance.new("ImageButton")
        local ColorPickerHueMain = Instance.new("ImageButton")
        local ColorPickerHueHandle = Instance.new("TextButton")
        local ColorPickerOptions = Instance.new("Frame")
        local UIListLayout_3 = Instance.new("UIListLayout")
        local ColorPickerR = Instance.new("TextBox")
        local ColorPickerG = Instance.new("TextBox")
        local ColorPickerB = Instance.new("TextBox")
        local ColorPickerRGB = Instance.new("TextBox")
        local ColorPickerRainbowMain = Instance.new("TextButton")
        local ColorPickerRainbowTitle = Instance.new("TextLabel")
        local ColorPickerRainbowIndicator = Instance.new("TextButton")
        local ColorPickerSelect = Instance.new("TextButton")

        ColorPickerMain.Name = "ColorPickerMain"
        ColorPickerMain.Parent = MainHolder
        ColorPickerMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ColorPickerMain.BackgroundTransparency = 1.000
        ColorPickerMain.Position = UDim2.new(0, 0, 0.677083313, 0)
        ColorPickerMain.Size = UDim2.new(0, 229, 0, 23)
        ColorPickerMain.Font = Enum.Font.SourceSans
        ColorPickerMain.Text = ""
        ColorPickerMain.TextColor3 = Color3.fromRGB(0, 0, 0)
        ColorPickerMain.TextSize = 14.000

        ColorPickerTitle.Name = "ColorPickerTitle"
        ColorPickerTitle.Parent = ColorPickerMain
        ColorPickerTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ColorPickerTitle.BackgroundTransparency = 1.000
        ColorPickerTitle.Position = UDim2.new(0.0262008738, 0, 0, 0)
        ColorPickerTitle.Size = UDim2.new(0, 223, 0, 23)
        ColorPickerTitle.Font = Enum.Font.GothamSemibold
        ColorPickerTitle.Text = title
        ColorPickerTitle.TextColor3 = Color3.fromRGB(210, 210, 210)
        ColorPickerTitle.TextSize = 11.000
        ColorPickerTitle.TextXAlignment = Enum.TextXAlignment.Left

        ColorPickerCurrentColor.Name = "ColorPickerCurrentColor"
        ColorPickerCurrentColor.Parent = ColorPickerTitle
        ColorPickerCurrentColor.BackgroundColor3 = default
        ColorPickerCurrentColor.BorderSizePixel = 0
        ColorPickerCurrentColor.Position = UDim2.new(0.896860957, 0, 0, 0)
        ColorPickerCurrentColor.Size = UDim2.new(0, 23, 0, 23)
        ColorPickerCurrentColor.AutoButtonColor = false
        ColorPickerCurrentColor.Font = Enum.Font.SourceSans
        ColorPickerCurrentColor.Text = ""
        ColorPickerCurrentColor.TextColor3 = Color3.fromRGB(0, 0, 0)
        ColorPickerCurrentColor.TextSize = 14.000

        ColorPickerPickerMain.Name = "ColorPickerPickerMain"
        ColorPickerPickerMain.Parent = WindowMain
        ColorPickerPickerMain.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
        ColorPickerPickerMain.BorderSizePixel = 0
		        ColorPickerPickerMain.ClipsDescendants = true
        ColorPickerPickerMain.Position = UDim2.new(0, ColorPickerMain.Position.X.Offset + 229, 0, ColorPickerMain.AbsolutePosition.Y)
        ColorPickerPickerMain.Size = UDim2.new(0, 0, 0, 201)

        ColorPickerPickerBackFrame.Name = "ColorPickerPickerBackFrame"
        ColorPickerPickerBackFrame.Parent = ColorPickerPickerMain
        ColorPickerPickerBackFrame.BackgroundColor3 = default
        ColorPickerPickerBackFrame.BorderSizePixel = 0
        ColorPickerPickerBackFrame.Size = UDim2.new(0, 201, 0, 201)

        ColorPickerMainColor.Name = "ColorPickerMainColor"
        ColorPickerMainColor.Parent = ColorPickerPickerBackFrame
        ColorPickerMainColor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ColorPickerMainColor.BackgroundTransparency = 1.000
        ColorPickerMainColor.Size = UDim2.new(0, 201, 0, 201)
        ColorPickerMainColor.Image = "rbxassetid://4805274903"

        ColorPickerMainHandle.Name = "ColorPickerMainHandle"
        ColorPickerMainHandle.Parent = ColorPickerMainColor
        ColorPickerMainHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ColorPickerMainHandle.BackgroundTransparency = 1.000
        ColorPickerMainHandle.Position = UDim2.new(0.427860707, 0, 0.427860707, 0)
        ColorPickerMainHandle.Size = UDim2.new(0, 14, 0, 14)
        ColorPickerMainHandle.Image = "http://www.roblox.com/asset/?id=4953646208"

        ColorPickerHueMain.Name = "ColorPickerHueMain"
        ColorPickerHueMain.Parent = ColorPickerPickerMain
        ColorPickerHueMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ColorPickerHueMain.BackgroundTransparency = 1.000
        ColorPickerHueMain.Position = UDim2.new(0.618425488, 0, 0, 0)
        ColorPickerHueMain.Size = UDim2.new(0, 23, 0, 201)
        ColorPickerHueMain.Image = "rbxassetid://4650897105"

        ColorPickerHueHandle.Name = "ColorPickerHueHandle"
        ColorPickerHueHandle.Parent = ColorPickerHueMain
        ColorPickerHueHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ColorPickerHueHandle.BorderSizePixel = 0
        ColorPickerHueHandle.Position = UDim2.new(0, 0, 0.228855714, 0)
        ColorPickerHueHandle.Size = UDim2.new(0, 23, 0, 4)
        ColorPickerHueHandle.AutoButtonColor = false
        ColorPickerHueHandle.Font = Enum.Font.SourceSans
        ColorPickerHueHandle.Text = ""
        ColorPickerHueHandle.TextColor3 = Color3.fromRGB(0, 0, 0)
        ColorPickerHueHandle.TextSize = 14.000

        ColorPickerOptions.Name = "ColorPickerOptions"
        ColorPickerOptions.Parent = ColorPickerPickerMain
        ColorPickerOptions.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        ColorPickerOptions.BackgroundTransparency = 1.000
        ColorPickerOptions.Position = UDim2.new(0.686567187, 0, 0, 0)
        ColorPickerOptions.Size = UDim2.new(0, 105, 0, 132)

        UIListLayout_3.Parent = ColorPickerOptions
        UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout_3.Padding = UDim.new(0, 4)

        ColorPickerR.Name = "ColorPickerR"
        ColorPickerR.Parent = ColorPickerOptions
        ColorPickerR.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ColorPickerR.BackgroundTransparency = 1.000
        ColorPickerR.Size = UDim2.new(0, 105, 0, 23)
        ColorPickerR.Font = Enum.Font.SourceSans
        ColorPickerR.Text = math.floor(default.R*255)
        ColorPickerR.TextColor3 = Color3.fromRGB(255, 0, 0)
        ColorPickerR.TextSize = 14.000

        ColorPickerG.Name = "ColorPickerG"
        ColorPickerG.Parent = ColorPickerOptions
        ColorPickerG.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ColorPickerG.BackgroundTransparency = 1.000
        ColorPickerG.Size = UDim2.new(0, 105, 0, 23)
        ColorPickerG.Font = Enum.Font.SourceSans
        ColorPickerG.Text = math.floor(default.G*255)
        ColorPickerG.TextColor3 = Color3.fromRGB(0, 255, 0)
        ColorPickerG.TextSize = 14.000

        ColorPickerB.Name = "ColorPickerB"
        ColorPickerB.Parent = ColorPickerOptions
        ColorPickerB.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ColorPickerB.BackgroundTransparency = 1.000
        ColorPickerB.Size = UDim2.new(0, 105, 0, 23)
        ColorPickerB.Font = Enum.Font.SourceSans
        ColorPickerB.Text = math.floor(default.B*255)
        ColorPickerB.TextColor3 = Color3.fromRGB(0, 0, 255)
        ColorPickerB.TextSize = 14.000

        ColorPickerRGB.Name = "ColorPickerRGB"
        ColorPickerRGB.Parent = ColorPickerOptions
        ColorPickerRGB.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ColorPickerRGB.BackgroundTransparency = 1.000
        ColorPickerRGB.Size = UDim2.new(0, 105, 0, 23)
        ColorPickerRGB.Font = Enum.Font.SourceSans
        ColorPickerRGB.Text = math.floor(default.R*255)..", "..math.floor(default.G*255)..", "..math.floor(default.B*255)
        ColorPickerRGB.TextColor3 = Color3.fromRGB(255, 255, 255)
        ColorPickerRGB.TextSize = 14.000

        ColorPickerRainbowMain.Name = "ColorPickerRainbowMain"
        ColorPickerRainbowMain.Parent = ColorPickerOptions
        ColorPickerRainbowMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ColorPickerRainbowMain.BackgroundTransparency = 1.000
        ColorPickerRainbowMain.Position = UDim2.new(0, 0, 1.08000004, 0)
        ColorPickerRainbowMain.Size = UDim2.new(0, 105, 0, 23)
        ColorPickerRainbowMain.Font = Enum.Font.SourceSans
        ColorPickerRainbowMain.Text = ""
        ColorPickerRainbowMain.TextColor3 = Color3.fromRGB(0, 0, 0)
        ColorPickerRainbowMain.TextSize = 14.000

        ColorPickerRainbowTitle.Name = "ColorPickerRainbowTitle"
        ColorPickerRainbowTitle.Parent = ColorPickerRainbowMain
        ColorPickerRainbowTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ColorPickerRainbowTitle.BackgroundTransparency = 1.000
        ColorPickerRainbowTitle.Position = UDim2.new(0.0928676054, 0, 0, 0)
        ColorPickerRainbowTitle.Size = UDim2.new(0, 95, 0, 23)
        ColorPickerRainbowTitle.Font = Enum.Font.GothamSemibold
        ColorPickerRainbowTitle.Text = "Rainbow"
        ColorPickerRainbowTitle.TextColor3 = Color3.fromRGB(210, 210, 210)
        ColorPickerRainbowTitle.TextSize = 11.000
        ColorPickerRainbowTitle.TextXAlignment = Enum.TextXAlignment.Left

        ColorPickerRainbowIndicator.Name = "ColorPickerRainbowIndicator"
        ColorPickerRainbowIndicator.Parent = ColorPickerRainbowTitle
        ColorPickerRainbowIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ColorPickerRainbowIndicator.BackgroundTransparency = 1.000
        ColorPickerRainbowIndicator.Position = UDim2.new(0.766396046, 0, 0, 0)
        ColorPickerRainbowIndicator.Size = UDim2.new(0, 23, 0, 23)
        ColorPickerRainbowIndicator.Font = Enum.Font.SourceSans
        ColorPickerRainbowIndicator.Text = "x"
        ColorPickerRainbowIndicator.TextColor3 = Color3.fromRGB(210, 210, 210)
        ColorPickerRainbowIndicator.TextSize = 14.000

        ColorPickerSelect.Name = "ColorPickerSelect"
        ColorPickerSelect.Parent = ColorPickerPickerMain
        ColorPickerSelect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ColorPickerSelect.BackgroundTransparency = 1.000
        ColorPickerSelect.Position = UDim2.new(0.687082052, 0, 0.651741266, 0)
        ColorPickerSelect.Size = UDim2.new(0, 103, 0, 70)
        ColorPickerSelect.Font = Enum.Font.GothamSemibold
        ColorPickerSelect.Text = "Select"
        ColorPickerSelect.TextColor3 = Color3.fromRGB(255, 255, 255)
        ColorPickerSelect.TextSize = 11.000

        local RAINBOWING = false

        ColorPickerMain.MouseButton1Down:Connect(function()
            if ColorPickerPickerMain.Size.X.Offset == 0 then
                TweenService:Create(ColorPickerPickerMain, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0, 335, 0, ColorPickerPickerMain.Size.Y.Offset)}):Play()
                for i, v in pairs(WindowMain:GetChildren()) do
                    if v.Name == "ColorPickerPickerMain" and v ~= ColorPickerPickerMain then
                        TweenService:Create(v, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, v.Size.Y.Offset)}):Play()
                    end
                end
            else
                TweenService:Create(ColorPickerPickerMain, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, ColorPickerPickerMain.Size.Y.Offset)}):Play()
            end
        end)
        
        ColorPickerCurrentColor.MouseButton1Down:Connect(function()
            if ColorPickerPickerMain.Size.X.Offset == 0 then
                TweenService:Create(ColorPickerPickerMain, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0, 335, 0, ColorPickerPickerMain.Size.Y.Offset)}):Play()
                for i, v in pairs(WindowMain:GetChildren()) do
                    if v.Name == "ColorPickerPickerMain" and v ~= ColorPickerPickerMain then
                        TweenService:Create(v, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, v.Size.Y.Offset)}):Play()
                    end
                end
            else
                TweenService:Create(ColorPickerPickerMain, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, ColorPickerPickerMain.Size.Y.Offset)}):Play()
            end
        end)

        local MouseDown = false
local function map(x, in_min, in_max, out_min, out_max)
                    return out_min + (x - in_min)*(out_max - out_min)/(in_max - in_min)
                end

                local H, S, B = Color3.toHSV(Color3.fromRGB(0, 255, 127))

                local function updateColor()
                    local Color = Color3.fromHSV(H,S,B)
                    ColorPickerRGB.Text = tostring(math.floor(Color.r * 255))..", "..tostring(math.floor(Color.g * 255))..", "..tostring(math.floor(Color.b * 255))
                    ColorPickerR.Text = tostring(math.floor(Color.r * 255))
                    ColorPickerG.Text = tostring(math.floor(Color.g * 255))
                    ColorPickerB.Text = tostring(math.floor(Color.b * 255))
	                ColorPickerPickerBackFrame.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
                    ColorPickerCurrentColor.BackgroundColor3 = Color3.fromHSV(H, S, B)
                    callback(Color)
                end

                ColorPickerSelect.MouseButton1Down:Connect(function()
                    TweenService:Create(ColorPickerPickerMain, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, ColorPickerPickerMain.Size.Y.Offset)}):Play()
                end)

                ColorPickerRainbowMain.MouseButton1Down:Connect(function()
                    if RAINBOWING then
                        ColorPickerRainbowIndicator.Text = "x"
                        TweenService:Create(ColorPickerRainbowTitle, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
                        TweenService:Create(ColorPickerRainbowIndicator, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
                        RAINBOWING  = false
                    else
                        ColorPickerRainbowIndicator.Text = "✓"
                        TweenService:Create(ColorPickerRainbowTitle, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                        TweenService:Create(ColorPickerRainbowIndicator, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                        RAINBOWING = true
                    end

                    spawn(function()
                        while RAINBOWING do
                            ColorPickerPickerBackFrame.BackgroundColor3 = Color3.fromHSV(ColorCounterRainbow, 1, 1)
        
                            ColorPickerHueHandle.Position = UDim2.new(0, 0, 0, ColorPickerHuePosition)
                            ColorPickerMainHandle.Position = UDim2.new(0, 190, 0, 0)

                            local Color = Color3.fromHSV(ColorCounterRainbow, 1, 1)
                            ColorPickerRGB.Text = tostring(math.floor(Color.r * 255))..", "..tostring(math.floor(Color.g * 255))..", "..tostring(math.floor(Color.b * 255))
                            ColorPickerR.Text = tostring(math.floor(Color.r * 255))
                            ColorPickerG.Text = tostring(math.floor(Color.g * 255))
                            ColorPickerB.Text = tostring(math.floor(Color.b * 255))
        
                            callback(ColorPickerPickerBackFrame.BackgroundColor3) 
                            wait()
                        end
                    end)
                end)

                local UserInputService = game:GetService("UserInputService")
                local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
                local RunService = game:GetService("RunService")
                ColorPickerMainColor.MouseEnter:connect(function()
                    local input = ColorPickerMainColor.InputBegan:connect(function(key)
                        if key.UserInputType == Enum.UserInputType.MouseButton1 then
                            while wait() and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                                local objectPosition = Vector2.new(Mouse.X - ColorPickerMainColor.AbsolutePosition.X, Mouse.Y - ColorPickerMainColor.AbsolutePosition.Y);
                                local XRange = math.clamp(map(objectPosition.X, 0, 190, 0, 1), 0, 1)
                                local YRange = math.clamp(map(objectPosition.Y, 0, 190, 0, 1), 0, 1)
                                S = XRange
                                B = 1-YRange
                                ColorPickerMainHandle:TweenPosition(UDim2.new(0, XRange*190, 0, YRange*190), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.1, true);
                                updateColor()
                            end
                        end
                    end)

                    local leave;
                    leave = ColorPickerMainColor.MouseLeave:connect(function()
                        input:disconnect();
                        leave:disconnect();
                    end)
                end)

                ColorPickerHueMain.InputBegan:connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        MouseDown = true
                    end
                end)

				ColorPickerHueHandle.InputBegan:connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        MouseDown = true
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        MouseDown = false
                    end
                end)

                Mouse.Move:connect(function()
                    if MouseDown then
                        local range = math.clamp(map(Mouse.Y, ColorPickerHueMain.AbsolutePosition.Y, ColorPickerHueMain.AbsolutePosition.Y + ColorPickerHueMain.AbsoluteSize.Y, 0, 1), 0, 1)
                        ColorPickerHueHandle:TweenPosition(UDim2.new(0, 0, 0, range*201), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.1, true);
                        H = range
                        updateColor()
                    end
                end)

                RunService.RenderStepped:Connect(function()
                    if MouseDown then
                        local range = math.clamp(map(Mouse.Y, ColorPickerHueMain.AbsolutePosition.Y, ColorPickerHueMain.AbsolutePosition.Y + ColorPickerHueMain.AbsoluteSize.Y, 0, 1), 0, 1)
                        ColorPickerHueHandle:TweenPosition(UDim2.new(0, 0, 0, range*201), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.1, true);
                        H = range
                        updateColor()
                    end
                end)

                local Change = false
                ColorPickerRGB.Focused:Connect(function()
                    Change = true
                end)

                ColorPickerRGB.FocusLost:Connect(function()
                    Change = false
                end)

                RunService.RenderStepped:Connect(function()
                    if Change then
                        local Ra = math.floor(tonumber(ColorPickerRGB.Text:split(",")[1]))
                        local Ga = math.floor(tonumber(ColorPickerRGB.Text:split(",")[2]))
                        local Bb = math.floor(tonumber(ColorPickerRGB.Text:split(",")[3]))
                        ColorPickerR.Text = Ra
                        ColorPickerG.Text = Ga
                        ColorPickerB.Text = Bb
                        ColorPickerPickerBackFrame.BackgroundColor3 = Color3.new(Ra, Ga, Bb)
                    end
                end)

                local Change2 = false
                ColorPickerR.Focused:Connect(function()
                    Change2 = true
                end)

                ColorPickerR.FocusLost:Connect(function()
                    Change2 = false
                end)

                RunService.RenderStepped:Connect(function()
                    if Change2 then
                        local Ra = tonumber(ColorPickerR.Text)
                        ColorPickerPickerBackFrame.BackgroundColor3 = Color3.new(Ra, ColorPickerPickerBackFrame.BackgroundColor3.G, ColorPickerPickerBackFrame.BackgroundColor3.B)
                    end
                end)

                local Change3 = false
                ColorPickerG.Focused:Connect(function()
                    Change3 = true
                end)

                ColorPickerG.FocusLost:Connect(function()
                    Change3 = false
                end)

                RunService.RenderStepped:Connect(function()
                    if Change3 then
                        local Ga = tonumber(ColorPickerG.Text)
                        ColorPickerPickerBackFrame.BackgroundColor3 = Color3.new(ColorPickerPickerBackFrame.BackgroundColor3.R, Ga, ColorPickerPickerBackFrame.BackgroundColor3.B)
                    end
                end)

                local Change4 = false
                ColorPickerB.Focused:Connect(function()
                    Change4 = true
                end)

                ColorPickerB.FocusLost:Connect(function()
                    Change4 = false
                    
                end)

                RunService.RenderStepped:Connect(function()
                    if Change4 then
                        local BB = tonumber(ColorPickerB.Text)
                        ColorPickerPickerBackFrame.BackgroundColor3 = Color3.new(ColorPickerPickerBackFrame.BackgroundColor3.R, ColorPickerPickerBackFrame.BackgroundColor3.B, BB)
                    end
                end)

        return colorpicker
    end

    RunService.RenderStepped:Connect(function()
        if not minimized and not dropdownopen and not closed then
            local size = 0
            for i, v in pairs(MainHolder:GetChildren()) do
                if v:IsA("Frame") or v:IsA("TextButton") then
                    size = size + v.Size.Y.Offset
                end
            end

            WINDOWSIZE = size

            TweenService:Create(MainHolder, TweenInfo.new(0.1, Enum.EasingStyle.Exponential,Enum.EasingDirection.Out), {Size = UDim2.new(0, MainHolder.Size.X.Offset, 0, size + 3)}):Play()
        end
    end)

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == library.Keybind then

            for i, v in pairs(UIHolder:GetChildren()) do
                if v.Name == "WindowMain" then
                    if v.Size.X.Offset ~= 0 then
                        spawn(function()
                            for i, v in pairs(WindowMain:GetChildren()) do
                                if v.Name == "ColorPickerPickerMain" then
                                    TweenService:Create(v, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, v.Size.Y.Offset)}):Play()
                                end
                            end
                            MainHolder.ClipsDescendants = true
                            closed = true
                            TweenService:Create(v.Title, TweenInfo.new(0.1, Enum.EasingStyle.Exponential,Enum.EasingDirection.Out), {TextSize = 0}):Play()
                            TweenService:Create(v.ColorBar, TweenInfo.new(0.1, Enum.EasingStyle.Exponential,Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, 1)}):Play()
                            TweenService:Create(v, TweenInfo.new(0.1, Enum.EasingStyle.Exponential,Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, v.Size.Y.Offset)}):Play()
                            TweenService:Create(v.MainHolder, TweenInfo.new(0.1, Enum.EasingStyle.Exponential,Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, v.MainHolder.Size.Y.Offset)}):Play()
                            TweenService:Create(v.MinimizeButton, TweenInfo.new(0.1, Enum.EasingStyle.Exponential,Enum.EasingDirection.Out), {TextSize = 0}):Play()
                            TweenService:Create(v.Title, TweenInfo.new(0.1, Enum.EasingStyle.Exponential,Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
                        end)
                    else
                        spawn(function()
                            MainHolder.ClipsDescendants = false
                            closed = true
                            TweenService:Create(v.Title, TweenInfo.new(0.1, Enum.EasingStyle.Exponential,Enum.EasingDirection.Out), {TextSize = 12}):Play()
                            TweenService:Create(v.ColorBar, TweenInfo.new(0.1, Enum.EasingStyle.Exponential,Enum.EasingDirection.Out), {Size = UDim2.new(0, 229, 0, 1)}):Play()
                            TweenService:Create(v, TweenInfo.new(0.1, Enum.EasingStyle.Exponential,Enum.EasingDirection.Out), {Size = UDim2.new(0, 229, 0, v.Size.Y.Offset)}):Play()
                            TweenService:Create(v.MainHolder, TweenInfo.new(0.1, Enum.EasingStyle.Exponential,Enum.EasingDirection.Out), {Size = UDim2.new(0, 229, 0, v.MainHolder.Size.Y.Offset)}):Play()
                            TweenService:Create(v.MinimizeButton, TweenInfo.new(0.1, Enum.EasingStyle.Exponential,Enum.EasingDirection.Out), {TextSize = 14}):Play()
                            TweenService:Create(v.Title, TweenInfo.new(0.1, Enum.EasingStyle.Exponential,Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
                            wait(0.7)
                            closed = false
                        end)
                    end
                end
            end
        end
    end)

    return window
end
return library
