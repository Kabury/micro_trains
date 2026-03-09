-- Helper function to calculate position based on orientation
local function get_offset_pos(entity, distance)
    local rad = entity.orientation * 2 * math.pi
    return {
        x = entity.position.x + (distance * math.sin(rad)),
        y = entity.position.y - (distance * math.cos(rad))
    }
end

-- Spawn engine on build
local function on_created(event)
    local entity = event.entity or event.destination
    if not (entity and entity.valid) then return end
    
    if entity.name == "micro_wagon" or entity.name == "micro_tank" then
        -- Distance is sum of joint distances: 1.5 + 0.7 = 2.2
        local pos = get_offset_pos(entity, 1)
        
        local engine = entity.surface.create_entity{
            name = "micro_loco",
            position = pos,
            direction = entity.direction,
            force = entity.force,
            quality = entity.quality,
            -- This is the critical fix: bypass collision with the parent wagon
            teleport = true 
        }
        
        -- If it still fails, log it to the console for debugging
        if not engine then 
            entity.force.print("Cargo Ship: Failed to spawn engine logic. Check for obstructions.")
        end
    end
end

-- Removal logic
local function on_removed(event)
    local entity = event.entity
    if not (entity and entity.valid) then return end

    if entity.name == "micro_wagon" or entity.name == "micro_tank" then
        local neighbors = entity.surface.find_entities_filtered{
            name = "micro_loco",
            position = entity.position,
            radius = 5
        }
        for _, eng in pairs(neighbors) do
            if eng.valid then eng.destroy() end
        end
    elseif entity.name == "micro_loco" then
        local other = entity.get_connected_rolling_stock(defines.rail_direction.front) or 
                      entity.get_connected_rolling_stock(defines.rail_direction.back)
        if other and other.valid and other.name == "micro_wagon" or other.name == "micro_tank" then
            other.destroy()
        end
    end
end

-- Event Registration
script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_built}, on_created)
script.on_event({defines.events.on_player_mined_entity, defines.events.on_robot_mined_entity, defines.events.on_entity_died, defines.events.script_raised_destroy}, on_removed)

-- Enforce 2-part limit
script.on_event(defines.events.on_train_created, function(event)
    local carriages = event.train.carriages
    local ship_parts = 0
    for _, c in pairs(carriages) do
        if c.name == "micro_wagon" or c.name == "micro_tank" or c.name == "micro_loco" then
            ship_parts = ship_parts + 1
        end
    end

    if ship_parts > 0 and #carriages > 2 then
        for _, c in pairs(carriages) do
            c.disconnect_rolling_stock(defines.rail_direction.front)
            c.disconnect_rolling_stock(defines.rail_direction.back)
        end
    end
end)