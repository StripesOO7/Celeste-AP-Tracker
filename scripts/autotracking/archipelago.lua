-- this is an example/ default implementation for AP autotracking
-- it will use the mappings defined in item_mapping.lua and location_mapping.lua to track items and locations via thier ids
-- it will also load the AP slot data in the global SLOT_DATA, keep track of the current index of on_item messages in CUR_INDEX
-- addition it will keep track of what items are local items and which one are remote using the globals LOCAL_ITEMS and GLOBAL_ITEMS
-- this is useful since remote items will not reset but local items might
ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")

CUR_INDEX = -1
SLOT_DATA = nil
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}

function onClear(slot_data)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onClear, slot_data:\n%s", dump_table(slot_data)))
        print("1")
    end
    SLOT_DATA = slot_data
    CUR_INDEX = -1
    -- reset locations
    for _, v in pairs(LOCATION_MAPPING) do
        if v[1] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: clearing location %s", v[1]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[1]:sub(1, 1) == "@" then
                    obj.AvailableChestCount = obj.ChestCount
                else
                    obj.Active = false
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
        end
    end
    -- reset items
    for _, v in pairs(ITEM_MAPPING) do
        if v[1] and v[2] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: clearing item %s of type %s", v[1], v[2]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[2] == "toggle" then
                    obj.Active = false
                elseif v[2] == "progressive" then
                    obj.CurrentStage = 0
                    obj.Active = false
                elseif v[2] == "consumable" then
                    obj.AcquiredCount = 0
                elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                    print(string.format("onClear: unknown item type %s for code %s", v[2], v[1]))
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
        end
    end
    print(dump_table(SLOT_DATA))
    -- Set goal
    --print(Tracker.FindObjectForCode("berriesreq").AcquiredCount)
    
    if slot_data["berries_required"] ~= 0 then
        Tracker:FindObjectForCode("berryreq").AcquiredCount = tonumber(slot_data["berries_required"])
    end
    if slot_data["hearts_required"] ~= 0 then
        Tracker:FindObjectForCode("heartreq").AcquiredCount = tonumber(slot_data["hearts_required"])
    end
    if slot_data["berries_required"] ~= 0 then
        Tracker:FindObjectForCode("cassettesreq").AcquiredCount = tonumber(slot_data["cassettes_required"])
    end
    if slot_data["levels_required"] ~= 0 then
        Tracker:FindObjectForCode("compreq").AcquiredCount = tonumber(slot_data["levels_required"])
    end
    if slot_data["victory_condition"] == 0 then
        Tracker:FindObjectForCode("goal").CurrentStage = 0
    end
    if slot_data["victory_condition"] == 1 then
        Tracker:FindObjectForCode("goal").CurrentStage = 1
    end
    if slot_data["victory_condition"] == 2 then
        Tracker:FindObjectForCode("goal").CurrentStage = 2
    end
    if slot_data["victory_condition"] then       
        if slot_data["hearts_required"] and not slot_data["hearts_required"] == 0 then
            Tracker:FindObjectForCode("goal").CurrentStage = 1
            Tracker:FindObjectForCode("hearts_required").AcquiredCount = tonumber(slot_data["hearts_required"])
        end
        if slot_data["gemhearts"] and not slot_data["gemhearts"] == 0 then
            Tracker:FindObjectForCode("heartttl").CurrentStage = 1
            Tracker:FindObjectForCode("gemhearts").AcquiredCount = tonumber(slot_data["gemhearts"])
        end
        if slot_data["berries_required"] and not slot_data["berries_required"] == 0 then
            Tracker:FindObjectForCode("goal").CurrentStage = 2
            Tracker:FindObjectForCode("berries_required").AcquiredCount = tonumber(slot_data["berries_required"])
        end
        if slot_data["cassettes_required"] and not slot_data["cassettes_required"] == 0 then
            Tracker:FindObjectForCode("goal").CurrentStage = 3
            Tracker:FindObjectForCode("cassettes_required").AcquiredCount = tonumber(slot_data["cassettes_required"])
        end
        if slot_data["levels_required"] and not slot_data["levels_required"] == 0 then
            Tracker:FindObjectForCode("goal").CurrentStage = 4
            Tracker:FindObjectForCode("levels_required").AcquiredCount = tonumber(slot_data["levels_required"])
        end
    end
end
-- called when an item gets collected
function onItem(index, item_id, item_name, player_number)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onItem: %s, %s, %s, %s, %s", index, item_id, item_name, player_number, CUR_INDEX))
    end
    if not AUTOTRACKER_ENABLE_ITEM_TRACKING then
        return
    end
    if index <= CUR_INDEX then
        return
    end
    local is_local = player_number == Archipelago.PlayerNumber

    if  item_id == 8061000 then
        Tracker:FindObjectForCode("heartttl").AcquiredCount = Tracker:FindObjectForCode("heartttl").AcquiredCount + 1
    end
    if  item_id == 8062000 then
        Tracker:FindObjectForCode("heartttl").AcquiredCount = Tracker:FindObjectForCode("heartttl").AcquiredCount + 1
    end
    if  item_id == 8063000 then
        Tracker:FindObjectForCode("heartttl").AcquiredCount = Tracker:FindObjectForCode("heartttl").AcquiredCount + 1
    end
    if  item_id == 8064000 then
        Tracker:FindObjectForCode("heartttl").AcquiredCount = Tracker:FindObjectForCode("heartttl").AcquiredCount + 1
    end
    if  item_id == 8065000 then
        Tracker:FindObjectForCode("heartttl").AcquiredCount = Tracker:FindObjectForCode("heartttl").AcquiredCount + 1
    end
    if  item_id == 8066000 then
        Tracker:FindObjectForCode("heartttl").AcquiredCount = Tracker:FindObjectForCode("heartttl").AcquiredCount + 1
    end
    if  item_id == 8067000 then
        Tracker:FindObjectForCode("heartttl").AcquiredCount = Tracker:FindObjectForCode("heartttl").AcquiredCount + 1
    end
    if  item_id == 8069000 then
        Tracker:FindObjectForCode("heartttl").AcquiredCount = Tracker:FindObjectForCode("heartttl").AcquiredCount + 1
    end
    if  item_id == 8061100 then
        Tracker:FindObjectForCode("heartttl").AcquiredCount = Tracker:FindObjectForCode("heartttl").AcquiredCount + 1
    end
    if  item_id == 8062100 then
        Tracker:FindObjectForCode("heartttl").AcquiredCount = Tracker:FindObjectForCode("heartttl").AcquiredCount + 1
    end
    if  item_id == 8063100 then
        Tracker:FindObjectForCode("heartttl").AcquiredCount = Tracker:FindObjectForCode("heartttl").AcquiredCount + 1
    end
    if  item_id == 8064100 then
        Tracker:FindObjectForCode("heartttl").AcquiredCount = Tracker:FindObjectForCode("heartttl").AcquiredCount + 1
    end
    if  item_id == 8065100 then
        Tracker:FindObjectForCode("heartttl").AcquiredCount = Tracker:FindObjectForCode("heartttl").AcquiredCount + 1
    end
    if  item_id == 8066100 then
        Tracker:FindObjectForCode("heartttl").AcquiredCount = Tracker:FindObjectForCode("heartttl").AcquiredCount + 1
    end
    if  item_id == 8067100 then
        Tracker:FindObjectForCode("heartttl").AcquiredCount = Tracker:FindObjectForCode("heartttl").AcquiredCount + 1
    end
    if  item_id == 8069100 then
        Tracker:FindObjectForCode("heartttl").AcquiredCount = Tracker:FindObjectForCode("heartttl").AcquiredCount + 1
    end
    if  item_id == 8061200 then
        Tracker:FindObjectForCode("heartttl").AcquiredCount = Tracker:FindObjectForCode("heartttl").AcquiredCount + 1
    end
    if  item_id == 8062200 then
        Tracker:FindObjectForCode("heartttl").AcquiredCount = Tracker:FindObjectForCode("heartttl").AcquiredCount + 1
    end
    if  item_id == 8063200 then
        Tracker:FindObjectForCode("heartttl").AcquiredCount = Tracker:FindObjectForCode("heartttl").AcquiredCount + 1
    end
    if  item_id == 8064200 then
        Tracker:FindObjectForCode("heartttl").AcquiredCount = Tracker:FindObjectForCode("heartttl").AcquiredCount + 1
    end
    if  item_id == 8065200 then
        Tracker:FindObjectForCode("heartttl").AcquiredCount = Tracker:FindObjectForCode("heartttl").AcquiredCount + 1
    end
    if  item_id == 8066200 then
        Tracker:FindObjectForCode("heartttl").AcquiredCount = Tracker:FindObjectForCode("heartttl").AcquiredCount + 1
    end
    if  item_id == 8067200 then
        Tracker:FindObjectForCode("heartttl").AcquiredCount = Tracker:FindObjectForCode("heartttl").AcquiredCount + 1
    end
    if  item_id == 8069200 then
        Tracker:FindObjectForCode("heartttl").AcquiredCount = Tracker:FindObjectForCode("heartttl").AcquiredCount + 1
    end

    if  item_id == 8041000 then
        Tracker:FindObjectForCode("compttl").AcquiredCount = Tracker:FindObjectForCode("compttl").AcquiredCount + 1
    end
    if  item_id == 8042000 then
        Tracker:FindObjectForCode("compttl").AcquiredCount = Tracker:FindObjectForCode("compttl").AcquiredCount + 1
    end
    if  item_id == 8043000 then
        Tracker:FindObjectForCode("compttl").AcquiredCount = Tracker:FindObjectForCode("compttl").AcquiredCount + 1
    end
    if  item_id == 8044000 then
        Tracker:FindObjectForCode("compttl").AcquiredCount = Tracker:FindObjectForCode("compttl").AcquiredCount + 1
    end
    if  item_id == 8045000 then
        Tracker:FindObjectForCode("compttl").AcquiredCount = Tracker:FindObjectForCode("compttl").AcquiredCount + 1
    end
    if  item_id == 8046000 then
        Tracker:FindObjectForCode("compttl").AcquiredCount = Tracker:FindObjectForCode("compttl").AcquiredCount + 1
    end
    if  item_id == 8047000 then
        Tracker:FindObjectForCode("compttl").AcquiredCount = Tracker:FindObjectForCode("compttl").AcquiredCount + 1
    end
    if  item_id == 8049000 then
        Tracker:FindObjectForCode("compttl").AcquiredCount = Tracker:FindObjectForCode("compttl").AcquiredCount + 1
    end
    if  item_id == 8041100 then
        Tracker:FindObjectForCode("compttl").AcquiredCount = Tracker:FindObjectForCode("compttl").AcquiredCount + 1
    end
    if  item_id == 8042100 then
        Tracker:FindObjectForCode("compttl").AcquiredCount = Tracker:FindObjectForCode("compttl").AcquiredCount + 1
    end
    if  item_id == 8043100 then
        Tracker:FindObjectForCode("compttl").AcquiredCount = Tracker:FindObjectForCode("compttl").AcquiredCount + 1
    end
    if  item_id == 8044100 then
        Tracker:FindObjectForCode("compttl").AcquiredCount = Tracker:FindObjectForCode("compttl").AcquiredCount + 1
    end
    if  item_id == 8045100 then
        Tracker:FindObjectForCode("compttl").AcquiredCount = Tracker:FindObjectForCode("compttl").AcquiredCount + 1
    end
    if  item_id == 8046100 then
        Tracker:FindObjectForCode("compttl").AcquiredCount = Tracker:FindObjectForCode("compttl").AcquiredCount + 1
    end
    if  item_id == 8047100 then
        Tracker:FindObjectForCode("compttl").AcquiredCount = Tracker:FindObjectForCode("compttl").AcquiredCount + 1
    end
    if  item_id == 8049100 then
        Tracker:FindObjectForCode("compttl").AcquiredCount = Tracker:FindObjectForCode("compttl").AcquiredCount + 1
    end
    if  item_id == 8041200 then
        Tracker:FindObjectForCode("compttl").AcquiredCount = Tracker:FindObjectForCode("compttl").AcquiredCount + 1
    end
    if  item_id == 8042200 then
        Tracker:FindObjectForCode("compttl").AcquiredCount = Tracker:FindObjectForCode("compttl").AcquiredCount + 1
    end
    if  item_id == 8043200 then
        Tracker:FindObjectForCode("compttl").AcquiredCount = Tracker:FindObjectForCode("compttl").AcquiredCount + 1
    end
    if  item_id == 8044200 then
        Tracker:FindObjectForCode("compttl").AcquiredCount = Tracker:FindObjectForCode("compttl").AcquiredCount + 1
    end
    if  item_id == 8045200 then
        Tracker:FindObjectForCode("compttl").AcquiredCount = Tracker:FindObjectForCode("compttl").AcquiredCount + 1
    end
    if  item_id == 8046200 then
        Tracker:FindObjectForCode("compttl").AcquiredCount = Tracker:FindObjectForCode("compttl").AcquiredCount + 1
    end
    if  item_id == 8047200 then
        Tracker:FindObjectForCode("compttl").AcquiredCount = Tracker:FindObjectForCode("compttl").AcquiredCount + 1
    end
    if  item_id == 8049200 then
        Tracker:FindObjectForCode("compttl").AcquiredCount = Tracker:FindObjectForCode("compttl").AcquiredCount + 1
    end

    if  item_id == 8021000 then
        Tracker:FindObjectForCode("cassettesttl").AcquiredCount = Tracker:FindObjectForCode("cassettesttl").AcquiredCount + 1
    end
    if  item_id == 8022000 then
        Tracker:FindObjectForCode("cassettesttl").AcquiredCount = Tracker:FindObjectForCode("cassettesttl").AcquiredCount + 1
    end
    if  item_id == 8023000 then
        Tracker:FindObjectForCode("cassettesttl").AcquiredCount = Tracker:FindObjectForCode("cassettesttl").AcquiredCount + 1
    end
    if  item_id == 8024000 then
        Tracker:FindObjectForCode("cassettesttl").AcquiredCount = Tracker:FindObjectForCode("cassettesttl").AcquiredCount + 1
    end
    if  item_id == 8025000 then
        Tracker:FindObjectForCode("cassettesttl").AcquiredCount = Tracker:FindObjectForCode("cassettesttl").AcquiredCount + 1
    end
    if  item_id == 8026000 then
        Tracker:FindObjectForCode("cassettesttl").AcquiredCount = Tracker:FindObjectForCode("cassettesttl").AcquiredCount + 1
    end
    if  item_id == 8027000 then
        Tracker:FindObjectForCode("cassettesttl").AcquiredCount = Tracker:FindObjectForCode("cassettesttl").AcquiredCount + 1
    end
    if  item_id == 8029000 then
        Tracker:FindObjectForCode("cassettesttl").AcquiredCount = Tracker:FindObjectForCode("cassettesttl").AcquiredCount + 1
    end

    CUR_INDEX = index;
    local v = ITEM_MAPPING[item_id]
    if not v then
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: could not find item mapping for id %s", item_id))
        end
        return
    end
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: code: %s, type %s", v[1], v[2]))
    end
    if not v[1] then
        return
    end
    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[2] == "toggle" then
            obj.Active = true
        elseif v[2] == "progressive" then
            if obj.Active then
                obj.CurrentStage = obj.CurrentStage + 1
            else
                obj.Active = true
            end
        elseif v[2] == "consumable" then
            obj.AcquiredCount = obj.AcquiredCount + obj.Increment
        elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: unknown item type %s for code %s", v[2], v[1]))
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: could not find object for code %s", v[1]))
    end
    -- track local items via snes interface
    if is_local then
        if LOCAL_ITEMS[v[1]] then
            LOCAL_ITEMS[v[1]] = LOCAL_ITEMS[v[1]] + 1
        else
            LOCAL_ITEMS[v[1]] = 1
        end
    else
        if GLOBAL_ITEMS[v[1]] then
            GLOBAL_ITEMS[v[1]] = GLOBAL_ITEMS[v[1]] + 1
        else
            GLOBAL_ITEMS[v[1]] = 1
        end
    end
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("local items: %s", dump_table(LOCAL_ITEMS)))
        print(string.format("global items: %s", dump_table(GLOBAL_ITEMS)))
    end
end

-- called when a location gets cleared
function onLocation(location_id, location_name)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onLocation: %s, %s", location_id, location_name))
    end
    if not AUTOTRACKER_ENABLE_LOCATION_TRACKING then
        return
    end
    local v = LOCATION_MAPPING[location_id]
    if not v and AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onLocation: could not find location mapping for id %s", location_id))
    end
    if not v[1] then
        return
    end
    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[1]:sub(1, 1) == "@" then
            obj.AvailableChestCount = obj.AvailableChestCount - 1
        else
            obj.Active = true
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onLocation: could not find object for code %s", v[1]))
    end
end

-- called when a locations is scouted
function onScout(location_id, location_name, item_id, item_name, item_player)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onScout: %s, %s, %s, %s, %s", location_id, location_name, item_id, item_name,
            item_player))
    end
    -- not implemented yet :(
end

-- called when a bounce message is received 
function onBounce(json)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onBounce: %s", dump_table(json)))
    end
    -- your code goes here
end

-- add AP callbacks
-- un-/comment as needed
Archipelago:AddClearHandler("clear handler", onClear)
if AUTOTRACKER_ENABLE_ITEM_TRACKING then
    Archipelago:AddItemHandler("item handler", onItem)
end
if AUTOTRACKER_ENABLE_LOCATION_TRACKING then
    Archipelago:AddLocationHandler("location handler", onLocation)
end
-- Archipelago:AddScoutHandler("scout handler", onScout)
-- Archipelago:AddBouncedHandler("bounce handler", onBounce)
