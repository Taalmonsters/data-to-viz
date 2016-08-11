class Nlp::RankedList
  
  def initialize(file)
    @frequencies = {}
    @data = []
    @title = ''
    add_freqlist(file)
  end
  
  def title
    return @title
  end
  
  def data
    return @data
  end
  
  def add_tf(tf)
    unless @frequencies.has_key?(tf)
      @frequencies[tf] = 0
    end
    @frequencies[tf] += 1
  end
  
  def rank
    @data = []
    r = 0
    @frequencies.keys.sort.reverse.each do |f|
      c = @frequencies[f]
      rr = []
      (1..c).each do |i|
        rr << i + r
      end
      r = rr[rr.size - 1]
      sorted = rr.sort
      len = sorted.length
      med = (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
      @data << { :rank => med, :frequency => f }
    end
    return self
  end
  
  def add_freqlist(freqlist)
    File.readlines(freqlist).each do |line|
      if line.start_with?('#title=')
        @title = line.sub('#title=','')
      else
        parts = line.split("\t")
        add_tf(parts[1].to_i)
      end
    end
    return rank
  end
  
end