-- TRYHARD lua for Stand by IB_U_Z_Z_A_R_Dl
-- GitHub repo: https://github.com/Illegal-Services/playerListPedViewer-Lua

-- CREDITS:
-- @nova_plays assisted me with draw_help_text() function.

util.require_natives("3095a")

local MY_ROOT <const> = menu.my_root()
local CURRENT_SCRIPT_VERSION <const> = "0.2"
local TITLE <const> = "Player List Ped Viewer v" .. CURRENT_SCRIPT_VERSION
MY_ROOT:divider("<- " ..  TITLE .. " ->")
MY_ROOT:divider(string.rep("-", 40))

local previewRenderedPed = true
MY_ROOT:toggle("Preview", {"playerlistpedviewer_preview"}, "When enabled, previews your rendered player ped.", function(toggle)
    previewRenderedPed = toggle
end, previewRenderedPed)
MY_ROOT:divider(string.rep("-", 40))

-- https://alloc8or.re/gta5/nativedb/?n=0xF1CEA8A4198D8E9A
-- This one doesn't seems to do anything AllSlot5_Slot_S
local presetName_list = {
    "PAUSE_SINGLE_LEFT",
    "PAUSE_SINGLE_MIDDLE",
    "PAUSE_SINGLE_RIGHT",
    "FACE_CREATION_PRESET",
    "MPLOBBY_ALL5SLOTS",
    "FACE_CREATION_CONFIRM",
    "CELEBRATION_WINNER",
    "CHARACTER_CREATOR_HERITAGE"
}

local presetName_index_map = {
    PAUSE_SINGLE_LEFT = 1,
    PAUSE_SINGLE_MIDDLE = 2,
    PAUSE_SINGLE_RIGHT = 3,
    FACE_CREATION_PRESET = 4,
    MPLOBBY_ALL5SLOTS = 5,
    FACE_CREATION_CONFIRM = 6,
    CELEBRATION_WINNER = 7,
    CHARACTER_CREATOR_HERITAGE = 8
}

local presetMaxPresetSlotValue_table = {
    PAUSE_SINGLE_LEFT = 0,
    PAUSE_SINGLE_MIDDLE = 0,
    PAUSE_SINGLE_RIGHT = 0,
    FACE_CREATION_PRESET = 4,
    MPLOBBY_ALL5SLOTS = 2,
    FACE_CREATION_CONFIRM = 0,
    CELEBRATION_WINNER = 2,
    CHARACTER_CREATOR_HERITAGE = 1
}

local previousPresetName = nil
local presetName = "CELEBRATION_WINNER"
local presetSlot = 0

MY_ROOT:list_select("Preset Name", {"playerlistpedviewer_presetname"}, "The selected preset name used for the rendering.", presetName_list, presetName_index_map["CELEBRATION_WINNER"], function(value, menu_name, prev_value)
    presetName = menu_name
    previousPresetName = presetName_list[prev_value]
end)

local PRESET_SLOT_CommandRef = MY_ROOT:slider("Preset Slot", {"playerlistpedviewer_presetnameslot"}, "The selected preset slot used for the rendering.", 0, presetMaxPresetSlotValue_table["CELEBRATION_WINNER"], 0, 1, function(value)
    presetSlot = value
end)

MY_ROOT:divider(string.rep("-", 40))

local pedPosX = 0.0
MY_ROOT:slider_float("Ped Horizontal Position", {"playerlistpedviewer_pedposx"}, "The rendered player's horizontal position.", -10000, 10000, 0, 1, function(value)
    pedPosX = value / 10
end)
local pedPosZ = 0.0
MY_ROOT:slider_float("Ped Vertical Position", {"playerlistpedviewer_pedposz"}, "The rendered player's vertical position.", -10000, 10000, 0, 1, function(value)
    pedPosZ = value / 10
end)
local pedPosY = 0.0
MY_ROOT:slider_float("Ped Size", {"playerlistpedviewer_pedposy"}, "The rendered player's size.", -10000, 50, 0, 1, function(value)
    pedPosY = value / 10
end)

local function isChildOfCommandRef(currentCommandRef, targetParentCommandRef)
    local parent_CommandRef = menu.get_parent(currentCommandRef)
    if
        not parent_CommandRef
        or not parent_CommandRef:isValid()
    then
        return false
    end

    if parent_CommandRef:equals(targetParentCommandRef) then
        return true
    end

    return isChildOfCommandRef(parent_CommandRef, targetParentCommandRef)
end

local function draw_rectangular_frame(x, y, width, height)
    local vertical_right_x = x + width
    local horizontal_bottom_y = y + height

    directx.draw_line(x, y, x, horizontal_bottom_y, {r=1, g=0, b=0, a=1}) -- Vertical Left
    directx.draw_line(vertical_right_x, y, vertical_right_x, horizontal_bottom_y, {r=1, g=0, b=0, a=1}) -- Vertical Right
    directx.draw_line(x, y, vertical_right_x, y, {r=1, g=0, b=0, a=1}) -- Horizontal Top
    directx.draw_line(x, horizontal_bottom_y, vertical_right_x, horizontal_bottom_y, {r=1, g=0, b=0, a=1}) -- Horizontal Bottom
end

local function draw_help_text()
    if presetName == "PAUSE_SINGLE_LEFT" then
        draw_rectangular_frame(0.161000, 0.222000, 0.226500, 0.597750)
    elseif presetName == "PAUSE_SINGLE_MIDDLE" then
        draw_rectangular_frame(0.386750, 0.222500, 0.22800, 0.599250)
    elseif presetName == "PAUSE_SINGLE_RIGHT" then
        draw_rectangular_frame(0.616000, 0.222000, 0.226000, 0.598000)
    elseif presetName == "FACE_CREATION_PRESET" then
        if presetSlot == 0 then
            draw_rectangular_frame(0.615000, 0.221000, 0.225000, 0.599000)
        elseif presetSlot == 1 then
            draw_rectangular_frame(0.388300, 0.221400, 0.225000, 0.110500)
        elseif presetSlot == 2 then
            draw_rectangular_frame(0.388000, 0.335400, 0.225000, 0.184000)
        elseif presetSlot == 3 then
            draw_rectangular_frame(0.388000, 0.337000, 0.225000, 0.183000)
        elseif presetSlot == 4 then
            draw_rectangular_frame(0.388000, 0.221000, 0.225000, 0.111000)
        end
    elseif presetName == "MPLOBBY_ALL5SLOTS" then
        if presetSlot == 0 then
            draw_rectangular_frame(0.163250, 0.222000, 0.111000, 0.600000)
        elseif presetSlot == 1 then
            draw_rectangular_frame(0.276500, 0.222000, 0.111000, 0.600000)
        elseif presetSlot == 2 then
            draw_rectangular_frame(0.389000, 0.222000, 0.111000, 0.600000)
        end
    elseif presetName == "FACE_CREATION_CONFIRM" then
        draw_rectangular_frame(0.43100, 0.091000, 0.281000, 0.888000)
    elseif presetName == "CELEBRATION_WINNER" then
        if presetSlot == 0 then
            draw_rectangular_frame(0.359000, 0.086000, 0.282000, 0.889100)
        elseif presetSlot == 1 then
            draw_rectangular_frame(0.639800, 0.086000, 0.282100, 0.889100)
        elseif presetSlot == 2 then
            draw_rectangular_frame(0.077300, 0.086000, 0.282100, 0.889000)
        end
    elseif presetName == "CHARACTER_CREATOR_HERITAGE" then
        if presetSlot == 0 then
            draw_rectangular_frame(0.050400, 0.199900, 0.224600, 0.223100)
        elseif presetSlot == 1 then
            draw_rectangular_frame(0.050400, 0.425000, 0.223800, 0.222200)
        end
    end

    directx.draw_rect(0.28, 0.786, 0.42, 0.15, {r=0, g=0, b=0, a=0.75})
    directx.draw_text(0.30, 0.805,
        '- To configure, first choose a spot where you want the player to be rendered . . .\n'
        .. '    by using "Preset Name" and/or "Preset Slot".\n'
        .. '\n- Then changes the position and size of the player . . .\n'
        .. '    by using "Ped Horizontal Position" / "Ped Vertical Position" and "Ped Size".'
    , ALIGN_TOP_LEFT, 0.6, {r=1, g=1, b=1, a=1})
end

local function renderPed(player_id)
    if GRAPHICS.UI3DSCENE_IS_AVAILABLE() then
        local presetName = presetName -- avoid local memory breaking
        if GRAPHICS.UI3DSCENE_PUSH_PRESET(presetName) then
            local player_ped = PLAYER.GET_PLAYER_PED(player_id)
            GRAPHICS.UI3DSCENE_ASSIGN_PED_TO_SLOT(presetName, player_ped, presetSlot, pedPosX, pedPosY, pedPosZ)
            GRAPHICS.UI3DSCENE_CLEAR_PATCHED_DATA()
        end
    end
end

util.create_tick_handler(function()
    if previousPresetName then
        previousPresetName = nil
        presetSlot = 0
        menu.set_value(PRESET_SLOT_CommandRef, presetSlot)
        menu.set_max_value(PRESET_SLOT_CommandRef, presetMaxPresetSlotValue_table[presetName])
    end

    if not menu.is_open() then
        return
    end

    if previewRenderedPed then
        local current_menu_commandRef = menu.get_current_menu_list()
        if not current_menu_commandRef then
            return
        end

        if
            current_menu_commandRef:equals(MY_ROOT)
            or isChildOfCommandRef(current_menu_commandRef, MY_ROOT)
        then
            draw_help_text()
            renderPed(PLAYER.PLAYER_ID())
            return
        end
    end

    local focused = players.get_focused()
    if
        not focused
        or not focused[1]
        or focused[2]
    then
        return
    end

    for player_id in players.list() do
        print(player_id .. "|" .. PLAYER.PLAYER_ID())
        if player_id == focused[1] then
            renderPed(player_id)
        else
            -- Fixes a bug where in SP, Stand returns the wrong player_id, so we makes usage of our RID instead.
            local playerRID = players.get_rockstar_id(player_id)
            local myRID = players.get_rockstar_id(PLAYER.PLAYER_ID())
            if playerRID == myRID then
                renderPed(PLAYER.PLAYER_ID())
            end
        end
    end
end)