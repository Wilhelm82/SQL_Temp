-- Batch submitted through debugger: SQLQuery7.sql|7|0|C:\Users\Wilson\AppData\Local\Temp\~vs877.sql
-- Batch submitted through debugger: SQLQuery1.sql|7|0|C:\Users\Wilson\AppData\Local\Temp\~vs645F.sql
-- =============================================
-- Author:    Wilhelm Paul
-- Create date: 19.08.2019
-- Description: zeige Dubletten
-- =============================================
CREATE PROCEDURE [dbo].[Dubletten_wenn_vorhanden] 
  
  
AS
BEGIN

  DECLARE @Waehrung varchar(10),@CandleType varchar(20),@CandleTypeID int, @sql nvarchar(4000), @dates date, @datesAlt date= null, @diffTage int, @weekDay int

  SET NOCOUNT ON;

    
  
  Declare cur_waehrungenTables Cursor FOR
  
  select Waehrung,CandleType,CandleTypeID
  from [TestDBVerwaltung].[dbo].tblWaehrungen 
  cross join [TestDBVerwaltung].[dbo].CandleType
  where AktiveInMarket=1 
  --AND WaehrungsID = 5 AND CandleTypeID IN (1,2,25,20,21,3,23,24,4,14,16,6,10,18,11,7,12,5,13,8,9)
 -- AND WaehrungsID = 5 AND CandleTypeID = 20
  --AND WaehrungsID in (3,6) AND CandleTypeID =1      --<--hier kann man auskommentieren, damit alle Waehrungen durchlaufen werden!
  order by Waehrung 


  OPEN cur_waehrungenTables

  Fetch NEXT FROM cur_waehrungenTables
  INTO @Waehrung,@CandleType,@CandleTypeID



  WHILE @@FETCH_STATUS=0
    BEGIN
      
    set @sql='

        declare @Anzahl int=0

      
        Declare cur_checkDupletten Cursor FOR
          SELECT count(*) Anzahl FROM '+ @Waehrung +'_'+@CandleType+ '
          WHERE EXISTS
          (SELECT * FROM ' + @Waehrung +'_'+@CandleType+ ' Kopie WHERE ' 
            + @Waehrung +'_'+@CandleType+ '.[Open] = Kopie.[Open] AND ' 
            + @Waehrung +'_'+@CandleType+ '.[Close] = Kopie.[Close] AND ' 
            + @Waehrung +'_'+@CandleType+ '.[High] = Kopie.[High] AND ' 
            + @Waehrung +'_'+@CandleType+ '.[Low] = Kopie.[Low] AND ' 
            + @Waehrung +'_'+@CandleType+ '.[Time] = Kopie.[Time] AND ' 
            + @Waehrung +'_'+@CandleType+ '.[Volume] = Kopie.[Volume]  AND ' 
            + @Waehrung +'_'+@CandleType+ '.[CandleDataSetID] <> Kopie.[CandleDataSetID])
           
       
        OPEN cur_checkDupletten

        Fetch NEXT FROM cur_checkDupletten
        INTO @Anzahl

        CLOSE cur_checkDupletten
        DEALLOCATE cur_checkDupletten
          
                        
        
        if (@Anzahl>0)
          BEGIN
            SELECT '''+@Waehrung +'_'+@CandleType+ ''',[CandleDataSetID],[Open],[Close],[High],[Low],[Time],[Volume],[importedTimeStamp] FROM '+ @Waehrung +'_'+@CandleType+ '
            WHERE EXISTS
            (SELECT * FROM ' + @Waehrung +'_'+@CandleType+ ' Kopie WHERE ' 
              + @Waehrung +'_'+@CandleType+ '.[Open] = Kopie.[Open] AND ' 
              + @Waehrung +'_'+@CandleType+ '.[Close] = Kopie.[Close] AND ' 
              + @Waehrung +'_'+@CandleType+ '.[High] = Kopie.[High] AND ' 
              + @Waehrung +'_'+@CandleType+ '.[Low] = Kopie.[Low] AND ' 
              + @Waehrung +'_'+@CandleType+ '.[Time] = Kopie.[Time] AND ' 
              + @Waehrung +'_'+@CandleType+ '.[Volume] = Kopie.[Volume]  AND ' 
              + @Waehrung +'_'+@CandleType+ '.[CandleDataSetID] <> Kopie.[CandleDataSetID])
             ORDER BY Time

          END   
       '
      execute sp_executesql @sql 
    
      Fetch NEXT FROM cur_waehrungenTables
      INTO @Waehrung,@CandleType,@CandleTypeID
    
    END

  CLOSE cur_waehrungenTables;  
  DEALLOCATE cur_waehrungenTables; 

END

