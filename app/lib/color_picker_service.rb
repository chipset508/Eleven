class ColorPickerService
  def self.random
    "%06x" % (rand * 0xffffff)
  end

  def self.by_state(state)
    case state
    when 'approved'
      "#04B807"
    when 'changes_requested'
      "#E41308"
    when 'closed'
      "#6f42c1"
    else
      "#848484"
    end
  end
end
