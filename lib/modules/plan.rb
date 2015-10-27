module Plan

  def self.cost(plan_type)
    if plan_type == "free"
      0
    elsif plan_type == "basic"
      9
    elsif plan_type == "pro"
      29
    elsif plan_type == "stalker"
      59
    elsif plan_type == "god"
      99
    end
  end


   def self.scans(plan_type)
    if plan_type == "free"
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
    elsif plan_type == "basic"
      0
    elsif plan_type == "pro"
      200
    elsif plan_type == "stalker"
      1000
    elsif plan_type == "god"
      2500
    end
  end

  def self.bulk_scans_allowed?(plan_type)
    if plan_type == "free"
      false
    elsif plan_type == "basic"
      false
    elsif plan_type == "pro"
      false
    elsif plan_type == "stalker"
      true
    elsif plan_type == "god"
      true
    end
  end

  def self.social_scans_enabled?(plan_type)
    if plan_type == "free"
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

end