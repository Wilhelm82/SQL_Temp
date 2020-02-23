-- =============================================
-- Author:		WP
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Erstellung_Statistik] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @Waehrung varchar(10),@CandleType varchar(20),@CandleTypeID int, @sql nvarchar(1000), @dates datetime, @datesAlt datetime= null, @diffTage int, @weekDay int,
	@day int, @month int, @year int, @hour int, @minute int, @millisecond int, @StartLastWeek date, @EndLastWeek date, @StartCurWeek date, @EndCurWeek date, @Anzahl int, @WeekDayName varchar(50),
	@paramDef nvarchar(200), @Sollwert int, @Istwert int, @Abweichung int, @Show bit
	

	/*###################*/
	



	Declare cur_waehrungenTables Cursor FOR
	
	select Waehrung,CandleType,CandleTypeID
	from [TESTdbVerwaltung].[dbo].tblWaehrungen 
	cross join [TESTdbVerwaltung].[dbo].CandleType
	where AktiveInMarket=1 
	AND WaehrungsID=2 and CandleTypeID =1
	order by Waehrung 


	OPEN cur_waehrungenTables

	Fetch NEXT FROM cur_waehrungenTables
	INTO @Waehrung,@CandleType,@CandleTypeID

	--SET @paramDef=N'@day int OUTPUT, @month int OUTPUT, @year int OUTPUT'

	WHILE @@FETCH_STATUS=0
		BEGIN
					
			/*###########################Check CandeleType######################################*/
			IF (@CandleTypeID=1)
				BEGIN

				
					/*###########################CHECKEN DER DATENANKUFT VOM DATUM HER############################################################################*/
					--SET @sql=N'SELECT @day=DATEPART(DAY,max([Time])), @month=DATEPART(MONTH,max([Time])), @year=DATEPART(YEAR,max([Time])) FROM '+@Waehrung+'_'+@CandleType
					--execute sp_executesql @sql ,@paramDef,@day=@day OUTPUT,@month=@month OUTPUT,@year=@year OUTPUT	
					
					--SET @sql=N'truncate table datesCheck insert into datesCheck select Datum from (select distinct(FORMAT([Time],''yyyy.MM.dd'')) Datum from '+@Waehrung+'_'+@CandleType+ ') as t order by Datum'
					SET @sql=N'truncate table datesCheck insert into datesCheck select Datum from (select distinct([Time]) Datum from '+@Waehrung+'_'+@CandleType+ ') as t order by Datum'
					execute sp_executesql @sql 

						Declare cur_datesCheck Cursor FOR
						select dates from datesCheck order by dates
		
			
						OPEN cur_datesCheck

						Fetch NEXT FROM cur_datesCheck
						INTO @dates



						WHILE @@FETCH_STATUS=0
							BEGIN
								--ERSTER WERT #############################################################################################
								if @datesAlt is null -->erster Wert
									BEGIN
										SET @datesAlt=@dates
										SET @diffTage=DATEDIFF(day,@datesAlt,@dates)
										--set datefirst 1;
										--@weekDay ist eine Zahl 1 bis 7
										SET @weekDay =DATEPART(weekday,@dates)
											IF @weekDay = 1
												Set @WeekDayName = 'Montag'
											IF @weekDay = 2
												Set @WeekDayName = 'Dienstag'
											IF @weekDay = 3
												Set @WeekDayName = 'Mittwoch'
											IF @weekDay = 4
												Set @WeekDayName = 'Donnerstag'
											IF @weekDay = 5
												Set @WeekDayName = 'Freitag'
											IF @weekDay = 6
												Set @WeekDayName = 'Samstag'
											IF @weekDay = 7
												Set @WeekDayName = 'Sonntag'

										SET @day     =DATEPART(day,@dates)
										SET @month   =DATEPART(month,@dates)
										SET @year    =DATEPART(year,@dates)
										SET @Sollwert = 1
										SET @Istwert  = @diffTage
										SET @hour        =DATEPART(hh, @dates)
										SET @minute      =DATEPART(mi,@dates)
										SET @millisecond =DATEPART(ms,@dates)
										/*###########################schreibe in die Tabelle:########################*/
										
										SET @Abweichung = 	@Istwert -  @Sollwert
										SET @Show = 0
										if (@Istwert =3) And (@WeekDay =7)
											SET @Show = 1

										IF (@Abweichung > 0) AND (@Show = 0)
											Begin
											
												Insert Into Statistik ([Waehrung], [CandleTypeID], [Wochentag], [Day], [Month], [Year], [hour], [minute], [second],    [Soll_Kerzen], [Ist_Kerzen], [Abweichung])
												VALUES	              (@Waehrung,  @CandleType,    @WeekDayName, @day, @month,  @year,  @hour,  @minute , @millisecond  ,@Sollwert     ,@Istwert    ,@Abweichung)
											
											
												 
												PRINT 'Waehrung: '+@Waehrung+'_'+@CandleType+ '   DiffTage:'+cast(@diffTage as varchar(50)) +'   WeekDay:'+cast(@weekDay as varchar(50))+' '+cast(@WeekDayName as varchar(50))+'  Day:'+cast(@day as varchar(50))+' Month:'+cast(@month as varchar(50))+' Year:'+cast(@year as varchar(50))
											
											END
											

															
								--NÄCHSTER WERT #############################################################################################
									END	else --> nächster Wert
									BEGIN
										SET @diffTage=DATEDIFF(day,@datesAlt,@dates)
										--set datefirst 1;
										SET @weekDay =DATEPART(weekday,@dates)
											IF @weekDay = 1
												Set @WeekDayName = 'Montag'
											IF @weekDay = 2
												Set @WeekDayName = 'Dienstag'
											IF @weekDay = 3
												Set @WeekDayName = 'Mittwoch'
											IF @weekDay = 4
												Set @WeekDayName = 'Donnerstag'
											IF @weekDay = 5
												Set @WeekDayName = 'Freitag'
											IF @weekDay = 6
												Set @WeekDayName = 'Samstag'
											IF @weekDay = 7
												Set @WeekDayName = 'Sonntag'

										SET @day     =DATEPART(day,@dates)
										SET @month   =DATEPART(month,@dates)
										SET @year    =DATEPART(year,@dates)
										SET @Sollwert = 1
										SET @Istwert = @diffTage
										SET @hour        =DATEPART(hh, @dates)
										SET @minute      =DATEPART(mi,@dates)
										SET @millisecond =DATEPART(ms,@dates)
										/*###########################schreibe in die Tabelle wenn die Differenz größer als 1:########################*/
										SET @Abweichung = 	@Istwert -  @Sollwert 
										SET @Show = 0
										IF (@Istwert =3) And (@WeekDay =7)
											SET @Show = 1

										IF (@Abweichung > 0) AND (@Show = 0)
										Begin
										
											Insert Into Statistik ([Waehrung], [CandleTypeID], [Wochentag], [Day], [Month], [Year], [hour], [minute], [second],    [Soll_Kerzen], [Ist_Kerzen], [Abweichung])
											VALUES	              (@Waehrung,  @CandleType,    @WeekDayName, @day, @month,  @year,  @hour,  @minute , @millisecond  ,@Sollwert    ,@Istwert     ,@Abweichung)
											--+' Day:'+cast(@day as varchar(50))+' Month:'+cast(@month as varchar(50))+' Year:'+cast(@year as varchar(50))+'    Start Cur. Week:'+cast(@StartCurWeek as varchar(50))+'    End Cur. Week:'+cast(@EndCurWeek as varchar(50))
											PRINT 'Waehrung: '+@Waehrung+'_'+@CandleType+ '   DiffTage:'+cast(@diffTage as varchar(50)) +'   WeekDay:'+cast(@weekDay as varchar(50))+' '+cast(@WeekDayName as varchar(50))+'  Day:'+cast(@day as varchar(50))+' Month:'+cast(@month as varchar(50))+' Year:'+cast(@year as varchar(50))
										END
								/*#####Testen#############################------------------------------
											SET @day     =DATEPART(day,@dates)
											SET @month   =DATEPART(month,@dates)
											SET @year    =DATEPART(year,@dates)
											-- start of last week (begin: monday)
											SET @StartLastWeek =CAST(DATEADD(WEEK, -1 ,DATEADD(DAY, -DATEPART(WEEKDAY, @dates) + 1, @dates)) AS DATE)
											-- end of last week (begin: monday)
											SET @EndLastWeek   =CAST(DATEADD(WEEK, -1, DATEADD(DAY, -DATEPART(WEEKDAY, @dates) + 7, @dates)) AS DATE)
											-- start of current week (begin: monday)
											SET @StartCurWeek  =CAST(DATEADD(DAY, -DATEPART(WEEKDAY, @dates) + 1, @dates) AS DATE)
											-- end of current week (begins monday)
											SET @EndCurWeek    =CAST(DATEADD(DAY, -DATEPART(WEEKDAY, @dates) + 7, @dates) AS DATE)
								-----------------------------------*/
						

											SET	@datesAlt=@dates
				
										END



								Fetch NEXT FROM cur_datesCheck
								INTO @dates
							END

				END
			
			/*
			IF @CandleTypeID = 2
			BEGIN
					
			END

			IF @CandleTypeID = 3
			BEGIN
					
			END

			BEGIN

			IF @CandleTypeID = 4
			BEGIN
										SET @datesAlt=@dates
										SET @diffTage=DATEDIFF(day,@datesAlt,@dates)
										--set datefirst 1;
										--@weekDay ist eine Zahl 1 bis 7
										SET @weekDay =DATEPART(weekday,@dates)
											IF @weekDay = 1
											Begin
												Set @WeekDayName = 'Montag'
												Set @Sollwert = 24*60
											End
											IF @weekDay = 2
											Begin
												Set @WeekDayName = 'Dienstag'
												Set @Sollwert = 24*60
											End
											IF @weekDay = 3
											Begin
												Set @WeekDayName = 'Mittwoch'
												Set @Sollwert = 24*60
											End
											IF @weekDay = 4
											Begin
												Set @WeekDayName = 'Donnerstag'
												Set @Sollwert = 24*60
											End
											IF @weekDay = 5
											Begin
												Set @WeekDayName = 'Freitag'
												set @Sollwert =22*60
											End
											IF @weekDay = 6
											Begin
												Set @WeekDayName = 'Samstag'
												Set @Sollwert = 24*60
											End
											IF @weekDay = 7
											Begin
												Set @WeekDayName = 'Sonntag'
												set @Sollwert =1*60
											End
										SET @day     =DATEPART(day,@dates)
										SET @month   =DATEPART(month,@dates)
										SET @year    =DATEPART(year,@dates)	
			END

			
			*/
			
			CLOSE cur_datesCheck;  
			DEALLOCATE cur_datesCheck;


			Fetch NEXT FROM cur_waehrungenTables
			INTO @Waehrung,@CandleType,@CandleTypeID
		END

CLOSE cur_waehrungenTables;  
DEALLOCATE cur_waehrungenTables;  
END
