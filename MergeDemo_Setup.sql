use Demo
go

if not exists (select * from sysobjects where name = 'Securities')
	create table Securities (
		Symbol varchar(100) primary key not null,
		IsDelisted bit not null default 0
	)

if not exists (select * from sysobjects where name = 'Trades')
	create table Trades (
		Symbol varchar(100) not null,
		ExecutionTime datetimeoffset not null default getdate(),
		Price decimal(10,5) not null
	)

if exists (select * from sysobjects where name = 'vLatestTrades')
	drop view vLatestTrades
go

create view vLatestTrades as
	with orderedTrades as (
		select p.Symbol, Price, ExecutionTime, ROW_NUMBER() over (PARTITION BY p.Symbol ORDER BY ExecutionTime desc) as RecentSequence, IsDelisted
		from Trades p
			inner join Securities s on p.Symbol = s.Symbol
	)
	select Symbol, Price, ExecutionTime, IsDelisted from orderedTrades where RecentSequence = 1
go

if not exists (select * from sysobjects where name = 'LatestPrices')
	create table LatestPrices (
		Symbol varchar(100) primary key not null,
		LastExecutionTime datetimeoffset not null,
		Price decimal(10,5) not null
	)

-- DEMO DATA

if not exists (select * from Securities)
	insert Securities (Symbol) values ('AAPL'),('BAC'),('MSFT'),('T'),('PFE'),('CMCSA'),('KO'),('XOM'),('CSCO'),('VZ'),('WFC'),('INTC'),('SIRI'),('F'),('DYP'),('JPM'),('WMT'),('ORCL'),('ET'),('JNJ'),('MRK'),('NVDA'),('PG'),('FB'),('KMI'),('CSX'),('DWDP'),('BMY'),('EPD'),('IBNK'),('C'),('PCG'),('NEE'),('EMC'),('CVX'),('UBER'),('PLTR'),('MO'),('MS'),('DIS'),('SCHW'),('HPQWI'),('ABT'),('ABBV'),('V'),('LCID'),('CPNG'),('PM'),('NWSAV'),('RTX')

if not exists (select * from Trades)
	insert Trades (Symbol,Price) values ('AAPL',100),('BAC',100),('MSFT',100),('T',100),('PFE',100),('CMCSA',100),('KO',100),('XOM',100),('CSCO',100),('VZ',100),('WFC',100),('INTC',100),('SIRI',100),('F',100),('DYP',100),('JPM',100)


