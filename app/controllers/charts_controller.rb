class ChartsController < ApplicationController
  
  def display_bar
    uploaded_io = params[:bar][:data]
    filename = Rails.root.join('public', 'uploads', uploaded_io.original_filename)
    File.open(filename, 'wb') do |file|
      file.write(uploaded_io.read)
    end
    @bar = {
      'title' => '',
      'x-axis' => '',
      'y-axis' => {
        'title' => { 'text' => '' }
      },
      'data' => [],
      'color' => params[:bar][:color]
    }
    File.read(filename).split("\n").each do |line|
      if line.start_with?('#title=')
        @bar['title'] = line.sub('#title=','')
      elsif line.start_with?('#x-axis=')
        @bar['x-axis'] = line.sub('#x-axis=','')
      elsif line.start_with?('#y-axis=')
        @bar['y-axis']['title']['text'] = line.sub('#y-axis=','')
      elsif line.start_with?('#y-unit=')
        @bar['y-unit'] = line.sub('#y-unit=','')
      elsif line.include?("\t")
        category, amount = line.split("\t")
        amount = amount.to_f
        @bar['data'] << [category, amount]
      end
    end
    File.delete(filename)
    @bar['data'] = @bar['data'].sort_by{|v| v[1]}.reverse
    respond_to do |format|
      format.js
    end
  end
  
  def display_line
    uploaded_io = params[:line][:data]
    filename = Rails.root.join('public', 'uploads', uploaded_io.original_filename)
    File.open(filename, 'wb') do |file|
      file.write(uploaded_io.read)
    end
    @line = {
      'title' => '',
      'x-axis' => {
        'categories' => [],
        'title' => { 'text' => '' }
      },
      'y-axis' => {
        'title' => { 'text' => '' }
      },
      'y-unit' => '',
      'series' => [],
      'color' => params[:line][:color]
    }
    File.read(filename).split("\n").each do |line|
      if line.start_with?('#title=')
        @line['title'] = line.sub('#title=','')
      elsif line.start_with?('#x-axis=')
        @line['x-axis']['title']['text'] = line.sub('#x-axis=','')
      elsif line.start_with?('#y-axis=')
        @line['y-axis']['title']['text'] = line.sub('#y-axis=','')
      elsif line.start_with?('#y-unit=')
        @line['y-unit'] = line.sub('#y-unit=','')
      elsif line.start_with?('#y-series=')
        line.sub('#y-series=','').split(',').each do |y|
          @line['series'] << { 'name' => y, 'data' => [] }
        end
      elsif line.include?("\t")
        parts = line.split("\t")
        @line['x-axis']['categories'] << parts.shift
        (0..parts.size-1).each do |i|
          @line['series'][i]['data'] << parts[i].to_f
        end
      end
    end
    File.delete(filename)
    respond_to do |format|
      format.js
    end
  end
  
  def display_pie
    uploaded_io = params[:pie][:data]
    filename = Rails.root.join('public', 'uploads', uploaded_io.original_filename)
    File.open(filename, 'wb') do |file|
      file.write(uploaded_io.read)
    end
    @pie = {
      'title' => '',
      'unit' => '',
      'data' => [],
      'color' => params[:pie][:color]
    }
    total = 0
    File.read(filename).split("\n").each do |line|
      if line.start_with?('#title=')
        @pie['title'] = line.sub('#title=','')
      elsif line.start_with?('#unit=')
        @pie['unit'] = line.sub('#unit=','')
      elsif line.include?("\t")
        category, amount = line.split("\t")
        amount = amount.to_f
        total += amount
        @pie['data'] << { 'name' => category, 'y' => amount, 'percentage' => 0.0 }
      end
    end
    File.delete(filename)
    @pie['data'].each{|point| point['percentage'] = (point['y'] / total) * 100 }
    respond_to do |format|
      format.js
    end
  end
  
  def display_zipf
    uploaded_io = params[:zipf][:data]
    filename = Rails.root.join('public', 'uploads', uploaded_io.original_filename)
    File.open(filename, 'wb') do |file|
      file.write(uploaded_io.read)
    end
    File.delete(filename)
    ranked_list = Nlp::MultiRankedList.new(filename)
    data = ranked_list.data
    p "title = "+ranked_list.title
    @zipf = {
      'title' => ranked_list.title,
      'x-axis' => {
        'title' => { 'text' => 'Rank' },
        'type' => 'logarithmic'
      },
      'y-axis' => {
        'title' => { 'text' => 'Frequency' },
        'type' => 'logarithmic'
      },
      'series' => data,
      'color' => params[:zipf][:color]
    }
    respond_to do |format|
      format.js
    end
  end
  
end