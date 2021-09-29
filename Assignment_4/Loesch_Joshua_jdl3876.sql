-- Author: Joshua Loesch
-- UTEID: jdl3876

-- 1.
SELECT
    first_name,
    last_name,
    email,
    accrued_fees
FROM
    (
        SELECT
            *
        FROM
            location l
            RIGHT OUTER JOIN patron   p ON p.primary_branch = l.branch_id
    )
WHERE
    accrued_fees IS NOT NULL
    AND branch_name = 'Northeast Central Branch';

-- 2.
SELECT
    title     AS fiction_title,
    number_of_pages,
    publisher AS author_name
FROM
    (
        SELECT
            *
        FROM
                 title_author_linking l
            INNER JOIN title  t ON t.title_id = l.title_id
            INNER JOIN author a ON l.author_id = a.author_id
    )
WHERE
        format = 'B'
    AND genre = 'FIC';

-- 3
SELECT
    title,
    format,
    genre,
    isbn
FROM
    title              t
    LEFT JOIN patron_title_holds p ON t.title_id = p.title_id
WHERE
    date_held IS NULL
ORDER BY
    genre ASC,
    title ASC;

-- 4
SELECT
    'College' reading_level,
    title,
    publisher,
    number_of_pages,
    genre
FROM
    title
WHERE
        number_of_pages >= 700
    AND format IN ( 'B', 'E' )
UNION
SELECT
    'High School' reading_level,
    title,
    publisher,
    number_of_pages,
    genre
FROM
    title
WHERE
    ( number_of_pages BETWEEN 250 AND 700 )
    AND format IN ( 'B', 'E' )
UNION
SELECT
    'Middle School' reading_level,
    title,
    publisher,
    number_of_pages,
    genre
FROM
    title
WHERE
        number_of_pages < 250
    AND format IN ( 'B', 'E' )
ORDER BY
    reading_level,
    title;


-- 5
SELECT
    p.zip,
    round(AVG(p.accrued_fees), 2) average_accrued_fees
FROM
         patron p
    JOIN checkouts c ON p.patron_id = c.patron_id
WHERE
    late_flag <> 'Y'
GROUP BY
    p.zip
ORDER BY
    average_accrued_fees DESC;

-- 6
SELECT
    title,
    genre,
    COUNT(a.author_id) AS author_count
FROM
         author a
    JOIN title_author_linking tl ON tl.author_id = a.author_id
    JOIN title                t ON t.title_id = tl.title_id
GROUP BY
    title,
    genre
HAVING
    COUNT(a.author_id) > 1
ORDER BY
    t.title ASC,
    t.genre DESC;

SELECT
    title,
    genre,
    COUNT(a.author_id) AS author_count
FROM
         author a
    JOIN title_author_linking tl ON tl.author_id = a.author_id
    JOIN title                t ON t.title_id = tl.title_id
WHERE
    instr(lower(a.last_name), 'phd') > 0
GROUP BY
    title,
    genre
HAVING
    COUNT(a.author_id) >= 2;

-- 7
SELECT
    title,
    publisher,
    number_of_pages,
    genre
FROM
    title
WHERE
    number_of_pages > (
        SELECT
            round(AVG(number_of_pages), 2)
        FROM
            title
    )
ORDER BY
    genre ASC,
    number_of_pages DESC;

-- 8
SELECT
    first_name,
    last_name,
    email
FROM
    patron p
WHERE
    p.patron_id NOT IN (
        SELECT
            patron_id
        FROM
            patron_phone
    )
ORDER BY
    p.last_name;

-- 9
SELECT
    first_name
    || ' '
    || last_name                                  patron,
    'Checkout '
    || c.checkout_id
    || ' due back on '
    || c.due_back_date                            checkout_due_back,
    CASE
        WHEN c.date_in IS NULL THEN
            'Not returned yet'
        ELSE
            'Returned'
    END                                           return_status,
    'Accrued fee total is: $'
    || TRIM(to_char(p.accrued_fees, '999999.99')) fees
FROM
         patron p
    JOIN checkouts c ON c.patron_id = p.patron_id;
    
-- 10
SELECT
    *
FROM
    location;

SELECT
    branch_id,
    regexp_substr(branch_name, '(\S*)(\s)')   district,
    regexp_substr(address, '(\S*)(\s)')       street_num,
    TRIM(regexp_substr(address, '(\s)(\D*)')) street_name
FROM
    location;
    
-- 11
SELECT
    CASE
        WHEN number_of_pages > 700 THEN
            'College'
        WHEN number_of_pages > 250 THEN
            'High School'
        WHEN number_of_pages < 250 THEN
            'Middle School'
        ELSE
            NULL
    END reading_level,
    title,
    publisher,
    number_of_pages,
    genre
FROM
    (
        SELECT
            *
        FROM
                 title t
            JOIN title_author_linking tl ON t.title_id = tl.title_id
            JOIN author               a ON tl.author_id = a.author_id
        WHERE
            t.format IN ( 'B', 'E' )
    )
ORDER BY
    reading_level ASC,
    title ASC;
    
-- 12
SELECT
    ROW_NUMBER()
    OVER(
        ORDER BY
            COUNT(DISTINCT(c.checkout_id)) DESC
    )                    row_number,
    DENSE_RANK()
    OVER(
        ORDER BY
            COUNT(DISTINCT(c.checkout_id)) DESC
    )                    rank,
    title,
    COUNT(c.checkout_id) number_of_checkouts
FROM
         title t
    JOIN title_loc_linking tl ON tl.title_id = t.title_id
    LEFT JOIN checkouts         c ON c.title_copy_id = tl.title_copy_id
GROUP BY
    title;

-- Final Q:12
select * from (SELECT
    ROW_NUMBER()
    OVER(
        ORDER BY
            COUNT(DISTINCT c.checkout_id) DESC
    )                             AS row_number,
    t.title,
    COUNT(DISTINCT c.checkout_id) AS number_of_checkouts
FROM
    title             t
    LEFT JOIN title_loc_linking tlc ON tlc.title_id = t.title_id
    FULL OUTER JOIN checkouts         c ON tlc.title_copy_id = c.title_copy_id
GROUP BY
    t.title
ORDER BY
    number_of_checkouts DESC,
    t.title ASC)
where row_number = 58;