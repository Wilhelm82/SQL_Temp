-- =============================================
-- Author:		<Author,,Name> Wilhelm Paul
-- Create date: <Create Date,,> 12.01.2020
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Qualitätsprüfung_Erhöhung_Prüfen]
	-- Add the parameters for the stored procedure here
	@Datum date output, @CandleTypeID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF (@CandleTypeID = 8)
		SELECT @Datum = DATEADD (MONTH , 1 , @Datum )
	ELSE IF (@CandleTypeID = 9) 
		SELECT @Datum = DATEADD (WEEK , 1 , @Datum )	
	ELSE 
		SELECT @Datum = DATEADD (day , 1 , @Datum )

	 
END
