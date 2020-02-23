CREATE TABLE [dbo].[Statistik] (
    [Waehrung]     VARCHAR (10)    NULL,
    [CandleTypeID] VARCHAR (20)    NULL,
    [Wochentag]    VARCHAR (50)    NULL,
    [Day]          INT             NULL,
    [Month]        INT             NULL,
    [Year]         INT             NULL,
    [hour]         INT             NULL,
    [minute]       INT             NULL,
    [second]       INT             NULL,
    [Soll_Kerzen]  INT             NULL,
    [Ist_Kerzen]   INT             NULL,
    [Abweichung]   INT             NULL,
    [Kommentar]    NVARCHAR (4000) NULL
);

