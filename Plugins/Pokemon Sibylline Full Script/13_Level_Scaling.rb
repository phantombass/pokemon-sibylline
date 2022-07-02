module LevelScale
  GYM_SWITCH = 59
  RIVAL_SWITCH = 60
  LEVEL_TRAINER_SWITCH = 61
  TRAINER_SWITCH = 62
  LEVEL_SCALING_SWITCH = 63
end

EventHandlers.add(:on_trainer_load, :level_scale,
  proc { |trainer|
    if trainer && $game_switches[LevelScale::LEVEL_SCALING_SWITCH]
      party = trainer.pokemon_party
      mlv = $Trainer.party.map { |e| e.level  }.max
      for pokemon in party
        level = 0
        level = 1 if level < 2
        if $PokemonSystem.level_caps == 1
          case $PokemonSystem.difficulty
          when 0
            level = mlv - 1 - rand(3)
          when 1
            level = mlv - rand(3)
          when 2
            level = mlv - 1 + rand(3)
          when 3
            level = mlv + 1 + rand(3)
          end
        elsif $PokemonSystem.level_caps == 0
          levelcap = LEVEL_CAP[$game_system.level_cap]
          if $game_switches[LevelScale::GYM_SWITCH]
            level = levelcap
          else
            level = mlv
          end
          case $PokemonSystem.difficulty
          when 0
            level = level - 1 - rand(3)
          when 1
            level = level - rand(3)
            level = levelcap - rand(2) if $game_switches[LevelScale::GYM_SWITCH]
          when 2
            level = level - 1 + rand(3)
          when 3
            level = level + 1 + rand(3)
          end
        end
        pokemon.level = level
        pokemon.calc_stats
        if !$game_switches[LevelScale::GYM_SWITCH] && !$game_switches[LevelScale::RIVAL_SWITCH] && !$game_switches[LevelScale::TRAINER_SWITCH]
          pokemon.reset_moves
        end

      end #end of for
    end
  }
)
