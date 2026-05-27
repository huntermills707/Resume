%----------------------------------------------------------------------------------------
%	MODERN RESUME / CV CLASS
%
%	Originally by Hunter Mills (v1.0, 2017) - MIT License.
%	Single-column, text-only layout with a \skill{} row command and a
%	BibLaTeX publications section.
%
%	Compile with XeLaTeX (and biber, for the publications list).
%----------------------------------------------------------------------------------------

%----------------------------------------------------------------------------------------
%	CLASS OPTIONS AND REQUIRED PACKAGES
%----------------------------------------------------------------------------------------

\ProvidesClass{resume}[2026/05/23 Modern resume class]
\NeedsTeXFormat{LaTeX2e}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}

% Encoding / colours (XeLaTeX handles UTF-8 natively; fontenc kept for safety)
\RequirePackage[T1]{fontenc}
\RequirePackage[usenames,dvipsnames]{xcolor}

% Section titles
\RequirePackage{titlesec}

% TikZ (used to position the header banner)
\RequirePackage{tikz}
\RequirePackage[none]{hyphenat}
\RequirePackage{fontawesome5}
\RequirePackage{multicol}

% Math / programming helpers
\RequirePackage{ifthen}
\RequirePackage{pgffor}
\RequirePackage{calc}
\newlength{\mylength}
\newlength{\@colw}
\newlength{\@headerLeftW}
\newlength{\@headerRightW}

\setlength{\parindent}{0pt}

%========================================================================
%	FONT CONFIGURATION  (compile with XeLaTeX)
%
%	Uses EB Garamond (body) and Inter (headings). Both ship with Overleaf,
%	so the template compiles out of the box -- just set the compiler to
%	"XeLaTeX". To swap in different fonts, change the \newfontfamily lines
%	below.
%========================================================================
\RequirePackage{unicode-math}

\definecolor{darkgray}{HTML}{000000}
\definecolor{gray}{HTML}{000000}
\definecolor{lightgray}{HTML}{000000}

\newfontfamily\bodyfont{EB Garamond}
\newfontfamily\thinfont{Inter Thin}
\newfontfamily\headingfont{Inter Regular}
\newcommand{\emphfont}{\bodyfont\itshape}
\newcommand{\mainfont}{\bodyfont}
\defaultfontfeatures{Mapping=tex-text}
\setmainfont[Mapping=tex-text, Color=gray]{EB Garamond}


%----------------------------------------------------------------------------------------
%	Header building blocks
%
% Compose the header inline in the .tex file from these primitives:
%
%   \begin{headerRow}{0.4}      % left column = 0.4 * textwidth
%       \nameBlock
%   \nextCol
%       \contactBlock           % or \summaryBlock -- your choice
%   \end{headerRow}
%   \par\noindent\rule{\textwidth}{.4pt}\par
%   \summaryBlock               % or \contactBlock -- whichever wasn't above
%
% Both columns are bottom-aligned via \minipage[b]: the BASELINE of each
% column's last line sits on the row's baseline. With \nameBlock's
% descender strut stripped, that baseline is also the visible bottom of
% the letters; for \contactBlock / \summaryBlock with non-descender
% content in their last line, the same holds. The visible bottoms of
% the two columns therefore line up.
%
% Field declarations:
%   \firstname / \lastname  -- name shown by \nameBlock
%   \info                   -- entries shown by \contactBlock. Format:
%                              \icon/text , comma-separated. Brace values
%                              containing commas, e.g. \location/{City, ST}.
%   \infocols               -- column count for \contactBlock (default 2)
%   \summary                -- text shown by \summaryBlock
%   \nameFontSize           -- font size for \nameBlock (default 48pt)
%----------------------------------------------------------------------------------------

\newcommand*{\firstname}[1]{\def\@firstname{#1}}
\newcommand*{\lastname}[1]{\def\@lastname{#1}}
\newcommand*{\summary}[1]{\def\@summary{#1}}
\newcommand*{\info}[1]{\def\@info{#1}}
\newcommand*{\infocols}[1]{\def\@infocols{#1}}
\newcommand*{\contactJustify}[1]{\def\@contactJustify{#1}}
\newcommand*{\nameFontSize}[1]{\def\@nameFontSize{#1}}

% Sensible defaults so blocks still render if a field is omitted. \def\@info{}
\def\@infocols{2}
\def\@contactJustify{r}
\def\@summary{}
\def\@nameFontSize{48pt}

% Strip the font's descender strut so the box's depth is 0 -- i.e. its
% bottom edge sits on the baseline. Combined with \minipage[b] in
% headerRow, this makes the visible bottom of "Firstname Lastname" land
% on the row's baseline (instead of 12pt below it, where the 48pt strut
% would otherwise reserve space for descenders the name doesn't use).
\newcommand{\nameBlock}{%
	\raisebox{0pt}[\height][0pt]{%
		\fontsize{\@nameFontSize}{0pt}\selectfont\color{darkgray}%
		{\thinfont \@firstname }{\headingfont \@lastname}%
	}%
}

\newcommand{\contactBlock}{%
	\setlength{\@colw}{\dimexpr\linewidth/\@infocols\relax}%
	{\fontsize{10pt}{16pt}\headingfont
	\foreach \x/\y [count=\@ic] in \@info{%
		\ifnum\@ic>1\relax
			\pgfmathtruncatemacro{\@imod}{mod(\@ic-1,\@infocols)}%
			\ifnum\@imod=0\relax\\\fi
		\fi
		\makebox[\@colw][\@contactJustify]{%
			{\color{darkgray}\raisebox{-.15em}[0pt][0pt]{\fontsize{13pt}{12pt}\selectfont\x}}%
			\hspace{.25em}{\color{gray}\y}}%
  }\par\vspace{-16pt}}%
}

\newcommand{\summaryBlock}{%
	{\bodyfont\color{gray}\@summary\par}%
  \vspace{.25em}
}

% Two-column header row. Argument: the LEFT column's MINIMUM fraction
% of \textwidth -- if the name's natural width exceeds it, the left
% column auto-expands so the name never overflows (the right column
% shrinks to compensate). The RIGHT column always fills the remaining
% space, less a 1em gap. Both columns are \minipage[b] so the baseline
% of each column's last line sits on the row's baseline -- i.e. the
% visible bottoms line up.
\newenvironment{headerRow}[1]{%
	\setlength{\@headerLeftW}{#1\textwidth}%
	\settowidth{\mylength}{%
		\fontsize{\@nameFontSize}{\@nameFontSize}\selectfont
		{\thinfont \@firstname }{\headingfont \@lastname}%
	}%
	\ifdim\mylength>\@headerLeftW
		\setlength{\@headerLeftW}{\mylength}%
	\fi
	\setlength{\@headerRightW}{\dimexpr\textwidth-\@headerLeftW-1em\relax}%
	\par\noindent
	\begin{minipage}[b]{\@headerLeftW}\ignorespaces
}{%
	\end{minipage}%
  \vspace{-.75em}
}

\newcommand{\nextCol}{%
	\end{minipage}%
	\hfill
	\begin{minipage}[b]{\@headerRightW}\ignorespaces
}

% Contact-bar icons (FontAwesome)
\newcommand{\phone}{\faPhone*}
\newcommand{\email}{\faEnvelope}
\newcommand{\location}{\faMapMarker*}
\newcommand{\facebook}{\faFacebook}
\newcommand{\linkedin}{\faLinkedin}
\newcommand{\github}{\faGithub}
\newcommand{\googleplus}{\faGooglePlus}
\newcommand{\website}{\faIcon{external-link-alt}}
\newcommand{\dropbox}{\faDropbox}
\newcommand{\skype}{\faSkype}
\newcommand{\bitbucket}{\faBitbucket}
\newcommand{\orcid}{\faOrcid}

%----------------------------------------------------------------------------------------
%	Section titles
%----------------------------------------------------------------------------------------
\titlespacing{\section}{0pt}{0pt}{0pt}
\titleformat{\section}{
    \vspace{2pt}
	\fontsize{16pt}{2pt}\headingfont \raggedright\color{darkgray}}{}{0pt}{}[
        \color{darkgray}\underline{\hspace{\textwidth}}
    ]

%----------------------------------------------------------------------------------------
%	Row macros (structural names, used across sections)
%
% \rowFourTwo{a}{b}{c}{d} : 4 items on 2 lines, each line right-justifies its
%                           second item to the margin. (a hfill b / c hfill d)
% \rowThreeTwo{a}{b}{c}   : 3 items on 2 lines: "a hfill b" then c alone.
% \rowThreeOne{a}{b}{c}   : 3 items on 1 line: "a - b" left, c right.
% \rowTwoOne{a}{b}        : 2 items on 1 line: a left, b right.
% \rowOneOne{a}           : 2 item on 1 line
% \subline{...}           : one left-aligned line, indented to match the rows.
% \entryList{n}           : bullet list (n columns) for the details under a row.
%----------------------------------------------------------------------------------------
\setlength{\tabcolsep}{0pt}

\newcommand{\rowFourTwo}[4]{
	\setlength{\mylength}{\textwidth-0.45cm}

	\def\@tableWidth{\textwidth}
	\def\@rightColWidth{\mylength}

	\color{darkgray}
	\noindent\begin{tabular*}{\@tableWidth}{@{\extracolsep{\fill}}ll}
		\parbox[t]{.45cm}{\faSquare} & \parbox[t]{\@rightColWidth}{%
			\headingfont{#1}
			\hfill
			\bodyfont{#2}\\
			\headingfont{#3}
			\hfill
			\bodyfont{#4}}
	\end{tabular*}
	\renewcommand{\bfseries}{\mainfont\color{gray}}
}

\newcommand{\rowThreeTwo}[3]{
	\setlength{\mylength}{\textwidth-0.45cm}

	\def\@tableWidth{\textwidth}
	\def\@rightColWidth{\mylength}

	\color{darkgray}
	\noindent\begin{tabular*}{\@tableWidth}{@{\extracolsep{\fill}}ll}
		\parbox[t]{.45cm}{\faSquare} & \parbox[t]{\@rightColWidth}{%
			\headingfont{#1}
			\hfill
			\bodyfont{#2}\\
			\bodyfont{#3}}
	\end{tabular*}
	\renewcommand{\bfseries}{\mainfont\color{gray}}
}

\newcommand{\rowOneOne}[1]{
	\setlength{\mylength}{\textwidth-0.45cm}

	\def\@tableWidth{\textwidth}
	\def\@rightColWidth{\mylength}

	\color{darkgray}
	\noindent\begin{tabular*}{\@tableWidth}{@{\extracolsep{\fill}}ll}
		\parbox[t]{.45cm}{\faSquare} & \parbox[t]{\@rightColWidth}{
      \headingfont{#1}} 
	\end{tabular*}
	\renewcommand{\bfseries}{\mainfont\color{gray}}
	\vspace{-.7em}
}

\newcommand{\rowTwoOne}[2]{
	\setlength{\mylength}{\textwidth-0.45cm}

	\def\@tableWidth{\textwidth}
	\def\@rightColWidth{\mylength}

	\color{darkgray}
	\noindent\begin{tabular*}{\@tableWidth}{@{\extracolsep{\fill}}ll}
		\parbox[t]{.45cm}{\faSquare} & \parbox[t]{\@rightColWidth}{
			\headingfont{#1}
			\hfill
			\bodyfont{#2}}
	\end{tabular*}
	\renewcommand{\bfseries}{\mainfont\color{gray}}
	\vspace{-.7em}
}

\newcommand{\rowThreeOne}[3]{
  \vspace{-.25em}
	\setlength{\mylength}{\textwidth-0.45cm}

	\def\@tableWidth{\textwidth}
	\def\@rightColWidth{\mylength}

	\color{darkgray}
	\noindent\begin{tabular*}{\@tableWidth}{@{\extracolsep{\fill}}ll}
		\parbox[t]{.45cm}{\faSquare} & \parbox[t]{\@rightColWidth}{
			\headingfont{#1} \bodyfont{- #2}
			\hfill
			\bodyfont{#3}}
	\end{tabular*}
	\renewcommand{\bfseries}{\mainfont\color{gray}}
	\vspace{-.7em}
}

\newenvironment{entryList}[1]{
  \color{gray}
	\vspace{-1.5em}
	\emergencystretch=3em\relax
	\ifnum#1>1
	\def\@onecol{1}
	\fi
	\ifdefined\@onecol
		\begin{multicols}{#1}
	\else
		\vspace{.25em}
	\fi
	\begin{itemize}
		\renewcommand\labelitemi{\faIcon[regular]{square}}
		\setlength\itemsep{-.25em}
	}{
	\end{itemize}
	\ifdefined\@onecol
		\end{multicols}
	\fi
	\vspace{-.5em}
}

\newcommand{\subline}[1] {
	\vspace{-.5em}
  \color{gray}
	\noindent\begin{tabular*}{\@tableWidth}{@{\extracolsep{\fill}}ll}
    \parbox[t]{\mylength}{} & \parbox[t]{\@rightColWidth}{
			{#1}
    }
	\end{tabular*}
}

%----------------------------------------------------------------------------------------
%	Labeled rows  (fixed-width left column, no inter-column hfill)
%
% \rowTwoFlat{labelw}{label}{content}
%     Two-item row with the label in a fixed-width left column and the content
%     flowing in the right column. No hfill -- the right column starts wherever
%     the label column ends. Example:
%         \rowTwoFlat{14em}{Languages}{Python, SQL, C++}
%
% \rowLabeledHfill{labelw}{label}{left}{right}
%     Like \rowTwoFlat, but the right column itself splits its two items with
%     an hfill (useful for institution + date pairs). Example:
%         \rowLabeledHfill{14em}{Stanford University}{MS CME}{2018}
%----------------------------------------------------------------------------------------

\newcommand{\rowTwoFlat}[3]{
	\setlength{\mylength}{\textwidth-0.45cm-#1-1em}

	\def\@tableWidth{\textwidth}
	\def\@rightColWidth{\mylength}

	\color{darkgray}
	\noindent\begin{tabular}{p{#1} p{1em} p{\@rightColWidth}}
    \parbox[t]{.45cm}{\faSquare} \headingfont #2 & & #3
	\end{tabular}
	\renewcommand{\bfseries}{\mainfont\color{gray}}
	\vspace{.15em}
}


\newcommand{\rowLabeledHfill}[4]{
	\setlength{\mylength}{\textwidth-#1-1em}

	\def\@tableWidth{\textwidth}
	\def\@rightColWidth{\mylength}

	\color{darkgray}
	\noindent\begin{tabular}{p{#1} p{1em} p{\@rightColWidth}}
		\parbox[t]{.45cm}{\faSquare} \headingfont #2 & & \parbox[t]{\@rightColWidth}{#3 \hfill #4}
	\end{tabular}
	\renewcommand{\bfseries}{\mainfont\color{gray}}
    \vspace{-1.1em}
}

%----------------------------------------------------------------------------------------
%	PUBLICATIONS SETUP  (BibLaTeX + biber)
%	Your references live in publications.bib. To emphasise your own name,
%	annotate your author position there, e.g.  author+an = {1=highlight}.
%	The two redefinitions below render any "highlight"-annotated name in bold.
%----------------------------------------------------------------------------------------

\RequirePackage[backend=biber, style=numeric, sorting=ydnt,
                maxbibnames=99, giveninits=true,
                doi=false, isbn=false, url=false]{biblatex}

\setlength{\bibitemsep}{.25em}   % space between publications; use 0pt for tightest
\setlength{\bibparsep}{0pt}      % space between paragraphs within an entry
\defbibenvironment{bibliography}
  {\list{\parbox[t]{.45cm}{\faSquare}}
     {\setlength{\leftmargin}{.45cm}%
      \setlength{\labelwidth}{.45cm}%
      \setlength{\labelsep}{0pt}%
      \setlength{\itemindent}{0em}%
      \setlength{\itemsep}{\bibitemsep}%
      \setlength{\parsep}{\bibparsep}}%
      \color{gray}
   \emergencystretch=2em\relax}
  {\endlist}
  {\item}

% Bold (and darken) the author's own name. We use \fontseries here rather than
% \textbf because the entry macros locally repurpose \bfseries.
\newcommand*{\cvnamehighlight}[1]{{\fontseries{b}\selectfont\color{darkgray}#1}}
\renewcommand*{\mkbibnamegiven}[1]{\ifitemannotation{highlight}{\cvnamehighlight{#1}}{#1}}
\renewcommand*{\mkbibnamefamily}[1]{\ifitemannotation{highlight}{\cvnamehighlight{#1}}{#1}}

%----------------------------------------------------------------------------------------
%	Hyperlink Setup
%----------------------------------------------------------------------------------------
\RequirePackage[hidelinks]{hyperref}
\hypersetup{colorlinks=false}
