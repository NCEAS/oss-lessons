
Good enough data modeling
========================================================
width: 1440
height: 900
font-family: 'Gill Sans', 'Source Sans Pro', 'Aller', 'Helvetica'
css: ../course-overview/oss.css

![NCEAS](../course-overview/images/nceas-logo.png)

Open Science for Synthesis, Gulf Research Program

July 10-28, 2017

Sponsor: [Gulf Research Program, National Academy of Sciences](http://www.nationalacademies.org/gulf/index.html)


Learning outcomes
========================================================

- Understand basics of relational data models 
- Learn how to design and create effective data tables in SQL
- Learn to query tables in SQL

Data Organization
========================================================
title: false

![](images/excel-org-01.png)

Multiple tables
========================================================
title: false
transition: fade

![](images/excel-org-02.png)

Inconsistent observations
========================================================
title: false
transition: fade

![](images/excel-org-03.png)

Inconsistent variables
========================================================
title: false
transition: fade

![](images/excel-org-04.png)

Marginal sums and statistics
========================================================
title: false
transition: fade

![](images/excel-org-05.png)

Good enough data modeling
========================================================
title: false

## Tables (aka Entities)

- Separate table for entity or thing measured
- Each row represents a single observed entity
- Observations (rows) all unique

## Variables (aka Attributes)

- All values in column of the same type
- All columns pertain to the observed entity (e.g., row)

- This is *normalized* data (aka tidy data)

***

![](images/table-denorm.png)

![](images/tables-norm.png)

Primary and Foreign Keys
========================================================

Primary Key: unique identifier for observations

Foreign Key: reference to a primary key in another table

***
![](images/tables-keys.png)

Simple Guidelines for Effective Data
========================================================

- Design to add rows, not columns
- Each column one type
- Eliminate redundancy
- Uncorrected data file
- Header line
- Nonproprietary formats
- Descriptive names
- No spaces

- [Borer et al. 2009. **Some Simple Guidelines for Effective Data Management.** Bulletin of the Ecological Society of America.](http://matt.magisa.org/pubs/borer-esa-2009.pdf)


Related resources
========================================================

- [Borer et al. 2009. **Some Simple Guidelines for Effective Data Management.** Bulletin of the Ecological Society of America.](http://matt.magisa.org/pubs/borer-esa-2009.pdf)
- [Software Carpentry SQL tutorial](https://swcarpentry.github.io/sql-novice-survey/)

Acknowledgements
=========================================================

OSS2017 was funded under a grant from the [Gulf Research Program, National Academy of Sciences](http://www.nationalacademies.org/gulf/index.html)

[![CC-BY](../course-overview/images/ccby.png)](http://creativecommons.org/licenses/by/4.0/) This work is licensed under a Creative Commons Attribution 4.0 International License.

