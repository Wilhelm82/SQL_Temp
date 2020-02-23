﻿CREATE TABLE [dbo].[USDSEK_Hours_12] (
    [CandleDataSetID]   BIGINT       IDENTITY (1, 1) NOT NULL,
    [Open]              VARCHAR (50) NULL,
    [Close]             VARCHAR (50) NULL,
    [High]              VARCHAR (50) NULL,
    [Low]               VARCHAR (50) NULL,
    [Time]              DATETIME     NULL,
    [Volume]            VARCHAR (50) NULL,
    [RealVolume]        VARCHAR (50) NULL,
    [Spread]            VARCHAR (50) NULL,
    [importedTimeStamp] DATETIME     CONSTRAINT [USDSEK_Hours_12_importedTimeStamp] DEFAULT (getdate()) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ClusteredIndex-USDSEK_Hours_12]
    ON [dbo].[USDSEK_Hours_12]([Time] ASC, [Open] ASC, [Close] ASC, [High] ASC, [Low] ASC) WITH (IGNORE_DUP_KEY = ON);

