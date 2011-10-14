
sanitize = (str) ->
  return str.replace /^account\/?/, ''


getBucket = (str) ->
  id = sanitize str
  if id.length == 0
    id = 'user_bucket'
  else
    id = id + '_bucket'
  return $("#account_page").find('fieldset[id=' + id + ']')


$(document).ready ->
  path = location.pathname.slice(1, location.pathname.length)
  return unless path.match(/^account/)

  $("#account_tabs li").each ->
    e = $(this).find('a')
    if e.attr('href') != path
      getBucket(e.attr('href')).hide()


jQuery ->
  $("#account_tabs li").each ->
    $(this).click ->
      visible = $("fieldset:visible")
      path = $(this).find('a').attr('href')
      bucket = getBucket(path)

      return false if bucket.attr('id') == visible.attr('id')
      visible.hide()
      bucket.show()
      return false

