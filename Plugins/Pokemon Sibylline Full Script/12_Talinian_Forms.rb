MultipleForms.register(:HOOTHOOT, {
  "getFormOnCreation" => proc { |pkmn|
    next if pkmn.form_simple >= 2
    if $game_map
      map_pos = $game_map.metadata&.town_map_position
      next 1 if map_pos && map_pos[0] == 0   # Talín region
    end
    next 0
  }
})

MultipleForms.copy(:HOOTHOOT,:NOCTOWL,:CHIKORITA,:BAYLEEF,:LITTEN,:TORRACAT,:MANKEY,:PRIMEAPE,:JOLTIK,:GALVANTULA,:POLIWAG,:POLIWHIRL,:POLIWRATH,:POLITOED,:RUFFLET,:BRAVIARY,:MAGNEMITE,:MAGNETON,:MAGNEZONE,:SOLOSIS,:DUOSION,:SLAKOTH,:VIGOROTH,:WOOBAT,:SWOOBAT,:PIKIPEK,:TRUMBEAK,:TOUCANNON,:DUNSPARCE,:PHANTUMP,:TREVENANT,:HEATMOR)

MultipleForms.register(:SQUIRTLE, {
  "getFormOnCreation" => proc { |pkmn|
    next if pkmn.form_simple >= 3
    if $game_map
      map_pos = $game_map.metadata&.town_map_position
      next 2 if map_pos && map_pos[0] == 0   # Talín region
    end
    next 0
  }
})

MultipleForms.copy(:SQUIRTLE,:WARTORTLE,:PINSIR)

GameData::Evolution.register({
  :id                   => :HoldItemLevel30,
  :parameter            => :Item,
  :minimum_level        => 30,   # Needs any level up
  :level_up_proc        => proc { |pkmn, parameter|
    next pkmn.item == parameter
  },
  :after_evolution_proc => proc { |pkmn, new_species, parameter, evo_species|
    next false if evo_species != new_species || !pkmn.hasItem?(parameter)
    pkmn.item = nil   # Item is now consumed
    next true
  }
})
