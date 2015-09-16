class String

  def is_dead?
    dates = self.scan(/[0-9]{4}/)
    dates.count > 1
  end

  def is_common?
    self.include?("may refer to")
  end

  def is_a_redirect?
     self.include?("This is a redirect")
  end

end
