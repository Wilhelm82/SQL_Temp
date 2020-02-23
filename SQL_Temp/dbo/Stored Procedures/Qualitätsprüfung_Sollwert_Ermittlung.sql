/*SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO*/
-- =============================================
-- Author:		<Author,,Name> Wilhelm Paul
-- Create date: <Create Date,,> 22.11.2019
-- Description:	<Description,,> 
-- =============================================
CREATE PROCEDURE [dbo].[Qualitätsprüfung_Sollwert_Ermittlung]
	-- Add the parameters for the stored procedure here
	 @Datum date, @weekDay int Output, @CandleTypeID int,  @Sollwert int Output
	--@WeekDayName varchar(50) Output,
	
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE  @Month int, @KW int

	SET @weekDay = DATEPART(weekday,@Datum)
	SET @Month = DATEPART(month,@Datum)
	--SET DATEFIRST 1;
	SET @KW = DATEPART(week,@Datum)

	IF (@CandleTypeID = 1) Begin--#################   1  Dayly #####
		IF @weekDay IN ( 1 ,2 ,3 ,4 ,5 ,7)
			SET @Sollwert = 1
		ELSE IF @weekDay = 6 
			SET @Sollwert = 0	
	END ELSE IF (@CandleTypeID = 2) Begin--#################   2   Hours_1 #####
		IF @weekDay IN ( 1 ,2 ,3 ,4) 
			SET @Sollwert = 24
		ELSE IF @weekDay = 5 
			SET @Sollwert = 23
		ELSE IF @weekDay = 6 
			SET @Sollwert = 0
		ELSE IF @weekDay = 7 
			SET @Sollwert = 1	
	END ELSE IF (@CandleTypeID = 3) Begin--#################   3  Hours_4 #####
		IF @weekDay IN ( 1 ,2 ,3 ,4 ,5) 
			SET @Sollwert = 6
		ELSE IF @weekDay = 6 
			SET @Sollwert = 0
		ELSE IF @weekDay = 7 
			SET @Sollwert = 1	
	END ELSE IF (@CandleTypeID = 4) Begin --#################   4  Minutes_1 #####
		IF @weekDay IN ( 1 ,2 ,3 ,4) 
			SET @Sollwert = 1440
		ELSE IF @weekDay = 5 
			SET @Sollwert = 1380
		ELSE IF @weekDay = 6 
			SET @Sollwert = 0
		ELSE IF @weekDay = 7 
			SET @Sollwert = 60		
	END ELSE IF (@CandleTypeID = 5) Begin--#################   5  Minutes_5 #####
		IF @weekDay IN ( 1 ,2 ,3 ,4) 
			SET @Sollwert = 288
		ELSE IF @weekDay = 5 
			SET @Sollwert = 276
		ELSE IF @weekDay = 6 
			SET @Sollwert = 0
		ELSE IF @weekDay = 7 
			SET @Sollwert = 12	
	END ELSE IF (@CandleTypeID = 6) Begin--#################   6  Minutes_15 #####
		IF @weekDay IN ( 1 ,2 ,3 ,4) 
			SET @Sollwert = 96
		ELSE IF @weekDay = 5 
			SET @Sollwert = 92
		ELSE IF @weekDay = 6 
			SET @Sollwert = 0
		ELSE IF @weekDay = 7 
			SET @Sollwert = 4	
	END ELSE IF (@CandleTypeID = 7) Begin--#################   7  Minutes_30 #####
		IF @weekDay IN ( 1 ,2 ,3 ,4) 
			SET @Sollwert = 48
		ELSE IF @weekDay = 5 
			SET @Sollwert = 46
		ELSE IF @weekDay = 6 
			SET @Sollwert = 0
		ELSE IF @weekDay = 7 
			SET @Sollwert = 2	
	END ELSE IF (@CandleTypeID  IN ( 8, 9)) Begin--#################   8  Monthly AND  9  Weekly #####
			
			SET @Sollwert = 1
	
	END ELSE IF (@CandleTypeID = 10) Begin--#################   10  Minutes_2 #####
		IF @weekDay IN ( 1 ,2 ,3 ,4) 
			SET @Sollwert = 720
		ELSE IF @weekDay = 5 
			SET @Sollwert = 690
		ELSE IF @weekDay = 6 
			SET @Sollwert = 0
		ELSE IF @weekDay = 7 
			SET @Sollwert = 30	
	END ELSE IF (@CandleTypeID = 11) Begin--#################   11  Minutes_3 #####
		IF @weekDay IN ( 1 ,2 ,3 ,4)
			SET @Sollwert = 480
		ELSE IF @weekDay = 5 
			SET @Sollwert = 460
		ELSE IF @weekDay = 6 
			SET @Sollwert = 0
		ELSE IF @weekDay = 7 
			SET @Sollwert = 20
	END ELSE IF (@CandleTypeID = 12) Begin--#################   12  Minutes_4 #####
		IF @weekDay IN ( 1 ,2 ,3 ,4) 
			SET @Sollwert = 360
		ELSE IF @weekDay = 5 
			SET @Sollwert = 345
		ELSE IF @weekDay = 6 
			SET @Sollwert = 0
		ELSE IF @weekDay = 7 
			SET @Sollwert = 15
	END ELSE IF (@CandleTypeID = 13) Begin--#################   13  Minutes_6 #####
		IF @weekDay IN ( 1 ,2 ,3 ,4) 
			SET @Sollwert = 240
		ELSE IF @weekDay = 5 
			SET @Sollwert = 230
		ELSE IF @weekDay = 6 
			SET @Sollwert = 0
		ELSE IF @weekDay = 7 
			SET @Sollwert = 10
	END ELSE IF (@CandleTypeID = 14) Begin--#################   14  Minutes_10 #####
		IF @weekDay IN ( 1 ,2 ,3 ,4) 
			SET @Sollwert = 144
		ELSE IF @weekDay = 5 
			SET @Sollwert = 138
		ELSE IF @weekDay = 6 
			SET @Sollwert = 0
		ELSE IF @weekDay = 7 
			SET @Sollwert = 6
	END ELSE IF (@CandleTypeID = 16) Begin--#################   16  Minutes_12 #####
		IF @weekDay IN ( 1 ,2 ,3 ,4) 
			SET @Sollwert = 120
		ELSE IF @weekDay = 5 
			SET @Sollwert = 115
		ELSE IF @weekDay = 6 
			SET @Sollwert = 0
		ELSE IF @weekDay = 7 
			SET @Sollwert = 5	
	END ELSE IF (@CandleTypeID = 18) Begin--#################   18  Minutes_20 #####
		IF @weekDay IN ( 1 ,2 ,3 ,4) 
			SET @Sollwert = 72
		ELSE IF @weekDay = 5 
			SET @Sollwert = 69
		ELSE IF @weekDay = 6 
			SET @Sollwert = 0
		ELSE IF @weekDay = 7 
			SET @Sollwert = 3	
	END ELSE IF (@CandleTypeID = 20) Begin--#################   20  Hours_2 #####
		IF @weekDay IN ( 1 ,2 ,3 ,4 ,5) 
			SET @Sollwert = 12
		ELSE IF @weekDay = 6 
			SET @Sollwert = 0
		ELSE IF @weekDay = 7 
			SET @Sollwert = 1	
	END ELSE IF (@CandleTypeID = 21) Begin--#################   21  Hours_3 #####
		IF @weekDay IN ( 1 ,2 ,3 ,4 ,5) 
			SET @Sollwert = 8
		ELSE IF @weekDay = 6 
			SET @Sollwert = 0
		ELSE IF @weekDay = 7 
			SET @Sollwert = 1
	END ELSE IF (@CandleTypeID = 23) Begin--#################   23  Hours_6 #####
		IF @weekDay IN ( 1 ,2 ,3 ,4 ,5) 
			SET @Sollwert = 4
		ELSE IF @weekDay = 6 
			SET @Sollwert = 0
		ELSE IF @weekDay = 7 
			SET @Sollwert = 1	
	END ELSE IF (@CandleTypeID = 24) Begin--#################   24  Hours_8 #####
		IF @weekDay IN ( 1 ,2 ,3 ,4 ,5) 
			SET @Sollwert = 3
		ELSE IF @weekDay = 6 
			SET @Sollwert = 0
		ELSE IF @weekDay = 7 
			SET @Sollwert = 1
	END ELSE IF (@CandleTypeID = 25) Begin--#################   25  Hours_12 #####
		IF @weekDay IN ( 1 ,2 ,3 ,4 ,5) 
			SET @Sollwert = 2
		ELSE IF @weekDay = 6 
			SET @Sollwert = 0
		ELSE IF @weekDay = 7 
			SET @Sollwert = 1
	END

END
