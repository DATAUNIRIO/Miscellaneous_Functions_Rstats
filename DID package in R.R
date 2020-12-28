
lmfit <- lm(mpg ~ wt, mtcars)
lmfit
summary(lmfit)
library(broom)

tabela<-tidy(lmfit)
tabela2<-augment(lmfit)
tabela3<-glance(lmfit)

glmfit <- glm(am ~ wt, mtcars, family = "binomial")
tidy(glmfit)
augment(glmfit)
glance(glmfit)

nlsfit <- nls(mpg ~ k / wt + b, mtcars, start = list(k = 1, b = 0))
tidy(nlsfit)
augment(nlsfit, mtcars)
glance(nlsfit)

tt <- t.test(wt ~ am, mtcars)
tidy(tt)

wt <- wilcox.test(wt ~ am, mtcars)
tidy(wt)

glance(tt)

#-------------------------------------------------------------------------
# devtools::install_github("bcallaway11/did")

library(did)
data(mpdta)

out <- att_gt(yname = "lemp",
              gname = "first.treat",
              idname = "countyreal",
              tname = "year",
              xformla = ~1,
              data = mpdta,
              est_method = "reg"
)

summary(out)
ggdid(out, ylim = c(-.25,.1))
es <- aggte(out, type = "dynamic")
summary(es)
ggdid(es)
group_effects <- aggte(out, type = "group")
summary(group_effects)
