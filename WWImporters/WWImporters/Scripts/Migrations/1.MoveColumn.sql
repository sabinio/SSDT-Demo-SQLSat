IF NOT EXISTS (SELECT * FROM common.ScriptLog WHERE ScriptName = 'PickedByPersonID Migration')
BEGIN
	DECLARE @BatchStartOrderLineID INT=1;
	DECLARE @MaxOrderLineID INT;
	DECLARE @BatchSize INT = 2000;
	SELECT @MaxOrderLineID = MAX(OrderID) FROM Sales.Orders;

	WHILE @BatchStartOrderLineID < @MaxOrderLineID
	BEGIN
		PRINT 'Updating From OrderLineID: ' + CAST(@BatchStartOrderLineID AS VARCHAR(50)) + ' to OrderLineID: ' + CAST(@BatchStartOrderLineID + @BatchSize as VARCHAR(50));
	
		UPDATE OL
		SET PickedByPersonID = O.PickedByPersonID
		FROM Sales.Orders O
		JOIN Sales.OrderLines OL ON OL.OrderID = O.OrderID
		WHERE OL.OrderLineID BETWEEN @BatchStartOrderLineID AND (@BatchStartOrderLineID + @BatchSize);

		SET @BatchStartOrderLineID = @BatchStartOrderLineID + @BatchSize + 1;
	END

	INSERT INTO common.ScriptLog (ScriptName) VALUES ('PickedByPersonID Migration')
END