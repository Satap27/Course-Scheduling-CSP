# Course Scheduling CSP
## Descrizione
Il programma permette di ottenere una programmazione degli orari delle lezioni valida, dato un insieme di parametri.

## Utilizzo
Per utilizzare il software è necessario avere installato nel proprio dispositivo [MiniZinc](https://www.minizinc.org/doc-2.5.3/en/installation.html).

L'eseguibile [schedule.mnz](bin/schedule.mnz) implementa il modello MiniZinc del problema e si aspetta di ricevere i parametri da un _datafile_. Il repository contiene due datafile di esempio ([ingegneria.dnz](bin/ingegneria.mnz) e [umanistica.mnz](bin/umanistica.dnz)), ma può essere sottomesso un problema personalizzato definendo i seguenti parametri nel file .dnz:
 * **daily_hours:** rappresenta il numero di ore in cui ogni aula è disponibile giornalmente;
 * **days:** i giorni della settimana in cui le aule sono aperte;
 * **rooms:** il numero totale di aule a disposizione;
 * **courses:** il set di corsi ai quali afferiscono gli insegnamenti di interesse;
 * **teachings:** il set degli insegnamenti che devono essere programmati settimanalmente;
 * **professors:** il numero totale di professori;
 * **H:** il numero massimo di ore giornaliere di insegnamento per i professori;
 * **t1:** il numero minimo di ore giornaliere di inegnamento di una materia (se presente quel giorno);
 * **t2:** il numero massimo di ore giornaliere di inegnamento di una materia (se presente quel giorno);
 * **sequential:** un booleano che impone se **true** di avere le ore di insegnamento giornaliere per ogni materia contigue;
 * **course:** una lista che associa ad ogni insegnamento l'indice del suo corso;
 * **teaching_hours:** una lista che associa ad ogni insegnamento le ore di lezione settimanali;
 * **professor:** una lista che associa ad ogni insegnamento l'indice del suo professore.
 
Un file così definito può essere incluso nel modello (`include "datafile.dzn"`). Più datafile possono essere inclusi nello stesso modello, ma lo stesso paramentro non può essere definito più di una volta!

Per la risoluzione è suggerito il _solver_ [Geocode](https://www.gecode.org/), già implementato nel bundle MiniZinc.

## Note
I datafile di esempio rappresentano una libera interpretazione di alcuni insegnamenti della scuola di Ingegneria e della scuola di Studi Umanistici dell'[Università degli Studi di Firenze](https://www.unifi.it/).
