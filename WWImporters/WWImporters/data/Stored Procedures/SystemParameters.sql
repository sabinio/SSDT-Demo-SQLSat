CREATE PROCEDURE [data].SystemParameters
AS

SET NOCOUNT ON;

CREATE TABLE #SystemParameters(
	[SystemParameterID] [int] NOT NULL,
	[DeliveryAddressLine1] [nvarchar](60) COLLATE Latin1_General_100_CI_AS NOT NULL,
	[DeliveryAddressLine2] [nvarchar](60) COLLATE Latin1_General_100_CI_AS NULL,
	[DeliveryCityID] [int] NOT NULL,
	[DeliveryPostalCode] [nvarchar](10) COLLATE Latin1_General_100_CI_AS NOT NULL,
	[DeliveryLocation] [geography] NOT NULL,
	[PostalAddressLine1] [nvarchar](60) COLLATE Latin1_General_100_CI_AS NOT NULL,
	[PostalAddressLine2] [nvarchar](60) COLLATE Latin1_General_100_CI_AS NULL,
	[PostalCityID] [int] NOT NULL,
	[PostalPostalCode] [nvarchar](10) COLLATE Latin1_General_100_CI_AS NOT NULL,
	[ApplicationSettings] [nvarchar](max) COLLATE Latin1_General_100_CI_AS NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Application_SystemParameters] PRIMARY KEY CLUSTERED 
(
	[SystemParameterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)


BEGIN TRANSACTION

INSERT #SystemParameters ([SystemParameterID], [DeliveryAddressLine1], [DeliveryAddressLine2], [DeliveryCityID], [DeliveryPostalCode], [DeliveryLocation], [PostalAddressLine1], 
	[PostalAddressLine2], [PostalCityID], [PostalPostalCode], [ApplicationSettings], [LastEditedBy], [LastEditedWhen]) 
VALUES (1, N'Suite 14', N'$(Address)', 30378, N'94129', 0xE6100000010C09DE904605E24240C617EDF142A05EC0, N'PO Box 201158', N'Golden Gate Park', 30378, 
	N'94129', N'', 1, CAST(N'2013-01-01T00:00:00.0000000' AS DateTime2))

COMMIT TRANSACTION


MERGE [Application].[SystemParameters] T
USING #SystemParameters S ON
    T.[SystemParameterID] = S.[SystemParameterID]
WHEN MATCHED THEN UPDATE SET
    T.[DeliveryAddressLine1] = S.[DeliveryAddressLine1], 
    T.[DeliveryAddressLine2] = S.[DeliveryAddressLine2], 
    T.[DeliveryCityID] = S.[DeliveryCityID], 
    T.[DeliveryPostalCode] = S.[DeliveryPostalCode], 
    T.[DeliveryLocation] = S.[DeliveryLocation], 
    T.[PostalAddressLine1] = S.[PostalAddressLine1], 
    T.[PostalAddressLine2] = S.[PostalAddressLine2], 
    T.[PostalCityID] = S.[PostalCityID], 
    T.[PostalPostalCode] = S.[PostalPostalCode], 
    T.[ApplicationSettings] = S.[ApplicationSettings], 
    T.[LastEditedBy] = S.[LastEditedBy], 
    T.[LastEditedWhen] = S.[LastEditedWhen]
WHEN NOT MATCHED BY TARGET THEN INSERT ([SystemParameterID], [DeliveryAddressLine1], [DeliveryAddressLine2], [DeliveryCityID], [DeliveryPostalCode], [DeliveryLocation], [PostalAddressLine1], [PostalAddressLine2], [PostalCityID], [PostalPostalCode], [ApplicationSettings], [LastEditedBy], [LastEditedWhen])
    VALUES (S.[SystemParameterID], S.[DeliveryAddressLine1], S.[DeliveryAddressLine2], S.[DeliveryCityID], S.[DeliveryPostalCode], S.[DeliveryLocation], S.[PostalAddressLine1], S.[PostalAddressLine2], S.[PostalCityID], S.[PostalPostalCode], S.[ApplicationSettings], S.[LastEditedBy], S.[LastEditedWhen])
WHEN NOT MATCHED BY SOURCE THEN DELETE;

DROP TABLE #SystemParameters;
