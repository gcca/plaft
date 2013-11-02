SRC = $(wildcard frontend/*.ls frontend/*/*.ls \
	frontend/*/*/*.ls frontend/*/*/*.ls frontend/*/*/*/*.ls)
DST = $(SRC:.ls=.js)
DIR = lac/static
BAS = frontend
F3P = frontend/3rdparty

all: $(foreach D,$(DST), $(DIR)/$(D))
	@browserify lac/static/frontend/customer-form.js > lac/static/customer-form-src.js
	@cat $(F3P)/zepto-min.js $(F3P)/underscore-min.js $(F3P)/ink-min.js $(F3P)/backbone-min.js $(F3P)/prelude-min.js $(F3P)/base-min.js /dev/shm/mapr-customer-form lac/static/customer-form-src.js > lac/static/customer-form.js
	@rm lac/static/customer-form-src.js
	@echo Compilado...

$(DIR)/%.js: %.ls
	lsc -o lac/static/$(dir $^) -c $<
#$(^:.ls=.js)
