use Demo
go

-- MERGE LATEST DATA CHANGES ONLY

if exists (select * from sysobjects where name = 'MergeLatestPrices')
	drop proc MergeLatestPrices
go
create proc MergeLatestPrices as
begin

	declare @rc int

	MERGE LatestPrices AS tgt
	USING vLatestTrades AS src 
	ON tgt.Symbol = src.Symbol
	WHEN 
		MATCHED AND src.IsDelisted = 1
		THEN DELETE
	WHEN 
		MATCHED AND tgt.LastExecutionTime < src.ExecutionTime
		THEN UPDATE SET tgt.Price = src.Price, tgt.LastExecutionTime = src.ExecutionTime
	WHEN 
		NOT MATCHED BY TARGET and src.IsDelisted = 0
		THEN INSERT (Symbol, LastExecutionTime, Price) 
			VALUES (Symbol, ExecutionTime, Price)
	WHEN NOT MATCHED BY SOURCE 
		THEN DELETE;

	set @rc = @@ROWCOUNT
	select @rc as 'WorkDone'

end
go

