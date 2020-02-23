/*###########################Tabelle löschen*/

--hier mit Transaction eine Tabelle löschen:
begin transaction Test

truncate table [dbo].[Quali_laetzte_Pruefung]-- opretaion
select * from [dbo].[Quali_laetzte_Pruefung]  -- Ergebnis anschauen
---------------------------------
commit tran Test -- zufrieden (nur das ausführen)

--rollback tran Test -- nicht zufrieden  (nur das ausführen)


/*###########################führe Prozedur aus*/
DECLARE @RC int
-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[Qualitätsprüfung] 
GO

/*###########################öffne Statistik*/
SELECT *
  FROM [TestDBWaehrungen].[dbo].[Statistik_2]