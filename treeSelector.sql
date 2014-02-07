with tree (Name, Id, PId, [Level_], Pathroot, MainRootId) --level, pathstr)
as (select Name, 
		Id, 
		PId,
		[Level_] = 0, 
		[Pathroot] = cast('/' as varchar(max)),
		[MainRootId] = Id
	from dbo.Tree
	where Id in (select FindId from dbo.TreeFind)	
union all
	select 
		parent.Name, 
		parent.Id, 
		parent.PId,
		[Level_] = child.[Level_] + 1,
		[Pathroot] = cast(child.Pathroot + parent.Name as varchar(max)),
		[MainRootId] = child.MainRootId
	from dbo.Tree parent 
     inner join tree child on parent.id = child.PId
    where  
		not child.Id = parent.Id 
     ) 
select *
from tree 
order by MainRootId,Pathroot
--option (maxrecursion 1000)
