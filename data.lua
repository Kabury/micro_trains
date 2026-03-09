-- 1. ITEM
data:extend({
  {
    type = "item-with-entity-data",
    name = "micro_wagon",
    icon = "__micro_train__/graphics/ItemIcon.png",
    icon_size = 176,
    subgroup = "transport",
    order = "a[train]-g[micro_wagon]",
    place_result = "micro_wagon",
    stack_size = 5
  },
  {
    type = "item-with-entity-data",
    name = "micro_tank",
    icon = "__micro_train__/graphics/FluidIcon.png",
    icon_size = 176,
    subgroup = "transport",
    order = "a[train]-g[micro_tank]",
    place_result = "micro_tank",
    stack_size = 5
  }
})

-- 2. CARGO WAGON
local micro_wagon = table.deepcopy(data.raw["cargo-wagon"]["cargo-wagon"])
micro_wagon.name = "micro_wagon"
micro_wagon.minable = {mining_time = 1, result = "micro_wagon"}
micro_wagon.inventory_size = 5
micro_wagon.max_speed = 0.5
micro_wagon.selection_box = {{-1, -0.4}, {1, 0.4}}
micro_wagon.collision_box = {{-1, -0.4}, {1, 0.4}}
micro_wagon.joint_distance = 0.2
micro_wagon.connection_distance = 1.5
micro_wagon.pictures={rotated={filename="__micro_train__/graphics/Item.png",width=256,height=256,direction_count=128,line_length=8,scale=0.5,counterclockwise=true,shift = {0, -0.5}}}
micro_wagon.wheels=nil
micro_wagon.horizontal_doors=nil
micro_wagon.vertical_doors=nil

-- 2. CARGO WAGON
local micro_tank = table.deepcopy(data.raw["fluid-wagon"]["fluid-wagon"])
micro_tank.name = "micro_tank"
micro_tank.minable = {mining_time = 1, result = "micro_tank"}
micro_tank.max_speed = 0.5
micro_tank.selection_box = {{-1, -0.4}, {1, 0.4}}
micro_tank.collision_box = {{-1, -0.4}, {1, 0.4}}
micro_tank.joint_distance = 0.2
micro_tank.connection_distance = 1.5
micro_tank.pictures={rotated={filename="__micro_train__/graphics/Fluid.png",width=256,height=256,direction_count=128,line_length=8,scale=0.5,counterclockwise=true,shift = {0, -0.5}}}
micro_tank.wheels=nil
micro_tank.horizontal_doors=nil
micro_tank.vertical_doors=nil
micro_tank.tank_count = 1
micro_tank.capacity = 10000

-- 3. LOCOMOTIVE
local micro_loco = table.deepcopy(data.raw["locomotive"]["locomotive"])
micro_loco.name = "micro_loco"
micro_loco.minable = nil
micro_loco.energy_source.fuel_inventory_size=1
micro_loco.flags = {"placeable-neutral", "player-creation", "placeable-off-grid", "not-on-map"}
micro_loco.selectable_in_game = false
micro_loco.collision_box = {{-1, -0.4}, {1, 0.4}} 
micro_loco.selection_box = {{-1, -0.4}, {1, 0.4}}
micro_loco.joint_distance = 0.2 -- Set slightly higher than 0.5 to satisfy the 0.2 border requirement
micro_loco.connection_distance = 1.5
micro_loco.energy_source = {
    type = "burner",
    fuel_categories = {"chemical"},
    effectivity = 1,
    fuel_inventory_size = 5
}
micro_loco.pictures = { rotated = { layers = { { filename = "__micro_train__/graphics/blank.png", size = 1, direction_count = 1 } } } }
micro_loco.wheels = nil


data:extend({micro_wagon, micro_loco, micro_tank})