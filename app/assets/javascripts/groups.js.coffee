# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require_self
window.Groups =
  init : () ->
#    $('#newGroupModal').modal('show');

$(document).ready ->
  if $('body').data('controller-name') in ['groups']
    Groups.init()