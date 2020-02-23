CREATE TABLE [dbo].[AUDCAD_Minutes_1_Kopie] (
    [CandleDataSetID]   BIGINT       NOT NULL,
    [Open]              VARCHAR (50) NULL,
    [Close]             VARCHAR (50) NULL,
    [High]              VARCHAR (50) NULL,
    [Low]               VARCHAR (50) NULL,
    [Time]              DATETIME     NULL,
    [Volume]            VARCHAR (50) NULL,
    [importedTimeStamp] DATETIME     NULL,
    PRIMARY KEY CLUSTERED ([CandleDataSetID] ASC)
);

