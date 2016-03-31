INCS=../scripts/common.pm

default: test



test: test_confs test_journals

test_confs: confs
	diff -w  sample_conf-output.xml output/confs.xml

test_journals: journals
	diff -w  sample_journals-output.xml output/journals.xml

journals: output/journals.xml

confs: output/confs.xml

output/confs.xml: ../scripts/processConf.pl $(INCS)
	perl ../scripts/processConf.pl sample_conf.txt > output/confs.xml

output/journals.xml: ../scripts/processJournals.pl $(INCS)
	perl ../scripts/processJournals.pl sample_journals.txt > output/journals.xml

confs.bib: confs.txt txtToLatexConfs.pl $(INCS)
	perl ../scripts/txtToLatexConfs.pl confs.txt > confs.bib

journals.bib: journals.txt txtToLatexJournals.pl
	perl ../scripts/txtToLatexJournals.pl journals.txt > journals.bib

clean:
	rm -f journals.bib confs.bib

bibs:	confs.bib journals.bib
