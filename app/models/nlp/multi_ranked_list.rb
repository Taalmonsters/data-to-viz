class Nlp::MultiRankedList
  
  def initialize(file)
    @frequencies = []
    @data = []
    @title = ''
    @series = []
    add_freqlist(file)
  end
  
  def series
    return @series
  end
  
  def title
    return @title
  end
  
  def data
    return @data
  end
  
  def add_tf(tf,s)
    @frequencies << {} unless @frequencies.size > s
    unless @frequencies[s].has_key?(tf)
      @frequencies[s][tf] = 0
    end
    @frequencies[s][tf] += 1
  end
  
  def rank
    @data = []
    @frequencies.each_with_index do |series,s|
      series_data = {
        :name => @series[s],
        :data => [],
        :pointStart => 0
      }
      r = 0
      series.keys.sort.reverse.each do |f|
        c = series[f]
        rr = []
        (1..c).each do |i|
          rr << i + r
        end
        r = rr[rr.size - 1]
        sorted = rr.sort
        len = sorted.length
        med = (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
        series_data[:data] << [ med, f ]
        series_data[:pointStart] = med unless series_data[:pointStart] > 0
      end
      @data << series_data
    end
    return self
  end
  
  def add_freqlist(freqlist)
    File.readlines(freqlist).each do |line|
      if line.start_with?('#title=')
        @title = line.sub('#title=','')
      elsif line.start_with?('#series=')
        @series = line.sub('#series=','').split(",")
      elsif line.include?("\t")
        s = 0
        line.split("\t").in_groups_of(2) do |set|
          unless set[1].blank?
            add_tf(set[1].to_i,s)
          end
          s += 1
        end
      end
    end
    return rank
  end
  
end