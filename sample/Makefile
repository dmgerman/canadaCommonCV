INCS=../scripts/common.pm

default: test

test: test_confs test_journals

test_confs: confs
	diff -w  sample_confs-output.xml output/confs.xml
	diff -w  sample_confs-output.bib output/confs.bib

test_journals: journals
	diff -w  sample_journals-output.xml output/journals.xml
	diff -w  sample_journals-output.bib output/journals.bib

journals: output/journals.xml output/journals.bib

confs: output/confs.xml output/confs.bib

output/confs.xml: ../scripts/processConfs.pl $(INCS) sample_confs.txt
	perl $< sample_confs.txt > tmp.tmp && mv tmp.tmp  $@

output/journals.xml: ../scripts/processJournals.pl $(INCS) sample_journals.txt
	perl $< sample_journals.txt > tmp.tmp && mv tmp.tmp  $@

output/confs.bib: ../scripts/txtToLatexConfs.pl $(INCS)  sample_confs.txt
	perl $< sample_confs.txt > tmp.tmp && mv tmp.tmp  $@

output/journals.bib:  ../scripts/txtToLatexJournals.pl $(INCS) sample_journals.txt
	perl $< sample_journals.txt > tmp.tmp && mv tmp.tmp  $@

clean:
	rm -f journals.bib confs.bib

bibs:	confs.bib journals.bib
