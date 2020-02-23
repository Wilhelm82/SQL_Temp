CREATE TABLE [dbo].[Statistik_2] (
    [Waehrung]     VARCHAR (10)    NULL,
    [CandleTypeID] VARCHAR (20)    NULL,
    [Wochentag]    VARCHAR (50)    NULL,
    [Time]         DATETIME        NULL,
    [Soll_Kerzen]  INT             NULL,
    [Ist_Kerzen]   INT             NULL,
    [Abweichung]   INT             NULL,
    [Kommentar]    NVARCHAR (4000) NULL
);

