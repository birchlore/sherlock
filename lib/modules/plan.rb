module Plan

  def self.cost(plan_type)
    if plan_type == "free"
      0
    elsif plan_type == "basic"
      29
    elsif plan_type == "pro"
      49
    elsif plan_type == "stalker"
      99
    end
  end


   def self.scans(plan_type)
    if plan_type == "free"
      10
    elsif plan_type == "basic"
      100
    elsif plan_type == "pro"
      300
    elsif plan_type == "stalker"
      1000
    end
  end

end
