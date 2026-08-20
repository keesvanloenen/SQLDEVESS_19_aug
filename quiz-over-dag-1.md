# Quiz over dag 1

1. In SSMS wordt het volgende script gedraaid:

    ```sql
    DROP DATABASE IF EXISTS BUA;
    GO
    CREATE DATABASE BUA;
    GO
    CREATE TABLE Bonussen
    (
        Amount   decimal(8,2)
    );
    ```

    Wat is het resultaat?

1. Welke van de onderstaande uitspraken over het gebruik van `GO` in SQL Server is correct?

    a. `GO` is een Transact-SQL statement dat door de SQL Server engine wordt uitgevoerd om een transactie expliciet af te sluiten.  
    b. `GO` wordt opgeslagen als onderdeel van het queryplan zodat SQL Server bij heruitvoering dezelfde batchindeling behoudt.  
    c. Variabelen die vóór `GO` zijn gedeclareerd, blijven beschikbaar in de volgende batch zolang ze in dezelfde sessie worden uitgevoerd.  
    d. `GO` wordt door clienttools zoals SSMS geïnterpreteerd om batches te scheiden; objecten zoals procedures en views moeten elk in één batch staan.

1. Kies een (slim) **data type** voor:
    - Rood-waarde (zoals in RGB)
    - Postcode (Nederlands)
    - Geslacht ('m', 'v', 'o')
    - Straatnaam
    - Opleverdatum
    - Kortingspercentage

1. Welke service wordt **niet** meegeleverd als je SQL Server koopt?

    a. SQL Server Reporting Services (SSRS)  
    b. SQL Server Integration Services (SSIS)  
    c. SQL Server Optimization Services (SSOS)  
    d. SQL Server Analysis Services (SSAS)  

1. Welk van bovenstaande services kan worden gebruikt voor het maken en beheren van multidimensionale en tabulaire modellen voor data-analyse en business intelligence?

1. Wat is de belangrijkste functie van een **schema** in SQL Server?

    a. Het opslaan van gegevens in tabellen  
    b. Het groeperen en beveiligen van database-objecten zoals tabellen en views  
    c. Het automatisch back-uppen van databases  
    d. Het gebruik van `dbo` voorkomen

1. Welk type query heeft het meest baat bij een `PERSISTED` computed column?

    a. `SELECT`  
    b. `INSERT`  
    c. `UPDATE`  
    d. `DELETE`  

1. In een tabel _Afspraken_ mag een combinatie van _PatientID_ en _AfspraakDatumTijd_ niet dubbel voorkomen, omdat een patiënt niet twee afspraken op exact hetzelfde moment kan hebben.
Welke **constraint** kun je overwegen?

1. In plaats van een IDENTITY-kolom wil je een database object dat door meerdere tabellen gebruikt kan worden. Vul in:

    ```sql
    CREATE _________ myCounter START WITH 1 INCREMENT BY 1;
    ``` 

1. Naast _data type_ en _nullability_ zijn er nog enkele **constraint** soorten. Welke?

1. `Id` is als volgt gedefinieerd: 

    ```sql
    Id bigint PRIMARY KEY
    ```

    Mag de volgende code (en waarom wel/niet)?

    ```sql
    INSERT INTO Measurements
    (Id, Temperature, MeasuredAt)
    VALUES
    (1, 21.5, '20260105');
    ```

1. Wat gebeurt er als je een kolom met een DEFAULT constraint niet opneemt in een INSERT-statement?

    a. De invoer mislukt omdat elke kolom een waarde moet krijgen.  
    b. De waarde uit de DEFAULT constraint wordt automatisch ingevuld.  
    c. SQL Server vult altijd NULL in.  
    d. SQL Server vult voor een numeriek datatype 0 in, voor een tekst datatype '' en voor een bit 0.  

1. In een bestaande tabel _Orders_ moet een **foreign key** worden toegevoegd. Deze moet verwijzen van `Orders.CustomerId` naar `Customers.Id` en moet voldoen aan de volgende eisen:
    - Bij het verwijderen van een customer moeten alle bijbehorende orders automatisch worden verwijderd.
    - Bij het updaten van de customer-id moeten de gekoppelde orders automatisch worden aangepast.
    
    Vul in:

    ```sql
    ALTER TABLE __________
    ADD CONSTRAINT FK_Orders_Customers
    FOREIGN KEY (__________)
    REFERENCES __________(__________)
    ON DELETE __________
    ON UPDATE __________;
    ```

1. Wat is het doel van de `CAST()` functie in SQL Server?  
  a. Het samenvoegen van meerdere kolommen tot één resultaat  
  b. Het omzetten van een waarde van het ene datatype naar een ander datatype  
  c. Het afronden van numerieke waarden  
  d. Het formatteren van uitvoer voor rapportages  

1. Wat is het doel van een tabel waarvan de naam begint met een **`#`**?  

    a. Om gegevens permanent te bewaren zodat alle gebruikers ze later nog kunnen opvragen  
    b. Om tussenresultaten van een complexe bewerking op te slaan en meerdere keren te hergebruiken binnen dezelfde sessie  
    c. Automatische indexering en daardoor meestal sneller dan een gewone tabel
    d. Om een back-up te maken van een tabel voordat je die verwijdert

1. Maak een nieuwe (herbruikbare) UDF (user defined) function. Kies er één:

- **AddBackslash** (gemakkelijker)  
  retourneer een string die aan de meegegeven string een backslash toevoegt als deze er nog niet stond
- **IsStrongPassword** (uitdagender)  
  retourneer een boolean, die een meegegeven wachtwoord valideert op sterkte.  
  Een wachtwoord is sterk genoeg als het:
  - groter is dan 11 tekens
  - het tenminste een nummer bevat
  - het tenminste één hoofdletter bevat

  Hint: gebruik een `CASE`-statement, syntax:
  ```sql
  CASE
    WHEN <voorwaarde_1> THEN <resultaat_1>
    WHEN <voorwaarde_2> THEN <resultaat_2>
    ...
    ELSE <standaard_resultaat>
  END
  ```