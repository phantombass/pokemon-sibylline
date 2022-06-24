MultipleForms.register(:HOOTHOOT, {
  "getForm" => proc { |pkmn|
    next if pkmn.form_simple >= 2
    if $game_map
      map_pos = $game_map.metadata&.town_map_position
      next 1 if map_pos && map_pos[0] == 0   # Talín region
    end
    next 0
  }
})

MultipleForms.copy(:HOOTHOOT,:CHIKORITA,:LITTEN,:MANKEY)

MultipleForms.register(:SQUIRTLE, {
  "getForm" => proc { |pkmn|
    next if pkmn.form_simple >= 3
    if $game_map
      map_pos = $game_map.metadata&.town_map_position
      next 2 if map_pos && map_pos[0] == 0   # Talín region
    end
    next 0
  }
})
