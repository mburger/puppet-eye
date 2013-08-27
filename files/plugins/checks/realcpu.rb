class Realcpu < Eye::Checker::Custom
  param :below, [Fixnum, Float], true

  def check_name
    @check_name ||= "realcpu(#{human_value(below)})"
  end

  def get_value
    `top -b -p #{@pid} -n 1 | grep '#{@pid}'| awk '{print $9}'`.chomp.to_i
  end

  def human_value(value)
    "#{value}%"
  end

  def good?(value)
    value < below
  end
end
