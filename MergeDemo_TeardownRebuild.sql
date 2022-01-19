
-- TEAR DOWN AND REBUILD LATEST DATA FROM SCRATCH

if exists (select * from sysobjects where name = 'BuildLatestPrices')
	drop proc BuildLatestPrices
go
create proc BuildLatestPrices as
begin

	declare @rc int

	truncate table LatestPrices;

	insert LatestPrices (Symbol, Price, LastExecutionTime)
		select Symbol, Price, ExecutionTime
		from vLatestTrades
		where IsDelisted = 0

	set @rc = @@ROWCOUNT

	select @rc as 'WorkDone'

end
go

