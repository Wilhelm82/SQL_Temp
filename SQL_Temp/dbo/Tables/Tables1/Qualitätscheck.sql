CREATE TABLE [dbo].[Qualitätscheck] (
    [Prüf_ID]      BIGINT       IDENTITY (1, 1) NOT NULL,
    [WaehrungsID]  INT          NULL,
    [Waehrung]     VARCHAR (10) NULL,
    [CandleTypeID] INT          NULL,
    [CandleType]   VARCHAR (50) NULL,
    [VON]          DATE         NULL,
    [BIS]          DATE         NULL
);

