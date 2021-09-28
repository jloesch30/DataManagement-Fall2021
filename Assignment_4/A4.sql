-- 1.
select first_name, last_name from (
select * from location l
right outer join patron p
on p.primary_branch = l.branch_id)
where accrued_fees is not null and branch_name = 'Northeast Central Branch';

-- 2.
select title as fiction_title, number_of_pages, publisher as author_name from
(select * from title_author_linking l
inner join title t
on t.title_id = l.title_id
inner join author a
on l.author_id = a.author_id)
where format = 'B' and genre = 'FIC';

-- 3
