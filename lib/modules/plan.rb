module Plan

  def self.names
    ["free", "junior", "basic", "pro", "stalker", "god"]
  end

  def self.cost(plan_type)
    if plan_type == "free"
      0
    elsif plan_type == "junior"
      19
    elsif plan_type == "basic"
      29
    elsif plan_type == "pro"
      59
    elsif plan_type == "stalker"
      99
    elsif plan_type == "god"
      199
    end
  end


  def self.scans(plan_type)
    if plan_type == "free"
      20
    elsif plan_type == "junior"
      20
    elsif plan_type == "basic"
      220
    elsif plan_type == "pro"
      1020
    elsif plan_type == "stalker"
      2520
    elsif plan_type == "god"
      6020
    end
  end

  def self.basic_scans(plan_type)
    if plan_type == "free"
      20
    else
      100000
    end
  end

  def self.social_scans(plan_type)
    if plan_type == "free"
      0
    elsif plan_type == "junior"
      0
    elsif plan_type == "basic"
      200
    elsif plan_type == "pro"
      1000
    elsif plan_type == "stalker"
      2500
    elsif plan_type == "god"
      6000
    end
  end

  def self.bulk_scans_allowed?(plan_type)
    if plan_type == "free"
      false
    elsif plan_type == "junior"
      false
    elsif plan_type == "basic"
      false
    elsif plan_type == "pro"
      true
    elsif plan_type == "stalker"
      true
    elsif plan_type == "god"
      true
    end
  end

  def self.social_scans_enabled?(plan_type)
    if plan_type == "free"
      false
    elsif plan_type == "junior"
      false
    elsif plan_type == "basic"
      true
    elsif plan_type == "pro"
      true
    elsif plan_type == "stalker"
      true
    elsif plan_type == "god"
      true
    end
  end

end