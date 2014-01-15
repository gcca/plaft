var Backbone = {
    "VERSION": {},
    "setDomLibrary": function () {},
    "noConflict": function () {},
    "emulateHTTP": {},
    "emulateJSON": {}
};

/**
 * @param {Function} onError
 * @param {Backbone.Model} originalModel
 * @param {Object} options
 */
Backbone.wrapError = function(onError, originalModel, options){};

/**
 * @param {string=} method
 * @param {Backbone.Model=} model
 * @param {Object=} options
 */
Backbone.sync = function(method, model, options){};

/**
 * @extends {Backbone.Events}
 * @constructor
 * @param {Object=} attrs
 * @param {Object=} options
 */
Backbone.Model = function(attrs, options) {};

/** @type {*} */
Backbone.Model.prototoype.validationError;

Backbone.Model.prototype.once = Backbone.Events.once;
Backbone.Model.prototype.listenTo = Backbone.Events.listenTo;
Backbone.Model.prototype.listenToOnce = Backbone.Events.listenToOnce;
Backbone.Model.prototype.stopListening = Backbone.Events.stopListening;

Backbone.Model.prototype.keys = _.prototype.keys;
Backbone.Model.prototype.values = _.prototype.values;
Backbone.Model.prototype.pairs = _.prototype.pairs;
Backbone.Model.prototype.invert = _.prototype.invert;
Backbone.Model.prototype.pick = _.prototype.pick;
Backbone.Model.prototype.omit = _.prototype.omit;

/**
 * @param {Object} properties
 * @param {Object=} classProperties
 */
Backbone.Model.prototype.extend = function(properties, classProperties) {};

/**
 * @param {string} attribute
 * @return {*}
 */
Backbone.Model.prototype.get = function(attribute) {};

/**
 * @param {string|Object} key
 * @param {*=} value
 * @param {Object=} options
 * @return {Backbone.Model}
 */
Backbone.Model.prototype.set = function(key, value, options) {};

/**
 * @param {string} attribute
 * @return {string}
 */
Backbone.Model.prototype.escape = function(attribute) {};

/**
 * @param {string} attribute
 * @return {boolean}
 */
Backbone.Model.prototype.has = function(attribute) {};

/**
 * @param {string} attribute
 * @param {Object=} options
 * @return {Backbone.Model}
 */
Backbone.Model.prototype.unset = function(attribute, options) {};

/**
 * @param {Object=} options
 */
Backbone.Model.prototype.clear = function(options) {};

/** @type {number} */
Backbone.Model.prototype.id;

/** @type {string} */
Backbone.Model.prototype.idAttribute;

/** @type {number} */
Backbone.Model.prototype.cid;

/** @type {Object} */
Backbone.Model.prototype.attributes;

/** @type {Object} */
Backbone.Model.prototype.changed;

/** @type {Object|Function} */
Backbone.Model.prototype.defaults;

/**
 * @param {Object=} options
 * @return {Object}
 */
Backbone.Model.prototype.toJSON = function(options) {};

/**
 * @param {Object=} options
 * @return {boolean|Object}
 */
Backbone.Model.prototype.destroy = function(options) {};

/**
 * @param {Object} attributes
 */
Backbone.Model.prototype.validate = function(attributes) {};

/**
 * @return {boolean}
 */
Backbone.Model.prototype.isValid = function() {};

/**
 * @return {string}
 */
Backbone.Model.prototype.url = function() {};

/** @type {string|Function} */
Backbone.Model.urlRoot;

/**
 * @param {Object} resp
 * @param {Object} xhr
 * @return {Object}
 */
Backbone.Model.prototype.parse = function(resp, xhr) {};

/**
 * @return {Backbone.Model}
 */
Backbone.Model.prototype.clone = function() {};

/**
 * @return {boolean}
 */
Backbone.Model.prototype.isNew = function() {};

/**
 * @param {Object=} options
 * @return {Backbone.Model}
 */
Backbone.Model.prototype.change = function(options) {};

/**
 * @param {string|number=} attr
 * @return {boolean}
 */
Backbone.Model.prototype.hasChanged = function(attr) {};

/**
 * @param {Object=} attributes
 * @return {Object}
 */
Backbone.Model.prototype.changedAttributes = function(attributes) {};

/**
 * @param {string|number} attribute
 * @return {*}
 */
Backbone.Model.prototype.previous = function(attribute) {};

/**
 * @return {Object}
 */
Backbone.Model.prototype.previousAttributes = function() {};

/**
 * @extends {Backbone.Events}
 * @constructor
 * @param {Object|Backbone.Model|Array.<Object>=} models
 * @param {Object=} config
 */
Backbone.Collection = function(models, config) {};

/** @type {Object} */
Backbone.Collection.prototype.syncArgs;

/** @type {Array} */
Backbone.Collection.prototype.previousModels;

/**
 * @param {Object=} options
 */
Backbone.Collection.prototype.sort = function(options) {};

/**
 * @param {Object} resp
 * @param {Object} xhr
 * @return {Object}
 */
Backbone.Collection.prototype.parse = function(resp, xhr) {};

Backbone.Collection.prototype.map = _.prototype.map;
Backbone.Collection.prototype.reduce = _.prototype.reduce;
Backbone.Collection.prototype.reduceRight = _.prototype.reduceRight;
Backbone.Collection.prototype.each = _.prototype.each;
Backbone.Collection.prototype.forEach = _.prototype.forEach;
Backbone.Collection.prototype.find = _.prototype.find;
Backbone.Collection.prototype.detect = _.prototype.detect;
Backbone.Collection.prototype.filter = _.prototype.filter;
Backbone.Collection.prototype.select = _.prototype.select;
Backbone.Collection.prototype.reject = _.prototype.reject;
Backbone.Collection.prototype.every = _.prototype.every;
Backbone.Collection.prototype.all = _.prototype.all;
Backbone.Collection.prototype.any = _.prototype.any;
Backbone.Collection.prototype.some = _.prototype.some;
Backbone.Collection.prototype.include = _.prototype.include;
Backbone.Collection.prototype.contains = _.prototype.contains;
Backbone.Collection.prototype.invoke = _.prototype.invoke;
Backbone.Collection.prototype.min = _.prototype.min;
Backbone.Collection.prototype.max = _.prototype.max;
Backbone.Collection.prototype.chain = _.prototype.chain;
Backbone.Collection.prototype.sortedIndex = _.prototype.sortedIndex;
Backbone.Collection.prototype.toArray = _.prototype.toArray;
Backbone.Collection.prototype.size = _.prototype.size;
Backbone.Collection.prototype.first = _.prototype.first;
Backbone.Collection.prototype.initial = _.prototype.initial;
Backbone.Collection.prototype.rest = _.prototype.rest;
Backbone.Collection.prototype.last = _.prototype.last;
Backbone.Collection.prototype.without = _.prototype.without;
Backbone.Collection.prototype.shuffle = _.prototype.shuffle;
Backbone.Collection.prototype.lastIndexOf = _.prototype.lastIndexOf;
Backbone.Collection.prototype.isEmpty = _.prototype.isEmpty;

/**
 * @param {Object=} options
 * @return {Array.<Object>}
 */
Backbone.Collection.prototype.toJSON = function(options) {};

Backbone.Collection.prototype.once = Backbone.Events.once;
Backbone.Collection.prototype.listenTo = Backbone.Events.listenTo;
Backbone.Collection.prototype.listenToOnce = Backbone.Events.listenToOnce;
Backbone.Collection.prototype.stopListening = Backbone.Events.stopListening;

/** @type {number} */
Backbone.Collection.prototype.length;

/** @type {Array} */
Backbone.Collection.prototype.models;

/** @type {Backbone.Model} */
Backbone.Collection.model;

/**
 * @param {Object|Array.<Object>} models
 * @param {Object=} options
 * @return {Object} returns jQuery xhr
 */
Backbone.Collection.prototype.update = function(models, options) {};

/**
 * @param {string|number} index
 * @return {Backbone.Model|undefined}
 */
Backbone.Collection.prototype.at = function(index) {};

/**
 * @param {string|number|Backbone.Model} id
 * @return {Backbone.Model|undefined}
 */
Backbone.Collection.prototype.get = function(id) {};

/**
 * @param {string|number} cid
 * @return {Backbone.Model|undefined}
 */
Backbone.Collection.prototype.getByCid = function(cid) {};

/**
 * @param {Object|Backbone.Model|Array.<Object>} models
 * @param {Object=} options
 */
Backbone.Collection.prototype.add = function(models, options){};

/**
 * @param {Object|Backbone.Model|Array.<Object>} models
 * @param {Object=} options
 */
Backbone.Collection.prototype.remove = function(models, options){};

/**
 * @param {Object|Backbone.Model} model
 * @param {Object=} options
 */
Backbone.Collection.prototype.create = function(model, options){};

/**
 * @param {Array|Object=} models
 * @param {Object=} options
 */
Backbone.Collection.prototype.reset = function(models, options){};

/**
 * @param {Array|Object=} models
 * @param {Object=} options
 */
Backbone.Collection.prototype.set = function(models, options){};

/**
 * @param {string} attr
 * @return {Array}
 */
Backbone.Collection.prototype.pluck = function(attr){};

/**
 * @param {*} value
 * @param {Object=} options
 * @return {number|undefined}
 */
Backbone.Collection.prototype.indexOf = function(value, options){};

/**
 * @param {Object=} options
 * @return {Backbone.Model|undefined}
 */
Backbone.Collection.prototype.shift = function(options){};

/**
 * @param {Backbone.Model|Object} model
 * @param {Object=} options
 */
Backbone.Collection.prototype.unshift = function(model, options){};

/**
 * @param {Object=} options
 */
Backbone.Collection.prototype.pop = function(options){};

/**
 * @param {Backbone.Model} model
 * @param {Object=} options
 */
Backbone.Collection.prototype.push = function(model, options){};

/**
 * @param {number=} begin
 * @param {number=} end
 */
Backbone.Collection.prototype.slice = function(begin, end) {};

/**
 * @param {Object} attrs
 * @param {boolean=} first
 * @return {Array}
 */
Backbone.Collection.prototype.where = function(attrs, first) {};

/**
 * @param {Object} attrs
 * @return {Object}
 */
Backbone.Collection.prototype.findWhere = function(attrs) {};

/**
 * @param {Function|string} iterator
 * @param {Object=} context
 */
Backbone.Collection.prototype.sortBy = function(iterator, context) {};

/**
 * @param {Function|string} iterator
 * @param {Object=} context
 */
Backbone.Collection.prototype.groupBy = function(iterator, context) {};

Backbone.Router.prototype = {
    "route": function () {},
    "_bindRoutes": function () {},
    "_routeToRegExp": function () {},
    "_extractParameters": function () {}
};

Backbone.Router.prototype.once = Backbone.Events.once;
Backbone.Router.prototype.listenTo = Backbone.Events.listenTo;
Backbone.Router.prototype.listenToOnce = Backbone.Events.listenToOnce;
Backbone.Router.prototype.stopListening = Backbone.Events.stopListening;

/**
 * @constructor
 */
Backbone.History = function() {};

Backbone.History.prototype.once = Backbone.Events.once;
Backbone.History.prototype.listenTo = Backbone.Events.listenTo;
Backbone.History.prototype.listenToOnce = Backbone.Events.listenToOnce;
Backbone.History.prototype.stopListening = Backbone.Events.stopListening;

/** @type {boolean} */
Backbone.History.started;

/** @type {boolean} */
Backbone.History.prototype.started;

/**
 * @param {Object=} options
 */
Backbone.History.prototype.start = function(options) {};

/**
 * @param {Object=} options
 */
Backbone.History.prototype.stop = function(options) {};

/**
 * @param {Object=} e
 */
Backbone.History.prototype.checkUrl = function(e) {};

/**
 * @param {string} fragment
 * @param {boolean|Object=} options
 */
Backbone.History.prototype.navigate = function(fragment, options) {};

/**
 * @param {string=} fragment
 * @param {boolean=} forcePushState
 */
Backbone.History.prototype.getFragment = function(fragment, forcePushState) {};

/**
 * @param {...*} args
 * @constructor
 */
Backbone.View = function(args){};

/**
 * @param {Object=} events
 */
Backbone.View.prototype.delegateEvents = function(events){};
/**
 * @param {Object=} events
 */
Backbone.View.prototype.undelegateEvents = function(events){};

/**
 * @param {string|Element|jQuery} element
 * @param {boolean=} delegate
 */
Backbone.View.prototype.setElement = function(element, delegate){};
