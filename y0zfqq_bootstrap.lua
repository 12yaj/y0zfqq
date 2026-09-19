--[[ y0zfqq — ortak getgenv ayarlari (b.lua / paste_this_pc readfile ile yukler) ]]
return function(g, playerGui)
    g.OxideForcePC = (g.OxideForcePC ~= false)
    g.y0zfqqDeferLoad = (g.y0zfqqDeferLoad == true)
    g.OxideDeferLoad = (g.OxideDeferLoad == true)
    g.y0zfqqJoinGrace = (g.y0zfqqJoinGrace == true)
    g.OxideJoinGrace = (g.y0zfqqJoinGrace == true)
    g.y0zfqqJoinGraceSec = g.y0zfqqJoinGraceSec or 15
    g.OxideJoinGraceSec = g.OxideJoinGraceSec or g.y0zfqqJoinGraceSec
    g.y0zfqqStealthGui = (g.y0zfqqStealthGui ~= false)
    g.y0zfqqHideGlobals = (g.y0zfqqHideGlobals ~= false)
    g.OxideUsePlayerGui = true
    g.OxideKickSafe = (g.OxideKickSafe ~= false)
    g.OxidePhoneParity = (g.OxidePhoneParity ~= false)
    -- PC GitHub: GC/filtergc + hook = 2513/9513. Kapali (PhoneParity ile birlikte aa.lua da atlar)
    g.OxideSkipACNeutralizer = (g.OxideSkipACNeutralizer ~= false)
    -- BAC hook varsayilan KAPALI — acarsan 9513/2513 riski (sadece idle kick icin opt-in)
    g.y0zfqqDisableBacSpoof = (g.y0zfqqDisableBacSpoof ~= false)
    g.OxideDisableBacSpoof = (g.OxideDisableBacSpoof ~= false)
    g.y0zfqqEnableBacSpoof = (g.y0zfqqEnableBacSpoof == true)
    g.OxideEnableBacSpoof = (g.OxideEnableBacSpoof == true)
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
    -- Evidence scrub: remote-only modda zaten calismaz; acik bayrak GC taramasi = ek kick
    g.y0zfqqDisableEvidenceScrub = (g.y0zfqqDisableEvidenceScrub ~= false)
    g.OxideDisableEvidenceScrub = (g.OxideDisableEvidenceScrub ~= false)
    -- Hub acilinca hook/GC katmanlari varsayilan kapali (Insert sonrasi 9513)
    g.y0zfqqEnableHubLayers = (g.y0zfqqEnableHubLayers == true)
    g.OxideEnableHubLayers = (g.OxideEnableHubLayers == true)
    g.OxideAutoGuard = (g.OxideAutoGuard == true)
    g.y0zfqqAutoGuard = (g.y0zfqqAutoGuard == true)
    g.OxideAutoLoadConfig = (g.OxideAutoLoadConfig == true)
    g.y0zfqqAutoLoadConfig = (g.y0zfqqAutoLoadConfig == true)
    -- Jane tarzi: inject sonrasi menu (Insert/.y0z yok). Kapatmak icin: getgenv().y0zfqqDirectMenu = false
    g.y0zfqqDirectMenu = (g.y0zfqqDirectMenu ~= false)
    g.OxideDirectMenu = (g.OxideDirectMenu ~= false)
    g.y0zfqqLazyInject = (g.y0zfqqLazyInject == true)
    g.OxideLazyInject = (g.OxideLazyInject == true)
    if g.y0zfqqDirectMenu then
        g.y0zfqqOpenMenuAfterLoad = (g.y0zfqqOpenMenuAfterLoad ~= false)
        -- BAC-2518: CreateWindow hemen acilirsa (coklu loadstring) — kisa nefes
        g.y0zfqqMenuGraceAfterLoad = g.y0zfqqMenuGraceAfterLoad or 12
        g.y0zfqqHubLoadGraceSec = g.y0zfqqHubLoadGraceSec or 0
        g.y0zfqqHubSplitGraceSec = g.y0zfqqHubSplitGraceSec or 0
        g.y0zfqqDirectMenuDelaySec = g.y0zfqqDirectMenuDelaySec or 4
    end
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
