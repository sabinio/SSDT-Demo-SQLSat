CREATE PROCEDURE [DataLoadSimulation].[DailyProcessToCreateHistory]
	 @StartDate DATE,
        @EndDate DATE,
        @AverageNumberOfCustomerOrdersPerDay INT,
        @SaturdayPercentageOfNormalWorkDay INT,
        @SundayPercentageOfNormalWorkDay INT,
        @UpdateCustomFields INT, -- they were done in the initial load
        @IsSilentMode INT,
        @AreDatesPrinted INT

AS

RETURN 0
GO