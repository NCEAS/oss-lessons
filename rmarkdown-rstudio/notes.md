---
title: RMarkdown and RStudio
---

TODO: Check if latest stable releases of RStudio Client support R Notebooks feature


Introduction:

Plain text is a great way to write information down. Plain text has some major advantages:

- Works regardless of what decade you're trying to read the file, i.e. computers have and will continue to speak plain text but MS Word formats will continue to be a pain in the neck forever
- Works perfectly with version control software like git. MS Word does not.
- Easy to read, easy to write

Markdown is a plain text format that allows for more advanced typesetting features such as:

- Text formatting (bold, italic, etc.)
- Links
- Tables
- In-lined images

So if we want those kinds of things, we might want to use Markdown.

RMarkdown allows us to produce an output document (PDF, DOCX, website) based upon a mix of Markdown and R code.
This lets us write analyses in R as we already do but also write our reports/papers/etc. in R.
Instead of the usual:

- Run analysis
- Edit/update report

loop, the loop becomes:

- Edit RMarkdown doc
- Go home

Best resources:

- [http://rmarkdown.rstudio.com/](http://rmarkdown.rstudio.com/)
- [http://kbroman.org/knitr_knutshell/](http://kbroman.org/knitr_knutshell/)

Flow:

- Get RStudio installed and running
    - Make sure students have a recent version
- Teach RMarkdown, get students knitting reports
    - Teach Rmd
        - Get students to create Rmd doc
        - Knit the document
        - Go through the document piece-by-piece:
            - YAML frontmatter
            - Chunks
    - Teach RStudio Notebooks

RMarkdown Principles:

- Chunks

Chunks take options, see: https://yihui.name/knitr/options/

Common options include:

- include TRUE/FALSE
- echo TRUE/FALSE

- Inline expressions in prose

Just type what you want with `r 2+2`

- Plots

Base graphics: Just run `plot(1:10)`
ggplot2: Run `print(ggplot(...))`

Customize output sizing with chunk options: `fig.width`, `fig.height`

- Tables

If you search around, there are tons of ways to do this. The most basic way and the way I almost always use is with the `kable` function from the `knitr` package:

```{r}
knitr::kable(my_data_frame)
```

Reference: http://rmarkdown.rstudio.com/lesson-7.html


- Output formats


