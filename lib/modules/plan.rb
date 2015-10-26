module Plan

  def self.cost(plan_type)
    if plan_type == "free"
      0
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

end