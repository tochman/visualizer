describe ReportGenerator do

  let(:basic_increase_stats) { double(Google::Apis::AnalyticsV3::GaData, rows: [['20161118', '43', '73'],
                                                                       ['20161119', '34', '51'],
                                                                       ['20161120', '23', '46'],
                                                                       ['20161121', '42', '95'],
                                                                       ['20161122', '47', '85'],
                                                                       ['20161123', '52', '80'],
                                                                       ['20161124', '60', '93'],
                                                                       ['20161125', '31', '53'],
                                                                       ['20161126', '28', '41'],
                                                                       ['20161127', '33', '61'],
                                                                       ['20161128', '43', '81'],
                                                                       ['20161129', '38', '84'],
                                                                       ['20161130', '101', '181'],
                                                                       ['20161201', '46', '77']],
                             query: double(Google::Apis::AnalyticsV3::GaData::Query,
                                           start_date: '20161118',
                                           end_date: '20161201')
  ) }

  let(:basic_decrease_stats) { double(Google::Apis::AnalyticsV3::GaData, rows: [['20161118', '43', '73'],
                                                                                ['20161119', '34', '51'],
                                                                                ['20161120', '23', '46'],
                                                                                ['20161121', '42', '95'],
                                                                                ['20161122', '47', '85'],
                                                                                ['20161123', '52', '80'],
                                                                                ['20161124', '60', '93'],
                                                                                ['20161125', '1', '53'],
                                                                                ['20161126', '1', '41'],
                                                                                ['20161127', '1', '61'],
                                                                                ['20161128', '1', '81'],
                                                                                ['20161129', '1', '84'],
                                                                                ['20161130', '1', '100'],
                                                                                ['20161201', '1', '60']],
                                      query: double(Google::Apis::AnalyticsV3::GaData::Query,
                                                    start_date: '20161118',
                                                    end_date: '20161201')
  ) }

  it 'generates a comparison text for increased traffic' do
    expected_content = 'Your site attracted 320 visitors this week. That\'s a 6.3% increase compared to the week before.'
    expect(subject.calculate_traffic(basic_increase_stats)).to eq expected_content
  end

  it 'generates a comparison text for decreased traffic' do
    expected_content = 'Your site attracted 7 visitors this week. That\'s a -97.7% decrease compared to the week before.'
    expect(subject.calculate_traffic(basic_decrease_stats)).to eq expected_content
  end



end