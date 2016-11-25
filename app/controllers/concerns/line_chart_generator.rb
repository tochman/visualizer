module LineChartGenerator
  extend ActiveSupport::Concern

  def self.generate(dataset)
    a = Gruff::Line.new(400)
    labels = {}
    visits = []
    page_views = []
    dataset.each_with_index {|d, i| labels[i] = Date.parse(d[0]).strftime('%d/%m')}
    dataset.each {|data| visits.push data[1].to_i}
    dataset.each {|data| page_views.push data[2].to_i}
    file_name = 'data.png'
    a.theme_pastel
    a.labels = labels
    a.data :Visits, visits
    a.data :Page_Vievs, page_views
    a.show_vertical_markers = true
    a.left_margin=10.0
    a.right_margin=10.0
    #a.write(File.join('app','assets','images',"keynote_#{Date.today.strftime('%H_%M')}.png"))
    a.write(File.join('app','assets','images',file_name))
    return file_name
  end
end