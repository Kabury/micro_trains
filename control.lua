-- Helper function to calculate position based on orientation
local function get_offset_pos(entity, distance)
    local rad = entity.orientation * 2 * math.pi
    return {
        x = entity.position.x + (distance * math.sin(rad)),
        y = entity.position.y - (distance * math.cos(rad))
    }
end



---@param event EventData.on_robot_built_entity
local function on_created(event)
  local entity = event.entity
  if not (entity and entity.valid) then return end
  if entity.name == "micro_wagon" or entity.name == "micro_tank" then
    local pos = get_offset_pos(entity, 0.85)
    local engine = entity.surface.create_entity
    {
      name = "micro_loco",
      position = pos,
      force = entity.force,
      direction = entity.direction,
      orientation = entity.orientation,
      mirror = entity.mirroring,
      raise_built = true
    }
    if not (engine and engine.valid) then
        entity.force.print("Failed to spawn locomotive for wagon")
    end
  end
end



---@param event EventData.on_robot_mined_entity
local function on_removed(event) 
  local entity = event.entity 
  if not (entity and entity.valid) then return end
  
  local wagon = entity.name == "micro_wagon" or entity.name == "micro_tank"
  local loco = entity.name == "micro_loco"
  if not (wagon or loco) then return end

  local complement =entity.get_connected_rolling_stock(defines.rail_direction.front) or
                    entity.get_connected_rolling_stock(defines.rail_direction.back)
  if not complement then return end


  if loco then
    event.buffer.insert{name = complement.name, count = 1}
  end
  complement.destroy()
end



script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_built}, on_created)
script.on_event({defines.events.on_player_mined_entity, defines.events.on_robot_mined_entity, defines.events.on_entity_died, defines.events.script_raised_destroy}, on_removed)



script.on_event(defines.events.on_train_created, function(event)
  local train_parts = event.train.carriages
  local micro_parts = 0
  for _, part in pairs(train_parts) do
    if part.name == "micro_wagon" or part.name == "micro_tank" or part.name == "micro_loco" then
      micro_parts = micro_parts + 1
    end
  end
  if micro_parts > 0 and #train_parts > 2 then
    for _, c in pairs(train_parts) do
      c.disconnect_rolling_stock(defines.rail_direction.front)
      c.disconnect_rolling_stock(defines.rail_direction.back)
      c.force.print("Disconnected all wagons due to trying to connect microwagons")
    end
  end
end)