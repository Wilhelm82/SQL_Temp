-- =============================================
-- Author:		Wilhelm Paul
-- Create date: 10.08.2019
-- Description:	Dubletten entfernen
-- =============================================
CREATE PROCEDURE [dbo].[Ddubletten_Entfernen] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN

	DECLARE @Waehrung varchar(10),@CandleType varchar(20),@CandleTypeID int, @sql nvarchar(1000), @dates date, @datesAlt date= null, @diffTage int, @weekDay int
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	Declare cur_waehrungenTables Cursor FOR
	
	select Waehrung,CandleType,CandleTypeID
	from [TestDBVerwaltung].[dbo].tblWaehrungen 
	cross join [TestDBVerwaltung].[dbo].CandleType
	where AktiveInMarket=1 
	--AND WaehrungsID=5 and CandleTypeID =20      --<--hier kann man auskommentieren, damit alle Waehrungen durchlaufen werden!
	order by Waehrung 


	OPEN cur_waehrungenTables

	Fetch NEXT FROM cur_waehrungenTables
	INTO @Waehrung,@CandleType,@CandleTypeID



	WHILE @@FETCH_STATUS=0
		BEGIN
		--delete ohne importedTimeStamp:
		--wo alles gleich ist entfernen!:
			
		set @sql='DELETE FROM '+ @Waehrung +'_'+@CandleType+ '
			WHERE EXISTS
			(SELECT * FROM ' + @Waehrung +'_'+@CandleType+ ' Kopie WHERE '
				+ @Waehrung +'_'+@CandleType+ '.[Open] = Kopie.[Open] AND ' 
				+ @Waehrung +'_'+@CandleType+ '.[Close] = Kopie.[Close] AND ' 
				+ @Waehrung +'_'+@CandleType+ '.High = Kopie.High AND ' 
				+ @Waehrung +'_'+@CandleType+ '.Low = Kopie.Low AND ' 
				+ @Waehrung +'_'+@CandleType+ '.[Time] = Kopie.[Time] AND ' 
				+ @Waehrung +'_'+@CandleType+ '.Volume = Kopie.Volume  AND ' 
				+ @Waehrung +'_'+@CandleType+ '.CandleDataSetID < Kopie.CandleDataSetID)'

			execute sp_executesql @sql 

		--delete & behalte wo Volumen max ist:
		--delete importedTimeStamp== && time==: max(Volume):  
		
		set @sql='DELETE FROM '+ @Waehrung +'_'+@CandleType+ '
			WHERE EXISTS
			(SELECT * FROM ' + @Waehrung +'_'+@CandleType+ ' Kopie WHERE '
				+ @Waehrung +'_'+@CandleType+ '.[Time] = Kopie.[Time] AND ' 
				+ @Waehrung +'_'+@CandleType+ '.importedTimeStamp = Kopie.importedTimeStamp AND '
				+ @Waehrung +'_'+@CandleType+ '.Volume < Kopie.Volume)'

			execute sp_executesql @sql 


		--delete importedTimeStamp!= && time==: den mit dem älteren importdatum behalten
		set @sql='DELETE FROM '+ @Waehrung +'_'+@CandleType+ '
			WHERE EXISTS
			(SELECT * FROM ' + @Waehrung +'_'+@CandleType+ ' Kopie WHERE '
				+ @Waehrung +'_'+@CandleType+ '.[Time] = Kopie.[Time] AND '
				+ @Waehrung +'_'+@CandleType+ '.importedTimeStamp > Kopie.importedTimeStamp)'

			execute sp_executesql @sql 

		
		
			Fetch NEXT FROM cur_waehrungenTables
			INTO @Waehrung,@CandleType,@CandleTypeID
		
		END

	CLOSE cur_waehrungenTables;  
	DEALLOCATE cur_waehrungenTables; 

END


---------------------------------------------------------------------------------------------------


