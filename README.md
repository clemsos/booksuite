# Booksuite

Booksuite is a toolkit for collaborative writing, editing and publishing.

Based on work for costoffreedom and waitingbassel

Fork this rep to get started

## What you can do with it

* write in Markdown
* read the book as a website (using Gitbook) : ```gitbook serve```
* publish an epub (using Gitbook): ```make epub```
* create a printable PDF book (using Pandoc+Latex) ```make pdf-release```
* book versioning and preview : ```make pdf-draft```

### Generate a PDF


All styling of the PDF happens in the ```assets/CustomBook.cls``` file .



### Dependencies

* Gitbook
* Latexmk
* Bash / Make
* Pandoc
