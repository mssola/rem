

/*
 * Extending Array.
 */
var ap = Array.prototype;
if (!ap.extended) {
  // Ensure this is only done once.
  ap.extended = true;

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
}
