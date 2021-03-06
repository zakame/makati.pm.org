// micro_dispatcher.js - (C) tokuhirom, MIT License.
(function() {
    var namedParam    = /:([\w\d]+)/g;
    var splatParam    = /\*([\w\d]+)/g;
    var escapeRegExp  = /[\-\[\]{}()+?.,\\\^$|#\s]/g;

    // http://perfectionkills.com/instanceof-considered-harmful-or-how-to-write-a-robust-isarray/
    var toString = Object.prototype.toString;
    function isRegExp(obj) {
        return toString.call(obj)=='[object RegExp]';
    }

    function Dispatcher() {
        this.routes = [];
    }
    Dispatcher.prototype = {
        register: function(route, callback) {
            if (!isRegExp(route)) {
                route = this._compileRoute(route);
            }
            this.routes.push([route, callback]);
        },
        dispatch: function (path) {
            var routes = this.routes;
            for (var i=0, l=routes.length; i<l; i++) {
                var route = this.routes[i][0];
                var callback = this.routes[i][1];
                var matched = route.exec(path);
                if (matched) {
                    var args = matched.slice(1);
                    callback.apply(this, args);
                }
            }
        },
        _compileRoute : function(route) {
            route = route.replace(escapeRegExp, "\\$&").replace(namedParam, "([^\/]+)").replace(splatParam, "(.*?)");
            return new RegExp('^' + route + '$');
        }
    };
    this.MicroDispatcher = Dispatcher;
})();
