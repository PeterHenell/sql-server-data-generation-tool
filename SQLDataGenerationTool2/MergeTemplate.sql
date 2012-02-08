SET IDENTITY_INSERT Tournament_Cnfg.TournamentInactivityReasonType ON

MERGE Tournament_Cnfg.TournamentInactivityReasonType AS TARGET
USING 
(
	SELECT -1, N'STILL_ACTIVE', N'Tournament Still active' UNION ALL
	SELECT 0, N'AUTO_STOP', N' Automatic stop' UNION ALL
	SELECT 1, N'BY_ADMIN', N' Tournament stopped by admin' UNION ALL
	SELECT 2, N'END_DATE_PASSED', N' Tournament end date passed'
 ) AS 
	SOURCE (TournamentInactivityReasonTypeId, EnumConstant, [Description])
 
ON (TARGET.TournamentInactivityReasonTypeId = SOURCE.TournamentInactivityReasonTypeId) 

--WHEN MATCHED THEN
--UPDATE SET 
--	EnumConstant = SOURCE.EnumConstant, [Description] = SOURCE.[Description]

WHEN NOT MATCHED BY TARGET THEN 
INSERT (TournamentInactivityReasonTypeId, EnumConstant, [Description])
VALUES (SOURCE.TournamentInactivityReasonTypeId, SOURCE.EnumConstant, SOURCE.[Description])


;


SET IDENTITY_INSERT Tournament_Cnfg.TournamentInactivityReasonType OFF