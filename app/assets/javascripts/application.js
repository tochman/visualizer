// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require turbolinks
//= require_tree .

//   ____            __ _        _                 _
//  / ___|_ __ __ _ / _| |_     / \   ___ __ _  __| | ___ _ __ ___  _   _
// | |   | '__/ _` | |_| __|   / _ \ / __/ _` |/ _` |/ _ \ '_ ` _ \| | | |
// | |___| | | (_| |  _| |_   / ___ \ (_| (_| | (_| |  __/ | | | | | |_| |
//  \____|_|  \__,_|_|  \__| /_/   \_\___\__,_|\__,_|\___|_| |_| |_|\__, |
//                                                                  |___/
//

$(document).ready(function () {
    $(function () {
        $(document).foundation();
    });


    $('#subscribe').click(function () {
        var email = $('#email').val();
        $.ajax({
                url: '/subscribe',
                type: 'post',
                dataType: 'json',
                data: {email: email}
            })
            .done(function (data) {
                $('.subscribe').html('<strong>' + data.message + '</strong>');
            })
            .fail(function (data) {
                $('.subscribe').append('<strong>' + data.responseJSON.message + '</strong>');
            });
    });

    $('#webhook').blur(function () {
        var input = $('#webhook');
        debugger;
        if (input.val().length && parseUrl(input.val()).authority !== "hooks.slack.com") {
            $('.list a').on('click.myDisable', function (e) {
                e.preventDefault();
            }).css({color: "red"});
            if (input.parent().find('p').length == 0) {
                input.append('<p><strong>Not a valid Slack Webhook</strong></p>');

            }
        } else {
            input.parent().find('p').remove();
            $('.list a').off('click.myDisable').removeAttr('style');
            $(function () {
                var addToUrl;
                addToUrl = "hook=" + input.val();
                $(".list a").attr('href', function (i, h) {
                    return h + (h.indexOf('?') != -1 ? "&" + addToUrl : "?" + addToUrl);
                });
            });
        }
    })

});


function parseUrl(url) {
    var pattern = RegExp("^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\\?([^#]*))?(#(.*))?");
    var matches = url.match(pattern);
    return {
        scheme: matches[2],
        authority: matches[4],
        path: matches[5],
        query: matches[7],
        fragment: matches[9]
    };
}