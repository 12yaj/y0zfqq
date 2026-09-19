--[[ y0zfqq — ortak getgenv ayarlari ]]
return function(g, playerGui)
    g.OxideForcePC = (g.OxideForcePC ~= false)
    g.y0zfqqDeferLoad = (g.y0zfqqDeferLoad == true)
    g.OxideDeferLoad = (g.OxideDeferLoad == true)
    g.y0zfqqJoinGrace = (g.y0zfqqJoinGrace == true)
    g.OxideJoinGrace = (g.OxideJoinGrace == true)
    g.y0zfqqJoinGraceSec = g.y0zfqqJoinGraceSec or 15
    g.OxideJoinGraceSec = g.OxideJoinGraceSec or g.y0zfqqJoinGraceSec
    g.y0zfqqStealthGui = (g.y0zfqqStealthGui == true)
    g.y0zfqqHideGlobals = (g.y0zfqqHideGlobals ~= false)
    g.OxideUsePlayerGui = true
    g.OxideKickSafe = (g.OxideKickSafe ~= false)
    g.OxidePhoneParity = (g.OxidePhoneParity ~= false)
    g.OxideSkipACNeutralizer = true
    g.y0zfqqDisableBacSpoof = true
    g.OxideDisableBacSpoof = true
    g.y0zfqqEnableBacSpoof = false
    g.OxideEnableBacSpoof = false
    g.OxideDisableTags = true
    g.OxideDefaultStealMethod = g.OxideDefaultStealMethod or "Tween Glide"
    g.y0zfqqRemoteOnly = true
    g.OxideRemoteOnly = true
    g.y0zfqqAllowClientEggApi = false
    g.OxideAllowClientEggApi = false
    if g.y0zfqqMenuKey == nil and g.OxideMenuKey == nil then
        g.y0zfqqMenuKey = Enum.KeyCode.Insert
    end
    g.y0zfqqDisableEvidenceScrub = true
    g.OxideDisableEvidenceScrub = true
    g.y0zfqqEnableHubLayers = false
    g.OxideEnableHubLayers = false
    g.OxideAutoGuard = false
    g.y0zfqqAutoGuard = false
    g.OxideAutoLoadConfig = false
    g.y0zfqqAutoLoadConfig = false
    g.y0zfqqMinimalUi = false
    g.OxideMinimalUi = false
    g.y0zfqqDirectMenu = (g.y0zfqqDirectMenu ~= false)
    g.y0zfqqOpenMenuAfterLoad = true
    g.y0zfqqMenuGraceAfterLoad = g.y0zfqqMenuGraceAfterLoad or 0
    g.OxideCreateWindowOpts = g.OxideCreateWindowOpts or {
        Mobile = false,
        Parent = playerGui,
        LoadingAnimation = true,
        LoadingDuration = 1.15,
        DisplayOrder = 100,
        SkipTagSystem = true,
        AutoLoad = false,
        ConfigName = "y0zfqq_steal",
        GuiName = "SettingsUI",
        Name = "y0zfqq | Steal an Egg",
    }
    if playerGui then
        g.OxideCreateWindowOpts.Parent = g.OxideCreateWindowOpts.Parent or playerGui
    end
    g.OxideCreateWindowOpts.SkipTagSystem = true
    g.OxideCreateWindowOpts.AutoLoad = false
    g.OxideCreateWindowOpts.ConfigName = "y0zfqq_steal"
end
