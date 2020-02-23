-- =============================================
-- Author:		Ed
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Edi_checkTimeDiffInCandle] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @Waehrung varchar(10),@CandleType varchar(20),@CandleTypeID int, @sql nvarchar(1000), @dates date, @datesAlt date= null, @diffTage int, @weekDay int
	

	/*###################*/
	



	Declare cur_waehrungenTables Cursor FOR
	
	select Waehrung,CandleType,CandleTypeID
	from [TESTdbVerwaltung].[dbo].tblWaehrungen 
	cross join [TESTdbVerwaltung].[dbo].CandleType
	where AktiveInMarket=1 
	AND WaehrungsID=1 and CandleTypeID =5
	order by Waehrung 


	OPEN cur_waehrungenTables

	Fetch NEXT FROM cur_waehrungenTables
	INTO @Waehrung,@CandleType,@CandleTypeID



	WHILE @@FETCH_STATUS=0
		BEGIN
				
			/*###########################CHECKEN DER DATENANKUFT VOM DATUM HER############################################################################*/
			-- '+@Waehrung+'_'+@CandleType+ '	
			SET @sql=N'truncate table datesCheck insert into datesCheck select Datum from (select distinct(FORMAT([Time],''yyyy.MM.dd'')) Datum from '+@Waehrung+'_'+@CandleType+ ') as t order by Datum'


			-- Ergebnisse aus der Tabelle
			execute sp_executesql @sql 

				Declare cur_datesCheck Cursor FOR
				select dates from datesCheck order by dates
		
			
				OPEN cur_datesCheck

				Fetch NEXT FROM cur_datesCheck
				INTO @dates



				WHILE @@FETCH_STATUS=0
					BEGIN

						if @datesAlt is null -->erster Wert
							SET @datesAlt=@dates
					
						else
							BEGIN
								SET @diffTage=DATEDIFF(day,@datesAlt,@dates)
								SET @weekDay=DATEPART(weekday,@dates)
							
								IF @weekDay=7 AND @diffTage !=2 -- > Sonntag
									PRINT 'TagesDifferenz Freitag bis Sonntag der Waehrung '+@Waehrung+'_'+@CandleType+ ' muss immer 2 Tage betragen in diesem Fall betraegt die Differenz '+cast(@diffTage as varchar(50)) +' Datum vor Sonntag: '+cast(@datesAlt as varchar(50))+' SonntagsDatum :'+cast(@dates as varchar(50)) 

								ELSE IF @weekDay!=7 AND @diffTage>1
									PRINT 'TagesDifferenz Montag bis Freitag der Waehrung '+@Waehrung+'_'+@CandleType+ ' muss immer 1 Tag betragen in diesem Fall betraegt die Differenz '+cast(@diffTage as varchar(50)) +' Datum 1: '+cast(@datesAlt as varchar(50))+' Datum 2:'+cast(@dates as varchar(50)) 
							 

								SET	@datesAlt=@dates
							END



						Fetch NEXT FROM cur_datesCheck
						INTO @dates


					END



			CLOSE cur_datesCheck;  
			DEALLOCATE cur_datesCheck;


			Fetch NEXT FROM cur_waehrungenTables
			INTO @Waehrung,@CandleType,@CandleTypeID

			

		END


CLOSE cur_waehrungenTables;  
DEALLOCATE cur_waehrungenTables;  
END
