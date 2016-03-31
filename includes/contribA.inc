\bibliographystyle{plain}

\newcommand\bibPrefix{J}
\newcommand\bibWidth{Cl}

\makeatletter
\renewcommand\@biblabel[1]{[\bibPrefix#1]\hfill}
\renewcommand\@bibitem[1]{%
\item\if@filesw \immediate\write\@auxout
{\string\bibcite{#1}{%
 \bibPrefix\the\value{\@listctr}}}%
 \fi\ignorespaces
}%
\makeatother

\renewcommand\refname{Publications in Journals}
\begin{thebibliography}{\bibWidth}
\setlength{\parskip}{-1mm}


