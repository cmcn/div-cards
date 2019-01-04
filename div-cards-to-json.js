var rows = $('.wikitable.sortable.item-table > tbody > tr');
var cards = [];
var baseUrl = 'https://pathofexile.gamepedia.com'

$.each(rows, function(i, row) {
  var cells = $(row).children();

  var cardObject = {};
  console.log(row);
  cardObject['name'] = $(cells[0]).find('a').first().text();
  cardObject['url'] = baseUrl + $(cells[0]).find('a').first().attr('href');

  cardObject['stack_size'] = parseInt($(cells[1]).text());

  cardObject['effect'] = $(cells[2]).text();
  if ($(cells[2]).find('a').length > 0) {
    cardObject['effect_url'] = baseUrl + $(cells[2]).find('a').first().attr('href');
  } else {
    cardObject['effect_url'] = "";
  }

  var locations = [];
  var locs = $(cells[3]).find('a');
  $.each(locs, function(i, loc) {
    var locObject = {};
    locObject['location'] = $(loc).text();
    locObject['location_url'] = baseUrl + $(loc).attr('href');

    locations.push(locObject);
  });
  cardObject['locations'] = locations;

  cardObject['drop_restrictions'] = $(cells[4]).text();

  cards.push(cardObject);
});

console.log(JSON.stringify(cards));
