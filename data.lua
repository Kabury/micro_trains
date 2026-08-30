local meld = require("meld")

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

local join = 0.1
local connection = 0.65
local collision = {{-1.1, -0.25}, {1.1, 0.25}}
local selection = {{-1.1, -0.5}, {1.1, 0.5}}
local friction = 0.50/2
local vertical = -0.5

-- 2. CARGO WAGON
data:extend{meld.meld(table.deepcopy(data.raw["cargo-wagon"]["cargo-wagon"]),{
  name = "micro_wagon",
  minable = {mining_time = 1, result = "micro_wagon"},
  inventory_size = settings.startup["micro-wagon-size"].value --[[@as integer]], 
  vertical_selection_shift = vertical,
  selection_box = selection,
  collision_box = collision,
  joint_distance = join,
  connection_distance = connection,
  pictures=meld.overwrite({rotated={filename="__micro_train__/graphics/Item.png",width=256,height=256,direction_count=128,line_length=8,scale=0.5,counterclockwise=true,shift = {0, -1},apply_projection=false}}),
  wheels= meld.delete(),
  horizontal_doors= meld.delete(),
  vertical_doors= meld.delete(),
  weight = 1000/2,
  max_speed = 1.5*math.sqrt(2),
  braking_force = 3*4,
  friction_force = friction,
  air_resistance = 0.01/2
})}

-- 2. CARGO WAGON
data:extend{meld.meld(table.deepcopy(data.raw["fluid-wagon"]["fluid-wagon"]),{
  name = "micro_tank",
  minable = {mining_time = 1, result = "micro_tank"},
  tank_count = 1,
  capacity = settings.startup["micro-tank-size"].value --[[@as integer]],
  vertical_selection_shift = vertical,
  selection_box = selection,
  collision_box = collision,
  joint_distance = join,
  connection_distance = connection,
  pictures=meld.overwrite({rotated={filename="__micro_train__/graphics/Fluid.png",width=256,height=256,direction_count=128,line_length=8,scale=0.5,counterclockwise=true,shift = {0, -1},apply_projection=false}}),
  wheels= meld.delete(),
  horizontal_doors= meld.delete(),
  vertical_doors= meld.delete(),
  weight = 1000/2,
  max_speed = 1.5*math.sqrt(2),
  braking_force = 3*4,
  friction_force = friction,
  air_resistance = 0.01/2
})}


-- 3. LOCOMOTIVE
data:extend{meld.meld(table.deepcopy(data.raw["locomotive"]["locomotive"]),{
  name = "micro_loco",
  minable = {mining_time = 1, result = meld.delete()},
  vertical_selection_shift = vertical,
  selection_box = selection,
  collision_box = collision,
  joint_distance = join, -- Set slightly higher than 0.5 to satisfy the 0.2 border requirement
  connection_distance = connection,
  pictures=meld.overwrite({rotated={filename = "__micro_train__/graphics/blank.png", size = 1, direction_count = 1}}),
  wheels= meld.delete(),
  horizontal_doors= meld.delete(),
  vertical_doors= meld.delete(),
  weight = 2000/2,
  max_speed = 1.2*math.sqrt(2),
  braking_force = 10*4,
  friction_force = friction,
  air_resistance = 0.0075/2,
  flags = meld.append( {"not-on-map"}),
  energy_source = meld.overwrite({
    type = "burner",
    fuel_categories = {"chemical"},
    effectivity = 1,
    fuel_inventory_size = 1 }),
  max_power = 600*2 .. "kW",
  reversing_power_modifier = 1
})}


