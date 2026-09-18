--[[ y0zfqq — ortak getgenv ayarlari (b.lua / paste_this_pc readfile ile yukler) ]]
return function(g, playerGui)
    g.OxideForcePC = (g.OxideForcePC ~= false)
    g.OxideUsePlayerGui = true
    g.OxideKickSafe = (g.OxideKickSafe ~= false)
    g.OxidePhoneParity = (g.OxidePhoneParity ~= false)
    g.OxideSkipACNeutralizer = (g.OxideSkipACNeutralizer ~= false)
    -- Acik spoof PC'de BAC-8512 uretebiliyor; acmak icin: getgenv().y0zfqqEnableBacSpoof = true
    g.OxideEnableBacSpoof = (g.OxideEnableBacSpoof == true)
    g.y0zfqqEnableBacSpoof = (g.y0zfqqEnableBacSpoof == true)
    g.OxideDisableTags = (g.OxideDisableTags ~= false)
    g.OxideDefaultStealMethod = g.OxideDefaultStealMethod or "Tween Glide"
    g.y0zfqqRemoteOnly = (g.y0zfqqRemoteOnly ~= false)
    g.OxideRemoteOnly = (g.OxideRemoteOnly ~= false)
    g.y0zfqqDisableEvidenceScrub = (g.y0zfqqDisableEvidenceScrub ~= false)
    g.OxideDisableEvidenceScrub = true
    g.OxideAutoGuard = (g.OxideAutoGuard == true)
    g.y0zfqqAutoGuard = (g.y0zfqqAutoGuard == true)
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
