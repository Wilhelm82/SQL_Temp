-- =============================================
-- Author:		<Author,,Name> Wilhelm Paul
-- Create date: <Create Date, ,> 12.01.2020
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[Erhöhung_Prüfen]  
(  
       @i int,  
       @Datum date
	    
)  
RETURNS int 
AS  
BEGIN  
      /* -- Declare the return variable here  
       --DECLARE @Result int  
       SELECT @Result = @Number1 * @Number2;  
       -- Return the result of the function  
       RETURN @Result  */

	DECLARE @Result1 date, @Result2 int

		--erhöhe VON + 1
		SELECT @Datum = DATEADD (day , 1 , @Datum ) 
		SELECT @Result1 = @Datum
		-- Return the result of the function
		--RETURN @Result1 
		
		--Zähler @i um 1 erhöhen
		SET @i = @i + 1
		SELECT @Result2 = @i	
		RETURN @Result2 
	

END 

