module ReportGenerator
  extend ActiveSupport::Concern
  require 'RMagick'

  include Magick

  DEFAULT_CHART_COLORS = {colors: ['#8DCDC1', '#EB6E44'],
                          marker_color: '#7C786A',
                          font_color: '#7C786A',
                          background_colors: 'transparent'}

  def self.generate(service, params, property)
    basic_stats = get_basic_stats(service, params)
    sources = get_sources(service, params)
    file_name = "#{property.name.downcase}_week_#{Date.today.strftime('%U')}.png"
    generate_line_graph(basic_stats, file_name)
    generate_pie_chart(sources, file_name)
    construct_report(property, file_name, basic_stats)
  end

  private

  def self.construct_report(property, file, dataset)
    #binding.pry
    report = Image.new(600, 800) do
      self.background_color = '#FFF5C3'
    end

    chart = Image.read(File.join('tmp', "line_#{file}")).first
    pie = Image.read(File.join('tmp', "pie_#{file}")).first
    platforms = Image.read(File.join('app', 'assets', 'images', 'platforms.png')).first.resize_to_fit!(200)

    title = Image.new(600, 100) do
      self.background_color = 'transparent'
    end

    title_text = Draw.new
    title_text.annotate(title, 0, 0, 0, 0, property.name) do
      title_text.gravity = CenterGravity
      self.pointsize = 20
      self.font_family = 'Arial'
      self.fill = '#7C786A'
      self.font_weight = BoldWeight
    end

    sub_title_text = Draw.new
    sub_title_text.annotate(title, 0, 0, 0, 20, "Week #{Date.today.strftime('%U')} statistics for #{property.website_url}") do
      sub_title_text.gravity = CenterGravity
      self.pointsize = 12
      self.fill = '#7C786A'
    end

    stats = Image.new(300, 50) do
      self.background_color = 'transparent'
    end

    sessions_text = Draw.new
    sessions_text.annotate(stats, 0, 0, 0, 0, "Visits: #{dataset.totals_for_all_results['ga:sessions']}") do
      sessions_text.gravity = NorthWestGravity
      self.pointsize = 20
      self.fill = '#8DCDC1'
    end

    page_views_text = Draw.new
    page_views_text.annotate(stats, 0, 0, 0, 30, "Page views: #{dataset.totals_for_all_results['ga:uniquePageviews']}") do
      page_views_text.gravity = NorthWestGravity
      self.pointsize = 20
      self.fill = '#EB6E44'
    end

    report.composite!(title, 0, 0, OverCompositeOp)
    report.composite!(chart, 10, 80, OverCompositeOp)
    report.composite!(stats, 295, 120, OverCompositeOp)
    report.composite!(pie, 220, 275, OverCompositeOp)
    report.composite!(platforms, 25, 280, OverCompositeOp)

    report.write(File.join('public', 'tmp', file))
    return "/tmp/#{file}"
  end

  def self.get_basic_stats(service, params)
    profile_id = "ga:#{params[:profile_id]}"
    start_date = Date.today.beginning_of_week.strftime('%F')
    end_date = Date.today.end_of_week.strftime('%F')
    metrics = 'ga:sessions, ga:uniquePageviews'
    data = service.get_ga_data(profile_id, start_date, end_date, metrics, {
        dimensions: 'ga:date'
    })
    return data
  end

  def self.get_sources(service, params)
    profile_id = "ga:#{params[:profile_id]}"
    start_date = Date.today.beginning_of_week.strftime('%F')
    end_date = Date.today.end_of_week.strftime('%F')
    metrics = 'ga:sessions'
    data = service.get_ga_data(profile_id, start_date, end_date, metrics, {
        dimensions: 'ga:userType'
    })
    return data
  end

  def self.generate_line_graph(dataset, file_name)
    labels = {}
    visits = []
    page_views = []
    dataset.rows.each_with_index { |d, i| labels[i] = Date.parse(d[0]).strftime('%d/%m') }
    dataset.rows.each { |data| visits.push data[1].to_i }
    dataset.rows.each { |data| page_views.push data[2].to_i }

    line = Gruff::Line.new(250)
    line.theme = DEFAULT_CHART_COLORS
    line.title = 'Visits and Page Views'
    line.labels = labels
    line.data :Visits, visits
    line.data :Page_Vievs, page_views
    line.show_vertical_markers = true
    line.left_margin=10.0
    line.right_margin=10.0
    line.write(File.join('public','tmp', "line_#{file_name}"))
  end

  def self.generate_pie_chart(sources, file_name)
    pie = Gruff::Pie.new(350)
    pie.theme = DEFAULT_CHART_COLORS
    pie.title = 'Returning vs New Visitors'
    pie.data sources.rows[0][0].pluralize.to_sym, sources.rows[0][1].to_i
    pie.data sources.rows[1][0].pluralize.to_sym, sources.rows[1][1].to_i
    pie.write(File.join('public', 'tmp', "pie_#{file_name}"))
  end
end