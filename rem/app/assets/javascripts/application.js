/*
 * Main JS script.
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


//= require flash
//= require users


/* This is a trick to load the correct Rem object from CoffeeScript. */
var Rem;
Rem = (typeof exports !== 'undefined' && exports !== null) ? exports : this;

/* The code below handles the signin_menu */
$(document).ready(function() {
  /* If clicked, toogle the menu */
  $('.signin').click(function(e) {
    e.preventDefault();
    $('fieldset#signin_menu').toggle();
    $('.signin').toggleClass('menu-open');
  });

  /* Return false on mouseup event */
  $('fieldset#signin_menu').mouseup(function() { return false });

  /* Hide the menu if we are clicking to another part of the site */
  $(document).mouseup(function(e) {
    if($(e.target).parent('a.signin').length == 0) {
      $('.signin').removeClass('menu-open');
      $('fieldset#signin_menu').hide();
    }
  });
});
