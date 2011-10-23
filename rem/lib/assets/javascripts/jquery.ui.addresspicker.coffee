#
# jQuery UI addresspicker @VERSION
#
# This is a fork of https://github.com/sgruhier/jquery-addresspicker developed
# by Sébastien Gruhier. This plugin is released under the GPLv2
#
# Copyright 2010, AUTHORS.txt (http://jqueryui.com/about)
# Dual licensed under the MIT or GPL Version 2 licenses.
# http://jquery.org/license
#
# Copyright (C) 2011 Miquel Sabaté <mikisabate@gmail.com>
#
# Depends:
#   jquery.ui.core.js
#   jquery.ui.widget.js
#   jquery.ui.autocomplete.js
#


(($, undefined_) ->
  $.widget "ui.addresspicker",
    options:
      appendAddressString: ""
      mapOptions:
        zoom: 5
        center: new google.maps.LatLng(46, 2)
        scrollwheel: false
        mapTypeId: google.maps.MapTypeId.ROADMAP

      elements:
        map: false
        lat: false
        lng: false
        locality: false
        country: false

      draggableMarker: true

    marker: -> @gmarker
    map: -> @gmap

    updatePosition: ->
      @_updatePosition @gmarker.getPosition()

    reloadPosition: ->
      @gmarker.setVisible true
      @gmarker.setPosition new google.maps.LatLng(@lat.val(), @lng.val())
      @gmap.setCenter @gmarker.getPosition()

    selected: ->
      @selectedResult

    _create: ->
      @geocoder = new google.maps.Geocoder()
      @element.autocomplete
        source: $.proxy(@_geocode, this)
        focus: $.proxy(@_focusAddress, this)
        select: $.proxy(@_selectAddress, this)

      @lat = $(@options.elements.lat)
      @lng = $(@options.elements.lng)
      @locality = $(@options.elements.locality)
      @country = $(@options.elements.country)
      if @options.elements.map
        @mapElement = $(@options.elements.map)
        @_initMap()

    _initMap: ->
      @options.mapOptions.center = new google.maps.LatLng(@lat.val(), @lng.val())  if @lat and @lat.val()
      @gmap = new google.maps.Map(@mapElement[0], @options.mapOptions)
      @gmarker = new google.maps.Marker(
        position: @options.mapOptions.center
        map: @gmap
        draggable: @options.draggableMarker
      )
      google.maps.event.addListener @gmarker, "dragend", $.proxy(@_markerMoved, this)
      @gmarker.setVisible false

    _updatePosition: (location) ->
      @lat.val location.lat()  if @lat
      @lng.val location.lng()  if @lng

    _markerMoved: ->
      @_updatePosition @gmarker.getPosition()

    _geocode: (request, response) ->
      address = request.term
      self = this
      @geocoder.geocode
        address: address + @options.appendAddressString
      , (results, status) ->
        if status is google.maps.GeocoderStatus.OK
          i = 0

          while i < results.length
            results[i].label = results[i].formatted_address
            i++
        response results

    _findInfo: (result, type) ->
      i = 0

      while i < result.address_components.length
        component = result.address_components[i]
        return component.long_name  unless component.types.indexOf(type) is -1
        i++
      false

    _focusAddress: (event, ui) ->
      address = ui.item
      return  unless address
      if @gmarker
        @gmarker.setPosition address.geometry.location
        @gmarker.setVisible true
        @gmap.fitBounds address.geometry.viewport
      @_updatePosition address.geometry.location
      @locality.val @_findInfo(address, "locality")  if @locality
      @country.val @_findInfo(address, "country")  if @country

    _selectAddress: (event, ui) ->
      @selectedResult = ui.item

  $.extend $.ui.addresspicker,
    version: "@VERSION"

  # make IE think it doesn't suck
  unless Array.indexOf
    Array::indexOf = (obj) ->
      i = 0

      while i < @length
        return i  if this[i] is obj
        i++
      -1
) jQuery 
