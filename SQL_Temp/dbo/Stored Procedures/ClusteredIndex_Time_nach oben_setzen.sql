-- =============================================
-- Author:		Wilhelm Paul
-- Create date: 09.10.2019
-- Description:	ClusteredIndex setzen
-- =============================================
CREATE PROCEDURE [dbo].[ClusteredIndex_Time_nach oben_setzen] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN

	DECLARE @Waehrung varchar(10),@CandleType varchar(20),@CandleTypeID int,@WaehrungsID int, @sql nvarchar(1000), @dates date, @datesAlt date= null, @diffTage int, @weekDay int
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	Declare cur_waehrungenTables Cursor FOR
	
	select Waehrung,CandleType,CandleTypeID,@WaehrungsID
	from [TestDBVerwaltung].[dbo].tblWaehrungen 
	cross join [TestDBVerwaltung].[dbo].CandleType
	where AktiveInMarket=1 
	--AND WaehrungsID = 2 AND CandleTypeID IN (25)
	--AND WaehrungsID = 5 AND CandleTypeID IN (1,2,25,20,21,3,23,24,4,14,16,6,10,18,11,7,12,5,13,8,9)
    -- AND WaehrungsID = 5 AND CandleTypeID = 20
    --AND WaehrungsID in (3,6) AND CandleTypeID =1
	--AND WaehrungsID=2 and CandleTypeID =1      --<--hier kann man auskommentieren, damit alle Waehrungen durchlaufen werden!
	order by Waehrung 


	OPEN cur_waehrungenTables

	Fetch NEXT FROM cur_waehrungenTables
	INTO @Waehrung,@CandleType,@CandleTypeID,@WaehrungsID



	WHILE @@FETCH_STATUS=0
		BEGIN
			--IF (@WaehrungsID = 2 AND @CandleTypeID IN (1,2))
			--	BEGIN
			--		Fetch NEXT FROM cur_waehrungenTables
			--		INTO @Waehrung,@CandleType,@CandleTypeID,@WaehrungsID
			--		continue

			--	END

			
					
			set @sql='

					ALTER TABLE '+ @Waehrung +'_'+@CandleType+ ' DROP CONSTRAINT IF EXISTS [PK_'+ @Waehrung +'_'+@CandleType+'] WITH ( ONLINE = OFF )
			
					SET ANSI_PADDING ON
					
					DROP INDEX IF EXISTS '+ @Waehrung +'_'+@CandleType+ '.[ClusteredIndex-'+ @Waehrung +'_'+@CandleType+'];
					

					CREATE UNIQUE CLUSTERED INDEX [ClusteredIndex-'+ @Waehrung +'_'+@CandleType+'] ON '+ @Waehrung +'_'+@CandleType+ '
						(
						  [Time] ASC,
						  [Open] ASC,
						  [Close] ASC,
						  [High] ASC,
						  [Low] ASC
						  
						)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			    	'


			execute sp_executesql @sql 

			
			Fetch NEXT FROM cur_waehrungenTables
			INTO @Waehrung,@CandleType,@CandleTypeID,@WaehrungsID
		
		END

	CLOSE cur_waehrungenTables;  
	DEALLOCATE cur_waehrungenTables; 

END


---------------------------------------------------------------------------------------------------


