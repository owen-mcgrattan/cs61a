create table parents as
  select "abraham" as parent, "barack" as child union
  select "abraham"          , "clinton"         union
  select "delano"           , "herbert"         union
  select "fillmore"         , "abraham"         union
  select "fillmore"         , "delano"          union
  select "fillmore"         , "grover"          union
  select "eisenhower"       , "fillmore";

create table dogs as
  select "abraham" as name, "long" as fur, 26 as height union
  select "barack"         , "short"      , 52           union
  select "clinton"        , "long"       , 47           union
  select "delano"         , "long"       , 46           union
  select "eisenhower"     , "short"      , 35           union
  select "fillmore"       , "curly"      , 32           union
  select "grover"         , "short"      , 28           union
  select "herbert"        , "curly"      , 31;

create table sizes as
  select "toy" as size, 24 as min, 28 as max union
  select "mini",        28,        35        union
  select "medium",      35,        45        union
  select "standard",    45,        60;

-------------------------------------------------------------
-- PLEASE DO NOT CHANGE ANY SQL STATEMENTS ABOVE THIS LINE --
-------------------------------------------------------------

-- The size of each dog
create table size_of_dogs as
  select name,size from dogs,sizes where min< height and height <= max;

-- All dogs with parents ordered by decreasing height of their parent
create table by_height as
  select child from parents, dogs where parent=name order by height desc;

-- Sentences about siblings that are the same size
create table sentences as
  with
    siblings(first, second) as (
      select a.child, b.child from parents as a, parents as b
        where a.parent = b.parent and a.child<b.child
    )
  select first || ' and ' || second || ' are ' || a.size || ' siblings'
    from siblings, size_of_dogs as a, size_of_dogs as b
    where a.size = b.size and a.name = first and b.name = second;

-- Ways to stack 4 dogs to a height of at least 170, ordered by total height
create table stacks as
  with
    sums(names,total,n,max) as (
      select name,height,1,height from dogs union
      select names || ', ' || name,total+height,n+1,height
        from sums,dogs
        where n<4 and max<height
    )
  select names,total from sums where n=4 and total>=170 order by total;

-- non_parents is an optional, but recommended question
-- All non-parent relations ordered by height difference
create table non_parents as
  with
    grandparents(gdog,gpup) as (
      select a.parent,b.child from parents as a, parents as b
        where a.child=b.parent
    ),
    ancestors(ancestor,descendent) as (
      select gdog,gpup from grandparents union
      select ancestor,child from ancestors,parents
        where parent=descendent
    ),
    relations(first,second) as (
      select ancestor, descendent from ancestors union
      select descendent, ancestor from ancestors
    )
  select first,second from relations,dogs as f,dogs as s
    where first=f.name and second = s.name order by f.height-s.height;

create table ints as
    with i(n) as (
        select 1 union
        select n+1 from i limit 100
    )
    select n from i;

create table divisors as
  with blah(one,two) as (
    select b.n,a.n
    from ints as b, ints as a where a.n<=b.n
  )
  select one,COUNT(*) as count from blah where one%two==0 group by one;

create table primes as
    select one from divisors where count==2;
