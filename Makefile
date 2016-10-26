FORMS=$(basename $(wildcard *.cform)) $(basename $(wildcard *.cftemplate))

COMMONFORM=node_modules/.bin/commonform
CFTEMPLATE=node_modules/.bin/cftemplate

all: docx

docx: $(addprefix build/,$(FORMS:=.docx))

pdf: $(addprefix build/,$(FORMS:=.pdf))

html: $(addprefix build/,$(FORMS:=.html))

md: $(addprefix build/,$(FORMS:=.md))

build:
	mkdir -p build

build/%.pdf: build/%.docx | build
	unoconv -f pdf $<

build/%.docx: %.cform %.title %.options %.json | build $(COMMONFORM)
	$(COMMONFORM) render \
		--format docx \
		--blanks $*.json \
		--title "$(shell cat $*.title)" \
		$(shell cat $*.options) \
		< $*.cform \
		> $@

build/%.md: %.cform %.title %.options %.json | build $(COMMONFORM)
	$(COMMONFORM) render \
		--format markdown \
		--blanks $*.json \
		--title "$(shell cat $*.title)" \
		$(shell cat $*.options) \
		< $*.cform \
		> $@

build/%.html: %.cform %.title %.options %.json | build $(COMMONFORM)
	$(COMMONFORM) render \
		--format html5 \
		--blanks $*.json \
		--title "$(shell cat $*.title)" \
		$(shell cat $*.options) \
		< $*.cform \
		> $@

%.cform: %.cftemplate %.json | $(CFTEMPLATE)
	$(CFTEMPLATE) $*.cftemplate $*.json > $@

%.cform: %.cftemplate | $(CFTEMPLATE)
	$(CFTEMPLATE) $*.cftemplate > $@

%.options:
	echo '--number outline' > $@

$(CFTEMPLATE):
	npm install "cftemplate@^2.0.1"
	npm shrinkwrap

$(COMMONFORM):
	npm install "commonform-cli@0.11.x"
	npm shrinkwrap

.PHONY: clean critique lint

clean:
	rm -rf build

critique: $(COMMONFORM)
	$(COMMONFORM) critique < $(TARGET).cform | sort -u

lint: $(COMMONFORM)
	$(COMMONFORM) lint < $(TARGET).cform | sort -u
