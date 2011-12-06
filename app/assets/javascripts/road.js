
function contents_for(mk)
{
  string = '<div class="infodiv"> <span>' + mk.title + '</span>' + 
    '<img src="' + mk.description + '" /></div>';
    
  return string;
}

$(document).ready(function() {
  var gmap, markers = '', locs = [];
  var directionsService = new google.maps.DirectionsService();
  var directionsDisplay = new google.maps.DirectionsRenderer();

  if (typeof(remMarkers) != 'undefined')
    markers = JSON.parse(remMarkers);

  // Initialize the bounds with the first element.
  first = new google.maps.LatLng(markers[0].lat, markers[0].lng);
  var bounds = new google.maps.LatLngBounds(first, first);

  // Initialize the GMap.
  var myOptions = {
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    center: first,
    zoom: 5
  }
  gmap = new google.maps.Map(document.getElementById("road_map"), myOptions);
  directionsDisplay.setMap(gmap);

  // Setup markers and adjust the bounds.
  $.each(markers, function(index, mk) {
    pos = new google.maps.LatLng(mk.lat, mk.lng);
    locs.push(pos);
    bounds.extend(pos);

    var info = new google.maps.InfoWindow({ content: contents_for(mk) });
    var mark = new google.maps.Marker({ position: pos, map: gmap });
    google.maps.event.addListener(mark, 'click', function() {
      info.open(gmap, mark);
    });
  });
  gmap.fitBounds(bounds);

  // Direction request
  var request = {
    origin:locs[0],
    destination:locs[1],
    travelMode: google.maps.TravelMode.DRIVING
  };
  directionsService.route(request, function(result, status) {
    if (status == google.maps.DirectionsStatus.OK) {
      directionsDisplay.setDirections(result);
    }
  });
});
  
