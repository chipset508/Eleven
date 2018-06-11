class RandomColor
  def self.call
    "%06x" % (rand * 0xffffff)
  end
end
