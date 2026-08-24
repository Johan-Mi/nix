hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "1.2",
})

local terminal = "alacritty"
local menu = "rofi -show run"

hl.window_rule({
    match = {
        float = 0,
        workspace = "w[tv1]",
    },
    border_size = 0,
})

hl.window_rule({
    match = {
        float = 0,
        workspace = "f[1]",
    },
    border_size = 0,
})

local mainMod = "SUPER"

hl.bind(mainMod .. " + return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("firefox --new-window"))
hl.bind(mainMod .. " + SHIFT + I", hl.dsp.exec_cmd("firefox --private-window"))
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd("swaylock --color 000000"))
hl.bind(mainMod .. " + CTRL + P", hl.dsp.exec_cmd("grim ~/\"Pictures/$(date).png\""))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exit())
hl.bind(mainMod .. " + space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(mainMod .. " + tab", hl.dsp.focus({ workspace = "previous" }))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("pkill -USR1 waybar"))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))

hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- Move active window to a workspace with mainMod + SHIFT + [0-9]
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1, follow = false }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2, follow = false }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3, follow = false }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4, follow = false }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5, follow = false }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6, follow = false }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7, follow = false }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8, follow = false }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9, follow = false }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10, follow = false }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

hl.bind(mainMod .. " + ALT + W", hl.dsp.exec_cmd("change-volume 1%+"), { locked = true, repeating = true })
hl.bind(mainMod .. " + ALT + Q", hl.dsp.exec_cmd("change-volume 1%-"), { locked = true, repeating = true })
hl.bind(mainMod .. " + ALT + S", hl.dsp.exec_cmd("brightnessctl set 1%+"), { locked = true, repeating = true })
hl.bind(mainMod .. " + ALT + A", hl.dsp.exec_cmd("brightnessctl set 1%-"), { locked = true, repeating = true })
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd("brightnessctl set 0"), { locked = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.window_rule({
    name = "suppress-maximize-events",
    match = {
        class = ".*",
    },
    -- Ignore maximize requests from all apps. You'll probably like this.
    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    -- Fix some dragging issues with XWayland
    no_focus = true,
})

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
    general = {
        gaps_in = 0,
        gaps_out = 0,
        col = {
            active_border = "rgb(777777)",
            inactive_border = "rgb(000000)",
        },
        layout = "master",
    },
    decoration = {
        shadow = {
            enabled = false,
        },
        blur = {
            enabled = false,
        },
    },
    animations = {
        enabled = false,
    },
    -- Ref https://wiki.hyprland.org/Configuring/Workspace-Rules/
    -- "Smart gaps" / "No gaps when only"
    master = {
        new_status = "master",
    },
    input = {
        kb_layout = "se_tweaks",
        kb_variant = "nodeadkeys",
        kb_options = "compose:prsc,compose:menu",
        repeat_delay = 300,
        repeat_rate = 40,
        touchpad = {
            disable_while_typing = false,
            tap_to_click = false,
        },
    },
    binds = {
        allow_workspace_cycles = true,
    },
})

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprctl setcursor \"Vanilla-DMZ\" 24 & swaybg -i ~/Pictures/wallpapers/smokayyy.jpg & waybar & warn-battery & sunsetr")
end)
