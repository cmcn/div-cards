require 'json'
require 'csv'
require 'date'
require 'net/http'

MAX_LOCS_LENGTH = 7

def hyperlink(link, text)
  "=HYPERLINK(\"#{link}\",  \"#{text}\")"
end

# Get Divination Card Values
date_string = Date.today.strftime('%Y-%m-%d')
values_url = "https://poe.ninja/api/data/itemoverview?league=Betrayal&type=DivinationCard&date=#{date_string}"
values_res = Net::HTTP.get_response(URI(values_url))
values = JSON.parse(values_res.body)['lines']

# Read and parse json file
file = File.read('./raw_div_cards.json')
cards = JSON.parse(file)

# Write div card data to csv
CSV.open('csvs/div_cards.csv', 'wb') do |csv|
  csv << ['Value', 'Name', 'Stack Size', 'Effect', 'Locations','','','','','','', 'Drop Restrictions']

  cards.each do |card|
    card_value_data = values.find { |v| v['name'] == card['name'] }
    if card_value_data
      value = card_value_data['chaosValue']
    else
      value = ''
    end

    name = hyperlink(card['url'], card['name'])
    stack_size = card['stack_size']
    effect = hyperlink(card['effect_url'], card['effect'])

    locs_arr = card['locations'].map do |loc|
      loc_link = loc['location_url'].gsub('War_for_the_Atlas', 'Betrayal')
      loc_name = loc['location'].gsub(' (War for the Atlas)', '')
      hyperlink(loc_link, loc_name)
    end

    if locs_arr.length < MAX_LOCS_LENGTH
      locs_arr.fill('', locs_arr.length, MAX_LOCS_LENGTH - locs_arr.length)
    elsif locs_arr.length > MAX_LOCS_LENGTH
      locs_arr.slice!(MAX_LOCS_LENGTH)
    end

    drop_restrictions = card['drop_restrictions']

    row = [value, name, stack_size, effect, *locs_arr, drop_restrictions]
    csv << row
  end
end
