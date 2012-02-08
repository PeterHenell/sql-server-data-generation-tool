--select 'SELECT * FROM ' + table_schema + '.' + table_name from information_schema.tables

--SELECT * FROM Common_Cnfg.Permission
--SELECT * FROM Common_Cnfg.PermissionInRole
--SELECT * FROM Common_Cnfg.StaffRole
--SELECT * FROM Common_Cnfg.StaffUser
--SELECT * FROM Common_Cnfg.StaffUserEventType
--SELECT * FROM Common_Cnfg.StaffUserEventLog
--SELECT * FROM Tournament_Cnfg.TournamentInactivityReasonType
--SELECT * FROM Tournament_Cnfg.Tournament
--SELECT * FROM Tournament_Cnfg.TournamentWinCriteriaType
--SELECT * FROM Bonus_Cnfg.BonusProgram
--SELECT * FROM Bonus_Cnfg.BonusProgramDepositType
--SELECT * FROM Bonus_Cnfg.BonusProgramFilterType
--SELECT * FROM Bonus_Cnfg.BonusProgramOccuranceType
--SELECT * FROM Bonus_Cnfg.BonusProgramPriority
--SELECT * FROM Bonus_Cnfg.BonusType
--SELECT * FROM dbo.DeployHistory


--SET IDENTITY_INSERT Tournament_Cnfg.TournamentWinCriteriaType ON

MERGE Tournament_Cnfg.TournamentWinCriteriaType AS TARGET
USING 
(
	SELECT	1, 'BEST_OVERALL_NET_WIN', 'Best overall net win' UNION ALL
	SELECT	2, 'BEST_OVERALL_PAYOUT_FACTOR', 'Best overall payout factor' UNION ALL
	SELECT	3, 'MOST_GAME_ROUNDS', 'Most game rounds' UNION ALL
	SELECT	4, 'BEST_EQUALIZED_PAYOUT_FACTOR_PER_GAME_ROUND', 'Best equalized payout factor per game round' UNION ALL
	SELECT	5, 'BEST_NET_WIN_FOR_20_CONSECUTIVE_ROUNDS', 'Best net win for 20 consecutive rounds' UNION ALL
	SELECT	6, 'BEST_EQUALIZED_PAYOUT_FACTOR_FOR_20_CONSECUTIVE_ROUNDS', 'Best equalized payout factor for 20 consecutive rounds'
 ) AS 
	SOURCE (TournamentWinCriteriaTypeId, EnumConstant, [Description])
 
ON (TARGET.TournamentWinCriteriaTypeId = SOURCE.TournamentWinCriteriaTypeId) 

WHEN MATCHED THEN
	UPDATE SET 
		EnumConstant = SOURCE.EnumConstant, [Description] = SOURCE.[Description]

WHEN NOT MATCHED BY TARGET THEN 
	INSERT (TournamentWinCriteriaTypeId, EnumConstant, [Description])
	VALUES (SOURCE.TournamentWinCriteriaTypeId, SOURCE.EnumConstant, SOURCE.[Description])


;

--1, 'BEST_OVERALL_NET_WIN', 'Best overall net win'
--2, 'BEST_OVERALL_PAYOUT_FACTOR', 'Best overall payout factor'
--3, 'MOST_GAME_ROUNDS', 'Most game rounds'
--4, 'BEST_EQUALIZED_PAYOUT_FACTOR_PER_GAME_ROUND', 'Best equalized payout factor per game round'
--5, 'BEST_NET_WIN_FOR_20_CONSECUTIVE_ROUNDS', 'Best net win for 20 consecutive rounds'
--6, 'BEST_EQUALIZED_PAYOUT_FACTOR_FOR_20_CONSECUTIVE_ROUNDS', 'Best equalized payout factor for 20 consecutive rounds'
