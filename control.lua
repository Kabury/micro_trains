-- Helper function to calculate position based on orientation
local function get_offset_pos(entity, distance)
    local rad = entity.orientation * 2 * math.pi
    return {
        x = entity.position.x + (distance * math.sin(rad)),
        y = entity.position.y - (distance * math.cos(rad))
    }
end

local function on_created(event)
    local entity = event.entity or event.destination
    if not (entity and entity.valid) then return end
    if entity.name == "micro_wagon" or entity.name == "micro_tank" then
        local pos = get_offset_pos(entity, 0.85)
        local engine = entity.surface.create_entity{
            name = "micro_loco",
            position = pos,
            force = entity.force,
            direction = entity.direction, -- Keep this as a fallback
            orientation = entity.orientation,
            mirror = entity.mirroring,
            raise_built = true
        }
        if not (engine and engine.valid) then
            entity.force.print("Failed to spawn locomotive for wagon")
        end
    end
end

-- Combined Removal and Refund Logic
local function on_removed(event) 
    local entity = event.entity 
    if not (entity and entity.valid) then return end
    if entity.name == "micro_wagon" or entity.name == "micro_tank" then
        local neighbors = entity.surface.find_entities_filtered{
            name = "micro_loco",
            position = entity.position,
            radius = 2
        }
        for _, eng in pairs(neighbors) do
            if eng.valid then
                eng.destroy()
            end
        end
    elseif entity.name == "micro_loco" then
        local other = entity.get_connected_rolling_stock(defines.rail_direction.front) or
                      entity.get_connected_rolling_stock(defines.rail_direction.back)
        if other and other.valid and (other.name == "micro_wagon" or other.name == "micro_tank") then
            if event.buffer then
                event.buffer.insert{name = other.name, count = 1}
            end
            other.destroy()
        end
    end
end

-- Event Registration
script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_built}, on_created)
script.on_event({defines.events.on_player_mined_entity, defines.events.on_robot_mined_entity, defines.events.on_entity_died, defines.events.script_raised_destroy}, on_removed)


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
            c.force.print("Train broke")
        end
    end
end)