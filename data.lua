data:extend({
  {
    type = "item-with-entity-data",
    name = "micro_wagon",
    icon = "__micro_train__/graphics/ItemIcon.png",
    icon_size = 210,
    subgroup = "transport",
    order = "a[train]-g[micro_wagon]",
    place_result = "micro_wagon",
    stack_size = 5
  },
  {
    type = "item-with-entity-data",
    name = "micro_tank",
    icon = "__micro_train__/graphics/FluidIcon.png",
    icon_size = 210,
    subgroup = "transport",
    order = "a[train]-g[micro_tank]",
    place_result = "micro_tank",
    stack_size = 5
  }
})

data:extend({
  {
    type = "recipe",
    name = "micro_wagon",
    enabled = false, -- Locked by default until tech is researched
    ingredients = {
      {type = "item", name = "locomotive", amount = 1},
      {type = "item", name = "cargo-wagon", amount = 1}
    },
    results = {{type = "item", name = "micro_wagon", amount = 1}}
  },
  {
    type = "recipe",
    name = "micro_tank",
    enabled = false,
    ingredients = {
      {type = "item", name = "locomotive", amount = 1},
      {type = "item", name = "fluid-wagon", amount = 1}
    },
    results = {{type = "item", name = "micro_tank", amount = 1}}
  }
})

data:extend({
  {
    type = "technology",
    name = "micro_wagon_tech",
    icon = "__micro_train__/graphics/ItemIcon.png",
    icon_size = 210,
    effects = {
      {
        type = "unlock-recipe",
        recipe = "micro_wagon"
      }
    },
    prerequisites = {"railway"},
    unit = {
      count = 100,
      ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1}
      },
      time = 30
    },
    order = "c-g-a"
  },
  {
    type = "technology",
    name = "micro_tank_tech",
    icon = "__micro_train__/graphics/FluidIcon.png",
    icon_size = 210,
    effects = {
      {
        type = "unlock-recipe",
        recipe = "micro_tank"
      }
    },
    prerequisites = {"fluid-wagon"},
    unit = {
      count = 100,
      ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1}
      },
      time = 30
    },
    order = "c-g-b"
  }
})

-- 2. CARGO WAGON
local micro_wagon = table.deepcopy(data.raw["cargo-wagon"]["cargo-wagon"])
micro_wagon.name = "micro_wagon"
micro_wagon.minable = {mining_time = 1, result = "micro_wagon"}
micro_wagon.inventory_size = settings.startup["micro-wagon-size"].value
micro_wagon.max_speed = 0.5
micro_wagon.vertical_selection_shift = -1
micro_wagon.selection_box = {{-1.1, -0.25}, {1.1, 0.25}}
micro_wagon.collision_box = {{-1.1, -0.25}, {1.1, 0.25}}
micro_wagon.joint_distance = 0.1
micro_wagon.connection_distance = 0.85
micro_wagon.pictures={rotated={filename="__micro_train__/graphics/Item.png",width=256,height=256,direction_count=128,line_length=8,scale=0.5,counterclockwise=true,shift = {0, -1},apply_projection=false}}
micro_wagon.wheels=nil
micro_wagon.horizontal_doors=nil
micro_wagon.vertical_doors=nil

micro_wagon.weight = 1000/2
micro_wagon.max_speed = 1.5*math.sqrt(2)
micro_wagon.braking_force = 3*4
micro_wagon.friction_force = 0.50/2
micro_wagon.air_resistance = 0.01/2

-- 2. CARGO WAGON
local micro_tank = table.deepcopy(data.raw["fluid-wagon"]["fluid-wagon"])
micro_tank.name = "micro_tank"
micro_tank.minable = {mining_time = 1, result = "micro_tank"}
micro_tank.max_speed = 0.5
micro_tank.vertical_selection_shift = -1
micro_tank.selection_box = {{-1.1, -0.25}, {1.1, 0.25}}
micro_tank.collision_box = {{-1.1, -0.25}, {1.1, 0.25}}
micro_tank.joint_distance = 0.1
micro_tank.connection_distance = 0.85
micro_tank.pictures={rotated={filename="__micro_train__/graphics/Fluid.png",width=256,height=256,direction_count=128,line_length=8,scale=0.5,counterclockwise=true,shift = {0, -1}}}
micro_tank.wheels=nil
micro_tank.horizontal_doors=nil
micro_tank.vertical_doors=nil
micro_tank.tank_count = 1
micro_tank.capacity = settings.startup["micro-tank-size"].value

micro_tank.weight = 1000/2
micro_tank.max_speed = 1.5*math.sqrt(2)
micro_tank.braking_force = 3*4
micro_tank.friction_force = 0.50/2
micro_tank.air_resistance = 0.01/2

-- 3. LOCOMOTIVE
local micro_loco = table.deepcopy(data.raw["locomotive"]["locomotive"])
micro_loco.name = "micro_loco"
micro_loco.minable = {mining_time = 0.5}
micro_loco.flags = {"placeable-neutral", "player-creation", "not-on-map"}
micro_loco.selectable_in_game = false
micro_loco.vertical_selection_shift = -1
micro_loco.collision_box = {{-1.1, -0.25}, {1.1, 0.25}} 
micro_loco.selection_box = {{-1.1, -0.25}, {1.1, 0.25}}
micro_loco.joint_distance = 0.1 -- Set slightly higher than 0.5 to satisfy the 0.2 border requirement
micro_loco.connection_distance = 0.85
micro_loco.energy_source = {
    type = "burner",
    fuel_categories = {"chemical"},
    effectivity = 1,
    fuel_inventory_size = 1
}
micro_loco.pictures = { rotated = { layers = { { filename = "__micro_train__/graphics/blank.png", size = 1, direction_count = 1 } } } }
micro_loco.wheels = nil

micro_loco.weight= 2000 / 2
micro_loco.max_speed = 1.2 * math.sqrt(2)
micro_loco.max_power = 600*2 .. "kW"
micro_loco.reversing_power_modifier = 1
micro_loco.braking_force = 10*4
micro_loco.friction_force = 0.5/2
micro_loco.air_resistance = 0.0075/2



data:extend({micro_wagon, micro_loco, micro_tank})