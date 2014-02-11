all: simplesnap.8 simplesnap.html

simplesnap.8: simplesnap.sgml
	docbook2man simplesnap.sgml
	docbook2man simplesnap.sgml
	docbook2man simplesnap.sgml

simplesnap.html: simplesnap.sgml
	docbook2html -u simplesnap.sgml

clean:
	rm -f simplesnap.html simplesnap.8

