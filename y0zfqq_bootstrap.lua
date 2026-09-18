--[[ y0zfqq — ortak getgenv ayarlari (b.lua / paste_this_pc readfile ile yukler) ]]
return function(g, playerGui)
    g.OxideForcePC = (g.OxideForcePC ~= false)
    g.OxideUsePlayerGui = true
    g.OxideKickSafe = (g.OxideKickSafe ~= false)
    g.OxidePhoneParity = (g.OxidePhoneParity ~= false)
    g.OxideSkipACNeutralizer = (g.OxideSkipACNeutralizer ~= false)
    g.OxideEnableBacSpoof = (g.OxideEnableBacSpoof ~= false)
    g.OxideDisableTags = (g.OxideDisableTags ~= false)
    g.OxideDefaultStealMethod = g.OxideDefaultStealMethod or "Tween Glide"
    g.OxideCreateWindowOpts = g.OxideCreateWindowOpts or {
        Mobile = false,
        Parent = playerGui,
        LoadingAnimation = true,
        LoadingDuration = 0.9,
        DisplayOrder = 100,
        SkipTagSystem = true,
    }
    if playerGui then
        g.OxideCreateWindowOpts.Parent = g.OxideCreateWindowOpts.Parent or playerGui
    end
    g.OxideCreateWindowOpts.SkipTagSystem = true
end
