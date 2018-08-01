//check javascript version
function get_js_version ()
{
    this.jsv = {
            versions: [
                "1.1", "1.2", "1.3", "1.4", "1.5", "1.51", "1.6", "1.7", "1.8", "1.9", "2.0"
            ],
            version: ""
        };

    var d = document;

    for (i = 0; i < jsv.versions.length; i++) {
        var g = d.createElement('script'),
            s = d.getElementsByTagName('script')[0];

            g.setAttribute("language", "JavaScript" + jsv.versions[i]);
            g.text = "this.jsv.version='" + jsv.versions[i] + "';";
            s.parentNode.insertBefore(g, s);
    }

    return jsv.version;
}

var jVersion = 'JavaScript Version: ' + get_js_version();
//document.write('JavaScript Version: ' + get_js_version());