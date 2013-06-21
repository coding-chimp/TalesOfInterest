class ChapterParser

  def initialize(episode)
    @episode = episode
  end

  def parse_file(file, type)
    if type.include? "text"
      parse_text_file(file)
    elsif type.include? "json"
      count = parse_json_file(file)
    end
  end

  def parse_line(line, count)
    time = line.scan(/\d{0,3}[:.]?\d{1,2}[:.]\d{1,2}/)[0].gsub '.', ':'
    time = time.prepend("0:") if time.count(':') == 1
    title = line.scan(/\s(.+)/)[0][0].gsub(/<.+>/, "").chomp
    create_or_update_chapter(count, time, title)
  end

private

  def parse_text_file(file)
    count = 0
    File.open(file.tempfile, 'r').each_line do |line, index|
      count += 1
      parse_line(line, count)
    end
    count
  end

  def parse_json_file(file)
    count = 0
    json = JSON.parse File.read(file.tempfile)
    @episode.playtime = json['length'].to_i
    json['chapters'].each do |chapter|
      count += 1
      create_or_update_chapter(count, chapter['start'], chapter['title'])
    end
    count
  end

  def create_or_update_chapter(count, time, title)
    if count <= @episode.chapters.count
      chapter = @episode.chapters[count-1]
      chapter.update_attributes(pretty_time: time, title: title)
    else
      chapter = Chapter.create!(pretty_time: time, title: title, episode_id: @episode.id)
      @episode.chapters << chapter
    end
  end

end