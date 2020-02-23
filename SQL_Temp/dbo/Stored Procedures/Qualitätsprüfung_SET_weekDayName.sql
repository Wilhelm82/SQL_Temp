-- =============================================
-- Author:		<Author,,Name> Wilhelm Paul
-- Create date: <Create Date,,> 22.11.2019
-- Description:	<Description,,> 
-- =============================================
CREATE PROCEDURE [dbo].[Qualitätsprüfung_SET_weekDayName]
	-- Add the parameters for the stored procedure here
	 @weekDay int, @WeekDayName varchar(50) Output
	
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @weekDay = 1 
		SET @WeekDayName = 'Montag'		
	ELSE IF @weekDay = 2 
		SET @WeekDayName = 'Dienstag'
	ELSE IF @weekDay = 3 
		SET @WeekDayName = 'Mittwoch'
	ELSE IF @weekDay = 4 
		SET @WeekDayName = 'Donnerstag'
	ELSE IF @weekDay = 5 
		SET @WeekDayName = 'Freitag'
	ELSE IF @weekDay = 6 
		SET @WeekDayName = 'Samstag'
	ELSE IF @weekDay = 7 
		SET @WeekDayName = 'Sonntag'

END
