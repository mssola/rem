/*
 * Handling the Google Map on the route page.
 *
 * Copyright (C) 2011 Miquel Sabaté <mikisabate@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */


// Global variables
var directionsService = new google.maps.DirectionsService();
var directionsDisplay = new google.maps.DirectionsRenderer();
var locs = [], changes, markers = '';


/*
 * Update the directions on the map. Used by the route.coffee script when
 * the sortable list has been updated.
 *
 * @param indexs An array of indexes that represents the actual layout of
 * the sortable list.
 */
function update_directions(indexs)
{
  var aux = [];
  changes = [];
  $.each(indexs, function(indexi, j) {
    $.each(locs, function(indexl, val) {
      if (val[1] == j) {
        aux.push(val);
        changes.push(val[1]);
        return false;
      }
    });
  });
  direction_request(aux);
}

/*
 * Generate all the waypoints for the current route.
 *
 * @param locations The locations of the current route.
 * @return an array of waypoints.
 */
function generate_waypoints(locations)
{
  var waypts = [];
  var aux = locations.slice(1, -1);
  $.each(aux, function(index, lc) {
    waypts.push({
      location:lc[0],
      stopover:true
    });
  });
  return waypts;
}

/*
 * Issue a direction request for this GMap with the given @p locations.
 */
function direction_request(locations)
{
  var request = {
    origin:locations.first()[0],
    destination:locations.last()[0],
    travelMode: google.maps.TravelMode.DRIVING,
    waypoints: generate_waypoints(locations)
  };
  directionsService.route(request, function(result, status) {
    if (status == google.maps.DirectionsStatus.OK) {
      directionsDisplay.setDirections(result);
    }
  });
}

/*
 * Get the id for the given marker @p mk.
 */
function get_marker_id(mk)
{
  return mk.title.split("|")[1].match(/^\/places\/id\/(.+)$/)[1];
}

/* When document is ready, initialize all the GMaps stuff. */
$(document).ready(function() {
  var gmap;

  if (typeof(remMarkers) != 'undefined')
    markers = JSON.parse(remMarkers);
  else
    return false;

  if (markers.empty()) {
    // Initialize an empty GMap.
    dummy = new google.maps.LatLng(0, 0);
    var myOptions = {
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      center: dummy,
      zoom: 1
    }
    gmap = new google.maps.Map(document.getElementById("road_map"), myOptions);
  } else {
    // Initialize the GMap.
    first = new google.maps.LatLng(markers[0].lat, markers[0].lng);
    var myOptions = {
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      center: first,
      zoom: 5
    }
    gmap = new google.maps.Map(document.getElementById("road_map"), myOptions);
    directionsDisplay.setMap(gmap);

    // Setup the position of the markers.
    $.each(markers, function(index, mk) {
      pos = new google.maps.LatLng(mk.lat, mk.lng);
      locs.push([pos, get_marker_id(mk)]);
    });

    // Direction request
    direction_request(locs);
  }
});
  
