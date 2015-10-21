module Plan

  def self.cost(plan_type)
    if plan_type == "free"
      0
    elsif plan_type == "basic"
      19
    elsif plan_type == "pro"
      39
    elsif plan_type == "stalker"
      99
    elsif plan_type == "god"
      99
    end
  end


   def self.scans(plan_type)
    if plan_type == "free"
      10
    elsif plan_type == "basic"
      100
    elsif plan_type == "pro"
      500
    elsif plan_type == "stalker"
      2500
    elsif plan_type == "god"
      6000
    end
  end

end
