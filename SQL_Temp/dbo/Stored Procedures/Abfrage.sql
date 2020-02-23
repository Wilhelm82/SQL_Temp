/*###########################Tabelle löschen*/

--hier mit Transaction eine Tabelle löschen:
begin transaction Test

truncate table [dbo].[Qualitätscheck]-- opretaion   [Statistik_2]
select * from [dbo].[Qualitätscheck]  -- Ergebnis anschauen
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