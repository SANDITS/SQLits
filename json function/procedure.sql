ALTER PROCEDURE its.sp_insertJson
@colore VARCHAR(20),
@animaleNome VARCHAR(20) = NULL,
@animaleSpecie VARCHAR(20) = NULL
as

IF @colore is null 
BEGIN
	raiserror('il parametro @colore non può essere NULL', -1, -1, 'sp_InsertJson')
END
ELSE
BEGIN

declare @id int = (select max(id) + 1 from its.json)
declare @j nvarchar(max) , @jAnimali nvarchar(max)

set @jAnimali =
		JSON_MODIFY(
			JSON_MODIFY('{}', '$.nome', @animaleNome),
			'$.specie',
			@animaleSpecie
			)
-- select @jAnimali, JSON_QUERY(@jAnimali)

set @j = JSON_MODIFY('{}', '$.id', @id)
set @j = JSON_MODIFY(
			JSON_MODIFY(@j, '$.colore', @colore),
			'append $.animali', 
			@jAnimali
			)
-- select @j
insert into its.json values (@j)
PRINT 'La registrazione del JSON è andata a buon fine

per verifica:
SELECT * FROM its.json
order by id desc '

END

EXEC its.sp_insertJson @colore = 'giallo', @animaleNome = 'pluto'

