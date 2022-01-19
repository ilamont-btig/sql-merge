
-- FIND AND INSERT NEW DATA, DELETE REMOVED DATA, UPDATE EXISTING DATA

if exists (select * from sysobjects where name = 'ThreeStepUpdateLatestPrices')
	drop proc ThreeStepUpdateLatestPrices
go

create proc ThreeStepUpdateLatestPrices as
begin

	declare @rci int
	declare @rcd int
	declare @rcu int

	insert LatestPrices (Symbol, Price, LastExecutionTime)
		select Symbol, Price, ExecutionTime
		from vLatestTrades
		where IsDelisted = 0 and Symbol not in (select distinct Symbol from LatestPrices) 

	set @rci = @@ROWCOUNT

	delete lp from LatestPrices lp inner join Securities s on lp.Symbol = s.Symbol where IsDelisted = 1
	set @rcd = @@ROWCOUNT

	update lp set lp.Price = src.Price, lp.LastExecutionTime = src.ExecutionTime
	from LatestPrices lp inner join vLatestTrades src
		on IsDelisted = 0 and lp.LastExecutionTime < src.ExecutionTime
	set @rcu = @@ROWCOUNT

	select @rci as 'Inserts', @rcd as 'Deletes', @rcu as 'Updates'

end
go

