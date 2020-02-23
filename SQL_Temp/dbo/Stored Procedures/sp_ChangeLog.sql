CREATE PROCEDURE [dbo].[sp_ChangeLog]
	@TableName AS NVARCHAR(255),
	@PrimeKeyFieldName as varchar (255),
	@OperationType as NVARCHAR(8)
	
AS

		DECLARE @ChangeLogTblName as char(25)

		DECLARE @WinUserName as NVARCHAR(100)
		
		DECLARE @ColumnName AS NVARCHAR(255)
		DECLARE @Hostname AS NVARCHAR(255)
		DECLARE @ColumnList AS NVARCHAR(2000)
		DECLARE @Column AS NVARCHAR(255)
		DECLARE @SQL AS NVARCHAR(2000)
	
		SET @ChangeLogTblName = 'tblChangeLog'

		SET @WinUserName=RIGHT(SYSTEM_USER, LEN(SYSTEM_USER) - CHARINDEX('\', SYSTEM_USER))	
		SET @ColumnName = ''
		SET @Hostname = HOST_NAME()
		SET @ColumnList = ''
		SET @Column = ''
		SET @SQL=''
		
		--Liste mit Spaltennamen generieren
		SELECT 
			@ColumnList = @ColumnList + c.name +';' 
		FROM 
			syscolumns c 
			INNER JOIN sysobjects o ON o.id = c.id 
		WHERE 
			o.name = @TableName
		ORDER BY 
			colid
	
		SET @ColumnList = SUBSTRING(@ColumnList, 1, DATALENGTH(@ColumnList)-2)
		
		--Spaltennamen durchlaufen
		WHILE DATALENGTH(@ColumnList) > 0
			BEGIN
				SET @ColumnName = SUBSTRING(@ColumnList, 1, CHARINDEX(';', @ColumnList) - 1)
	
				SET @SQL = ''
				SET @SQL = @SQL + 'INSERT INTO dbo.' + @ChangeLogTblName
				SET @SQL = @SQL + ' ( '
				SET @SQL = @SQL + 'OperationType, '
				SET @SQL = @SQL + 'SourceUser, '
				SET @SQL = @SQL + 'WinUserName, '
				SET @SQL = @SQL + 'LogDateTime ,'
				SET @SQL = @SQL + 'TableName, '
				SET @SQL = @SQL + 'ColumnName, '
				SET @SQL = @SQL + 'PrimeKeyID, '
				SET @SQL = @SQL + 'OldValue, '
				SET @SQL = @SQL + 'NewValue, '
				SET @SQL = @SQL + 'InvestitionsAntragsID '
				SET @SQL = @SQL + ') '
				SET @SQL = @SQL + 'SELECT '
				SET @SQL = @SQL + '''' + @OperationType + ''', '
				SET @SQL = @SQL + '''' + @Hostname + ''', '
				SET @SQL = @SQL + '''' + @WinUserName + ''', '
				SET @SQL = @SQL + 'GETDATE(), '
				SET @SQL = @SQL + '''' + @TableName + ''', '
				SET @SQL = @SQL + '''' + @ColumnName + ''', '
	
				Begin
					IF @OperationType='UPDATED'
						BEGIN
							SET @SQL = @SQL + 'CONVERT(NVARCHAR(255), #Inserted.[' + @PrimeKeyFieldName + ']), '
							SET @SQL = @SQL + 'CONVERT(NVARCHAR(1600), #Deleted.[' + @ColumnName + ']), '
							SET @SQL = @SQL + 'CONVERT(NVARCHAR(1600), #Inserted.[' + @ColumnName + ']),  '
							SET @SQL = @SQL + '#Deleted.InvestitionsAntragsID '
							SET @SQL = @SQL + 'FROM '
							SET @SQL = @SQL + '#Inserted '
							SET @SQL = @SQL + 'INNER JOIN #Deleted ON #Inserted.[' + @PrimeKeyFieldName + '] = #Deleted.[' + @PrimeKeyFieldName + '] '
							SET @SQL = @SQL + 'WHERE '
							SET @SQL = @SQL + '(NOT #Inserted.[' + @ColumnName + '] = #Deleted.[' + @ColumnName + ']) OR (#Inserted.[' + @ColumnName + '] IS NULL AND #Deleted.[' + @ColumnName + '] IS NOT NULL) OR (#Inserted.[' + @ColumnName + '] IS NOT NULL AND #Deleted.[' + @ColumnName + '] IS NULL )'
						END
					 ELSE IF @OperationType='DELETED'
						BEGIN
							SET @SQL = @SQL + 'CONVERT(NVARCHAR(255), #Deleted.[' + @PrimeKeyFieldName + ']), '
							SET @SQL = @SQL + 'CONVERT(NVARCHAR(1600), #Deleted.[' + @ColumnName + ']), '
							SET @SQL = @SQL + 'NULL,  '
							SET @SQL = @SQL + '#Deleted.InvestitionsAntragsID '
							SET @SQL = @SQL + 'FROM '
							SET @SQL = @SQL + '#Deleted '
						END
					ELSE IF @OperationType='INSERTED'
						BEGIN
							SET @SQL = @SQL + 'CONVERT(NVARCHAR(255), #Inserted.[' + @PrimeKeyFieldName + ']), '
							SET @SQL = @SQL + 'NULL, '
							SET @SQL = @SQL + 'CONVERT(NVARCHAR(1600), #Inserted.[' + @ColumnName + ']), '
							SET @SQL = @SQL + '#Inserted.InvestitionsAntragsID '
							SET @SQL = @SQL + 'FROM '
							SET @SQL = @SQL + '#Inserted '
						END
				END
				
				BEGIN
				IF @ColumnName <> 'ID'
					EXEC sp_executesql @SQL
				END
				
				SET @ColumnList = SUBSTRING(@ColumnList, CHARINDEX(';', @ColumnList) + 1, DATALENGTH(@ColumnList))
			END
