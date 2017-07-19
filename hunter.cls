%----------------------------------------------------------------------------------------
%	CLASS OPTIONS AND REQUIRED PACKAGES
%----------------------------------------------------------------------------------------

\ProvidesClass{hunter}[2014/04/30 CV class]
\NeedsTeXFormat{LaTeX2e}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}


% Radar Charts
\RequirePackage[]{inputenc} 
\RequirePackage[T1]{fontenc}
\RequirePackage[upright]{fourier} 
\RequirePackage[usenames,dvipsnames]{xcolor}
\RequirePackage{tkz-kiviat,numprint,fullpage} 
\usetikzlibrary{arrows}

% Custom Sections
\RequirePackage{titlesec}

% Header and circle charts
\RequirePackage{tikz}
\RequirePackage[none]{hyphenat}
\RequirePackage{fontawesome}
\RequirePackage{multicol}
\RequirePackage{float}

% Math Stuff
\RequirePackage{ifthen}
\RequirePackage{pgffor}
\RequirePackage{calc}
\newlength{\mylength}

% Font Settings
\RequirePackage{unicode-math}
\newfontfamily\bodyfont[]{Portland LDO}
\newfontfamily\thinfont[]{Vegur Light}
\newfontfamily\headingfont[]{Vegur}
\newfontfamily\emphfont[]{Portland LDO Italic}
\defaultfontfeatures{Mapping=tex-text}
\setmainfont[Mapping=tex-text, Color=gray]{Portland LDO}
\definecolor{darkgray}{HTML}{333333}
\definecolor{lightgray}{HTML}{999999}


%----------------------------------------------------------------------------------------
%	Header
%
% firstname: First name for header
% lastname: Last name for header
% summary: Brief summary for header right of name
% headersplit: spaceing between name and summary
% headerspace: spacing from top of page
% makeHeader: makes the header
%
% infoSection: 2 inputs. Bar for contact info
%    1: icon followed by "/" and the information separated by commas
%    2: spacing between items
%----------------------------------------------------------------------------------------

\newcommand*{\firstname}[1]{\def\@firstname{#1}}
\newcommand*{\lastname}[1]{\def\@lastname{#1}}
\newcommand*{\summary}[1]{\def\@summary{#1}}
\newcommand*{\info}[1]{\def\@info{#1}}
\newcommand*{\headersplit}[1]{\def\@headersplit{#1}}
\newcommand*{\headerspace}[1]{\def\@headerspace{#1}}

\newcommand{\makeHeader}[0]{
	\begin{tikzpicture}[remember picture,overlay]
		\node [rectangle, anchor=north, minimum width=\textwidth, minimum height=\@headerspace] (top) at (current page.north){};		    
		\node [rectangle, anchor=north, minimum width=\textwidth, minimum height=2.5cm] (box) at (top.south){};			
		\node [rectangle, anchor=center, minimum width=.5\textwidth, minimum height=2.75cm] (textAlign) at (box.center){};			
		\node [rectangle, anchor=west] (name) at (box.west) {%
			\fontsize{40pt}{72pt}\color{darkgray}%
			{\thinfont \@firstname }{\headingfont \@lastname}
		};
			
		\node [rectangle, text width=\@headersplit, anchor=east] at (box.east) {%
			\fontsize{12pt}{4pt}\color{lightgray}
			\begin{minipage}{\@headersplit}
			    \vspace{.5em}
			    \headingfont \raggedleft \@summary
			\end{minipage}
		};

	\end{tikzpicture}
}
		
\newcommand{\infoSection}[2]{

	\begin{tikzpicture}[remember picture,overlay]
		\node[rectangle, anchor=center, minimum height = .5cm] (data) at (box.south) {			
			\begin{minipage}{\textwidth}
			\centering
			\headingfont
			\foreach \x/\y in {#1} {
				\color{darkgray} \raisebox{-.5ex}{\fontsize{16pt}{20pt}\x} \hspace{.3em}\color{lightgray} \y \hspace{#2} 
			}
			\hspace{-#2} 
			\end{minipage}
		};
		\draw [darkgray] (data.south east) -- (data.south west);
		\draw [darkgray] (data.north east) -- (data.north west);
	\end{tikzpicture}
	\vspace{1cm}
	\vspace{\@headerspace}
}	

% Custom Symbols
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
%
% remove default spacing, remove section numbers, switch to fonts, and add line
%----------------------------------------------------------------------------------------
\titlespacing{\section}{0pt}{0pt}{0pt}
\titleformat{\section}{
	\vspace{-.4em}
	\fontsize{16pt}{20pt}\headingfont \raggedright\color{darkgray}}{}{.035\textwidth}{}[
        \vspace{-1em}\color{darkgray}\underline{\hspace{\textwidth}}
    ]

%----------------------------------------------------------------------------------------
%	List enviorment
%
% entryItem: 4 inputs for info. each is separated into 2 columns and rows. Each item
%    is aligned to the neatest horizontal margin.
%
% entryItemTwo: Same as entryItem, but with 2 pieces of info vs 4.
%
% subline: 1 input for info that is left aligned, but adds spacing to accomidate for
%    spacing in the entry item words.
%
% entryList: List enviorment to contain details for each entryitem (\item for entries)
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
	\vspace{-.5em}
}

\newenvironment{entryList}[1]{
	\vspace{-1.5em}
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
			\vspace{1.75em}}
	\end{tabular*}
	
}

%----------------------------------------------------------------------------------------
%	Radar Charts
%
% 4 inputs
%    1: Title for chart
%    2: List of skills sepatated by commas
%    3: Rankings for each skill (0-5) separated by commas
%    4: Scale for the chart
%----------------------------------------------------------------------------------------
\newcommand{\radarChart}[4]{
	\vspace{-1em}
	\begin{figure}[H]
		\centering
		{\fontsize{14pt}{20pt}\headingfont #1 }\par
		\begin{tikzpicture}
		\tkzKiviatDiagram[scale= #4,
		radial style/.style ={lightgray},
		lattice style/.style ={lightgray},
		rotate=90,
		radial  = 5,
		label space = 1.5,
		gap     = 1,  
		lattice = 5]{#2}
		\tkzKiviatLine[thick,color=gray,mark=none,
		fill=gray!75,opacity=.5](#3)
		\end{tikzpicture}
	\end{figure}
	\vspace{-1em}
}

%----------------------------------------------------------------------------------------
%	Circle Charts
%
% circChartArray: 1 input to determine number of columns for the charts
% 
% circChartEntry: 2 inputs
%    1: Name of Skill
%    2: Ranking of Skill (0-3)
%----------------------------------------------------------------------------------------

\newenvironment{circChartArray}[1]{
	
	\vspace{-.5em}
	\ifnum#1>1
		\def\@onecol{1}
	\fi
	\ifdefined\@onecol
		\begin{multicols}{#1}
			\else
			\vspace{-.25em}
			\fi
			
			}{%
		
	\ifdefined\@onecol
		\end{multicols}
	\fi
	\vspace{-.75em}
}


\newcommand{\circChartEntry}[2]{
	\begin{figure}[H]
		\centering
		\begin{tikzpicture}
		\coordinate (O) at (0,0);
		\draw[gray,fill=gray!75,opacity=.5] (O) circle (.7*#2 /3);
		\draw[gray] (O) circle (.7*1);
		\draw[gray] (O) circle (.7*2/3);
		\draw[gray] (O) circle (.7*1/3);
		\end{tikzpicture}
		\par #1
	\end{figure}
}