'use strict';if("undefined"===typeof jQuery)throw Error("Bootstrap's JavaScript requires jQuery");
+function(b){b.fn.emulateTransitionEnd=function(c){var f=!1,a=this;b(this).one(b.support.transition.end,function(){f=!0});setTimeout(function(){f||b(a).trigger(b.support.transition.end)},c);return this};b(function(){var c=b.support,f;a:{f=document.createElement("bootstrap");var a={WebkitTransition:"webkitTransitionEnd",MozTransition:"transitionend",OTransition:"oTransitionEnd otransitionend",transition:"transitionend"},e;for(e in a)if(void 0!==f.style[e]){f={end:a[e]};break a}f=!1}c.transition=f})}(jQuery);
+function(b){var c=function(a){b(a).on("click",'[data-dismiss="alert"]',this.close)};c.prototype.close=function(a){function e(){c.trigger("closed.bs.alert").remove()}var d=b(this),g=d.attr("data-target");g||(g=(g=d.attr("href"))&&g.replace(/.*(?=#[^\s]*$)/,""));var c=b(g);a&&a.preventDefault();c.length||(c=d.hasClass("alert")?d:d.parent());c.trigger(a=b.Event("close.bs.alert"));a.isDefaultPrevented()||(c.removeClass("in"),b.support.transition&&c.hasClass("fade")?c.one(b.support.transition.end,e).emulateTransitionEnd(150):
e())};var f=b.fn.alert;b.fn.alert=function(a){return this.each(function(){var e=b(this),d=e.data("bs.alert");d||e.data("bs.alert",d=new c(this));"string"==typeof a&&d[a].call(e)})};b.fn.alert.Constructor=c;b.fn.alert.noConflict=function(){b.fn.alert=f;return this};b(document).on("click.bs.alert.data-api",'[data-dismiss="alert"]',c.prototype.close)}(jQuery);
+function(b){var c=function(a,e){this.$element=b(a);this.options=b.extend({},c.DEFAULTS,e);this.isLoading=!1};c.DEFAULTS={loadingText:"loading..."};c.prototype.setState=function(a){var e=this.$element,d=e.is("input")?"val":"html",c=e.data();a+="Text";c.resetText||e.data("resetText",e[d]());e[d](c[a]||this.options[a]);setTimeout(b.proxy(function(){"loadingText"==a?(this.isLoading=!0,e.addClass("disabled").attr("disabled","disabled")):this.isLoading&&(this.isLoading=!1,e.removeClass("disabled").removeAttr("disabled"))},
this),0)};c.prototype.toggle=function(){var a=!0,b=this.$element.closest('[data-toggle="buttons"]');if(b.length){var d=this.$element.find("input");"radio"==d.prop("type")&&(d.prop("checked")&&this.$element.hasClass("active")?a=!1:b.find(".active").removeClass("active"));a&&d.prop("checked",!this.$element.hasClass("active")).trigger("change")}a&&this.$element.toggleClass("active")};var f=b.fn.button;b.fn.button=function(a){return this.each(function(){var e=b(this),d=e.data("bs.button"),g="object"==
typeof a&&a;d||e.data("bs.button",d=new c(this,g));"toggle"==a?d.toggle():a&&d.setState(a)})};b.fn.button.Constructor=c;b.fn.button.noConflict=function(){b.fn.button=f;return this};b(document).on("click.bs.button.data-api","[data-toggle^=button]",function(a){var e=b(a.target);e.hasClass("btn")||(e=e.closest(".btn"));e.button("toggle");a.preventDefault()})}(jQuery);
+function(b){var c=function(a,e){this.$element=b(a);this.$indicators=this.$element.find(".carousel-indicators");this.options=e;this.paused=this.sliding=this.interval=this.$active=this.$items=null;"hover"==this.options.pause&&this.$element.on("mouseenter",b.proxy(this.pause,this)).on("mouseleave",b.proxy(this.cycle,this))};c.DEFAULTS={interval:5E3,pause:"hover",wrap:!0};c.prototype.cycle=function(a){a||(this.paused=!1);this.interval&&clearInterval(this.interval);this.options.interval&&!this.paused&&
(this.interval=setInterval(b.proxy(this.next,this),this.options.interval));return this};c.prototype.getActiveIndex=function(){this.$active=this.$element.find(".item.active");this.$items=this.$active.parent().children();return this.$items.index(this.$active)};c.prototype.to=function(a){var e=this,d=this.getActiveIndex();if(!(a>this.$items.length-1||0>a))return this.sliding?this.$element.one("slid.bs.carousel",function(){e.to(a)}):d==a?this.pause().cycle():this.slide(a>d?"next":"prev",b(this.$items[a]))};
c.prototype.pause=function(a){a||(this.paused=!0);this.$element.find(".next, .prev").length&&b.support.transition&&(this.$element.trigger(b.support.transition.end),this.cycle(!0));this.interval=clearInterval(this.interval);return this};c.prototype.next=function(){if(!this.sliding)return this.slide("next")};c.prototype.prev=function(){if(!this.sliding)return this.slide("prev")};c.prototype.slide=function(a,e){var d=this.$element.find(".item.active"),c=e||d[a](),k=this.interval,h="next"==a?"left":"right",
m="next"==a?"first":"last",f=this;if(!c.length){if(!this.options.wrap)return;c=this.$element.find(".item")[m]()}if(c.hasClass("active"))return this.sliding=!1;m=b.Event("slide.bs.carousel",{relatedTarget:c[0],direction:h});this.$element.trigger(m);if(!m.isDefaultPrevented())return this.sliding=!0,k&&this.pause(),this.$indicators.length&&(this.$indicators.find(".active").removeClass("active"),this.$element.one("slid.bs.carousel",function(){var a=b(f.$indicators.children()[f.getActiveIndex()]);a&&a.addClass("active")})),
b.support.transition&&this.$element.hasClass("slide")?(c.addClass(a),c[0].offsetWidth,d.addClass(h),c.addClass(h),d.one(b.support.transition.end,function(){c.removeClass([a,h].join(" ")).addClass("active");d.removeClass(["active",h].join(" "));f.sliding=!1;setTimeout(function(){f.$element.trigger("slid.bs.carousel")},0)}).emulateTransitionEnd(1E3*d.css("transition-duration").slice(0,-1))):(d.removeClass("active"),c.addClass("active"),this.sliding=!1,this.$element.trigger("slid.bs.carousel")),k&&this.cycle(),
this};var f=b.fn.carousel;b.fn.carousel=function(a){return this.each(function(){var e=b(this),d=e.data("bs.carousel"),g=b.extend({},c.DEFAULTS,e.data(),"object"==typeof a&&a),k="string"==typeof a?a:g.slide;d||e.data("bs.carousel",d=new c(this,g));if("number"==typeof a)d.to(a);else if(k)d[k]();else g.interval&&d.pause().cycle()})};b.fn.carousel.Constructor=c;b.fn.carousel.noConflict=function(){b.fn.carousel=f;return this};b(document).on("click.bs.carousel.data-api","[data-slide], [data-slide-to]",
function(a){var e=b(this),d,c=b(e.attr("data-target")||(d=e.attr("href"))&&d.replace(/.*(?=#[^\s]+$)/,""));d=b.extend({},c.data(),e.data());var k=e.attr("data-slide-to");k&&(d.interval=!1);c.carousel(d);(k=e.attr("data-slide-to"))&&c.data("bs.carousel").to(k);a.preventDefault()});b(window).on("load",function(){b('[data-ride="carousel"]').each(function(){var a=b(this);a.carousel(a.data())})})}(jQuery);
+function(b){var c=function(a,e){this.$element=b(a);this.options=b.extend({},c.DEFAULTS,e);this.transitioning=null;this.options.parent&&(this.$parent=b(this.options.parent));this.options.toggle&&this.toggle()};c.DEFAULTS={toggle:!0};c.prototype.dimension=function(){return this.$element.hasClass("width")?"width":"height"};c.prototype.show=function(){if(!this.transitioning&&!this.$element.hasClass("in")){var a=b.Event("show.bs.collapse");this.$element.trigger(a);if(!a.isDefaultPrevented()){if((a=this.$parent&&
this.$parent.find("> .panel > .in"))&&a.length){var e=a.data("bs.collapse");if(e&&e.transitioning)return;a.collapse("hide");e||a.data("bs.collapse",null)}var d=this.dimension();this.$element.removeClass("collapse").addClass("collapsing")[d](0);this.transitioning=1;a=function(){this.$element.removeClass("collapsing").addClass("collapse in")[d]("auto");this.transitioning=0;this.$element.trigger("shown.bs.collapse")};if(!b.support.transition)return a.call(this);e=b.camelCase(["scroll",d].join("-"));
this.$element.one(b.support.transition.end,b.proxy(a,this)).emulateTransitionEnd(350)[d](this.$element[0][e])}}};c.prototype.hide=function(){if(!this.transitioning&&this.$element.hasClass("in")){var a=b.Event("hide.bs.collapse");this.$element.trigger(a);if(!a.isDefaultPrevented()){a=this.dimension();this.$element[a](this.$element[a]())[0].offsetHeight;this.$element.addClass("collapsing").removeClass("collapse").removeClass("in");this.transitioning=1;var e=function(){this.transitioning=0;this.$element.trigger("hidden.bs.collapse").removeClass("collapsing").addClass("collapse")};
if(!b.support.transition)return e.call(this);this.$element[a](0).one(b.support.transition.end,b.proxy(e,this)).emulateTransitionEnd(350)}}};c.prototype.toggle=function(){this[this.$element.hasClass("in")?"hide":"show"]()};var f=b.fn.collapse;b.fn.collapse=function(a){return this.each(function(){var e=b(this),d=e.data("bs.collapse"),g=b.extend({},c.DEFAULTS,e.data(),"object"==typeof a&&a);!d&&g.toggle&&"show"==a&&(a=!a);d||e.data("bs.collapse",d=new c(this,g));if("string"==typeof a)d[a]()})};b.fn.collapse.Constructor=
c;b.fn.collapse.noConflict=function(){b.fn.collapse=f;return this};b(document).on("click.bs.collapse.data-api","[data-toggle=collapse]",function(a){var e=b(this),d;a=e.attr("data-target")||a.preventDefault()||(d=e.attr("href"))&&d.replace(/.*(?=#[^\s]+$)/,"");d=b(a);var c=(a=d.data("bs.collapse"))?"toggle":e.data(),k=e.attr("data-parent"),h=k&&b(k);a&&a.transitioning||(h&&h.find('[data-toggle=collapse][data-parent="'+k+'"]').not(e).addClass("collapsed"),e[d.hasClass("in")?"addClass":"removeClass"]("collapsed"));
d.collapse(c)})}(jQuery);
+function(b){function c(d){b(a).remove();b(e).each(function(){var a=f(b(this)),e={relatedTarget:this};a.hasClass("Lc")&&(a.trigger(d=b.Event("hide.bs.dropdown",e)),d.isDefaultPrevented()||a.removeClass("Lc").trigger("hidden.bs.dropdown",e))})}function f(a){var e=a.attr("data-target");e||(e=(e=a.attr("href"))&&/#[A-Za-z]/.test(e)&&e.replace(/.*(?=#[^\s]*$)/,""));return(e=e&&b(e))&&e.length?e:a.parent()}var a=".Mc-Xi",e="[data-toggle=dropdown]",d=function(a){b(a).on("click.bs.dropdown",this.toggle)};
d.prototype.toggle=function(a){var e=b(this);if(!e.is(".Jc, :disabled")){var d=f(e);a=d.hasClass("Lc");c();if(!a){if("ontouchstart"in document.documentElement&&!d.closest(".A-Cj").length)b('<div class="Mc-Xi"/>').insertAfter(b(this)).on("click",c);var g={relatedTarget:this};d.trigger(a=b.Event("show.bs.dropdown",g));if(a.isDefaultPrevented())return;d.toggleClass("Lc").trigger("shown.bs.dropdown",g);e.focus()}return!1}};d.prototype.keydown=function(a){if(/(38|40|27)/.test(a.keyCode)){var d=b(this);
a.preventDefault();a.stopPropagation();if(!d.is(".Jc, :disabled")){var c=f(d),g=c.hasClass("Lc");if(!g||g&&27==a.keyCode)return 27==a.which&&c.find(e).focus(),d.click();d=c.find("[role=menu] li:not(.Wi):visible a, [role=listbox] li:not(.Wi):visible a");d.length&&(c=d.index(d.filter(":focus")),38==a.keyCode&&0<c&&c--,40==a.keyCode&&c<d.length-1&&c++,~c||(c=0),d.eq(c).focus())}}};var g=b.fn.dropdown;b.fn.dropdown=function(a){return this.each(function(){var e=b(this),c=e.data("bs.dropdown");c||e.data("bs.dropdown",
c=new d(this));"string"==typeof a&&c[a].call(e)})};b.fn.dropdown.Constructor=d;b.fn.dropdown.noConflict=function(){b.fn.dropdown=g;return this};b(document).on("click.bs.dropdown.data-api",c).on("click.bs.dropdown.data-api",".dropdown form",function(a){a.stopPropagation()}).on("click.bs.dropdown.data-api",e,d.prototype.toggle).on("keydown.bs.dropdown.data-api",e+", [role=menu], [role=listbox]",d.prototype.keydown)}(jQuery);
+function(b){var c=function(a,e){this.options=e;this.$element=b(a);this.$backdrop=this.isShown=null;this.options.remote&&this.$element.find(".Hk-Hj").load(this.options.remote,b.proxy(function(){this.$element.trigger("loaded.bs.modal")},this))};c.DEFAULTS={backdrop:!0,keyboard:!0,show:!0};c.prototype.toggle=function(a){return this[this.isShown?"Rk":"Sk"](a)};c.prototype.show=function(a){var e=this,d=b.Event("show.bs.modal",{relatedTarget:a});this.$element.trigger(d);this.isShown||d.isDefaultPrevented()||
(this.isShown=!0,this.escape(),this.$element.on("click.dismiss.bs.modal",'[data-dismiss="modal"]',b.proxy(this.hide,this)),this.backdrop(function(){var d=b.support.transition&&e.$element.hasClass("Qc");e.$element.parent().length||e.$element.appendTo(document.body);e.$element.show().scrollTop(0);d&&e.$element[0].offsetWidth;e.$element.addClass("Rc").attr("aria-hidden",!1);e.enforceFocus();var c=b.Event("shown.bs.modal",{relatedTarget:a});d?e.$element.find(".Hk-Ik").one(b.support.transition.end,function(){e.$element.focus().trigger(c)}).emulateTransitionEnd(300):
e.$element.focus().trigger(c)}))};c.prototype.hide=function(a){a&&a.preventDefault();a=b.Event("hide.bs.modal");this.$element.trigger(a);this.isShown&&!a.isDefaultPrevented()&&(this.isShown=!1,this.escape(),b(document).off("focusin.bs.modal"),this.$element.removeClass("Rc").attr("aria-hidden",!0).off("click.dismiss.bs.modal"),b.support.transition&&this.$element.hasClass("Qc")?this.$element.one(b.support.transition.end,b.proxy(this.hideModal,this)).emulateTransitionEnd(300):this.hideModal())};c.prototype.enforceFocus=
function(){b(document).off("focusin.bs.modal").on("focusin.bs.modal",b.proxy(function(a){this.$element[0]===a.target||this.$element.has(a.target).length||this.$element.focus()},this))};c.prototype.escape=function(){if(this.isShown&&this.options.keyboard)this.$element.on("keyup.dismiss.bs.modal",b.proxy(function(a){27==a.which&&this.hide()},this));else this.isShown||this.$element.off("keyup.dismiss.bs.modal")};c.prototype.hideModal=function(){var a=this;this.$element.hide();this.backdrop(function(){a.removeBackdrop();
a.$element.trigger("hidden.bs.modal")})};c.prototype.removeBackdrop=function(){this.$backdrop&&this.$backdrop.remove();this.$backdrop=null};c.prototype.backdrop=function(a){var e=this.$element.hasClass("Qc")?"Qc":"";if(this.isShown&&this.options.backdrop){var d=b.support.transition&&e;this.$backdrop=b('<div class="Hk-Xi '+e+'" />').appendTo(document.body);this.$element.on("click.dismiss.bs.modal",b.proxy(function(a){a.target===a.currentTarget&&("static"==this.options.backdrop?this.$element[0].focus.call(this.$element[0]):
this.hide.call(this))},this));d&&this.$backdrop[0].offsetWidth;this.$backdrop.addClass("Rc");a&&(d?this.$backdrop.one(b.support.transition.end,a).emulateTransitionEnd(150):a())}else!this.isShown&&this.$backdrop?(this.$backdrop.removeClass("Rc"),b.support.transition&&this.$element.hasClass("Qc")?this.$backdrop.one(b.support.transition.end,a).emulateTransitionEnd(150):a()):a&&a()};var f=b.fn.modal;b.fn.modal=function(a,e){return this.each(function(){var d=b(this),g=d.data("bs.modal"),k=b.extend({},
c.DEFAULTS,d.data(),"object"==typeof a&&a);g||d.data("bs.modal",g=new c(this,k));if("string"==typeof a)g[a](e);else k.show&&g.show(e)})};b.fn.modal.Constructor=c;b.fn.modal.noConflict=function(){b.fn.modal=f;return this};b(document).on("click.bs.modal.data-api",'[data-toggle="modal"]',function(a){var e=b(this),d=e.attr("href"),c=b(e.attr("data-target")||d&&d.replace(/.*(?=#[^\s]+$)/,"")),d=c.data("bs.modal")?"Nc":b.extend({remote:!/#/.test(d)&&d},c.data(),e.data());e.is("a")&&a.preventDefault();c.modal(d,
this).one("Rk",function(){e.is(":visible")&&e.focus()})});b(document).on("show.bs.modal",".modal",function(){b(document.body).addClass("Hk-Lc")}).on("hidden.bs.modal",".modal",function(){b(document.body).removeClass("Hk-Lc")})}(jQuery);
+function(b){var c=function(a,e){this.type=this.options=this.enabled=this.timeout=this.hoverState=this.$element=null;this.init("tooltip",a,e)};c.DEFAULTS={animation:!0,placement:"Jj",selector:!1,template:'<div class="Jk"><div class="Jk-Xf"></div><div class="Jk-Kk"></div></div>',trigger:"hover focus",title:"",delay:0,html:!1,container:!1};c.prototype.init=function(a,e,d){this.enabled=!0;this.type=a;this.$element=b(e);this.options=this.getOptions(d);a=this.options.trigger.split(" ");for(e=a.length;e--;)if(d=
a[e],"click"==d)this.$element.on("click."+this.type,this.options.selector,b.proxy(this.toggle,this));else if("manual"!=d){var c="hover"==d?"mouseleave":"focusout";this.$element.on(("hover"==d?"mouseenter":"focusin")+"."+this.type,this.options.selector,b.proxy(this.enter,this));this.$element.on(c+"."+this.type,this.options.selector,b.proxy(this.leave,this))}this.options.selector?this._options=b.extend({},this.options,{trigger:"manual",selector:""}):this.fixTitle()};c.prototype.getDefaults=function(){return c.DEFAULTS};
c.prototype.getOptions=function(a){a=b.extend({},this.getDefaults(),this.$element.data(),a);a.delay&&"number"==typeof a.delay&&(a.delay={show:a.delay,hide:a.delay});return a};c.prototype.getDelegateOptions=function(){var a={},e=this.getDefaults();this._options&&b.each(this._options,function(b,c){e[b]!=c&&(a[b]=c)});return a};c.prototype.enter=function(a){var e=a instanceof this.constructor?a:b(a.currentTarget)[this.type](this.getDelegateOptions()).data("bs."+this.type);clearTimeout(e.timeout);e.hoverState=
"in";if(!e.options.delay||!e.options.delay.show)return e.show();e.timeout=setTimeout(function(){"in"==e.hoverState&&e.show()},e.options.delay.show)};c.prototype.leave=function(a){var e=a instanceof this.constructor?a:b(a.currentTarget)[this.type](this.getDelegateOptions()).data("bs."+this.type);clearTimeout(e.timeout);e.hoverState="out";if(!e.options.delay||!e.options.delay.hide)return e.hide();e.timeout=setTimeout(function(){"out"==e.hoverState&&e.hide()},e.options.delay.hide)};c.prototype.show=
function(){var a=b.Event("show.bs."+this.type);if(this.hasContent()&&this.enabled&&(this.$element.trigger(a),!a.isDefaultPrevented())){var e=this,a=this.tip();this.setContent();this.options.animation&&a.addClass("Qc");var d="function"==typeof this.options.placement?this.options.placement.call(this,a[0],this.$element[0]):this.options.placement,c=/\s?auto?\s?/i,k=c.test(d);k&&(d=d.replace(c,"")||"Jj");a.detach().css({top:0,left:0,display:"block"}).addClass(d);this.options.container?a.appendTo(this.options.container):
a.insertAfter(this.$element);var c=this.getPosition(),h=a[0].offsetWidth,f=a[0].offsetHeight;if(k){var l=this.$element.parent(),k=d,n=document.documentElement.scrollTop||document.body.scrollTop,p="body"==this.options.container?window.innerWidth:l.outerWidth(),q="body"==this.options.container?window.innerHeight:l.outerHeight(),l="body"==this.options.container?0:l.offset().left,d="Zi"==d&&c.top+c.height+f-n>q?"Jj":"Jj"==d&&0>c.top-n-f?"Zi":"Y"==d&&c.right+h>p?"X":"X"==d&&c.left-h<l?"Y":d;a.removeClass(k).addClass(d)}c=
this.getCalculatedOffset(d,c,h,f);this.applyPlacement(c,d);this.hoverState=null;d=function(){e.$element.trigger("shown.bs."+e.type)};b.support.transition&&this.$tip.hasClass("fade")?a.one(b.support.transition.end,d).emulateTransitionEnd(150):d()}};c.prototype.applyPlacement=function(a,e){var d,c=this.tip(),k=c[0].offsetWidth,f=c[0].offsetHeight,m=parseInt(c.css("margin-top"),10),l=parseInt(c.css("margin-left"),10);isNaN(m)&&(m=0);isNaN(l)&&(l=0);a.top+=m;a.left+=l;b.offset.setOffset(c[0],b.extend({using:function(a){c.css({top:Math.round(a.top),
left:Math.round(a.left)})}},a),0);c.addClass("Rc");m=c[0].offsetWidth;l=c[0].offsetHeight;"Jj"==e&&l!=f&&(d=!0,a.top=a.top+f-l);"Zi"==e||"Jj"==e?(f=0,0>a.left&&(f=-2*a.left,a.left=0,c.offset(a),m=c[0].offsetWidth,l=c[0].offsetHeight),this.replaceArrow(f-k+m,m,"left")):this.replaceArrow(l-f,l,"top");d&&c.offset(a)};c.prototype.replaceArrow=function(a,b,d){this.arrow().css(d,a?50*(1-a/b)+"%":"")};c.prototype.setContent=function(){var a=this.tip(),b=this.getTitle();a.find(".Jk-Kk")[this.options.html?
"html":"text"](b);a.removeClass("fade in top bottom left right")};c.prototype.hide=function(){function a(){"in"!=e.hoverState&&d.detach();e.$element.trigger("hidden.bs."+e.type)}var e=this,d=this.tip(),c=b.Event("hide.bs."+this.type);this.$element.trigger(c);if(!c.isDefaultPrevented())return d.removeClass("in"),b.support.transition&&this.$tip.hasClass("fade")?d.one(b.support.transition.end,a).emulateTransitionEnd(150):a(),this.hoverState=null,this};c.prototype.fixTitle=function(){var a=this.$element;
(a.attr("title")||"string"!=typeof a.attr("data-original-title"))&&a.attr("data-original-title",a.attr("title")||"").attr("title","")};c.prototype.hasContent=function(){return this.getTitle()};c.prototype.getPosition=function(){var a=this.$element[0];return b.extend({},"function"==typeof a.getBoundingClientRect?a.getBoundingClientRect():{width:a.offsetWidth,height:a.offsetHeight},this.$element.offset())};c.prototype.getCalculatedOffset=function(a,b,d,c){return"Zi"==a?{top:b.top+b.height,left:b.left+
b.width/2-d/2}:"Jj"==a?{top:b.top-c,left:b.left+b.width/2-d/2}:"X"==a?{top:b.top+b.height/2-c/2,left:b.left-d}:{top:b.top+b.height/2-c/2,left:b.left+b.width}};c.prototype.getTitle=function(){var a=this.$element,b=this.options;return a.attr("data-original-title")||("function"==typeof b.title?b.title.call(a[0]):b.title)};c.prototype.tip=function(){return this.$tip=this.$tip||b(this.options.template)};c.prototype.arrow=function(){return this.$arrow=this.$arrow||this.tip().find(".Jk-Xf")};c.prototype.validate=
function(){this.$element[0].parentNode||(this.hide(),this.options=this.$element=null)};c.prototype.enable=function(){this.enabled=!0};c.prototype.disable=function(){this.enabled=!1};c.prototype.toggleEnabled=function(){this.enabled=!this.enabled};c.prototype.toggle=function(a){a=a?b(a.currentTarget)[this.type](this.getDelegateOptions()).data("bs."+this.type):this;a.tip().hasClass("in")?a.leave(a):a.enter(a)};c.prototype.destroy=function(){clearTimeout(this.timeout);this.hide().$element.off("."+this.type).removeData("bs."+
this.type)};var f=b.fn.tooltip;b.fn.tooltip=function(a){return this.each(function(){var e=b(this),d=e.data("bs.tooltip"),g="object"==typeof a&&a;if(d||"destroy"!=a)if(d||e.data("bs.tooltip",d=new c(this,g)),"string"==typeof a)d[a]()})};b.fn.tooltip.Constructor=c;b.fn.tooltip.noConflict=function(){b.fn.tooltip=f;return this}}(jQuery);
+function(b){var c=function(a,b){this.init("popover",a,b)};if(!b.fn.tooltip)throw Error("Popover requires tooltip.js");c.DEFAULTS=b.extend({},b.fn.tooltip.Constructor.DEFAULTS,{placement:"right",trigger:"click",content:"",template:'<div class="popover"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>'});c.prototype=b.extend({},b.fn.tooltip.Constructor.prototype);c.prototype.constructor=c;c.prototype.getDefaults=function(){return c.DEFAULTS};c.prototype.setContent=
function(){var a=this.tip(),b=this.getTitle(),c=this.getContent();a.find(".popover-title")[this.options.html?"html":"text"](b);a.find(".popover-content")[this.options.html?"string"==typeof c?"html":"append":"text"](c);a.removeClass("fade top bottom left right in");a.find(".popover-title").html()||a.find(".popover-title").hide()};c.prototype.hasContent=function(){return this.getTitle()||this.getContent()};c.prototype.getContent=function(){var a=this.$element,b=this.options;return a.attr("data-content")||
("function"==typeof b.content?b.content.call(a[0]):b.content)};c.prototype.arrow=function(){return this.$arrow=this.$arrow||this.tip().find(".arrow")};c.prototype.tip=function(){this.$tip||(this.$tip=b(this.options.template));return this.$tip};var f=b.fn.popover;b.fn.popover=function(a){return this.each(function(){var e=b(this),d=e.data("bs.popover"),g="object"==typeof a&&a;if(d||"destroy"!=a)if(d||e.data("bs.popover",d=new c(this,g)),"string"==typeof a)d[a]()})};b.fn.popover.Constructor=c;b.fn.popover.noConflict=
function(){b.fn.popover=f;return this}}(jQuery);
+function(b){function c(a,e){var d,g=b.proxy(this.process,this);this.$element=b(a).is("body")?b(window):b(a);this.$body=b("body");this.$scrollElement=this.$element.on("scroll.bs.scroll-spy.data-api",g);this.options=b.extend({},c.DEFAULTS,e);this.selector=(this.options.target||(d=b(a).attr("href"))&&d.replace(/.*(?=#[^\s]+$)/,"")||"")+" .nav li > a";this.offsets=b([]);this.targets=b([]);this.activeTarget=null;this.refresh();this.process()}c.DEFAULTS={offset:10};c.prototype.refresh=function(){var a=
this.$element[0]==window?"offset":"position";this.offsets=b([]);this.targets=b([]);var c=this;this.$body.find(this.selector).map(function(){var d=b(this),d=d.data("target")||d.attr("href"),g=/^#./.test(d)&&b(d);return g&&g.length&&g.is(":visible")&&[[g[a]().top+(!b.isWindow(c.$scrollElement.get(0))&&c.$scrollElement.scrollTop()),d]]||null}).sort(function(a,b){return a[0]-b[0]}).each(function(){c.offsets.push(this[0]);c.targets.push(this[1])})};c.prototype.process=function(){var a=this.$scrollElement.scrollTop()+
this.options.offset,b=(this.$scrollElement[0].scrollHeight||this.$body[0].scrollHeight)-this.$scrollElement.height(),c=this.offsets,g=this.targets,f=this.activeTarget,h;if(a>=b)return f!=(h=g.last()[0])&&this.activate(h);if(f&&a<=c[0])return f!=(h=g[0])&&this.activate(h);for(h=c.length;h--;)f!=g[h]&&a>=c[h]&&(!c[h+1]||a<=c[h+1])&&this.activate(g[h])};c.prototype.activate=function(a){this.activeTarget=a;b(this.selector).parentsUntil(this.options.target,".active").removeClass("active");a=b(this.selector+
'[data-target="'+a+'"],'+this.selector+'[href="'+a+'"]').parents("li").addClass("active");a.parent(".dropdown-menu").length&&(a=a.closest("li.dropdown").addClass("active"));a.trigger("activate.bs.scrollspy")};var f=b.fn.scrollspy;b.fn.scrollspy=function(a){return this.each(function(){var e=b(this),d=e.data("bs.scrollspy"),g="object"==typeof a&&a;d||e.data("bs.scrollspy",d=new c(this,g));if("string"==typeof a)d[a]()})};b.fn.scrollspy.Constructor=c;b.fn.scrollspy.noConflict=function(){b.fn.scrollspy=
f;return this};b(window).on("load",function(){b('[data-spy="scroll"]').each(function(){var a=b(this);a.scrollspy(a.data())})})}(jQuery);
+function(b){var c=function(a){this.element=b(a)};c.prototype.show=function(){var a=this.element,c=a.closest("ul:not(.dropdown-menu)"),d=a.data("target");d||(d=(d=a.attr("href"))&&d.replace(/.*(?=#[^\s]*$)/,""));if(!a.parent("li").hasClass("active")){var g=c.find(".active:last a")[0],f=b.Event("show.bs.tab",{relatedTarget:g});a.trigger(f);f.isDefaultPrevented()||(d=b(d),this.activate(a.parent("li"),c),this.activate(d,d.parent(),function(){a.trigger({type:"shown.bs.tab",relatedTarget:g})}))}};c.prototype.activate=
function(a,c,d){function g(){f.removeClass("active").find("> .dropdown-menu > .active").removeClass("active");a.addClass("active");h?(a[0].offsetWidth,a.addClass("in")):a.removeClass("fade");a.parent(".dropdown-menu")&&a.closest("li.dropdown").addClass("active");d&&d()}var f=c.find("> .active"),h=d&&b.support.transition&&f.hasClass("fade");h?f.one(b.support.transition.end,g).emulateTransitionEnd(150):g();f.removeClass("in")};var f=b.fn.tab;b.fn.tab=function(a){return this.each(function(){var e=b(this),
d=e.data("bs.tab");d||e.data("bs.tab",d=new c(this));if("string"==typeof a)d[a]()})};b.fn.tab.Constructor=c;b.fn.tab.noConflict=function(){b.fn.tab=f;return this};b(document).on("click.bs.tab.data-api",'[data-toggle="tab"], [data-toggle="pill"]',function(a){a.preventDefault();b(this).tab("show")})}(jQuery);
+function(b){var c=function(a,e){this.options=b.extend({},c.DEFAULTS,e);this.$window=b(window).on("scroll.bs.affix.data-api",b.proxy(this.checkPosition,this)).on("click.bs.affix.data-api",b.proxy(this.checkPositionWithEventLoop,this));this.$element=b(a);this.affixed=this.unpin=this.pinnedOffset=null;this.checkPosition()};c.RESET="affix affix-top affix-bottom";c.DEFAULTS={offset:0};c.prototype.getPinnedOffset=function(){if(this.pinnedOffset)return this.pinnedOffset;this.$element.removeClass(c.RESET).addClass("affix");
var a=this.$window.scrollTop();return this.pinnedOffset=this.$element.offset().top-a};c.prototype.checkPositionWithEventLoop=function(){setTimeout(b.proxy(this.checkPosition,this),1)};c.prototype.checkPosition=function(){if(this.$element.is(":visible")){var a=b(document).height(),e=this.$window.scrollTop(),d=this.$element.offset(),g=this.options.offset,f=g.top,h=g.bottom;"top"==this.affixed&&(d.top+=e);"object"!=typeof g&&(h=f=g);"function"==typeof f&&(f=g.top(this.$element));"function"==typeof h&&
(h=g.bottom(this.$element));e=null!=this.unpin&&e+this.unpin<=d.top?!1:null!=h&&d.top+this.$element.height()>=a-h?"bottom":null!=f&&e<=f?"top":!1;this.affixed!==e&&(this.unpin&&this.$element.css("top",""),d="affix"+(e?"-"+e:""),g=b.Event(d+".bs.affix"),this.$element.trigger(g),g.isDefaultPrevented()||(this.affixed=e,this.unpin="bottom"==e?this.getPinnedOffset():null,this.$element.removeClass(c.RESET).addClass(d).trigger(b.Event(d.replace("affix","affixed"))),"bottom"==e&&this.$element.offset({top:a-
h-this.$element.height()})))}};var f=b.fn.affix;b.fn.affix=function(a){return this.each(function(){var e=b(this),d=e.data("bs.affix"),f="object"==typeof a&&a;d||e.data("bs.affix",d=new c(this,f));if("string"==typeof a)d[a]()})};b.fn.affix.Constructor=c;b.fn.affix.noConflict=function(){b.fn.affix=f;return this};b(window).on("load",function(){b('[data-spy="affix"]').each(function(){var a=b(this),c=a.data();c.offset=c.offset||{};c.offsetBottom&&(c.offset.bottom=c.offsetBottom);c.offsetTop&&(c.offset.top=
c.offsetTop);a.affix(c)})})}(jQuery);
