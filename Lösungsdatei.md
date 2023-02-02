# Lösungsdatei

## Aufgabe Data Warehousing

Es soll ein Data Warehousing für folgende Auswertungen erstellt werden. Als Client wird eine
Pivot Tabelle in EXCEL verwendet. In einer externen Datenbank werden die Rohdaten gespeichert.

## Aufgabe 1:

![erd](pictures/erd.png)
Wir haben uns für ein ERD (Entity-Relationship Model) entschieden, das aus fünf Tabellen besteht. Die ersten vier Tabellen "Filialen", "Quartal", "Artikel" und "Facts" haben eine starke Beziehung miteinander und bilden das Kernstück des ERD. Diese Tabellen enthalten wichtige Informationen über die Filialen, die Verkaufsquartale, die Artikel und die Verkaufszahlen.

Die fünfte Tabelle, die als "import-rohdaten" bezeichnet wird, hat keine direkte Verbindung zu den anderen vier Tabellen. Sie wird lediglich genutzt, um Daten aus externen Quellen zu importieren und dann in die anderen Tabellen zu integrieren.

Durch die starke Beziehung zwischen den ersten vier Tabellen ist es möglich, eine Pivot Tabelle zu generieren. Das ERD ermöglicht es uns, die Daten in einer organisierten und übersichtlichen Weise zu verwalten.
