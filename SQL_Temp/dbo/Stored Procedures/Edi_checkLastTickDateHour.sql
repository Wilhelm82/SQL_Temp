-- =============================================
-- Author:		Ed
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Edi_checkLastTickDateHour] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @Waehrung varchar(10),@CandleType varchar(20),@CandleTypeID int, @sql nvarchar(1000),
	@paramDef nvarchar(200),@day int , @month int , @year int,@lastFridayDay datetime,
	@lastFrDay int,@lastFrMonth int,@lastFrYear int
	
	/*###################*/
	



	Declare cur_waehrungenTables Cursor FOR
	
	select Waehrung,CandleType,CandleTypeID
	from [TESTdbVerwaltung].[dbo].tblWaehrungen 
	cross join [TESTdbVerwaltung].[dbo].CandleType
	where AktiveInMarket=1
	order by Waehrung 


	OPEN cur_waehrungenTables

	Fetch NEXT FROM cur_waehrungenTables
	INTO @Waehrung,@CandleType,@CandleTypeID

	SET @paramDef=N'@day int OUTPUT, @month int OUTPUT, @year int OUTPUT'

	WHILE @@FETCH_STATUS=0
		BEGIN
				
			/*###########################CHECKEN DER DATENANKUFT VOM DATUM HER############################################################################*/
				
			SET @sql=N'SELECT @day=DATEPART(DAY,max([Time])), @month=DATEPART(MONTH,max([Time])), @year=DATEPART(YEAR,max([Time])) FROM '+@Waehrung+'_'+@CandleType

			-- Ergebnisse aus der Tabelle
			execute sp_executesql @sql ,@paramDef,@day=@day OUTPUT,@month=@month OUTPUT,@year=@year OUTPUT

			IF ( @CandleTypeID IN (2,3,4,5,6,7))  
			Begin
			
					-- Letztes Freitag
					SELECT @lastFridayDay=DATEADD(DAY, -1 - ((DATEPART(WEEKDAY, getdate()) + @@DATEFIRST) % 7), CAST(getdate() AS DATE))
					SELECT @lastFrDay=Day(@lastFridayDay),@lastFrMonth=Month(@lastFridayDay),@lastFrYear=Year(@lastFridayDay)

					IF (@lastFrDay!=@day OR @lastFrMonth!=@month OR @lastFrYear!=@year)
						PRINT 'Die Tabelle '+@Waehrung+'_'+@CandleType+' SOLL: '+cast(@lastFrDay as varchar(10))+'.'+cast(@lastFrMonth as varchar(10))+'.'+cast(@lastFrYear as varchar(10))+char(13)+
						'IST: '+cast(@day as varchar(10))+'.'+cast(@month as varchar(10))+'.'+cast(@year as varchar(10))+char(13)

			END

			ELSE IF (@CandleTypeID=1)  /* Dayly*/
				Begin
							-- Letztes Mittwoch
						SELECT @lastFridayDay=DATEADD(DAY, -3 - ((DATEPART(WEEKDAY, getdate()) + @@DATEFIRST) % 7), CAST(getdate() AS DATE))
						SELECT @lastFrDay=Day(@lastFridayDay),@lastFrMonth=Month(@lastFridayDay),@lastFrYear=Year(@lastFridayDay)
						
						IF (@lastFrDay!=@day OR @lastFrMonth!=@month OR @lastFrYear!=@year)
							PRINT 'Die Tabelle '+@Waehrung+'_'+@CandleType+' SOLL: '+cast(@lastFrDay as varchar(10))+'.'+cast(@lastFrMonth as varchar(10))+'.'+cast(@lastFrYear as varchar(10))+char(13)+
							'IST: '+cast(@day as varchar(10))+'.'+cast(@month as varchar(10))+'.'+cast(@year as varchar(10))+char(13)
											
				END

				ELSE IF (@CandleTypeID=1)  /* Monthly*/
					Begin
		
							-- Heute minus 2 Monate
							SELECT @lastFridayDay=DATEADD(MONTH, -2, CAST(getdate() AS DATE))
							SELECT @lastFrDay=Day(@lastFridayDay),@lastFrMonth=Month(@lastFridayDay),@lastFrYear=Year(@lastFridayDay)

							IF ( @lastFrMonth!=@month OR @lastFrYear!=@year)
								PRINT 'Die Tabelle '+@Waehrung+'_'+@CandleType+' SOLL: '+cast(@lastFrDay as varchar(10))+'.'+cast(@lastFrMonth as varchar(10))+'.'+cast(@lastFrYear as varchar(10))+char(13)+
								'IST: '+cast(@day as varchar(10))+'.'+cast(@month as varchar(10))+'.'+cast(@year as varchar(10))+char(13)

					
					END

				ELSE IF (@CandleTypeID=9)  /*Weekly*/
					Begin
		
							-- Heute minus 2 Monate
							SELECT @lastFridayDay=DATEADD(WEEK, -3, CAST(getdate() AS DATE))
							SELECT @lastFrDay=Day(@lastFridayDay),@lastFrMonth=Month(@lastFridayDay),@lastFrYear=Year(@lastFridayDay)
							IF ( @lastFrMonth!=@month OR @lastFrYear!=@year)
								PRINT 'Die Tabelle '+@Waehrung+'_'+@CandleType+' SOLL: '+cast(@lastFrDay as varchar(10))+'.'+cast(@lastFrMonth as varchar(10))+'.'+cast(@lastFrYear as varchar(10))+char(13)+
								'IST: '+cast(@day as varchar(10))+'.'+cast(@month as varchar(10))+'.'+cast(@year as varchar(10))+char(13)

					
					END

	
		



			Fetch NEXT FROM cur_waehrungenTables
			INTO @Waehrung,@CandleType,@CandleTypeID

			

		END


CLOSE cur_waehrungenTables;  
DEALLOCATE cur_waehrungenTables;  
END
