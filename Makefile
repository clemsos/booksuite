# Build the book

BOOK_NAME = MyGreatBook
TEX_PATH = ./latex
MD_FILES = $(shell find . -name "*.md" -not -path "./_book/*"  ! -name "README.md" ! -name "SUMMARY.md")
TEX_FILES = $(patsubst ./%.md, ./latex/%.tex, $(MD_FILES))

TAGS=`cat TAGS.txt`
AUTHOR=`cat AUTHOR.txt`
PUBLISHER=`cat PUBLISHER.txt`

# Version Track
VERSION_FILE=VERSION.txt
VERSION=`cat $(VERSION_FILE)`
ISBN_FILE=ISBN.txt
ISBN=`cat $(ISBN_FILE)`
EDITION_FILE=EDITION.txt
EDITION=`cat $(EDITION_FILE)`
YEAR_FILE=YEAR.txt
YEAR=`cat $(YEAR_FILE)`

# create release directory
# copy latex book template
# copy latex custom book class
# delete existing includes
# create main .tex file following SUMMARY.md order
.PHONY: all
all: $(TEX_FILES)
	mkdir -p release
	cp assets/book.tex $(TEX_PATH)/$(BOOK_NAME).tex
	cp assets/CustomBook.cls $(TEX_PATH)/CustomBook.cls
	rm -f $(TEX_PATH)/includes.tex
	pandoc  SUMMARY.md -t html | \
		grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' | \
		sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$$//' | \
		cut -f 1 -d '.' | \
		awk '{printf("\\\include{%s}\n",$$1)}' \
		>> $(TEX_PATH)/includes.tex
	sed -i -ne '/% BEGIN INCLUDES/ {p; r $(TEX_PATH)/includes.tex' -e ':a; n; /% END INCLUDES/ {p; b}; ba}; p' $(TEX_PATH)/$(BOOK_NAME).tex


# make latex output path
latex/%.tex: ./%.md
	@mkdir -p "$(@D)"
	@pandoc "$<" -f markdown+hard_line_breaks -t latex -o "$@" --latex-engine=xelatex
	@if [ "$(findstring copyright, $(@F))" = "copyright" ]; then \
		perl -i -p -e "s/\\\{\\\{ book\.edition \\\}\\\}/$(EDITION)/" "$@"; \
		perl -i -p -e "s/\\\{\\\{ book\.year \\\}\\\}/$(YEAR)/" "$@"; \
		perl -i -p -e "s/(^Version) (.*book.version.*})(.*)/\\\textenglish{\1 $(VERSION)}\3/" "$@"; \
		perl -i -p -e "s/(^ISBN) (.*book.isbn.*})(.*)/\\\textenglish{\1 $(ISBN)}\3/" "$@"; \
	fi

clean:
	@rm -Rf $(TEX_FILES)
	@rm -Rf $(TEX_PATH)
	@rm -Rf release

# Remove all outputs then build them again
rebuild : clean all

# Build ebook with gitbook, then add metadata for Lulu
ebook:
	gitbook epub . .release/datfic.epub
	ebook-meta -a"$(AUTHOR)" --date="$(YEAR)" -p"$(PUBLISHER)" --tags="$(TAGS)" costoffreedom.epub

# Draft build
pdf-draft : all
	@cd $(TEX_PATH) && latexmk -xelatex -gg -pdf -pvc- $(BOOK_NAME).tex && cp $(BOOK_NAME).pdf "../release/$(BOOK_NAME)-Draft-`cat ../$(VERSION_FILE)`.pdf"

# Release build
pdf-release : all
	@cd $(TEX_PATH) && latexmk -xelatex -gg -pdf -pvc- Final.tex && mv Final.pdf "../release/$(BOOK_NAME)-`cat ../$(VERSION_FILE)`.pdf"
