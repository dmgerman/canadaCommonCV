default: test

test: test_confs test_journals

test_confs: 
	perl ../scripts/processConf.pl sample_conf.txt > /tmp/1.txt
	diff -w  sample_conf-output.xml /tmp/1.txt

test_journals: 
	perl ../scripts/processJournal.pl sample_journals.txt > /tmp/1.txt
	diff -w  sample_journals-output.xml /tmp/1.txt


confs.bib: confs.txt txtToLatexConfs.pl
	perl ../scripts/txtToLatexConfs.pl confs.txt > confs.bib


journals.bib: journals.txt txtToLatexJournals.pl
	perl ../scripts/txtToLatexJournals.pl journals.txt > journals.bib

clean:
	rm -f journals.bib confs.bib

bibs:	confs.bib journals.bib
