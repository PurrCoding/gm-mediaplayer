"use strict";

function requestUrl() {
    var a = document.getElementById("urlinput"),
        b = a.value;
    0 !== b.length && gmod.requestUrl(b)
}

function onUrlKeyDown(a) {
    13 === (a.keyCode || a.which) && requestUrl()
}

function hoverService() {
    console.log("PLAY: garrysmod/ui_hover.wav")
}

function selectService(a) {
    console.log("PLAY: garrysmod/ui_click.wav");
    var b = a.dataset.href;
    void 0 !== a.dataset.overlay ? gmod.openUrl(b) : window.location.href = b
} ! function (a) {
    void 0 !== a && (window.setServices = function (a) {
        a = a.split(",");
        for (var b, c, d = document.querySelectorAll(".media-service"), e = 0; e < d.length; e++)
            if (b = d[e], c = b.dataset.service) {
                c = c.split(" ");
                for (var f = 0; f < c.length; f++) - 1 === a.indexOf(c[f]) && (b.style.display = "none")
            }
    }, a.getServices())
}(window.gmod); 1