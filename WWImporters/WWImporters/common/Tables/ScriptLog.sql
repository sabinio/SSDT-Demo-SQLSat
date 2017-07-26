CREATE TABLE [common].[ScriptLog] (
    [ScriptName] VARCHAR (100) NOT NULL,
    [DateRun]    DATETIME2 (0) DEFAULT (sysutcdatetime()) NOT NULL,
    PRIMARY KEY CLUSTERED ([ScriptName] ASC)
);

