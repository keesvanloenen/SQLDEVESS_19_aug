1. Je inspecteert bij de klant de _Transactions_ tabel:
   ![Transactions Columns](/transactions-columns.png)  
   Waarom staat er iets vóór `decimal` en `char`?

1. Is een clustered index enkel toegestaan op primaire sleutels? Waarom wel, waarom niet?

1. Welke structuur heeft doorgaans de beste insert performance?  
   a. Clustered index op een oplopende identity  
   b. Clustered index op een random GUID  
   c. Heap zonder indexen  
   d. Heap met tenminste één nonclustered index

1. Waar of niet waar:  
   a. Een **clustered index** bepaalt de logische volgorde van de rijen in een tabel (de data is de index)  
   b. Een **nonclustered index** bepaalt de logische volgorde van de rijen in een tabel (de data is de index)  
   c. Een **clustered index** is een aparte datastructuur naast de tabel die alleen verwijzingen naar de rijen bevat.  
   d. Een **nonclustered index** is een aparte datastructuur naast de tabel die alleen verwijzingen naar de rijen bevat.  

1. Welke entiteit bevat informatie over de verdeling van waarden in kolommen (zoals histogrammen en dichtheid)?  
   a. De clustered index  
   b. De Index Allocation Map (IAM)  
   c. Het execution plan  
   d. De statistics

1. Na een initiële insert van 650.000 records in een tabel bij de klant lijkt het ophalen van data een eeuwigheid te duren. Dat was op development niet het geval. Wat is de meest waarschijnlijke oorzaak?

1. De opdrachtgever wil dat jij een kolom aan de resultaatset toevoegd met meta-informatie. Zij weet dan wie de query wanneer en op welke database heeft uitgevoerd. Je probeert het volgende, maar krijgt een error:

   ```sql
   SELECT
     ORIGINAL_LOGIN() + ' ' + DB_NAME() + ' ' + SYSDATETIME() AS meta
     , *
   FROM Sales.Accounts;
   ```

   Los het op.

1. Een collega klaagt over hekjes in een script. Hij vraagt om hulp. Wat zijn: **`#Urgent`** en **`##LastYear`**??

1. Data kan worden opgehaald via een `VIEW`, `TABLE VALUED FUNCTION` of een `STORED PROCEDURE`. Beschrijf de belangrijkste verschillen.

1. Welke uitspraak over DML-triggers in SQL Server is juist?

    a. Er zijn 3 soorten: BEFORE, AFTER en INSTEAD OF.  
    b. Een INSTEAD OF-trigger vervangt de oorspronkelijke DML-actie. Wil je die actie alsnog laten plaatsvinden, dan moet je dat expliciet in de trigger programmeren.  
    c. Een trigger draait in een eigen, losstaande transactie. Een ROLLBACK in de trigger heeft daarom geen effect op het oorspronkelijke INSERT/UPDATE/DELETE-statement.  
    d. Per tabel kun je maximaal één AFTER-trigger per actie (insert, update, delete) definiëren.  

1. Gegeven de volgende tabellen en trigger:

```sql
CREATE TABLE Bestelling (Id INT PRIMARY KEY, Bedrag DECIMAL(10,2));
CREATE TABLE AuditLog  (Id INT, Actie VARCHAR(20), Tijdstip DATETIME);
GO

CREATE TRIGGER trg_BestellingAudit ON Bestelling
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (Id, Actie, Tijdstip)
    SELECT Id, 'INSERT', GETDATE()
    FROM ???;
END
```

Welke tabel hoort op de plaats van ??? te staan om de zojuist toegevoegde rijen te loggen?

a. Bestelling  
b. inserted  
c. deleted  
d. updated  
