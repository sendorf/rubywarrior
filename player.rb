class Player
  def play_turn(warrior)
    #The warrior feels if there is an enemy near him
    enemy = feel_enemy(warrior)
    #The warrior feels if there is an enemy near him
    captive = feel_captive(warrior)
    # Counts the number of enemies
    enemies = count_enemies(warrior)
    # If there is an enemy the warrior attacks him
    if enemies > 1
      warrior.bind!(enemy)
    # If there is an enemy the warrior attacks him
    elsif enemy
      warrior.attack!(enemy)
    # If the warrior is hurt he rests to restore his health
    elsif warrior.health < 20
      warrior.rest!
    # If he is healthy he recues a captive
    elsif captive
      warrior.rescue!(captive)
    # If he is healthy he goes to the stairs to finish the level
    else
      warrior.walk!(warrior.direction_of_stairs)
    end
  end

  def feel_enemy(warrior)
    # Checks if there is an enemy and where it is to attack it
    enemy = false;
    if warrior.feel(:forward).enemy?
      enemy = :forward;
    elsif warrior.feel(:backward).enemy?
      enemy = :backward;
    elsif warrior.feel(:left).enemy?
      enemy = :left;
    elsif warrior.feel(:right).enemy?
      enemy = :right;
    end
  end

  def count_enemies(warrior)
    count = 0
    [:forward, :backward, :left, :right].each do |direction|
      if warrior.feel(direction).enemy?
        count = count +1;
      end
    end
    count
  end

  def feel_captive(warrior)
    # Checks if there is an captive and where it is to attack it
    captive = false;
    if warrior.feel(:forward).captive?
      captive = :forward;
    elsif warrior.feel(:backward).captive?
      captive = :backward;
    elsif warrior.feel(:left).captive?
      captive = :left;
    elsif warrior.feel(:right).captive?
      captive = :right;
    end
  end
end
