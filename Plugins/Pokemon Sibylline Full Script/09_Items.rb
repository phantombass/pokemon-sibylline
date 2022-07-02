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
      :AMPLIFIERORB
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
