# Tracing PrologPage

Source: https://moodleng.insa-rennes.fr/mod/page/view.php?id=3085

J'ai extrait de mon poly de cours de contraintes (en anglais) quelques transparents qui donnent des indications sur comment tracer les programmes Prolog :  
  
  * [Tracing Prolog (PDF)](https://moodleng.insa-rennes.fr/pluginfile.php/16559/mod_page/content/9/TracingProlog.pdf)



Pensez aussi à utiliser le prédicat 'spy'.

Par exemple :  
[eclipse] spy run_turing_machine/5.

Le '5' correspond à l'arité du prédicat 'run_turing_machine' (i.e. son nombre de paramètres).

Ensuite dans la trace 'l' (leap) permet de sauter au prochain événement de trace relatif à un des prédicats espionnés.  
  
La trace est à utiliser avec discernement, mais cela peut aider.

\--  
Mireille Ducassé

Last modified: Thursday, 11 September 2014, 1:26 PM
