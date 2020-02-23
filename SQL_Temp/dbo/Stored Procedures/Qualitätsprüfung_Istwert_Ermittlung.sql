/*SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO*/
-- =============================================
-- Author:		<Author,,Name> Wilhelm Paul
-- Create date: <Create Date,,> 11.01.2020
-- Description:	<Description,,> 
-- =============================================
CREATE PROCEDURE [dbo].[Qualitätsprüfung_Istwert_Ermittlung]
	-- Add the parameters for the stored procedure here
	 @Istwert int output, @Waehrung varchar(10), @CandleType varchar(50), @Datum date, @CandleTypeID int, @weekDay int
		
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @StartCurrKW date, @ENDCurrKW date, @StartCurrJear date, @EndCurrJear date, @StartCurrMonth date, @EndCurrMonth date,
	@sql nvarchar(4000), @ParmDefinition nvarchar(4000)
		
	IF @CandleTypeID IN ( 1,2,3,4,5,6,7,10,11,12,13,14,16,18,20,21,23,24,25) Begin

		SET @ParmDefinition = N'@Istwert int OUTPUT, @VON date';
		SET @sql='SELECT @Istwert = (SELECT COUNT(*) FROM '+ @Waehrung +'_'+@CandleType+' WHERE CAST([Time] as date) = @VON)'
		execute sp_executesql @sql,	@ParmDefinition, @Istwert=@Istwert OUTPUT, @VON=@Datum;
			
	
	END ELSE IF (@CandleTypeID = 8) Begin--#################   8   Monthly #####
		
		SET @ParmDefinition = N'@Istwert int OUTPUT, @VON date';
		SET @sql='SELECT @Istwert = (SELECT COUNT(*) FROM '+ @Waehrung +'_'+@CandleType+' WHERE year([Time]) = year(@VON) AND month([Time]) = month(@VON))'
		execute sp_executesql @sql,	@ParmDefinition, @Istwert=@Istwert OUTPUT, @VON=@Datum;


	END ELSE IF (@CandleTypeID = 9) Begin--#################   9  Weekly #####
				
		SET @ParmDefinition = N'@Istwert int OUTPUT, @VON date';
		SET @sql='SELECT @Istwert = (SELECT COUNT(*) FROM '+ @Waehrung +'_'+@CandleType+' WHERE year([Time]) = year(@VON) AND datepart(week,[Time]) = datepart(week,@von))'
		execute sp_executesql @sql,	@ParmDefinition, @Istwert=@Istwert OUTPUT, @VON=@Datum;
		
	END
END