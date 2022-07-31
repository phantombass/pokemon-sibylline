Battle::ItemEffects::OnSwitchIn.add(:UNNERVEORB,
  proc { |item, battler, battle|
    ability = battler.ability_id
    battler.ability_id = :UNNERVE
    if ability != battler.ability_id
      battle.pbShowAbilitySplash(battler,false,true)
      battle.pbDisplay(_INTL("{1}'s Unnerve Orb prevents berry usage!",battler.name))
      battle.pbHideAbilitySplash(battler)
      battler.ability_id = ability
    end
  }
)

Battle::ItemEffects::OnSwitchIn.add(:LEVITATEORB,
  proc { |ability, battler, battle|
    ability = battler.ability_id
    battler.ability_id = :LEVITATE
    if ability != battler.ability_id
      battle.pbShowAbilitySplash(battler,false,true)
      battle.pbDisplay(_INTL("{1}'s Levitate Orb lifts it off the ground!",battler.name))
      battle.pbHideAbilitySplash(battler)
      battler.ability_id = ability
    end
  }
)

Battle::ItemEffects::OnSwitchIn.add(:THICKFATORB,
  proc { |ability, battler, battle|
    ability = battler.ability_id
    battler.ability_id = :THICKFAT
    if ability != battler.ability_id
      battle.pbShowAbilitySplash(battler,false,true)
      battle.pbDisplay(_INTL("{1}'s Thick Fat Orb gives it heat and cold resistance!",battler.name))
      battle.pbHideAbilitySplash(battler)
      battler.ability_id = ability
    end
  }
)

Battle::ItemEffects::DamageCalcFromTarget.add(:THICKFATORB,
  proc { |item, user, target, move, mults, baseDmg, type|
    mults[:base_damage_multiplier] /= 2 if [:FIRE, :ICE].include?(type)
  }
)

Battle::ItemEffects::OnSwitchIn.add(:CACOPHONYORB,
  proc { |ability, battler, battle|
    ability = battler.ability_id
    battler.ability_id = :CACOPHONY
    if ability != battler.ability_id
      battle.pbShowAbilitySplash(battler,false,true)
      battle.pbDisplay(_INTL("{1}'s Cacophony Orb is causing an uproar!",battler.name))
      battle.pbHideAbilitySplash(battler)
      battler.ability_id = ability
    end
  }
)

Battle::ItemEffects::OnSwitchIn.add(:MAGICBOUNCEORB,
  proc { |ability, battler, battle|
    ability = battler.ability_id
    battler.ability_id = :MAGICBOUNCE
    if ability != battler.ability_id
      battle.pbShowAbilitySplash(battler,false,true)
      battle.pbDisplay(_INTL("{1}'s Magic Bounce Orb raises a protective wall!",battler.name))
      battle.pbHideAbilitySplash(battler)
      battler.ability_id = ability
    end
  }
)

Battle::ItemEffects::OnSwitchIn.add(:ILLUMINATEORB,
  proc { |item, battler, battle|
    ability = battler.ability_id
    battler.ability_id = :ILLUMINATE
    if ability != battler.ability_id
      battler.pbRaiseStatStageByAbility(:ACCURACY, 1, battler)
      battle.pbDisplay(_INTL("{1}'s Illuminate Orb boosts its accuracy!",battler.name))
      battler.ability_id = ability
    end
  }
)

Battle::ItemEffects::OnSwitchIn.add(:MOXIEORB,
  proc { |item, battler, battle|
    ability = battler.ability_id
    battler.ability_id = :MOXIE
    if ability != battler.ability_id
      battle.pbShowAbilitySplash(battler,false,true)
      battle.pbDisplay(_INTL("{1}'s Moxie Orb glows brightly!",battler.name))
      battle.pbHideAbilitySplash(battler)
      battler.ability_id = ability
    end
  }
)

Battle::ItemEffects::OnSwitchIn.add(:CHILLINGNEIGHORB,
  proc { |item, battler, battle|
    ability = battler.ability_id
    battler.ability_id = :CHILLINGNEIGH
    if ability != battler.ability_id
      battle.pbShowAbilitySplash(battler,false,true)
      battle.pbDisplay(_INTL("{1}'s Chilling Neigh Orb glows brightly!",battler.name))
      battle.pbHideAbilitySplash(battler)
      battler.ability_id = ability
    end
  }
)

Battle::ItemEffects::OnSwitchIn.add(:GRIMNEIGHORB,
  proc { |item, battler, battle|
    ability = battler.ability_id
    battler.ability_id = :GRIMNEIGH
    if ability != battler.ability_id
      battle.pbShowAbilitySplash(battler,false,true)
      battle.pbDisplay(_INTL("{1}'s Chilling Neigh Orb glows dully!",battler.name))
      battle.pbHideAbilitySplash(battler)
      battler.ability_id = ability
    end
  }
)

Battle::ItemEffects::AfterMoveUseFromUser.add(:MOXIEORB,
  proc { |item, user, targets, move, numHits, battle|
    next if battle.pbAllFainted?(user.idxOpposingSide)
    ability = user.ability_id
    if ability != :MOXIE
      numFainted = 0
      targets.each { |b| numFainted += 1 if b.damageState.fainted }
      next if numFainted == 0 || !user.pbCanRaiseStatStage?(:ATTACK, user)
      user.ability_id = :MOXIE
      user.pbRaiseStatStageByAbility(:ATTACK, numFainted, user)
      user.ability_id = ability
    end
  }
)

Battle::ItemEffects::AfterMoveUseFromUser.add(:CHILLINGNEIGHORB,
  proc { |item, user, targets, move, numHits, battle|
    next if battle.pbAllFainted?(user.idxOpposingSide)
    ability = user.ability_id
    if ability != :CHILLINGNEIGH
      numFainted = 0
      targets.each { |b| numFainted += 1 if b.damageState.fainted }
      next if numFainted == 0 || !user.pbCanRaiseStatStage?(:ATTACK, user)
      user.ability_id = :CHILLINGNEIGH
      user.pbRaiseStatStageByAbility(:ATTACK, numFainted, user)
      user.ability_id = ability
    end
  }
)

Battle::ItemEffects::AfterMoveUseFromUser.add(:GRIMNEIGHORB,
  proc { |item, user, targets, move, numHits, battle|
    next if battle.pbAllFainted?(user.idxOpposingSide)
    ability = user.ability_id
    if ability != :GRIMNEIGH
      numFainted = 0
      targets.each { |b| numFainted += 1 if b.damageState.fainted }
      next if numFainted == 0 || !user.pbCanRaiseStatStage?(:SPECIAL_ATTACK, user)
      user.ability_id = :GRIMNEIGH
      user.pbRaiseStatStageByAbility(:SPECIAL_ATTACK, numFainted, user)
      user.ability_id = ability
    end
  }
)

Battle::ItemEffects::OnSwitchIn.add(:INTIMIDATEORB,
  proc { |item, battler, battle|
    ability = battler.ability_id
    battler.ability_id = :INTIMIDATE
    if ability != battler.ability_id
      battle.pbShowAbilitySplash(battler,false,true)
      battle.allOtherSideBattlers(battler.index).each do |b|
        next if !b.near?(battler)
        check_item = true
        if b.hasActiveAbility?(:CONTRARY)
          check_item = false if b.statStageAtMax?(:ATTACK)
        elsif b.statStageAtMin?(:ATTACK)
          check_item = false
        end
        check_ability = b.pbLowerAttackStatStageIntimidate(battler)
        b.pbAbilitiesOnIntimidated if check_ability
        b.pbItemOnIntimidatedCheck if check_item
      end
      battle.pbDisplay(_INTL("{1}'s Intimidate Orb lowers the foe's Attack!",battler.name))
      battle.pbHideAbilitySplash(battler)
      battler.ability_id = ability
    end
  }
)

Battle::ItemEffects::OnSwitchIn.add(:HAUNTEDORB,
  proc { |item, battler, battle|
    ability = battler.ability_id
    battler.ability_id = :HAUNTED
    if ability != battler.ability_id
      battle.pbShowAbilitySplash(battler,false,true)
      battle.pbDisplay(_INTL("{1}'s Haunted Orb gives it Ghost typing!",battler.name))
      battler.effects[PBEffects::Type3] = :GHOST
      battle.pbHideAbilitySplash(battler)
      battler.ability_id = ability
    end
  }
)

Battle::ItemEffects::OnSwitchIn.add(:AMPLIFIERORB,
  proc { |item, battler, battle|
    ability = battler.ability_id
    battler.ability_id = :AMPLIFIER
    if ability != battler.ability_id
      battle.pbShowAbilitySplash(battler,false,true)
      battle.pbDisplay(_INTL("{1}'s Amplifier Orb gives it Sound typing!",battler.name))
      battler.effects[PBEffects::Type3] = :SOUND
      battle.pbHideAbilitySplash(battler)
      battler.ability_id = ability
    end
  }
)

Battle::ItemEffects::OnSwitchIn.add(:SHADOWGUARDORB,
  proc { |ability, battler, battle|
    ability = battler.ability_id
    battler.ability_id = :SHADOWGUARD
    if ability != battler.ability_id
      battle.pbShowAbilitySplash(battler,false,true)
      battle.pbDisplay(_INTL("{1}'s Haunted Orb gives it Dark typing!",battler.name))
      battler.effects[PBEffects::Type3] = :DARK
      battle.pbHideAbilitySplash(battler)
      battler.ability_id = ability
    end
  }
)

Battle::ItemEffects::TerrainStatBoost.add(:GRASSYSEED,
  proc { |item, battler, battle|
    next false if (battle.field.terrain != :Grassy || battle.field.field_effects == :Garden)
    next false if !battler.pbCanRaiseStatStage?(:DEFENSE, battler)
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    next battler.pbRaiseStatStageByCause(:DEFENSE, 1, battler, itemName)
  }
)

class Battle::Battler
  def ability_orb_held?(check_item)
    return false if !check_item
    item = GameData::Item.get(check_item)
    item_list = [
      :INTIMIDATEORB,
      :UNNERVEORB,
      :MOXIEORB,
      :GRIMNEIGHORB,
      :CHILLINGNEIGHORB,
      :SHADOWGUARDORB,
      :HAUNTEDORB,
      :ILLUMINATEORB,
      :LEVITATEORB,
      :CACOPHONYORB,
      :MAGICBOUNCEORB,
      :AMPLIFIERORB,
      :THICKFATORB
    ]
    return item_list.include?(item.id)
  end
  def itemActive?(ignoreFainted = false)
    return false if fainted? && !ignoreFainted
    @battle.allBattlers.each do |pkmn|
      return false if ability_orb_held?(pkmn.item) && (@battle.pbCheckGlobalAbility(:NEUTRALIZINGGAS))
    end
    return false if @effects[PBEffects::Embargo] > 0
    return false if @battle.field.effects[PBEffects::MagicRoom] > 0
    return false if @battle.corrosiveGas[@index % 2][@pokemonIndex]
    return false if hasActiveAbility?(:KLUTZ, ignoreFainted)
    return true
  end
  def canConsumeBerry?
    return false if @battle.pbCheckOpposingAbility(:UNNERVE, @index)
    @battle.allBattlers.each do |mon|
      return false if mon.hasActiveItem?(:UNNERVEORB)
    end
    return true
  end
  def both_instincts_active?
    if @battle.pbCheckGlobalAbility(:HUNTERSINSTINCT) && @battle.pbCheckGlobalAbility(:SURVIVALINSTINCT)
      return true
    else
      return false
    end
  end
  def pbAbilitiesOnInstinctEnding
    return if both_instincts_active?
    @battle.pbPriority(true).each do |b|
      next if b.fainted?
      next if !b.unstoppableAbility? && !b.abilityActive?
      Battle::AbilityEffects.triggerInstinct(b.ability, b, @battle, false)
    end
  end
  def pbAbilitiesOnSwitchOut
    if abilityActive?
      Battle::AbilityEffects.triggerOnSwitchOut(self.ability, self, false)
    end
    if ability_orb_held?(self.item) && hasActiveAbility?(:NEUTRALIZINGGAS)
      Battle::ItemEffects.triggerOnSwitchIn(self.item,self,false)
    end
    # Reset form
    @battle.peer.pbOnLeavingBattle(@battle, @pokemon, @battle.usedInBattle[idxOwnSide][@index / 2])
    # Treat self as fainted
    @hp = 0
    @fainted = true
    # Check for end of Neutralizing Gas/Unnerve
    pbAbilitiesOnNeutralizingGasEnding if hasActiveAbility?(:NEUTRALIZINGGAS, true)
    pbItemsOnUnnerveEnding if (hasActiveAbility?(:UNNERVE, true) || hasActiveItem?(:UNNERVEORB))
    pbAbilitiesOnInstinctEnding if (hasActiveAbility?(:HUNTERSINSTINCT,true) || hasActiveAbility?(:SURVIVALINSTINCT,true))
    # Check for end of primordial weather
    @battle.pbEndPrimordialWeather
  end

  def pbAbilitiesOnFainting
    # Self fainted; check all other battlers to see if their abilities trigger
    @battle.pbPriority(true).each do |b|
      next if !b || !b.abilityActive?
      Battle::AbilityEffects.triggerChangeOnBattlerFainting(b.ability, b, self, @battle)
    end
    @battle.pbPriority(true).each do |b|
      next if !b || !b.abilityActive?
      Battle::AbilityEffects.triggerOnBattlerFainting(b.ability, b, self, @battle)
    end
    pbAbilitiesOnNeutralizingGasEnding if hasActiveAbility?(:NEUTRALIZINGGAS, true)
    if ability_orb_held?(self.item) && hasActiveAbility?(:NEUTRALIZINGGAS)
      Battle::ItemEffects.triggerOnSwitchIn(self.item,self,false)
    end
    pbItemsOnUnnerveEnding if (hasActiveAbility?(:UNNERVE, true) || hasActiveItem?(:UNNERVEORB))
    pbAbilitiesOnInstinctEnding if (hasActiveAbility?(:HUNTERSINSTINCT,true) || hasActiveAbility?(:SURVIVALINSTINCT,true))
  end
  def pbRemoveItem(permanent = true)
    @effects[PBEffects::ChoiceBand] = nil if (!hasActiveAbility?(:GORILLATACTICS) || !hasActiveAbility?(:FORESTSSECRETS))
    @effects[PBEffects::Unburden]   = true if self.item && hasActiveAbility?(:UNBURDEN)
    pbItemsOnUnnerveEnding if self.item == :UNNERVEORB
    setInitialItem(nil) if permanent && self.item == self.initialItem
    self.item = nil
  end
end
def pbRaiseEffortValues(pkmn, stat, evGain = 10, ev_limit = true)
  stat = GameData::Stat.get(stat).id
  return 0 if ev_limit && pkmn.ev[stat] >= 252
  evTotal = 0
  GameData::Stat.each_main { |s| evTotal += pkmn.ev[s.id] }
  evGain = evGain.clamp(0, Pokemon::EV_STAT_LIMIT - pkmn.ev[stat])
  evGain = evGain.clamp(0, 252 - pkmn.ev[stat]) if ev_limit
  evGain = evGain.clamp(0, Pokemon::EV_LIMIT - evTotal)
  if evGain > 0
    pkmn.ev[stat] += evGain
    pkmn.calc_stats
  end
  return evGain
end
def pbRaiseHappinessAndLowerEV(pkmn,scene,stat,messages)
  h = pkmn.happiness<255
  e = pkmn.ev[stat]>0
  if !h && !e
    scene.pbDisplay(_INTL("It won't have any effect."))
    return false
  end
  if h
    pkmn.changeHappiness("evberry")
  end
  if e
    pkmn.ev[stat] = 0
    pkmn.calc_stats
  end
  scene.pbRefresh
  scene.pbDisplay(messages[2-(h ? 0 : 2)-(e ? 0 : 1)])
  return true
end
ItemHandlers::UseInField.add(:HMCATALOGUE,proc{|item|
  useHMCatalogue
})

ItemHandlers::UseFromBag.add(:HMCATALOGUE,proc{|item|
  next 2
})

ItemHandlers::UseOnPokemon.add(:REVIVE, proc { |item, qty, pkmn, scene|
  if !pkmn.fainted? || $PokemonSystem.nuzlocke == 1
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.hp = (pkmn.totalhp / 2).floor
  pkmn.hp = 1 if pkmn.hp <= 0
  pkmn.heal_status
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s HP was restored.", pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:MAXREVIVE, proc { |item, qty, pkmn, scene|
  if !pkmn.fainted? || $PokemonSystem.nuzlocke == 1
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.heal_HP
  pkmn.heal_status
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s HP was restored.", pkmn.name))
  next true
})

ItemHandlers::UseOnPokemonMaximum.add(:HPUP, proc { |item, pkmn|
  if pkmn.fainted? && $PokemonSystem.nuzlocke == 1
    scene.pbDisplay(_INTL("This Pokémon can no longer be used in the Nuzlocke."))
    next false
  end
  next pbMaxUsesOfEVRaisingItem(:HP, 10, pkmn, Settings::NO_VITAMIN_EV_CAP)
})

ItemHandlers::UseOnPokemon.add(:HPUP, proc { |item, qty, pkmn, scene|
  if pkmn.fainted? && $PokemonSystem.nuzlocke == 1
    scene.pbDisplay(_INTL("This Pokémon can no longer be used in the Nuzlocke."))
    next false
  end
  next pbUseEVRaisingItem(:HP, 10, qty, pkmn, "vitamin", scene, Settings::NO_VITAMIN_EV_CAP)
})

ItemHandlers::UseOnPokemon.add(:HEALTHFEATHER, proc { |item, qty, pkmn, scene|
  if pkmn.fainted? && $PokemonSystem.nuzlocke == 1
    scene.pbDisplay(_INTL("This Pokémon can no longer be used in the Nuzlocke."))
    next false
  end
  next pbUseEVRaisingItem(:HP, 1, qty, pkmn, "wing", scene, true)
})

ItemHandlers::UseOnPokemonMaximum.add(:HEALTHFEATHER, proc { |item, pkmn|
  if pkmn.fainted? && $PokemonSystem.nuzlocke == 1
    scene.pbDisplay(_INTL("This Pokémon can no longer be used in the Nuzlocke."))
    next false
  end
  next pbMaxUsesOfEVRaisingItem(:HP, 1, pkmn, true)
})

ItemHandlers::UseOnPokemonMaximum.add(:RARECANDY, proc { |item, pkmn|
  if pkmn.fainted? && $PokemonSystem.nuzlocke == 1
    scene.pbDisplay(_INTL("This Pokémon can no longer be used in the Nuzlocke."))
    next false
  end
  if $PokemonSystem.level_caps == 1
    next GameData::GrowthRate.max_level - pkmn.level
  else
    next LEVEL_CAP[$game_system.level_cap] - pkmn.level
  end
})

ItemHandlers::UseOnPokemon.add(:RARECANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.fainted? && $PokemonSystem.nuzlocke == 1
    scene.pbDisplay(_INTL("This Pokémon can no longer be used in the Nuzlocke."))
    next false
  end
  if $PokemonSystem.level_caps == 1
    if pkmn.level >= GameData::GrowthRate.max_level
      new_species = pkmn.check_evolution_on_level_up
      if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
        scene.pbDisplay(_INTL("It won't have any effect."))
        next false
      end
      # Check for evolution
      pbFadeOutInWithMusic {
        evo = PokemonEvolutionScene.new
        evo.pbStartScreen(pkmn, new_species)
        evo.pbEvolution
        evo.pbEndScreen
        scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
      }
      next true
    end
  else
    if pkmn.level >= LEVEL_CAP[$game_system.level_cap]
      new_species = pkmn.check_evolution_on_level_up
      if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
        scene.pbDisplay(_INTL("It won't have any effect."))
        next false
      end
      # Check for evolution
      pbFadeOutInWithMusic {
        evo = PokemonEvolutionScene.new
        evo.pbStartScreen(pkmn, new_species)
        evo.pbEvolution
        evo.pbEndScreen
        scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
      }
      next true
    end
  end
  # Level up
  pbChangeLevel(pkmn, pkmn.level + qty, scene)
  scene.pbHardRefresh
  next true
})

class Trainer
  def heal_party
    if $PokemonSystem.nuzlocke == 1
      pbEachPokemon { |poke,_box| poke.heal if !poke.fainted?}
    else
      pbEachPokemon { |poke,_box| poke.heal}
    end
  end
end
