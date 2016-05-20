# Booksuite

Booksuite is a toolkit for collaborative writing, editing and publishing.

Based on work done for [Cost of Freedom](https://github.com/costoffreedom/costoffreedom-book) and [Waiting 4 Bassel](https://github.com/waiting4bassel/waiting-latex)

Fork this rep to get started

## What you can do with it

* write in Markdown
* read the book as a website (using Gitbook) : ```gitbook serve```
* publish an epub (using Gitbook): ```make epub```
* create a printable PDF book (using Pandoc+Latex) ```make pdf-release```
* book versioning and preview : ```make pdf-draft```

### Generate a PDF


All styling of the PDF happens in ```assets/CustomBook.cls```.



### Dependencies

* Gitbook
* Latexmk
* Bash / Make
* Pandoc

### License

Booksuite is dedicated to the public domain with
[CC0-1.0](https://creativecommons.org/publicdomain/zero/1.0). If
you want a different license for your book, change this notice and
the accompanying `LICENSE.md` file.
