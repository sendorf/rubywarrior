class Player
  def play_turn(warrior)
    #The warrior feels if there is an enemy near him
    enemy = feel_enemy(warrior)
    #The warrior feels if there is an enemy near him
    captive = feel_captive(warrior)
    # Counts the number of enemies
    enemies = count_enemies(warrior)
    # Listen to sorrounding spaces and selects according to priority
    objective = objective_priority(warrior)
    # If healthy and still there are units to listen
    if objective
      # If there are units avoids moving to the stairs until he has interacted with them
      if warrior.feel(warrior.direction_of(objective)).stairs?
        warrior.walk!(feel_no_stairs(warrior))
      # If there is an enemy the warrior attacks him
      elsif enemies > 1
        warrior.bind!(enemy)
      # Avoids occupied spaces
      elsif objective.ticking?
        # If detonable he detonates until he is near death
        if check_if_detonable(warrior, objective) && warrior.health > 4
          warrior.detonate!(warrior.direction_of(objective))
        # Checks if the ticking objective is reachable
        elsif warrior.feel(warrior.direction_of(objective)).captive?
          warrior.rescue!(warrior.direction_of(objective))
        elsif warrior.feel(warrior.direction_of(objective)).enemy?
          warrior.attack!(warrior.direction_of(objective))
        # Goes to the tiking objective
        else
          warrior.walk!(warrior.direction_of(objective))
        end
      # He recues a captive
      elsif captive
        warrior.rescue!(captive)
      # Attacks enemies once there are no ticking captives
      elsif enemy
        warrior.attack!(enemy)
      # Heals himself after a battle
      elsif warrior.health < 20
        warrior.rest!
      # Move to the objective
      else
        warrior.walk!(warrior.direction_of(objective))
      end
    # If he is healthy he goes to the stairs to finish the level
    else
      warrior.walk!(warrior.direction_of_stairs)
    end
  end

  def check_if_detonable(warrior, objective)
    count = 0
    detonable = false
    look = warrior.look(warrior.direction_of(objective))
    # Counts the enemies he can see with the look
    look.each do |space|
      if space.enemy?
        count = count +1
      end
    end
    # Checks if the first space is free so he can hit both objectives with the explosion
    if count == 2 && !look.first.empty?
      detonable = true
    end
    return detonable
  end

  def feel_enemy(warrior)
    # Checks if there is an enemy and where it is to attack it
    enemy = false;
    if warrior.feel(:left).enemy?
      enemy = :left;
    elsif warrior.feel(:right).enemy?
      enemy = :right;
    elsif warrior.feel(:backward).enemy?
      enemy = :backward;
    elsif warrior.feel(:forward).enemy?
      enemy = :forward;
    end
  end

  def feel_empty(warrior)
    # Checks if there is an empty space
    empty = false;
    if warrior.feel(:forward).empty?
      empty = :forward;
    elsif warrior.feel(:right).empty?
      empty = :right;
    elsif warrior.feel(:left).empty?
      empty = :left;
    elsif warrior.feel(:backward).empty?
      empty = :backward;
    end
  end

  def feel_no_stairs(warrior)
    # Checks if the warrior is not moving to the stairs to soon
    empty = false;
    if !warrior.feel(:forward).stairs?
      empty = :forward;
    elsif !warrior.feel(:left).stairs?
      empty = :left;
    elsif !warrior.feel(:right).stairs?
      empty = :right;
    elsif !warrior.feel(:backward).stairs?
      empty = :backward;
    end
  end

  def count_enemies(warrior)
    count = 0
    # Counts the surronding enemies
    [:forward, :backward, :left, :right].each do |direction|
      if warrior.feel(direction).enemy?
        count = count +1;
      end
    end
    return count
  end

  def feel_captive(warrior)
    # Checks if there is an captive and where it is to attack it
    captive = false;
    if warrior.feel(:left).captive?
      captive = :left;
    elsif warrior.feel(:right).captive?
      captive = :right;
    elsif warrior.feel(:forward).captive?
      captive = :forward;
    elsif warrior.feel(:backward).captive?
      captive = :backward;
    end
  end

  # If there is a tiking space the warrior goes to that space first
  def objective_priority(warrior)
    objective = warrior.listen.first
    warrior.listen.each do |space|
      if space.ticking?
        objective = space
      end
    end
    return objective
  end
end
