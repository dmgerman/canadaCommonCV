INCS=../scripts/common.pm

default: confs journals

journals: journals.xml journals.bib

confs: confs.xml confs.bib

confs.xml: ../scripts/processConfs.pl $(INCS) confs.txt
	perl $< confs.txt > tmp.tmp && mv tmp.tmp  $@

journals.xml: ../scripts/processJournals.pl $(INCS) journals.txt
	perl $< journals.txt > tmp.tmp && mv tmp.tmp  $@

confs.bib: ../scripts/txtToLatexConfs.pl $(INCS)  confs.txt
	perl $< confs.txt > tmp.tmp && mv tmp.tmp  $@

journals.bib:  ../scripts/txtToLatexJournals.pl $(INCS) journals.txt
	perl $< journals.txt > tmp.tmp && mv tmp.tmp  $@

clean:
	rm -f journals.bib confs.bib journals.xml confs.xml

bibs:	confs.bib journals.bib

xmls:   confs.xml journals.xml
