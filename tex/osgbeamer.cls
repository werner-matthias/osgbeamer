% 2016-08-09 M. Werner: erste Version 
% 2020-08-17 M. Werner: Version
\NeedsTeXFormat{LaTeX2e}
\def\classname{osgbeamer}
\ProvidesClass{\classname}[2022/08/17 v0.9.0d]
\RequirePackage{etoolbox}
% \RequirePackage{xkeyval}
\RequirePackage{pgfopts}
\RequirePackage{varsfromjobname}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Jobname
% =======
% Im OSG LaTeX lecture maker system (OLLM system)
% wird in die Klasse durch den Jobnamen Informationen übergeben.
% Der Jobname ist wie folgt aufgebaut:
% <lectureprefix>-<number>-<doctype>-<language>-<topic>
%
% * <lectureprefix>: wahlfreies Kürzel für die Vorlesungsreihe
% * <number>       : zweistellig Nummer des Kapitels
% * <doctype>      : Ausgabeformat (siehe unten)
% * <language>     : de oder en (für deutsch oder englisch)
% * <topic>        : wahlfreie Bezeichnung für das Kapitelthema
%

\newtoggle{osgscript}
\newbool{osgoptionstandalone}

\pgfkeys{
  /osgbeamer/.cd,
  % Eine Standalone-Präsentation ist nicht Teil einer Serie 
  standalone/.is if=osgoptionstandalone,
  % Doctype
  % =======
  % Es können mehrere Arten von Ausgabeformaten erzeugt werden:
  % * slides  => Foliensatz,
  % * handout => 4 Slides auf einem Blatt,
  % * screen  => Slides mit Kommentaren und Vorschau für die Vorführung)
  % * script  => Kapitel eines Scripts
  doctype/.is choice,
  %doctype/.default/.expanded=\getfromjobname{3},
  doctype/slides/.code={
    \gdef\osgparentclass{beamer}
    \togglefalse{osgscript}
  },
  doctype/handout/.code={
    \PassOptionsToClass{handout}{beamer}
    \togglefalse{osgscript}
  },
  doctype/script/.code={
    \toggletrue{osgscript}
  },
  doctype/screen/.code={
    \PassOptionsToClass{second}{beamer}
    \togglefalse{osgscript}
  },
  % Sprachen
  lang/.is choice,
  lang/de/.estore in=\selectedbeamerlanguage,
  lang/en/.estore in=\selectedbeamerlanguage,
}
\ifdef{\ollm}{
  \pgfkeys{
    /osgbeamer/doctype/.expanded=\getfromjobname{3},
    /osgbeamer/lang=\getfromjobname{4}
  }
  \xdef\currenttopic{\getfromjobname{5}}
  }{}
% default: 
%  \gdef\osgparentclass{beamer}

% \newcommand{\osgoptiontypehandout}{
%   \PassOptionsToClass{handout}{beamer}
%   \gdef\selectedbeamertype{handout}
%   \gdef\osgparentclass{beamer}
%   \togglefalse{osgscript}
% }
% \newcommand{\osgoptiontypeslides}{
%   \gdef\selectedbeamertype{slides}
%   \gdef\osgparentclass{beamer}
%   \togglefalse{osgscript}
% }
% \newcommand{\osgoptiontypescript}{
%   \gdef\selectedbeamertype{script}
%   \gdef\osgparentclass{beamer}
%   \toggletrue{osgscript}
% }
% \newcommand{\osgoptiontypescreen}{
%   \gdef\selectedbeamertype{screen}
%   \gdef\osgparentclass{beamer}
%   \togglefalse{osgscript}
% }


% \ifstrinjob{handout}{\osgoptiontypehandout}{}
% \ifstrinjob{slides}{\osgoptiontypeslides}{}
% \ifstrinjob{screen}{\osgoptiontypescreen}{}
% \ifstrinjob{script}{\osgoptiontypescript}{}

% \DeclareOptionX{type}{
%   \ifcsdef{osgoptiontype#1}{
%     \csname osgoptiontype#1\endcsname
%   }{
%     \ClassError{\classname}{Unknown type: #1}{}
%   }
% }
% Die Sprache kann explizit mit der Option lang=<lang> gesetzt werden.
% Alternativ wird im Jobnamen nach dem String _de oder _en gesucht und die
% entsprechende Sprache gesetzt (siehe osgbeamerlanguage.sty)

% \newcommand{\osgoptionlangdeutsch}{
%   \gdef\selectedbeamerlanguage{deutsch}
% }
% \newcommand{\osgoptionlangenglish}{
%   \gdef\selectedbeamerlanguage{english}
% }
% \newcommand{\osgoptionlanggerman}{\osgoptionlangdeutsch}
% \newcommand{\osgoptionlangenglisch}{\osgoptionlangenglish}

% \DeclareOptionX{lang}{
%   \ifcsdef{osgoptionlang#1}{
%     \csname osgoptionlang#1\endcsname
%   }{
%     \ClassError{\classname}{Unknown language: #1}{}
%   }
% }
% Suche nach Referenzen, auch wenn das Kapitel aktuell nicht referenziert ist


  %\DeclareOptionX{forceref}{\PassOptionsToPackage{\CurrentOption}{osgbeamerexternal}}

  %
  
% Eine Standalone-Präsentation ist nicht Teil einer Serie 
% \newbool{osgoptionstandalone}
% \DeclareOptionX{standalone}{
%   \booltrue{osgoptionstandalone}
% }
%
\def\osg@stdbib{lit.bib}
% Es wird nicht das Standard-Bib-File eingebunden.

%\DeclareOptionX{stdbib}{%
%  \def\osg@stdbib{#1}
%}

% 
%\DeclareOptionX{extern}{}
% Seitenverhältnis
\gdef\osg@aspectratio{1610}
%\DeclareOptionX{aspectratio}[1610]{\gdef\osg@aspectratio{#1}}
% Deaktiviert die Kategorieicons
% Diese Option sollte genutzt werden, wenn coloremoji nicht
% installiert sind
\newbool{osgoptionnocategory}
\booltrue{osgoptionnocategory}
%\DeclareOptionX{nocategory}{
%  \booltrue{osgoptionnocategory}
%}

%Optionsverarbeitung, alle verbleibenden Optionen werden an die
%Elternklasse gegeben.
\ProcessPgfOptions{osgbeamer}
%\DeclareOptionX*{\PassOptionsToClass{\CurrentOption}{\osgparentclass}}
%\ProcessOptionsX

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Seitenverhältnis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%  Das Seitenverhältnis kann entweder als Klassenoption mit \aspectratio=XX
%  eingestellt werden, oder mit \forceaspectratio{XX} in "lectdates.tex". 
%  Bei unterschiedlichen Einstellungen gilt folgende Rangordnung:
%   1. \forceaspectratio in "lectdates.tex"
%   2. Klassenoption aspectration
%   3. Defaultwert der Klassenoption
\newcommand{\forceaspectratio}[1]{} % Dieser Befehl wird im Makefile ausgewertet und setzt \osg@forceaspectratio


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Basisklasse
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\providecommand{\osgforceaspectratio}{}
\iftoggle{osgscript}{
  % Kapitel 
  \LoadClass[twoside,
    open=right,
    chapterprefix=true,
    cleardoublepage=current,
    %headsepline,
    parskip=half,DIV=9, fontsize=10pt]{scrbook}
  \RequirePackage{etex}  
  \RequirePackage{scrhack}
  \RequirePackage{beamerarticle}
  \RequirePackage[latexfontsbody]{beamerarticletuc2014}
}{
  \ifdefstring{\osgforceaspectratio}{}{}{\def\osg@aspectratio{\osgforceaspectratio}}
  \LoadClass[ignorenonframetext,10pt,unknownkeysallowed,notheorems,aspectratio=\osg@aspectratio]{beamer}
  \RequirePackage{etex}  
  \usetheme[fakcolor=if]{tuc2014}
  
  %%% Handout
  \mode<handout>{
    \RequirePackage{pgfpages}
    \pgfpagesuselayout{4 on 1}[a4paper,landscape%,border shrink=5mm
    ]
  }
}
%%% Erlaube Neudefinitionen von Beamer-Environments (siehe http://tex.stackexchange.com/questions/267121/redefine-block-environment-in-beamer)
\long\def\beamer@newenvnoopt#1#2#3#4{%
  \expandafter\renewcommand\expandafter<\expandafter>\csname#1\endcsname[#2]{#3}%<- here
  \expandafter\long\expandafter\def\csname end#1\endcsname{#4}%
}
\long\def\beamer@newenvopt#1#2[#3]#4#5{%
  \expandafter\renewcommand\expandafter<\expandafter>\csname#1\endcsname[#2][#3]{#4}%<- here
  \expandafter\long\expandafter\def\csname end#1\endcsname{#5}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sprache (in osgbeamerlanguage.sty ausgelagert)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
\RequirePackage{osgbeamerlanguage}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Farben
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\colorlet{infgreen}{tuccolor@if}
\colorlet{tucgreen}{tuccolor@tuc}
\definecolor{lightgreen}{rgb}{0.824,0.878,0.804}
\definecolor{lightgreen2}{rgb}{0.844,0.918,0.834}
\definecolor{darkgreen}{rgb}{0,0.5,0}
\setbeamercolor{outline}{bg=yellow,fg=black}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Fonts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
\iftoggle{osgscript}{
  % keinen Versuch für das Skript auf das TUC-CI zu wechseln
  \RequirePackage[lf]{Baskervaldx}
  \RequirePackage{DejaVuSansCondensed} 
}{
  \usefonttheme{professionalfonts}
  %\usepackage{libertineMono}
  %\usepackage{biolinum}
  \RequirePackage{DejaVuSerifCondensed}  % Roboto-Slab als Roman-Schrift ist gräßlich
  \renewcommand{\rmdefault}{DejaVuSerifCondensed-TLF}
}
% Terminal Font
\RequirePackage[T1]{fontenc}
\RequirePackage[scaled=0.87]{ulgothic}
%\RequirePackage{microtype}

\RequirePackage{xspace}
%\RequirePackage{textcomp}
%% aus dem pifont-Paket:
\newcommand{\Pifont}[1]{\fontfamily{#1}\fontencoding{U}\fontseries{m}\fontshape{n}\selectfont}
\newcommand{\Pisymbol}[2]{{\Pifont{#1}\char#2}}
\newcommand{\ding}{\Pisymbol{pzd}}
%%% Farbiger "daraus folgt"-Pfeil
\newcommand{\follows}{{\usebeamercolor[fg]{structure}\ding{225}}\xspace}
%\newcommand{\lfollows}{{\usebeamercolor[fg]{structure}\rotatebox[180]{\ding{225}}}\xspace}
\newcommand{\lfollows}{{\usebeamercolor[fg]{structure}\rotatebox[origin=c]{180}{\ding{225}}}\xspace}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Grafiken
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
\RequirePackage{pgf}
% Horizontal zentriertes Bild
\newcommand{\osg@centerpic}[2][]{
  \def\parsewidth##1,##2,{\dimdef{\pw}{##1}\dimdef\aw{##2}}
  \edef\x{\noexpand\in@{,}{#1}}\x
  \ifin@
    \parsewidth#1,\relax
  \else
    \dimdef\pw{#1}
    \dimdef\aw{#1}
   \fi
  \only<presentation>{
     \centerline{
       \includegraphics[width=\pw]{#2}
     }
   }
   \only<article>{\centerline{\includegraphics[width=\aw]{#2}}}
}
\newcommand<>{\centerpic}[2][.9\textwidth]{%
  \only#3{\osg@centerpic[#1]{#2}}
}
\newcommand{\makesmiley}[2]{\csdef{osgsmiley#1}{\raisebox{-.2ex}{\includegraphics[height=1.8ex]{#2}}}}
\makesmiley{:-)}{1F60A} % happy
\makesmiley{:-D}{1F600} % laugh
\makesmiley{:-|)}{1F62C} % angry
\makesmiley{:-()}{1F615} % sad
\makesmiley{:-P}{1F61B} % tongue
\makesmiley{;-)}{1F609} % wink 
\makesmiley{:-o}{1F62E} % astonished
\makesmiley{B-)}{1F60E} % cool

\newcommand{\smiley}[1]{\csuse{osgsmiley#1}}
\let\osgsmiley=\smiley
\iftoggle{osgscript}{}{
  \newcommand{\inserttinyosglogo}{%
    \raisebox{-1pt}{\includegraphics[height=2ex]{OSG-Logo}}%
  }
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% Lecture / Kapitel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%% Chapter = Lecture
\ifbool{osgoptionstandalone}{
  \newcommand{\osgchapterprefix}{}
}{
  \newcommand{\osgchapterprefix}{\ordinal{chapter} \ldeen{Kapitel}{Chapter}}
}
\RequirePackage{aliascnt}
\iftoggle{osgscript}{
  \newaliascnt{lecture}{chapter}
}{  % Presentation
  \newaliascnt{chapter}{lecture}
}
\gdef\osg@aftertitle{}
\newrobustcmd{\AfterTitle}[1]{
  \gappto{\osg@aftertitle}{#1}
}
\iftoggle{osgscript}{
  \setcounter{tocdepth}{1}   % Inhaltsverzeichnis
  \newcommand{\osg@lecture}[3][]{%
    \ifstrempty{#1}{%
      \chapter{#2}
      \markleft{\thechapter. #2}
    }{%
      \chapter[#1]{#2}
      \markleft{\thechapter. #1}
    }
    \zref@label{#3}%
    \gdef\beamer@currentlecturelabel{#3}
  }
  \renewcommand{\lecture}[3][]{
    \ifx\@onlypreamble\@notprerr% OK, wir sind nach \begin{document}
      \osg@lecture[#1]{#2}{#3}
    \else%
      \AtBeginDocument{%
         \osg@lecture[#1]{#2}{#3}
      }  
    \fi
  }
}{ % Presentation
  \AtBeginLecture{
    \ifdefstring{\insertshortlecture}{}{
      \title{\insertlecture}
    }{
      \title[\insertshortlecture]{\insertlecture}
    }
    \zref@label{\beamer@currentlecturelabel}
    \tucthreeheadlines
    \tucnarrowframe
    \begingroup
    \ifbool{osgoptionstandalone}{}{
      \logo{\includegraphics[width=\hsize]{OSG-Logo}}
      }
    \setbeamertemplate{tuc3 headline 1}{\insertsubtitle}
    \setbeamertemplate{tuc3 headline 2}{\insertdate}
    \setbeamertemplate{tuc3 headline 3}{}
    \setbeamertemplate{navigation symbols}{}
    \setbeamertemplate{footline}{}
    \begin{frame}[c]
      \vbox{}
      {\usebeamerfont{subtitle}{\insertsubtitle}}\par\vskip2em
      \usebeamerfont{subtitle}\usebeamercolor[fg]{title}{\osgchapterprefix}\par\vskip0.25em
      {\usebeamerfont{title}\usebeamercolor[fg]{title}{\inserttitle}}\par\vskip2em
      \usebeamerfont{author}\insertauthor\par\vskip0.5em
      \usebeamerfont{institute}\insertinstitute
      \vfill
    \end{frame}
    \endgroup
    \tuctwoheadlines
    \tucwideframe
    \setbeamertemplate{tuc2 headline 1}{\insertsubtitle~--~\insertshorttitle}
    \setbeamertemplate{tuc2 headline 2}{\osginsertshortsection}
    \setbeamertemplate{footline}[osg]
    \osg@aftertitle
  }
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Anhang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Anhang gibt es in zwei "Geschmacksrichtungen". Zum einen kann eine einzelne
% Vorlesung einen Anhang haben, zum anderen können ganze Vorlesungen zum
% Anhang erklärt werden, was i.d.R. nur im Zusammenhang mit Skripten sinnvoll
% ist.
% Um beide Varianten zu unterscheiden wird geprüft, ob die \appendix-Anweisung
% in der Preamble oder in Dokument steht.
\RequirePackage{apptools}
\AtAppendix{%
  \ifx\@onlypreamble\@notprerr
   \renewcommand{\thesection}{\appendixname~\Alph{section}:}
   \renewcommand{\thesubsection}{\thesection.\arabic{subsection}}
    \setcounter{section}{0}
  \else
    \renewcommand{\thesection}{\thechapter.\arabic{section}}
   \renewcommand{\thesubsection}{\thesection.\arabic{subsection}}
  \fi
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Titelei
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\let\kernsection=\section
\let\kernsubsection=\subsection

\iftoggle{osgscript}{
  % Dictum
  \renewcommand*{\dictumwidth}{.45\textwidth}
  \renewcommand*{\dictumrule}{}
  \renewcommand*{\dictumauthorformat}[1]{---~\rmfamily#1\medskip}
  
  \defbeamertemplate<article>{frametitle}{osg}{%
    \ifdefstring{\insertframetitle}{}{}{%
      \subsubsection*{\insertframetitle}%
    }%
  }
  \renewcommand{\framesubtitle}[1]{\paragraph*{#1}}%
  \setkomafont{paragraph}{\rmfamily\bfseries}
  \setbeamertemplate{frametitle}[osg]
}{
  \setbeamerfont{framesubtitle}{size=\large}
  %% Automatische Titel bei Abschnittsanfang
  \newtoggle{newsec}
  \newtoggle{newsubsec}
  \newcommand{\osg@insertsection}{\thesection\ \insertsection}
  \newcommand{\osg@insertsectionstar}{\insertsection}
  \newcommand{\osg@insertsubsection}{\thesubsection\ \insertsubsection}
  \newcommand{\osg@insertsubsectionstar}{\insertsubsection}
  %\newcommand{\osg@insertshortsection}{\thesection\ \secname} 
  %\newcommand{\osg@insertshortsection}{\thesection\ \insertshortsection} % /insertshortsectionhead?
  \newcommand{\osg@insertshortsection}{\thesection\ \insertsectionhead}
  \newcommand{\osg@insertshortsectionstar}{\insertsectionhead}
  \newcommand{\osg@insertshortsubsection}{\thesubsection\ \insertshortsubsection}
  \newcommand{\osg@insertshortsubsectionstar}{\insertshortsubsection}
  \let\osginsertsection=\osg@insertsection
  \let\osginsertsubsection=\osg@insertsubsection
  \let\osginsertshortsection=\osg@insertshortsection
  \let\osginsertshortsubsection=\osg@insertshortsubsection
  \togglefalse{newsec}
  \togglefalse{newsubsec}
  \AtBeginSection[%
    \let\osginsertsection=\osg@insertsectionstar
    \let\osginsertshortsection=\osg@insertshortsectionstar
    \toggletrue{newsec}
  ]{%
    \let\osginsertsection=\osg@insertsection
    \let\osginsertshortsection=\osg@insertshortsection
    \toggletrue{newsec}
  }
  \AtBeginSubsection[
    \let\osginsertsubsection=\osg@insertsubsectionstar
    \let\osginsertsubshortsection=\osg@insertshortsubsectionstar
    \toggletrue{newsubsec}
  ]{
    \let\osginsertsubsection=\osg@insertsubsection
    \let\osginsertshortsubsection=\osg@insertshortsubsection
    \toggletrue{newsubsec}
  }
  %\renewcommand{\section}{\toggletrue{newsec}\kernsection}
  %\renewcommand{\subsection}{\toggletrue{newsubsec}\kernsubsection}
  %% 
  \long\def\beamer@@frametitle[#1]#2{%
    \iftoggle{newsec}{% Neue Section
      \iftoggle{newsubsec}{% Neue Section + neue Subsection
        \gdef\insertframetitle{{\osginsertsection\ifnum\beamer@autobreakcount>0\relax{}\space\usebeamertemplate*{frametitle continuation}\fi}}%
        \gdef\beamer@frametitle{\osginsertsection}%
        \gdef\beamer@shortframetitle{\#1}%
        \gdef\insertframesubtitle{\osginsertsubsection}
        \gdef\@lastframetitle{\osginsertsubsection}
        % Trotzdem Titel angegeben? => Warnung
        \beamer@ifempty{#2}{}{%
          \GenericWarning{OSGBeamer}{title will be lost after section and subsection command}
        }
      }{ % Neue Section, ohne Subsection
        \beamer@ifempty{#2}{% Kein explizit gesetzter Titel
          \gdef\insertframetitle{{\osginsertsection\ifnum\beamer@autobreakcount>0\relax{}\space\usebeamertemplate*{frametitle continuation}\fi}}%
          \gdef\beamer@frametitle{\osginsertsection}%
          \gdef\beamer@shortframetitle{\osginsertshortsection}%
          \gdef\insertframesubtitle{}
          \gdef\@lastframetitle{\insertsection}
        }{% Titel gegeben, wird zum Subtitel
          \gdef\insertframetitle{{\osginsertsection\ifnum\beamer@autobreakcount>0\relax{}\space\usebeamertemplate*{frametitle continuation}\fi}}%
          \gdef\beamer@frametitle{\osginsertsection}%
          \gdef\beamer@shortframetitle{#1}%
          \gdef\insertframesubtitle{#2}
          \gdef\@lastframetitle{#2}
        }
      }
    }{% Keine neue Section
      \iftoggle{newsubsec}{% Neue Subsection
        \gdef\insertframetitle{{\osginsertsubsection\ifnum\beamer@autobreakcount>0\relax{}\space\usebeamertemplate*{frametitle continuation}\fi}}%
        \gdef\beamer@frametitle{\osginsertsubsection}%
        \gdef\beamer@shortframetitle{\osginsertshortsubsection}%
        \beamer@ifempty{#2}{
          \gdef\@lastframetitle{\osginsertsubsection}
        }{
          \gdef\insertframesubtitle{#2}
          \gdef\@lastframetitle{#2}
        }
      }{% Standard
        \beamer@ifempty{#2}{}{%
          \gdef\insertframetitle{{#2\ifnum\beamer@autobreakcount>0\relax{}\space\usebeamertemplate*{frametitle continuation}\fi}}%
          \gdef\beamer@frametitle{#2}%
          \gdef\beamer@shortframetitle{#1}%
          \gdef\@lastframetitle{#2}
        }%
      }%
    }%
    \ifnumequal{\insertpagenumber}{\insertframeendpage}{%
      \global\togglefalse{newsec}%
      \global\togglefalse{newsubsec}%
      % \setcounter{footnote}{0}
    }{} 
  }
}
\iftoggle{osgscript}{
  \newcommand{\contframetitle}[1][]{}
}{
  \newcommand{\contframetitle}[1][\@lastframetitle]{
    \gdef\insertframetitle{#1\space\usebeamertemplate*{frametitle continuation}}
    \gdef\beamer@frametitle{#1}%
  }
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Seitenformat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ifbool{osgoptionstandalone}{%
  \renewcommand{\thesection}{%
    \arabic{section}.%
  }
  \renewcommand{\thesubsection}{\arabic{section}.\arabic{subsection}}
}{
  \renewcommand{\thesection}{%
    \thechapter.\arabic{section}%
  }
  \renewcommand{\thesubsection}{
    \thesection.\arabic{subsection}
  }  %% TODO: Appendix
}
 
\iftoggle{osgscript}{
  \usepackage[]{scrlayer-scrpage}
  \clearpairofpagestyles
  \setkomafont{pageheadfoot}{\sffamily\footnotesize}
  \setkomafont{pagenumber}{\sffamily\bfseries\color{white}}
  \addtokomafont{dictum}{\small<all>\em}
  \setkomafont{chapterprefix}{\Huge\color{black}\bfseries}
  \setkomafont{chapter}{\color{infgreen!75!black}\huge}
  \addtolength{\headsep}{17mm}
  \DeclareNewLayer[
  background,
  topmargin,
  addheight=\headheight+3mm,
  mode=picture,
  contents=\putLL{\textcolor{infgreen!35}{\rule{\layerwidth}{\layerheight}}}
  ]{swatch.bg}
  \DeclareNewLayer[
    clone=swatch.bg,
    addheight=\headheight+3mm,
    contents=\putLL{\textcolor{infgreen}{\rule{\layerwidth}{\layerheight}}}
  ]{swatch-title.bg}
  \DeclareNewLayer[
  clone=swatch.bg,
  oddpage,
  outermargin,
  addhoffset=2mm,
  width=18mm,
  %height=\dimexpr1in+\voffset+\topmargin+\headheight\relax,
  height=\dimexpr1in+\voffset+\topmargin+\headheight+3mm\relax,
  contents={
    \putLL{%
      \textcolor{white}{\rule{1.5mm}{\layerheight}}%
      \textcolor{infgreen}{\rule{15mm}{\layerheight}}%
      \textcolor{white}{\rule{1.5mm}{\layerheight}}%
    }
    \putC{\makebox(0,0){\pagemark}}
  }
  ]{swatch.odd}
  \DeclareNewLayer[
  clone=swatch.odd,
  evenpage,
  addhoffset=\dimexpr1in+\hoffset+\evensidemargin-4mm-18mm\relax
  ]{swatch.even}
  \DeclareNewLayer[
  background,
  mode=picture,
  bottommargin,
  align=b,
  addvoffset=18mm,
  contents={
    \putLL{
       \textcolor{orange}{\rule{\layerwidth}{1pt}}
    }
  }
  ]{swatch.bottom}  
  % Layer aktivieren:
  \AddLayersAtBeginOfPageStyle{scrheadings}{swatch.odd,swatch.even,swatch.bg, swatch.bottom}
  % Kapitelstart hat leeren Balken
  \AddLayersAtBeginOfPageStyle{plain.scrheadings}{swatch.bg}
   \newcommand{\osg@pagehead}{
     \lehead{{\sffamily\scshape\osgshortauthor}: \osgshorttitle}
     \rohead{\leftmark\ $\blacktriangleright$ \rightmark}
   }
  \AtBeginDocument{
    \osg@pagehead
  }
  \AtEndDocument{
    \cleardoublepage
  }
  %\setlength{\footnotemargin}{1em}
}{ % Presentation
  \defbeamertemplate*{footline}{osg}
  {
    \begin{beamercolorbox}[colsep=0.25pt]{separation line}
    \end{beamercolorbox}
    \begin{beamercolorbox}[wd=\paperwidth,ht=8pt,dp=3pt]{fg=black,bg=white}%
      \leavevmode%
      \fontsize{7pt}{9pt}\selectfont%
      \hspace*{0.04994\paperheight}%
      \rlap{%
        \@tempswafalse%
        \expandafter\beamer@ifempty\expandafter{\inserttinyosglogo}{}{\inserttinyosglogo\@tempswatrue}%
        \expandafter\beamer@ifempty\expandafter{\beamer@shortdate}{}{\if@tempswa~~\fi\insertshortdate\@tempswatrue}%
        \expandafter\beamer@ifempty\expandafter{\beamer@shortauthor}{}{\if@tempswa~$\cdot$~\fi\insertshortauthor\@tempswatrue}%
      }\hfill%
      \ifbool{osgoptionstandalone}{%
        \insertframenumber\ / \inserttotalframenumber
      }{%
        {\Roman{chapter}}\hspace{1pt}--\hspace{1pt}\insertframenumber\ {\emph{\ldeen{von}{of}}}\ \inserttotalframenumber
      }\hfill%
      \llap{\insertshorttucurl}%
      \hspace*{0.04994\paperheight}%
    \end{beamercolorbox}%
  }

  %% TODO: place
  \setbeamercovered{invisible}
  \setbeamertemplate{theorem}[ams style]
  \setbeamertemplate{theorems}[numbered]
  \setbeamerfont{block title}{size=\normalsize}
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Größen und Abstände
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% \newcommand\ifinframe[2]{%
%   \ifbeamer@inframe%
%   #1
%   \else%
%   #2
%   \fi%
% }
\newbool{@osg@inkoma}
%\iftoggle{osgscript}{
% \pretocmd{\usekomafont}{\booltrue{@osg@inkoma}}{\typeout{Patching of
%     KOMA \string\usekomafont\ succeed}}{\typeout{Can't
%     patching KOMA \string\usekomafont}}
% \apptocmd{\usekomafont}{\boolfalse{@osg@inkoma}}{\typeout{Patching of
%     KOMA \string\usekomafont\ succeed}}{\typeout{Can't
%     patching KOMA \string\usekomafont}}
% }{}
% \newcommand<>{\osgselect}[1]{%
%   \ifstrempty{#2}{%
%     \ifbool{@osg@inkoma}{%
%       #1%
%     }{%
%       \only<presentation>{#1}%
%     }%
%   }{%
%     \only#2{#1}%
%   }%
% }
\newcommand<>{\osgselect}[1]{\ifstrempty{#2}{\only<presentation>{#1}}{\only#2{#1}}}
\newcommand{\osgpresart}[2]{\only<presentation>{#1}\only<article>{#2}}
\newcommand<>{\osgselecttwo}[2]{
  \ifstrempty{#3}{\only<presentation>{#1{#2}}}{\alt#3{#1{#2}}{#2}}
}
% TODO: Behandlung von optionalen Parametern
\newcommand{\makeselectable}[1]{%
  \expandafter\let\csname\detokenize{#1}@osg@orig\endcsname=#1%
  \renewcommand<>{#1}{\osgselect##1{\csname\detokenize{#1}@osg@orig\endcsname}%
  }%  
}  

\makeselectable{\smallskip}
\makeselectable{\medskip}
\makeselectable{\bigskip}
\makeselectable{\tiny}
\makeselectable{\scriptsize}
\makeselectable{\footnotesize}
\makeselectable{\small}
\makeselectable{\normalsize}
\makeselectable{\large}
\makeselectable{\Large} 
\makeselectable{\LARGE}
%
\let\osg@original@@vspacer=\@vspacer
\let\osg@original@@vspace=\@vspace
\renewcommand<>{\@vspacer}{\alt#1{\osg@original@@vspacer}{\@gobble}}
\renewcommand<>{\@vspace}{\alt#1{\osg@original@@vspace}{\@gobble}}
%\newcommand<>{\osgvspace}[1]{\only#2{\vspace{#1}}}
%\newcommand<>{\osghspace}[1]{\only#2{\hspace{#1}}}
\newcommand{\fsmall}{\csname\detokenize{\small}@osg@orig\endcsname}
%\makeselectable{\\}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Textauszeichnungen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
\newcommand<>{\sbf}[1]{\structure#2{\textbf#2{#1}}}         % Bold Text in Strukturfabe
\newcommand<>{\newdef}[1]{\structure#2{\textbf#2{#1}}}      % Neu definierter Begriff
%\newcommand<>{\grave}[1]{\only#2{\textcolor{structure}}{#1}}
\newcommand<>{\mgrave}[1]{\ensuremath{\color{structure}#1}}
\newcommand<>{\malert}[1]{\ensuremath{\usebeamercolor[fg]{alerted text}#1}}
\newif\ifosgmarkmm%
\newcommand{\markword}[2]{%
  \relax\ifmmode\osgmarkmmtrue\else\osgmarkmmfalse\fi\ifdef{\tikzexternalize}{\tikzset{external/export next=false}}{}%
  \tikz[remember picture, baseline]\node[anchor=text,inner sep=0pt](#1){\ifosgmarkmm$#2$\else#2\fi};}
\RequirePackage[normalem]{ulem}
\RequirePackage{url}
\def\UrlFont{\ttfamily\upshape}
\Urlmuskip = 0mu plus 1mu
\iftoggle{osgscript}{
  % \urlstyle{tt}
  \let\osg@original@@texttt=\texttt% 
  \gdef\osg@gravett#1{\textcolor{infgreen!50!black}{\textup{\osg@original@@texttt{#1}}}}
  \newcommand<>{\outline}[1]{\uline{#1}}
  \newcommand<>{\moutline}[1]{\uline{#1}}
  \newcommand<>{\ctiny}{}
  \newcommand<>{\cfootnotesize}{}
  \newcommand<>{\cscriptsize}{}
  \newcommand<>{\csmall}{}
  \newcommand<>{\cnormalsize}{}
  %\newcommand<>{\grave}[1]{\emph{#1}}
  \newcommand<>{\grave}[1]{%
    % Achtung, Macro funktioniert *nur* wenn ulgothic als Terminalfont genutzt wird. Andernfalls ist statt "ulg"
    % z.B. "cmtt" o.ä. zu nehmen
    \ifdefstring{\f@family}{ulg}{\osg@gravett{#1}}{% Wenn bereits Terminalfont, nutze osg@gravet, sonst mache es bei Umschalten auf \texttt
      \let\texttt=\osg@gravett%
      \emph{#1}% normal: einfaches Hervorheben
      \let\texttt=\osg@original@@texttt%
    }%
  }
}{
  \newcommand<>{\outline}[1]{{\setlength{\fboxsep}{0pt}{\only#2{\usebeamercolor{outline}}\colorbox{bg}{#1}}}}
  \newcommand<>{\moutline}[1]{{\setlength{\fboxsep}{0pt}{\only#2{\usebeamercolor{outline}}\colorbox{bg}{\ensuremath{#1}}}}}
  \newcommand<>{\ctiny}{\only#1{\tiny}}
  \newcommand<>{\cfootnotesize}{\only#1{\footnotesize}}
  \newcommand<>{\cscriptsize}{\only#1{\scriptsize}}
  \newcommand<>{\csmall}{\only#1{\small}}
  \newcommand<>{\cnormalsize}{\only#1{\normalsize}}
  \newcommand<>{\grave}[1]{\only#2{\textcolor{structure}}{#1}}
}
\newcommand{\sourceref}[2][\ldeen{Quelle}{Source}]{{\tiny<all>\textbf{#1}: \grave{#2}}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Fußnoten
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
\iftoggle{osgscript}{
  % Fußnoten sollen sich im presentation-Mode immer so verhalten,
  % als ob es mit [frame] aufgerufen würde.
  %% TODO: Optionaler Parameter von \footnote
  \let\osg@footnote@original=\footnote
  \gdef\do{}
  \newcommand{\osg@footnote@inblock}[2][]{% 
    \setkeys*{beamerfootnote}{#1}%
    \ifdefempty{\XKV@rm}{%
      \footnotemark}{\footnotemark[\XKV@rm]}%
    \listgadd{\osg@todo}{\protecting{#2}}%
  }
  \newcommand{\osg@footnote@init}{%
    \gdef\osg@todo{}%
    \let\footnote=\osg@footnote@inblock%
    %\makeselectable{\\}
  } 
  \newcommand{\osg@footnote@do}{%
    %\typeout{**** FOOTNOTE: \osg@todo}%
    \gdef\do##1{\addtocounter{footnote}{-1}}%
    \dolistloop{\osg@todo}%
    \gdef\do##1{\stepcounter{footnote}\footnotetext{##1}}%
    \dolistloop{\osg@todo}%
    \let\footnote=\osg@footnote@original%
    \gdef\osg@todo{}% in case of cascading blocks
  }
  \newcommand{\afootnote}[1]{\footnote{#1}}
}{ 
  \let\osg@footnote@original=\footnote
  \newcommand{\osg@eatfootnote}[2][]{}
  \long\def\osg@footnote@spec<#1>{\ifstrequal{#1}{article}{\osg@eatfootnote}{\osg@footnote@original[frame]}}%
  \renewcommand{\footnote}{\@ifnextchar<{\osg@footnote@spec}{\osg@footnote@original[frame]}}
  \newcommand*{\osg@footnote@init}{}
  \newcommand*{\osg@footnote@do}{}
  \newcommand{\afootnote}[1]{}
} 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Blöcke
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
\RequirePackage[framemethod=1]{mdframed}
\mdfdefinestyle{basicblock}{linewidth=1,innerleftmargin=20,innerrightmargin=20,skipabove=10ptplus5pt,skipbelow=10ptplus5pt,userdefinedwidth=\columnwidth }

%% TODO: Farben von Beamer übernehmen
\mdfdefinestyle{block}{style=basicblock,backgroundcolor=tuccolor@if!10!white,linecolor=tuccolor@if!80!black,frametitlebackgroundcolor=tuccolor@if!90!white,
  frametitlefont=\sffamily\color{white}}
\mdfdefinestyle{alertblock}{style=basicblock,backgroundcolor=tuccolor@warning!20!white,linecolor=tuccolor@warning!80!black,frametitlebackgroundcolor=tuccolor@warning!80!white,
  frametitlefont=\sffamily}
\mdfdefinestyle{exampleblock}{style=basicblock,backgroundcolor=black!5!white,linecolor=darkgray,frametitlebackgroundcolor=black!65,
  frametitlefont=\sffamily\color{white}}

\iftoggle{osgscript}{
  \renewenvironment<>{block}[1]{%
    \begin{actionenv}#2\parshape0\osg@footnote@init%
    \tikzexternaldisable%
    \begin{mdframed}[style=block,frametitle=#1]\makeselectable{\\}
    }{\end{mdframed}\osg@footnote@do\end{actionenv}}
  
\renewenvironment<>{alertblock}[1]{%
  \begin{actionenv}#2\parshape0\osg@footnote@init%
    \tikzexternaldisable%
    \begin{mdframed}[style=alertblock,frametitle=#1]\makeselectable{\\}
    }{\end{mdframed}\osg@footnote@do\end{actionenv}
}

\renewenvironment<>{exampleblock}[1]{%
  \begin{actionenv}#2\parshape0\osg@footnote@init%
    \tikzexternaldisable%
    \begin{mdframed}[style=exampleblock,frametitle=#1]\makeselectable{\\}
    }{\end{mdframed}\osg@footnote@do\end{actionenv}
}

   \mdtheorem[style=block]{osgdefinition}{Definition}[chapter]
   \mdtheorem[style=block]{osgtheorem}{Theorem}[chapter]

   %%% TODO: Fußnotenmechanismus anpassen
   \renewenvironment{definition}[1][]{%
     \parshape0%
     \osg@footnote@init%
     \tikzexternaldisable%
     \begin{osgdefinition}[#1]\makeselectable{\\}
     }{\end{osgdefinition}\osg@footnote@do
   }
   \renewenvironment{theorem}[1][]{%
     \parshape0%
     \osg@footnote@init%
     \tikzexternaldisable%
     \begin{osgtheorem}[#1]\makeselectable{\\}
     }{\end{osgtheorem}\osg@footnote@do
   }
   \newcounter{example}[chapter]
   \renewenvironment{example}[1][]{%
     \refstepcounter{example}%
     \parshape0% 
     \osg@footnote@init%
     \ifstrempty{#1}{\def\extitle{}}{\def\extitle{: #1}}
     \begin{exampleblock}{Beispiel \theexample\extitle}\makeselectable{\\}
     }{\end{exampleblock}\osg@footnote@do
   }
 }{
   \newtheorem{definition}{Definition}[chapter]
   \newtheorem{theorem}{Theorem}[chapter]
   \newtheorem{lemma}{Lemma}[chapter]
   \def\th@osgexamplestyle{
     \def\inserttheoremblockenv{exampleblock}
   }
   \def\th@osgblockstyle{ 
     \def\inserttheoremblockenv{block}
   }
   \theoremstyle{osgexamplestyle}
   \newtheorem{example}{Beispiel}[chapter]
   %\setbeamertemplate{example begin}{}
   %\setbeamertemplate{example end}{}
}
\renewcommand*{\thedefinition}{\arabic{chapter}.\arabic{definition}}
\renewcommand*{\theexample}{\arabic{chapter}.\arabic{example}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Columns
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 
\iftoggle{osgscript}{
  \define@key{beamer@col}{onlytextwidth}[true]{%
    \def\beamer@colentrycode{\hbox to\textwidth\bgroup\ignorespaces}%
    \def\beamer@colexitcode{\unskip\egroup}}
  \define@key{beamer@col}{totalwidth}{%
    \def\beamer@colentrycode{\hbox to#1\bgroup\ignorespaces}%
    \def\beamer@colexitcode{\unskip\egroup}}
  \define@key{beamer@col}{c}[true]{\def\beamer@colmode{c}\def\beamer@colalign{c}\def\beamer@colheadskip{}}
  \define@key{beamer@col}{t}[true]{\def\beamer@colmode{t}\def\beamer@colalign{t}\def\beamer@colheadskip{}}
  \define@key{beamer@col}{T}[true]{\def\beamer@colmode{T}\def\beamer@colalign{t}\def\beamer@colheadskip{\vskip-1ex\nointerlineskip}}
  \define@key{beamer@col}{b}[true]{\def\beamer@colmode{b}\def\beamer@colalign{b}\def\beamer@colheadskip{}}

  \newenvironment<>{osg@beamer@columnenv}[2][\beamer@colmode]{%
    \beamer@colclose\def\beamer@colclose{}%
    \begin{actionenv}#3%
      \setkeys{beamer@col}{#1}%
      \begin{minipage}[\beamer@colalign]{#2}%
        \leavevmode\raggedright\beamer@colheadskip\ignorespaces}
      {\end{minipage}\hfill\end{actionenv}\@ignoretrue}
  \let\endcolumn\endbeamer@columnenv

  \newcommand<>\osg@beamer@columncom[2][\beamer@colmode]{%
    \beamer@colclose%
    \def\beamer@colclose{\end{minipage}\hfill\end{actionenv}\ignorespaces}%
\begin{actionenv}#3%
  \setkeys{beamer@col}{#1}%
  \begin{minipage}[\beamer@colalign]{#2}%
    \leavevmode\raggedright\beamer@colheadskip\ignorespaces}

  \let\osg@orig@beamer@columncom=\beamer@columncom
  \let\osg@beamer@columnenv=\beamer@columnenv
  \let\endosg@beamer@columnenv=\endbeamer@columnenv
  \renewenvironment<>{columns}[1][c]{%
    \osg@footnote@init
    \def\beamer@colclose{}
    \ifstrempty{#2}{}{%
      \only#2{%
        \setkeys{beamer@col}{#1}%
        \let\beamer@columncom=\osg@beamer@columncom
        \let\beamer@columnenv=\osg@beamer@columnenv
        \let\endbeamer@columnenv=\endosg@beamer@columnenv
      }
    }
  }{
    \beamer@colclose
    \let\beamer@columncom=\osg@orig@beamer@columncom
    \let\beamer@columnenv=\osg@orig@beamer@columnenv
    \let\endbeamer@columnenv=\endosg@orig@beamer@columnenv
    \osg@footnote@do
  }
}{}
%% Vereinfachtes Spaltenmanagement für zwei Spalten:
%% twocolumns nimmt zwei optionale Argumente (Reihenfolge egal):
%%  - vertikale Ausrichtung {c|b|t|T}
\iftoggle{osgscript}{
  \newenvironment{twocolumns}[1][]{
    \def\nextcolumn{\par}
  }{
  }
}{
\newlength{\osgleftcolwid}
\newlength{\osgrightcolwid}
\def\osgtcparse#1,#2{
  \gdef\osgtcalignparam{#1}
  \gdef\osgtcalignparam{#2}
}
\newenvironment{twocolumns}[1][t,0.475]{
  \forcsvlist{\listadd\osgtcparamlist}{#1}
    %\def\osgtcfcolparam{t}%
    \ifinlist{t}{\osgtcparamlist}{\def\osgtcalignparam{t}\listremove{\osgtcparamlist}{t}}{}%
    \ifinlist{c}{\osgtcparamlist}{\def\osgtcalignparam{c}\listremove{\osgtcparamlist}{c}}{}%
    \ifinlist{b}{\osgtcparamlist}{\def\osgtcalignparam{b}\listremove{\osgtcparamlist}{b}}{}%
    \ifinlist{T}{\osgtcparamlist}{\def\osgtcalignparam{T}\listremove{\osgtcparamlist}{T}}{}%
    \ifundef{\osgtcalignparam}{
      \def\osgtcalignparam{c}%
    }{}
    \def\osgtcfcwid{0.475}%
    \renewcommand*{\do}[1]{
      \def\osgtcfcwid{##1}}%
    \dolistloop{\osgtcparamlist}%
    \setlength{\osgleftcolwid}{\osgtcfcwid\textwidth}
    \setlength{\osgrightcolwid}{0.97\textwidth}
    \addtolength{\osgrightcolwid}{-\osgtcfcwid\textwidth}
    \def\nextcolumn{\column{\osgrightcolwid}}
    \begin{columns}[\osgtcalignparam]
      \column{\osgleftcolwid}
    }{
    \end{columns}%\undef{\osgleftcolwid}\undef{\osgrightcolwid}
  }
}
%%%
\newcommand{\tikzanchor}[2]{%
  \tikz[baseline=(#2.base),remember picture]{\node[outer sep=0,inner sep=0pt](#2){#1};}\xspace%
}
%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Einfache Listen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
\RequirePackage{enumitem}
\RequirePackage{environ}

\iftoggle{osgscript}{}{
  \setlist[itemize]{label=\usebeamerfont*{itemize item}%
    \usebeamercolor[fg]{itemize item}
    \usebeamertemplate{itemize item}}
  % \setlist[itemize,1]{leftmargin=*}
  \setlist[enumerate]{%
    label=\protect\usebeamerfont{enumerate item}%
    \protect\usebeamercolor[fg]{enumerate item}%
    \insertenumlabel.}
  \setlist[description]{font=\protect\usebeamercolor[fg]{structure}} %
    %label=%\protect\usebeamerfont{description item}%
     %\protect\usebeamercolor[fg]{description item}%
     %\protect\usebeamercolor[fg]{structure}%
    %\insertdescriptionitem}
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Literaturreferenzen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
\RequirePackage{fontawesome}
\newcommand{\papericon}{\textcolor{infgreen}{\faLeanpub}}
\newcommand{\bookicon}{\textcolor{infgreen}{\faBook}}
\newcommand{\webicon}{\textcolor{infgreen}{\faLink}}
\newlength\osg@widestlit%
\RequirePackage{needspace}
\RequirePackage[%
citestyle=alphabetic-verb,
bibstyle=alphabetic-verb,
backend=biber,
%hyperref=true
]{biblatex}
\ifdefstring{\osg@stdbib}{none}{
}{
  \addbibresource{../../../Common/Library/\osg@stdbib}
}

\global\setlength\osg@widestlit{6em}%
\newlist{literaturelist}{description}{1}
\setlist[literaturelist]{font=\mdseries,
  leftmargin=\dimexpr\osg@widestlit+0.5em\relax,
  labelindent=0pt,
  labelwidth=\osg@widestlit}

\let\origcite=\cite
\let\origfullcite=\fullcite

% \renewcommand*{\cite}[2][]{%
%   % \ifbeamer@inlecture% Vermeidet Referenzen, wenn die Vorlesung nicht aktiv ist
%   \origcite[#1]{#2}%
%   % \fi%
% }
% \renewcommand*{\fullcite}[2][]{%
%   % \ifbeamer@inlecture% Vermeidet Referenzen, wenn die Vorlesung nicht aktiv
%   % ist
%   \origfullcite[#1]{#2}
%   % \fi%
% }

\newcommand{\bookitem}[2][]{
  % \begin{litlistitem}
  \item [\bookicon~\cite{#2}]
  % \hfill]
  % ]
   \AtNextCitekey{\clearfield{url}\clearfield{doi}\clearfield{issn}\clearfield{isbn}\clearfield{keywords}}
  \fullcite[#1]{#2}
  % \end{litlistitem}
}
\newcommand{\paperitem}[2][]{
  % \begin{litlistitem}
  \item[\papericon~\cite{#2}] 
   %\AtNextBibliography{\clearfield{url}\clearfield{doi}\clearfield{issn}\clearfield{isbn}\clearfield{keywords}}
   \AtNextCitekey{\clearfield{url}\clearfield{doi}\clearfield{issn}\clearfield{isbn}\clearfield{keywords}}
  \fullcite[#1]{#2}
  % \end{litlistitem}
}
\newcommand{\webitem}[2][]{
  % \begin{litlistitem}
  \item[\webicon~\cite{#2}]
  \AtNextCitekey{\clearfield{doi}\clearfield{issn}\clearfield{isbn}\clearfield{keywords}}
  \fullcite[#1]{#2}
  % \end{litlistitem}
}
\newcommand{\bibcomment}[2][\ldeen{Anm:}{rem:}]{%\vspace{-1.2ex}
  \item[\scriptsize\hfill\grave{#1}] {\scriptsize \rmfamily \em #2\par}
}
\newcommand{\bibprolog}[1]{
  % \vspace{.5ex plus .5ex}
  \protect\needspace{3\baselineskip} 
  \item[]\sbf{#1}
}

% \RequirePackage{osgbeamercommon}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Anmerkungen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\iftoggle{osgscript}{
  \def\Note#1{}
}{
  \def\Note#1{\beamer@inframenote[item]{#1}}
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Kategorien
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Benötigt die Installation von coloremoji (siehe: https://github.com/alecjacobson/coloremoji.sty)
\ifbool{osgoptionnocategory}{
  % Categorien sind deaktiviert
  \newcommand{\newcategory}[2]{}
  \newcommand<>{\markcategory}[1]{}
}{
  \newcommand{\newcategory}[2]{%
    % #1: Name
    % #2: Bild
    \csgdef{caticon#1}{\includegraphics[height=.8cm]{#2}}%
    \csgdef{osg@cat#1}{
      \begin{tikzpicture}[overlay]
        \node[anchor=south east] at(current page.south east){\csuse{caticon#1}};
      \end{tikzpicture}
    }%
  }
  \newcommand{\osg@catnone}{}
  \newcategory{concept}{1F4A1}
  \newcategory{algorithm}{1F528}
  \newcategory{analysis}{1F52C}
  \newcommand<>{\markcategory}[1]{
    \only#2{\letcs{\osg@catexecute}{osg@cat#1}}
  }
  \let\osg@catexecute=\osg@catnone
  \AfterTitle{%
    \addtobeamertemplate{headline}{}{\osg@catexecute}
  }
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Titeldaten
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\iftoggle{osgscript}{
  \global\let\@osg@original@author=\author
  \global\let\@osg@original@title=\title
  \renewcommand{\author}[2][]{
    \ifblank{#1}{
      \xdef\osgshortauthor{#2}
    }{
      \xdef\osgshortauthor{#1}
    }
    %\@osg@original@author{#2}
    \gdef\osgauthor{#2}
    \gdef\@author{#2}
  }
  \renewcommand{\title}[2][]{
    \ifblank{#1}{
      \xdef\osgshorttitle{#2}
    }{
      \xdef\osgshorttitle{#1}
    }
    %\@osg@original@title{#2}
    \gdef\osgtitle{#2}
    \gdef\@title{#2}
  }
  \gdef\lehrveranstaltung{\title}
}{
  \gdef\lehrveranstaltung{\subtitle}
}
\newcommand{\setfirstlecnumber}[1]{\gdef\firstlecturenumber{#1}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Liest Titeldaten aus externer Datei ein
\typeout{*** Test lectdates}
\IfFileExists{lectdates}{%
  \typeout{*** Reading lectdates}
  \input{lectdates}
}{
  \lehrveranstaltung{Please set up ../Include/lectdates.tex!}
  \author[A. Nonym]{Anton Nonym}
  \institute[Prof. BS]{Professur Betriebssysteme}
  \date{\today}
  \tucurl[osg.informatik.tu-chemnitz.de]{http://osg.informatik.tu-chemnitz.de}
  \setfirstlecnumber{1}
}
\setcounter{chapter}{\firstlecturenumber}
%
\let\osg@origina@Roman=\Roman
\renewcommand{\Roman}[1]{%
  \ifnum\value{#1}=0\relax0\else\osg@origina@Roman{#1}\fi}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Beziehungen außerhalb des aktuellen Directories:
%  - Korrektur der Kapitelnummer
%  - Externe Referenzen
% Wird im Paket osgbeamerexternal.sty realisiert
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\addtocounter{chapter}{-2} % -1 => die Directory-Zählung fängt mit 1 an, und
                           % -1 => der Zähler wird zu Lecture-Begin inkrementiert 
\ifbool{osgoptionstandalone}{
  \newcommand{\xref}[2][]{\ref{#2}}
}{
%  \RequirePackage{osgbeamerexternal}
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Debug
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
\newcommand{\currentfontsize}{\f@size}
% %%% Local Variables:
% %%% mode: latex
% %%% End:
