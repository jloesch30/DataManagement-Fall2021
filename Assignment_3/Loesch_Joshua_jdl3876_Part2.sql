-- Author: Joshua Loesch
-- UTEID: jdl3876

-- Begin part 2

-- Problem: 1
SELECT
    genre,
    title,
    publisher,
    number_of_pages
FROM
    title;

SELECT
    genre,
    title,
    publisher,
    number_of_pages
FROM
    title
ORDER BY
    number_of_pages ASC;

-- Problem: 2
SELECT
    author_full_name
FROM
    (
        SELECT
            first_name
            || ' '
            || last_name AS author_full_name,
            first_letter
        FROM
            (
                SELECT
                    first_name,
                    last_name,
                    substr(first_name, 1, 1) AS first_letter
                FROM
                    author
            )
        WHERE
            first_letter IN ( 'A', 'B', 'C' )
    );
    
-- Problem: 3
SELECT
    patron_id,
    title_copy_id,
    date_out,
    due_back_date,
    date_in
FROM
    checkouts
WHERE
    date_out BETWEEN to_date('01-FEB-2021') AND to_date('28-FEB-2021')
ORDER BY
    date_in ASC,
    date_out ASC;

-- Problem: 4
SELECT
    patron_id,
    title_copy_id,
    date_out,
    due_back_date,
    date_in
FROM
    checkouts
WHERE
        date_out >= to_date('01-FEB-2021')
    AND date_out <= to_date('28-FEB-2021')
ORDER BY
    date_in ASC,
    date_out ASC;
    
-- Problem: 5
SELECT
    checkout_id,
    title_copy_id,
    ( 2 - times_renewed ) AS renewals_left
FROM
    checkouts
WHERE
    ROWNUM < 6
ORDER BY
    renewals_left ASC;
    
-- Problem: 6
SELECT
    title,
    genre,
    ( round(number_of_pages / 100) ) AS book_level
FROM
    title
WHERE
    round(number_of_pages / 100) > 9;

-- Problem: 7
SELECT
    first_name,
    middle_name,
    last_name
FROM
    author
WHERE
    middle_name IS NOT NULL
ORDER BY
    middle_name ASC,
    last_name ASC;
    
-- Problem: 8
SELECT
    sysdate            today_unformatted,
    to_char(sysdate, 'mm/dd/yyyy'),
    ( 5 )              days_late,
    (.25 )             late_fee,
    ( 5 *.25 )         total_late_fees,
    ( 5 - ( 5 *.25 ) ) late_fees_until_lock
FROM
    dual;
    
-- Problem: 9
SELECT DISTINCT
    genre
FROM
    title
ORDER BY
    genre ASC;
    
-- Problem: 10
SELECT * from title
where instr(lower(title), 'bird') > 0;