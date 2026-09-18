--[[ y0zfqq — ortak getgenv ayarlari (b.lua / paste_this_pc readfile ile yukler) ]]
return function(g, playerGui)
    g.OxideForcePC = (g.OxideForcePC ~= false)
    g.y0zfqqDeferLoad = (g.y0zfqqDeferLoad == true)
    g.OxideDeferLoad = (g.OxideDeferLoad == true)
    g.y0zfqqJoinGrace = (g.y0zfqqJoinGrace == true)
    g.OxideJoinGrace = (g.OxideJoinGrace == true)
    g.y0zfqqJoinGraceSec = g.y0zfqqJoinGraceSec or 15
    g.OxideJoinGraceSec = g.OxideJoinGraceSec or g.y0zfqqJoinGraceSec
    g.y0zfqqStealthGui = (g.y0zfqqStealthGui ~= false)
    g.y0zfqqHideGlobals = (g.y0zfqqHideGlobals ~= false)
    g.OxideUsePlayerGui = true
    g.OxideKickSafe = (g.OxideKickSafe ~= false)
    g.OxidePhoneParity = (g.OxidePhoneParity ~= false)
    g.OxideSkipACNeutralizer = (g.OxideSkipACNeutralizer ~= false)
    -- PC: BAC hook kapali (2513). Idle kick (3517) icin execute ONCE: getgenv().y0zfqqEnableBacSpoof = true
    g.y0zfqqDisableBacSpoof = (g.y0zfqqDisableBacSpoof == true)
    g.OxideBacSpoofDelay = g.OxideBacSpoofDelay or 18
    g.y0zfqqBacSpoofDelay = g.y0zfqqBacSpoofDelay or g.OxideBacSpoofDelay
    g.OxideDisableTags = (g.OxideDisableTags ~= false)
    g.OxideDefaultStealMethod = g.OxideDefaultStealMethod or "Tween Glide"
    g.y0zfqqRemoteOnly = (g.y0zfqqRemoteOnly ~= false)
    g.OxideRemoteOnly = (g.OxideRemoteOnly ~= false)
    g.y0zfqqAllowClientEggApi = (g.y0zfqqAllowClientEggApi == true)
    g.OxideAllowClientEggApi = (g.OxideAllowClientEggApi == true)
    if g.y0zfqqMenuKey == nil and g.OxideMenuKey == nil then
        g.y0zfqqMenuKey = Enum.KeyCode.Insert
    end
    g.y0zfqqDisableEvidenceScrub = (g.y0zfqqDisableEvidenceScrub ~= false)
    g.OxideDisableEvidenceScrub = true
    g.OxideAutoGuard = (g.OxideAutoGuard == true)
    g.y0zfqqAutoGuard = (g.y0zfqqAutoGuard == true)
    g.OxideAutoLoadConfig = (g.OxideAutoLoadConfig == true)
    g.y0zfqqAutoLoadConfig = (g.y0zfqqAutoLoadConfig == true)
    g.OxideCreateWindowOpts = g.OxideCreateWindowOpts or {
        Mobile = false,
        Parent = playerGui,
        LoadingAnimation = true,
        LoadingDuration = 0.9,
        DisplayOrder = 100,
        SkipTagSystem = true,
        AutoLoad = false,
        ConfigName = "y0zfqq_steal",
    }
    if playerGui then
        g.OxideCreateWindowOpts.Parent = g.OxideCreateWindowOpts.Parent or playerGui
    end
    g.OxideCreateWindowOpts.SkipTagSystem = true
    g.OxideCreateWindowOpts.AutoLoad = false
    g.OxideCreateWindowOpts.ConfigName = "y0zfqq_steal"
end
