# Matlab GUI for signal quality annotation 

Small interface in Matlab used in my thesis. The objective is to annotate data acording to their SNR and presence of fetal signal. The GUI can be deployed by simpling compiling the project annotator.prj.

<center><a href="http://fernando.planetarium.com.br/wp-content/uploads/2014/01/ssgui-1.png"><img src="http://fernando.planetarium.com.br/wp-content/uploads/2014/01/ssgui-1-1024x543.png" alt="ssgui" width="640" height="339" class="aligncenter size-large wp-image-3466" /></a></center>

Important features:
- Data is contained in compressed .zip file. Inside such file segments to be annotated should be contained in graphical format (.jpg). The compressed file is extracted to a "hidden" file in either Windows or Linux.
- Output is a .dat file, which is nothing more than a text file. Annotation procedure can be interupted at any time and continued, as long as the path to this file is given.
- Shortcuts for annotation are available for noise levels(keys: 1,2,3,4,5) and fetal presence (a,s,d,f).

Tests performed using
- Matlab 2013a - 2016a
- Windows 7 / Ubuntu


