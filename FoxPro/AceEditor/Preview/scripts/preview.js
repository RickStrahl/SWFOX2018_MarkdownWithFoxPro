$(document).ready(function() {
    highlightCode();
});
function highlightCode() {
    $("pre code")
        .each(function (i, block) {
            hljs.highlightBlock(block);
        });
}



function scrolltopragmaline(anchor) {    
    setTimeout(function () {
        try {
            var $el = $("#" + anchor);
            if ($el.length < 1)
                return;
                     
            $el.addClass("line-highlight");
            setTimeout(function () { $el.removeClass("line-highlight"); }, 1800);

            $("html").scrollTop($el.offset().top - 100); 
        }
        catch(ex) {  }
    },80);
}

function status(msg,append) {
    var $el = $("#statusmessage");
    if ($el.length < 1) {
        $el = $("<div id='statusmessage' style='position: fixed; opacity: 0.8; left:0; right:0; bottom: 0; padding: 5px 10px; background: #444; color: white;'></div>");
        $(document.body).append($el);
    }

    if (append) {
        var html = $el.html() +
            "<br/>" +
            msg;
        $el.html(html);
    }
    else
        $el.text(msg);

    $el.show();
    setTimeout(function() { $el.text(""); $el.fadeOut() }, 6000);
}


window.onerror = function windowError(message, filename, lineno, colno, error) {
    if (!isDebug)
        return true;
    
    var msg = "";
    if (message)
        msg = message;
    //if (filename)
    //    msg += ", " + filename;
    if (lineno)
        msg += " (" + lineno + "," + colno + ")";
    if (error)
        msg += error;

    // show error messages in a little pop overwindow
    if (isDebug)
        status(msg);

    console.log(msg);
    
    // don't let errors trigger browser window
    return true;
}

function debounce(func, wait, immediate) {
    var timeout;
    return function () {
        var context = this, args = arguments;
        var later = function () {
            timeout = null;
            if (!immediate) func.apply(context, args);
        };
        var callNow = immediate && !timeout;
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
        if (callNow)
            func.apply(context, args);
    };
};