-- =============================================
-- Author:		<Author,,Name> Wilhelm		
-- Create date: <Create Date,,> 26.12.2019
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Qualitätsprüfung] 
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @WaehrungsID int, @Waehrung varchar(10), @CandleTypeID int, @CandleType varchar(50), @VON date, @VONLog date, @BIS date, @weekDay int,
	@sql nvarchar(4000), @Time datetime, @AltTime datetime, @WeekDayName varchar(50), @Sollwert int, @Istwert int, 
	@Abweichung int, @Kommentar nvarchar(4000), @ParmDefinition nvarchar(4000), @Prüf_ID int, @1VON date
	
	Declare cur_waehrungenTables Cursor FOR
	
	select Waehrung,CandleType,CandleTypeID,WaehrungsID
	from [TESTdbVerwaltung].[dbo].[tblWaehrungen] 
	cross join [TESTdbVerwaltung].[dbo].[CandleType]
	where AktiveInMarket=1 
	--AND WaehrungsID=1 and CandleTypeID IN (1,2,8)
	AND WaehrungsID=1 and CandleTypeID =9
	order by Waehrung 

	OPEN cur_waehrungenTables

	Fetch NEXT FROM cur_waehrungenTables
	INTO @Waehrung,@CandleType,@CandleTypeID,@WaehrungsID
	 
	WHILE @@FETCH_STATUS=0
	BEGIN--Währungen durchlaufen
		
		--###########  Abfrage VON Wert aus der Tabelle [Qualitätscheck]  ###########
		SELECT @VON = MAX([BIS]) FROM [TestDBWaehrungen].[dbo].[Qualitätscheck] WHERE WaehrungsID=@waehrungsID AND CandleTypeID=@CandleTypeID
		--PRINT 'Print1: von: ' +cast(@VON as varchar(50))
		SET @VONLog=@VON
				
		--###########  Abfrage BIS Wert letzter Eintrag in der Währungstabelle   ###########
		--SELECT @BIS = cast(MAX([Time]) as date) from  [TestDBWaehrungen].[dbo].EURUSD_Minutes_1
		SET @ParmDefinition = N'@BIS date OUTPUT';
		set @sql='SELECT @BIS = CAST(MAX([Time]) as date) FROM '+ @Waehrung +'_'+@CandleType;
		execute sp_executesql @sql,	@ParmDefinition, @BIS=@BIS OUTPUT;
				
					
		IF (@VON <> @BIS) 
			BEGIN

				WHILE (@VON <= @BIS) BEGIN		
					--###########   Sollwertberechnung          #######################
					EXEC Qualitätsprüfung_Sollwert_Ermittlung @VON, @weekDay output, @CandleTypeID, @Sollwert output

					--###########   @WeekDayName => z.B.:Freitag      ######################
					EXEC Qualitätsprüfung_SET_weekDayName @weekDay, @WeekDayName output
					
					--###########   Istwertberechnung        ##########################		
					EXEC Qualitätsprüfung_Istwert_Ermittlung @Istwert output, @Waehrung, @CandleType, @VON, @CandleTypeID, @weekDay
			
					--###########   Abweichung        #################################	
					SET @Abweichung = @Istwert - @Sollwert
					
					/*###########   schreibe in die Tabelle Quali.Statistik_2:    ###########	*/
					IF (@Abweichung != 0) Begin
							SET @Kommentar = 'Die Differenz beträgt :'+cast(@Abweichung as varchar(50))			
							Insert Into Quali.Statistik_2([Waehrung], [CandleTypeID], [Wochentag], [Time], [Soll_Kerzen], [Ist_Kerzen], [Abweichung], [Kommentar])
											VALUES (@Waehrung,   @CandleType,   @WeekDayName, @VON , @Sollwert   , @Istwert    , @Abweichung,  @Kommentar)
					END
			
					--###########   Print        ######################################
					IF (@Abweichung != 0) Begin
						PRINT 'Print1: von: ' +cast(@VON as varchar(50))+ ' bis: ' +cast(@BIS as varchar(50))+ ' Wochentag: ' +cast(@WeekDayName as varchar(50))
						PRINT 'Print2: Waehrung: '+@Waehrung+'_'+@CandleType+' | '+CONVERT(varchar, @Sollwert, 120)+' | '+CONVERT(varchar, @Istwert, 120)+' | '+CONVERT(varchar, @Abweichung, 120)		
					END		 
			
					--###########   Erhöhung_Prüfen      #############################
					Exec Qualitätsprüfung_Erhöhung_Prüfen @VON output, @CandleTypeID

				END --<<--While


				--###########   schreibe in die Tabelle Qualitätscheck:  ########### 	
				--PRINT 'Print3: '+cast(@WaehrungsID as varchar(50))+' | '+cast(@Waehrung as varchar(50))+' | '+cast(@CandleTypeID as varchar(50))+' | '+cast(@CandleType as varchar(50))+' | '+cast(@VON as varchar(50))+ ' bis: ' +cast(@BIS as varchar(50))
				Insert Into Qualitätscheck ([WaehrungsID], [Waehrung], [CandleTypeID], [CandleType], [VON], [BIS])
									VALUES (@WaehrungsID,  @Waehrung,  @CandleTypeID,  @CandleType,  @VONLog,  @BIS)
				
		END

		Fetch NEXT FROM cur_waehrungenTables
		INTO @Waehrung,@CandleType,@CandleTypeID,@WaehrungsID
	END



CLOSE cur_waehrungenTables;  
DEALLOCATE cur_waehrungenTables;
END