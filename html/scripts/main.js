"use strict";
window.MP = function () {
    var a = document.body;
    return {
        setHtml: function (b) {
            a.innerHTML = b, console.log(a.innerHTML)
        }
    }
}();