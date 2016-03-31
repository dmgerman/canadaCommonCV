default: confsListBib.pdf journalsListBib.pdf contributionsInclude.tex

CCV=ccv-nserc

ccvReferences.txt: ../scripts/extractIndexes.rb $(CCV).txt
	ruby $< $(CCV).txt > ccvReferences.txt

$(CCV).txt: $(CCV).pdf
	pdftotext $(CCV).pdf

confsInclude.tex: ../scripts/createLatexDoc.pl ccvReferences.txt ../generate/confs.txt
	perl $< C ccvReferences.txt ../generate/confs.txt > tmp.tmp && mv tmp.tmp confsInclude.tex

journalsInclude.tex: ../scripts/createLatexDoc.pl ccvReferences.txt ../generate/journals.txt
	perl $< J ccvReferences.txt ../generate/journals.txt > tmp.tmp && mv tmp.tmp journalsInclude.tex

confsListBib.bbl: confsInclude.tex ../generate/confs.bib confsListBib.tex
	pdflatex confsListBib.tex
	bibtex confsListBib
	pdflatex confsListBib.tex

confsListBib.pdf: confsListBib.bbl confsListBib.tex 
	pdflatex confsListBib.tex

journalsListBib.bbl: journalsInclude.tex ../generate/journals.bib journalsListBib.tex 
	pdflatex journalsListBib.tex
	bibtex journalsListBib
	pdflatex journalsListBib.tex

journalsListBib.pdf: journalsListBib.bbl journalsListBib.tex 
	pdflatex journalsListBib.tex

contributionsInclude.tex: ../includes/contribA.inc ../includes/contribB.inc ../includes/contribC.inc  journalsListBib.bbl confsListBib.bbl
	tail --lines=+2 confsListBib.bbl > tmp.tmp && mv tmp.tmp tmp1.tmp
	tail --lines=+2 journalsListBib.bbl > tmp.tmp && mv tmp.tmp tmp2.tmp
	cat ../includes/contribA.inc tmp1.tmp contribB.inc tmp2.tmp ../includes/contribC.inc > contributionsInclude.tex
	rm -f tmp1.tmp tmp2.tmp

dummy: ccvReferences.txt confsInclude.tex confsListBib.pdf journalsListBib.pdf confsListBib.bbl journalsListBib.bbl contributionsInclude.tex

clean:
	rm -f ccvReferences.txt confsInclude.tex confsListBib.pdf journalsListBib.pdf confsListBib.bbl journalsListBib.bbl contributionsInclude.tex tmp1.tmp tmp2.tmp tmp.tmp
