// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
// 这里本来有 require jquery_ujs的，由于delete的confirm会出现两次就删了
// 详见https://stackoverflow.com/questions/4475449/link-to-confirm-displays-popup-twice#comment74971057_4475479
//= require rails-ujs
//= require turbolinks
//= require_tree .
//= require bootstrap
