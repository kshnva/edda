
library(MASS)
library(ggplot2)
library(dplyr)
library(lme4)
data(stormer)
set.seed(42)

# a)
#plot = ggplot(stormer, aes(x=Viscosity, y=Time, color=Wt)) + geom_point()
#plot

#form=as.formula(Time~Wt)
form=as.formula(Wt*Time~ Viscosity + Time)
lin_model = lm(form, data=stormer)
lin_model

#fplot = function(x){
#  (theta0[1]*x)/(50 - theta0[2])
#}
#plot = plot + geom_function(fun=fplot)
#plot

t_lin = lin_model$coefficients
initial = c(theta1 = unname(t_lin[2]), theta2=unname(t_lin[3]))
initial
form=as.formula(Time~ (theta1*Viscosity)/(Wt - theta2))
nmodel = nls(form, data=stormer,start=initial)
summary(nmodel)
confint(nmodel)
deviance(nmodel)
sig2 = sum(resid(nmodel) * resid(nmodel)) / (nrow(stormer) - 2)
theta_fit = coef(nmodel)


f_fit20 = function(v){
  (theta_fit[1]*v)/(20 - theta_fit[2])
}
f_fit50 = function(v){
  (theta_fit[1]*v)/(50 - theta_fit[2])
}
f_fit100 = function(v){
  (theta_fit[1]*v)/(100 - theta_fit[2])
}
plot = ggplot(stormer, aes(x=Viscosity, y=Time, color=Wt)) + geom_point()
plot = plot + stat_function(fun=f_fit20) +
        stat_function(fun=f_fit50) +
        stat_function(fun=f_fit100)

plot


qqnorm(resid(model)); qqline(resid(model),col="red")
# the fit seems to match the data well from visual inspection. The residuals are normally distributed skewed.    



initial = c(theta2=2)
form_limited =as.formula(Time~ (25*Viscosity)/(Wt - theta2))
model = nls(form_limited, data=stormer,start=initial)
summary(model)

theta2 = coef(model)[1]

f_fit20l = function(v){
  (25*v)/(20 - theta2)
}
f_fit50l = function(v){
  (25*v)/(50 - theta2)
}
f_fit100l = function(v){
  (25*v)/(100 - theta2)
}
plot = ggplot(stormer, aes(x=Viscosity, y=Time, color=Wt)) + geom_point()
plot = plot + stat_function(fun=f_fit20l) +
  stat_function(fun=f_fit50l) +
  stat_function(fun=f_fit100l)

plot







#c

cov.est=vcov(nmodel);cov.est
coef(nmodel)
alpha = 0.08
for (i in 1:2){
  ci = coef(nmodel)[i]-qt(c(alpha/2,1-alpha/2),23-2)*sqrt(cov.est[i,i])
  print(ci)
}


#d) f with conf interval assuming linear response:
alpha=0.006
grad50 = function(v, theta){
  rbind(theta[1]/(50 - theta[2]),
        (-theta[1]*v)/((50-theta[2])*(50-theta[2]))
        )
}
v3 = function(v) grad50(v, coef(nmodel))
cov.est
se = function(v) sqrt(t(v3(v)) %*% cov.est %*% v3(v))
ci = function(v) f_fit50(v) + (qt(c(alpha/2, 1-alpha/2),23) * (se(v)))
ub = function(v) ci(v)[1]
lb = function(v) ci(v)[2]

test_v = seq(from=10, to=300, by=5)
ub_data = numeric(length(test_v))
lb_data = numeric(length(test_v))
fv_data = numeric(length(test_v))
for (i in 1:length(test_v)){
  ub_data[i] = ub(test_v[i])
  lb_data[i] = lb(test_v[i])
  fv_data[i] = f_fit50(test_v[i])
}
fv_data
f_fit50(test_v[10])
plot_data = data.frame(
  v = test_v,
  ub = ub_data,
  lb = lb_data,
  ub1 = ub_data,
  lb1 = lb_data,
  fv = fv_data
)


plot = ggplot() + 
  geom_point(data=stormer, aes(x=Viscosity, y=Time, color=Wt)) +
  geom_ribbon(data=plot_data, aes(x=test_v,  ymin=lb, ymax=ub), fill = "lightblue",alpha=0.5)+
  geom_line(data=plot_data, aes(x=test_v,y=fv))

plot
#As v increases, we also see larger confidence intervals. 
# The fit line and confidence interval are for the expected value of Time.  
#Thus, despite the much larger measurement error sigma>6 not all measurements 
# need to lie inside the CI.






#stat_function(fun=ub) + stat_function(fun=lb)









#test_v = seq(from=20, to=300, by=5)
#w=50
#f_lin = function(v, theta){
 # return ((theta[1])/(50-theta[2])*v)
#}
#fv = f_lin(test_v, coef(model))
#theta = coef(model)
#plot + geom_abline(slope=(theta[1])/(50-theta[2]))

# w = 50
# fplot = function(x){
#   (28.876*x)/(w - 2.844)
# }
# plot = plot + geom_function(fun=fplot)
# plot
# 
# data = data.frame(test_v, fv)
# plot = plot + ggplot(data, aes(x=test_v, y=fv) )+ geom_point()
# 
# fn = function(theta, v, w){
#   return (theta[1]*v)/(w - theta[2])
# }
# # first order taylor expansion of formula:
# 
#        
# library(minpack.lm)
# library(ggplot2)
# # generate data
# x <- c(0, 1, 2, 3, 4, 5)
# y <- c(1, 2, 4, 8, 16, 32)
# # fit the model 
# start_values <- c(a=4, b=2)
# temp = y ~ a * exp(b * x)
# fit <- nls(temp,
#            start = start_values,
#            algorithm = "port",
#            control = nls.control(maxiter = 1000))
# fit
