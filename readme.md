# Markdown of the PostgresSQL exercises
###### - For the course Data Science for Business



## Goodreads_v2 exercise

###### The link for the exercise can be found on the following link:

<https://troelsmortensen.github.io/CodeLabs/Tutorials/GoodreadsExercises/Page.html>

----
### Exercise 2: 
 
❓ *What is the first and last name of the author with id 23?*


````postgresql
SELECT id, first_name, last_name
FROM author
WHERE id = 23;
````
| id | first\_name | last\_name |
| :--- | :--- | :--- |
| 23 | Jim | Butcher |

----
### Exercise 3 
❓*What book has the id 24358527?*

````postgresql
SELECT id, title, year_published
FROM book
WHERE id = 24358527;
````
❗ *Answer*:

| id | title | year\_published |
| :--- | :--- | :--- |
| 24358527 | Angles of Attack \(Frontlines,  #3\) | 2015 |

---
### Exercise 4 
❓*How many profiles are there?*
````postgresql
SELECT count(id) as "Numbers of profiles"
FROM profile;
````
❗ *Answer*:

| Numbers of profiles |
| :--- |
| 793 |

---
### Exercise 5 
❓*How many profiles have the first name 'Jaxx'?*
````postgresql
SELECT first_name,count(first_name)
FROM profile
WHERE first_name = 'Jaxx'
GROUP BY first_name
;
````
❗ *Answer*:

| first\_name | count |
| :--- | :--- |
| Jaxx | 3 |

---
### Exercise 6
❓*Are there two authors with the same first name?*
````postgresql
SELECT first_name, count(*)
FROM author
GROUP BY first_name
HAVING (count(*)>1)
ORDER BY count(*) DESC
LIMIT 3
;
````
❗ *Answer*:

| first\_name | count |
| :--- | :--- |
| John | 8 |
| Michael | 6 |
| Stephen | 6 |

---
### Exercise 7 & 8 
❓*Create a list of book titles and their page count, order by the book with the highest page count first*
````postgresql
SELECT title, page_count
FROM book
WHERE page_count IS NOT NULL
ORDER BY page_count DESC
LIMIT 5
;
````
❗ *Answer*:

| title | page\_count |
| :--- | :--- |
| Oathbringer \(The Stormlight Archive,  #3\) | 1248 |
| Rhythm of War \(The Stormlight Archive,  #4\) | 1230 |
| The Stand | 1152 |
| A Dance with Dragons \(A Song of Ice and Fire,  #5\) | 1125 |
| Words of Radiance \(The Stormlight Archive,  #2\) | 1087 |

---
### Exercise 9
❓*Show the books published in 2017*
````postgresql
SELECT *
FROM book
WHERE year_published = 2017
LIMIT 3
;
````
❗ *Answer*:

| id | isbn | title | page\_count | year\_published | binding\_id | publisher\_id | author\_id |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 36595716 | null | Changeling's Fealty \(Changeling Blood,  #1\) | 310 | 2017 | 4 | 8 | 5 |
| 34931316 | null | The Damned Trilogy: A Call to Arms,  The False Mirror,  and The Spoils of War | 958 | 2017 | 4 | 14 | 14 |
| 35621572 | null | Rise of Gods \(The Paternus Trilogy,  #1\) | 504 | 2017 | 4 | 29 | 27 |

---
### Exercise 10
❓*Who published: Tricked (The Iron Druid Chronicles,  #4)*
````postgresql
SELECT publisher.id,publisher_name, title
FROM publisher,
     book
WHERE title = 'Tricked (The Iron Druid Chronicles,  #4)'
    AND publisher.id IN (SELECT publisher_id
                        FROM book
                        WHERE title = 'Tricked (The Iron Druid Chronicles,  #4)'
                        )
;
````
❗ *Answer*:

| id | publisher\_name | title |
| :--- | :--- | :--- |
| 169 | Random House Publishing Group | Tricked \(The Iron Druid Chronicles,  #4\) |

---
### Exercise 11 
❓*What's the binding type of 'Fly by Night'?*
````postgresql
SELECT binding_type.id, type, title
FROM binding_type,
     book
WHERE title ='Fly by Night'
    AND binding_type.id = (SELECT binding_id
                           FROM book
                           WHERE title = 'Fly by Night'
                           )
;
````
❗ *Answer*:

| id | type | title |
| :--- | :--- | :--- |
| 2 | Hardcover | Fly by Night |

---
### Exercise 12
❓*How many books do not have an ISBN number?*
````postgresql
SELECT count(*) as "Books without ISBN nr."
FROM book
WHERE isbn ISNULL
;
````
❗ *Answer*:

| Books without ISBN nr. |
| :--- |
| 200 |

---
### Exercise 13
❓*How many authors have a middle name?*
````postgresql
SELECT count(*) as "Authors that have a middle name"
FROM author
WHERE middle_name IS NOT NULL
;
````
❗ *Answer*:

| Authors that have a middle name |
| :--- |
| 47 |

---
### Exercise 14
❓*Show an overview of author id and how many books they have written. Order by highest count at the top.*
````postgresql
SELECT author_id,first_name, last_name,count(title) as "Books read"
FROM author
JOIN goodreads_v2.book b ON author.id = b.author_id
GROUP BY author_id, first_name, last_name
ORDER BY count(title) DESC
LIMIT 5
;

````
❗ *Answer*:

| author\_id | first\_name | last\_name | Books read |
| :--- | :--- | :--- | :--- |
| 2 | Brandon | Sanderson | 41 |
| 5 | Glynn | Stewart | 23 |
| 11 | Derek | Landy | 20 |
| 23 | Jim | Butcher | 19 |
| 29 | Kevin | Hearne | 19 |

---
### Exercise 15 & 16
❓*What is the highest page count?*
````postgresql
SELECT max(page_count) as "Max PC", title
FROM book
WHERE page_count is not NULL
GROUP BY title
ORDER BY max(page_count) DESC
LIMIT 1;
````
❗ *Answer*:

| Max PC | title |
| :--- | :--- |
| 1248 | Oathbringer \(The Stormlight Archive,  #3\) |


* LIMIT kan bruges til kun få vist den første række ved at bruge i.e. "1"
  * I forlængelse af LIMIT kan offset bruges til at springe x antal rækker over, man kan f.eks. finde den 2 højeste page count ved at sige: 
````postgresql
LIMIT 1 OFFSET 1
````
* * Man kan også finde den 10'ene største page count ved at sige:
````postgresql
LIMIT 1 OFFSET 9
````
---
### Exercise 17
❓*How many books has the reader with the profile name 'Venom_Fate' read?*
````postgresql
SELECT count(*), profile_id, profile_name
FROM book_read,
     profile
WHERE status = 'read'
    AND profile_name = 'Venom_Fate'
    AND profile_id = (SELECT id
                      FROM profile
                      WHERE profile_name = 'Venom_Fate')
GROUP BY profile_id, profile_name
;
````
❗ *Answer*:

| count | profile\_id | profile\_name |
| :--- | :--- | :--- |
| 179 | 55 | Venom\_Fate |

---
### Exercise 18
❓*How many books are written by Brandon Sanderson?*
````postgresql
SELECT count(*), author_id, first_name, last_name
FROM book,
     author
WHERE first_name = 'Brandon' AND last_name = 'Sanderson'
    AND author_id = (SELECT id
                   FROM author
                   WHERE first_name = 'Brandon'
                    AND last_name = 'Sanderson')
GROUP BY author_id, first_name, last_name;
````
❗ *Answer*:

| count | author\_id | first\_name | last\_name |
| :--- | :--- | :--- | :--- |
| 41 | 2 | Brandon | Sanderson |

---
### Exercise 19
❓*How many readers have read the book 'Gullstruck Island'?*
````postgresql
SELECT count(*) as "Antal Readers", title
FROM book_read,
     book
WHERE title = 'Gullstruck Island'
    AND status = 'read'
    AND book_id = (SELECT id
                   FROM book
                   WHERE title = 'Gullstruck Island')
GROUP BY title;
````
❗ *Answer*:

| Antal Readers | title |
| :--- | :--- |
| 189 | Gullstruck Island |

---
### Exercise 20
❓*How many books have the author Ray Porter co-authored?*
````postgresql

````
❗ *Answer*:

---