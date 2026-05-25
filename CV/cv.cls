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

\ProvidesClass{cv}[2026/05/23 Modern CV class]
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
\RequirePackage{fontawesome}
\RequirePackage{multicol}

% Math / programming helpers
\RequirePackage{ifthen}
\RequirePackage{pgffor}
\RequirePackage{calc}
\newlength{\mylength}
\newlength{\@colw}

%========================================================================
%	FONT CONFIGURATION  (compile with XeLaTeX)
%
%	Uses EB Garamond (body) and Inter (headings). Both ship with Overleaf,
%	so the template compiles out of the box -- just set the compiler to
%	"XeLaTeX". To swap in different fonts, change the \newfontfamily lines
%	below.
%========================================================================
\RequirePackage{unicode-math}

\newfontfamily\bodyfont{EB Garamond}
\newfontfamily\thinfont{Inter Thin}
\newfontfamily\headingfont{Inter Regular}
\newcommand{\emphfont}{\bodyfont\itshape}
\newcommand{\mainfont}{\bodyfont}
\defaultfontfeatures{Mapping=tex-text}
\setmainfont[Mapping=tex-text, Color=000000]{EB Garamond}

\definecolor{darkgray}{HTML}{000000}
\definecolor{gray}{HTML}{000000}
\definecolor{lightgray}{HTML}{000000}


%----------------------------------------------------------------------------------------
%	Header
%
% firstname / lastname : name shown on the left of the header
% info                 : contact entries shown as a grid on the right of the name.
%                        Format: \icon/text , separated by commas. A value that
%                        contains a comma must be braced, e.g. \location/{City, ST}.
% infocols             : number of columns for the contact grid (default 2). The
%                        grid uses as many rows as needed to fit all entries.
% summary              : short blurb shown in the lined bar below the header
% headerspace          : spacing from the top of the page
% makeHeader           : draws the whole header (name + info grid + summary bar)
%----------------------------------------------------------------------------------------

\newcommand*{\firstname}[1]{\def\@firstname{#1}}
\newcommand*{\lastname}[1]{\def\@lastname{#1}}
\newcommand*{\summary}[1]{\def\@summary{#1}}
\newcommand*{\info}[1]{\def\@info{#1}}
\newcommand*{\infocols}[1]{\def\@infocols{#1}}
\newcommand*{\headerspace}[1]{\def\@headerspace{#1}}

% sensible defaults (so the header still works if a field is omitted)
\def\@info{}
\def\@infocols{2}
\def\@summary{}

\newcommand{\makeHeader}[0]{
	\begin{tikzpicture}[remember picture,overlay]
		\node [rectangle, anchor=north, minimum width=\textwidth, minimum height=\@headerspace] (top) at (current page.north){};
		\node [rectangle, anchor=north, minimum width=\textwidth, minimum height=2.5cm] (box) at (top.south){};
		\node [rectangle, anchor=center, minimum width=.5\textwidth, minimum height=2.75cm] (textAlign) at (box.center){};

		% Name (left)
		\node [rectangle, anchor=west] (name) at (box.west) {%
            \raisebox{1em}{
			\fontsize{48pt}{48pt}\color{darkgray}%
			{\thinfont \@firstname }{\headingfont \@lastname}}
		};

		% Contact info grid (right) -- \@infocols columns, as many rows as needed
		\node [rectangle, anchor=east] (info) at (box.east) {%
			\setlength{\@colw}{\dimexpr.53\textwidth/\@infocols\relax}%
			\begin{minipage}{.55\textwidth}
				\raggedleft\fontsize{10pt}{16pt}\headingfont
				\foreach \x/\y [count=\@ic] in \@info{%
					\ifnum\@ic>1\relax
						\pgfmathtruncatemacro{\@imod}{mod(\@ic-1,\@infocols)}%
						\ifnum\@imod=0\relax\\\fi
					\fi
					\makebox[\@colw][r]{%
						{\color{darkgray}\raisebox{-.25em}{\fontsize{15pt}{12pt}\selectfont\x}}%
						\hspace{.45em}{\color{lightgray}\y}}%
				}%
			\end{minipage}
		};
	\end{tikzpicture}
	% Drop below the header box, then the summary bar in normal flow so the
	% body always sits beneath it (no overlap, whatever the summary length).
	\vspace*{\dimexpr\@headerspace-.5em\relax}
	\par\noindent{\color{darkgray}\rule{\textwidth}{.4pt}}
	{\fontsize{11pt}{11pt}\bodyfont\color{lightgray}\@summary\par}
	\vspace{.25em}
}

% Contact-bar icons (FontAwesome)
\newcommand{\phone}{\faPhone}
\newcommand{\email}{\faEnvelope}
\newcommand{\location}{\faMapMarker}
\newcommand{\facebook}{\faFacebook}
\newcommand{\linkedin}{\faLinkedin}
\newcommand{\github}{\faGithub}
\newcommand{\googleplus}{\faGooglePlus}
\newcommand{\website}{\faExternalLink}
\newcommand{\dropbox}{\faDropbox}
\newcommand{\skype}{\faSkype}
\newcommand{\bitbucket}{\faBitbucket}

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
%	List environment
%
% entryItem    : 4 arguments (title, dates, sub-title, location) laid out in two
%                rows, the right-hand item flush to the margin.
% entryItemTwo : same idea, but only 2 arguments (title + dates).
% subline      : one left-aligned line, indented to match the entry items.
% entryList    : bullet list for the details under an entry (\item per bullet);
%                the argument is the number of columns.
%----------------------------------------------------------------------------------------
\setlength{\tabcolsep}{0pt}
\newcommand{\entryItem}[4]{
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

\newcommand{\entryItemTwo}[2]{
    \vspace{-.25em}
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

\newcommand{\entryItemThree}[3]{
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
		\renewcommand\labelitemi{\faSquareO}
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
	\noindent\begin{tabular*}{\@tableWidth}{@{\extracolsep{\fill}}ll}
		\parbox[t]{\mylength}{} & \parbox[t]{\@rightColWidth}{
			{#1}
			}
	\end{tabular*}
}

%----------------------------------------------------------------------------------------
%	Skill / info row  (text, no charts)
%
% \skill{Label}{comma, separated, items}
%    Prints a left-aligned label with the items beside it, e.g.
%    \skill{Programming}{Python, SQL, C++}
%----------------------------------------------------------------------------------------

\newcommand{\skill}[2]{
	\setlength{\mylength}{\textwidth-0.45cm}

	\def\@tableWidth{\textwidth}
	\def\@rightColWidth{\mylength - 15em}

	\color{darkgray}
	\noindent\begin{tabular}{p{14em} p{1em} p{\@rightColWidth}}
		\parbox[t]{.45cm}{\faSquare} \headingfont #1 & & #2
	\end{tabular}
	\renewcommand{\bfseries}{\mainfont\color{gray}}
	\vspace{.15em}
}


\newcommand{\issuer}[1]{
	\setlength{\mylength}{\textwidth-0.45cm}

	\def\@tableWidth{\textwidth}
	\def\@rightColWidth{\mylength - 15em}

	\color{darkgray}
  \noindent\parbox[t]{.45cm}{\faSquare} \headingfont{#1}
  \bodyfont
	\renewcommand{\bfseries}{\mainfont\color{gray}}
	\vspace{.25em}
}

\newcommand{\education}[3]{
	\def\@tableWidth{\textwidth}
	\def\@rightColWidth{\textwidth - 15em}

	\color{darkgray}
	\noindent\begin{tabular}{p{14em} p{1em} p{\@rightColWidth}}
		\parbox[t]{.45cm}{\faSquare} \headingfont #1 & & \parbox[t]{\@rightColWidth}{#2 \hfill #3}
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
\addbibresource{publications.bib}

\setlength{\bibitemsep}{0.25em}   % space between publications; use 0pt for tightest
\setlength{\bibparsep}{0pt}      % space between paragraphs within an entry
\defbibenvironment{bibliography}
  {\list{\parbox[t]{.45cm}{\faSquare}}
     {\setlength{\leftmargin}{\bibhang}%
      \setlength{\itemindent}{0em}%
      \setlength{\itemsep}{\bibitemsep}%
      \setlength{\parsep}{\bibparsep}}%
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
\definecolor{highlight}{RGB}{0,0,0}
\RequirePackage{hyperref}
\hypersetup{colorlinks=true,urlcolor=highlight}
