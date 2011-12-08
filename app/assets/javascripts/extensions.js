/*
 * Extending Javascript "classes".
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


if (!document.extendedJS) {
  // Ensure this is only done once.
  document.extendedJS = true;

  // Defining some shortcuts.
  var ap = Array.prototype;
  var sp = String.prototype;

  // Extending Array.

  /*
   * @return the first element of the Array.
   */
  ap.first = function() {
    return this[0];
  }

  /*
   * @return the last element of the Array.
   */
  ap.last = function() {
    return this[this.length - 1];
  }

  /*
   * @return true if this array is empty. False otherwise.
   */
  ap.empty = function() {
    return this.length == 0;
  }

  // Extending String.

  /*
   * @return true if this string ends with the given @p suffix.
   * False otherwise.
   */
  sp.endsWith = function(suffix) {
    return this.indexOf(suffix, this.length - suffix.length) !== -1;
  }
}
