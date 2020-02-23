﻿CREATE TABLE [dbo].[USDCAD_Hours_4] (
    [CandleDataSetID]   BIGINT       IDENTITY (1, 1) NOT NULL,
    [Open]              VARCHAR (50) NULL,
    [Close]             VARCHAR (50) NULL,
    [High]              VARCHAR (50) NULL,
    [Low]               VARCHAR (50) NULL,
    [Time]              DATETIME     NULL,
    [Volume]            VARCHAR (50) NULL,
    [RealVolume]        VARCHAR (50) NULL,
    [Spread]            VARCHAR (50) NULL,
    [importedTimeStamp] DATETIME     CONSTRAINT [USDCAD_Hours_4_importedTimeStamp] DEFAULT (getdate()) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ClusteredIndex-USDCAD_Hours_4]
    ON [dbo].[USDCAD_Hours_4]([Time] ASC, [Open] ASC, [Close] ASC, [High] ASC, [Low] ASC) WITH (IGNORE_DUP_KEY = ON);

