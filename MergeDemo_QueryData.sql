



declare @l decimal(10,5)
select @l = max(Price)+1 from LatestPrices where Symbol = 'CSCO'
insert Trades (Symbol,Price) values ('CSCO',@l)


declare @m decimal(10,5)
select @m = max(Price) * 0.95 from LatestPrices where Symbol = 'KO'
insert Trades (Symbol,Price) values ('KO',@m)


select * from Trades



exec MergeLatestPrices
exec BuildLatestPrices

select * from LatestPrices where Price <> 100


update Securities set IsDelisted = 1 where Symbol = 'AAPL'



