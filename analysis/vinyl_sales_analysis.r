# =========================
# Time Series Analysis of Vinyl Sales
# =========================

library(itsmr)
library(tseries)
library(aTSA)
library(forecast)

# -------------------------
# Data Loading & Preparation
# -------------------------
vinyl <- read.csv("Vinyl_Units_USA_1973_2024.csv", header = TRUE)
plot(vinyl, type='l', main = "Vinyl Sales (1973-2024)",xlab="Year", ylab="Units")

vinyl.mod <- vinyl[28:52,]
vinyl.ts <- ts(vinyl.mod[,2], start=2000, frequency=1)

# -------------------------
# Exploratory Analysis
# -------------------------
plot(vinyl.ts, main = "Vinyl Sales (USA 2000-2024)", ylab = "Units")
summary(vinyl.ts)
plot(vinyl.ts)
plota(vinyl.ts)
adf.test(vinyl.ts)

plot(log(vinyl.ts))
plota(log(vinyl.ts))


y2 <- ts(trend(vinyl.ts, 2), start=2000, frequency=1)

plot(vinyl.ts)
lines(y2)

y3 <- ts(trend(vinyl.ts, 3), start=2000, frequency=1)

plot(vinyl.ts)
lines(y3)

ma.fit3 <- ma(vinyl.ts, order = 3)
ma.fit5 <- ma(vinyl.ts, order = 5)
ma.fit7 <- ma(vinyl.ts, order = 7)
plot(vinyl.ts, main="MA Smoothing Comparison")
lines(ma.fit3, col="red", lwd=2)
lines(ma.fit5, col="blue", lwd=2)
lines(ma.fit7, col="green", lwd=2)
legend("topleft", c("MA(3)", "MA(5)", "MA(7)"),
       col=c("red","blue","green"), lwd=2)

par(mfrow=c(1,1))
ets.fit <- ets(vinyl.ts)
summary(ets.fit) # not good, no trend


plot(vinyl.ts, main = "ETS Fit on Vinyl")
lines(fitted(ets.fit), col="red", lwd=2)
legend("topleft", c("Original", "ETS fit"),
       col=c("black","red"), lwd=c(1,2))

ets.add <- ets(vinyl.ts, model="AAN")
ets.mult <- ets(vinyl.ts, model="MAN")
ets.dampa <- ets(vinyl.ts, model="AAN", damped = TRUE)
ets.dampm <- ets(vinyl.ts, model="MAN", damped = TRUE)

# -------------------------
# Stationarity Testing
# -------------------------
test(residuals(ets.add))
#tseries::adf.test(residuals(ets.add))
test(residuals(ets.mult))
#tseries::adf.test(residuals(ets.mult))
test(residuals(ets.dampa))
#tseries::adf.test(residuals(ets.dampa))
test(residuals(ets.dampm))
#tseries::adf.test(residuals(ets.dampm))

# -------------------------
# Model Fitting & Selection
# -------------------------
ets.aic <- c(AIC(ets.add),AIC(ets.mult),AIC(ets.dampa),AIC(ets.dampm))
names(ets.aic) = c("AAN","MAN","AAN(D)", "MAN(D)")
ets.aic

plot(vinyl.ts, main = "ETS Fit on vinyl")
lines(fitted(ets.add), col="red", lwd=2)
lines(fitted(ets.mult), col="blue", lwd=2)
lines(fitted(ets.dampa), col="purple", lwd=2)
lines(fitted(ets.dampm), col="gray", lwd=2)
legend("topleft", c("True Sales", "AAN", "MAN", "AAN damp", "MAN damp"),
       col=c("black","red","blue","purple","gray"), lwd=c(1,2))

#MAN without damping clearly the best
dif1 <- diff(vinyl.ts,1)
plota(dif1)
tseries::adf.test(dif1)
dif2 <- diff(vinyl.ts, 2)
plota(dif2)
adf.test(dif2)

#ARIMA
arima110 <- arima(vinyl.ts, order=c(1,1,0))
test(residuals(arima110))
adf.test(residuals(arima110))
arima111 <- arima(vinyl.ts, order=c(1,1,1))
test(residuals(arima111))
adf.test(residuals(arima111))
arima210 <- arima(vinyl.ts, order=c(2,1,0))
test(residuals(arima210))
adf.test(residuals(arima210))

#AutoArima
set.seed(1)
best.arima <- auto.arima(vinyl.ts)
best.arima
test(residuals(best.arima))
adf.test(residuals(best.arima))

arima.aic <- c(AIC(arima110), AIC(arima111), AIC(arima210), AIC(best.arima))
names(arima.aic) <- c("ARIMA 110", "ARIMA 111", "ARIMA 210", "ARIMA 020")

#AIC Comparison
final.aic <- c(ets.aic, arima.aic)
final.aic #beat are 110, 210, 020

# -------------------------
# Forecasting
# -------------------------
par(mfrow=c(2,2))
forecast.1.s <- forecast::forecast(arima110, h=5, level=95)
forecast.2.s <- forecast::forecast(arima210, h=5, level=95)
forecast.3.s <- forecast::forecast(best.arima, h=5, level=95)
forecast.4.s <- forecast::forecast(ets.mult, h=5, level=95)
plot(forecast.1.s)
plot(forecast.2.s)
plot(forecast.3.s)
plot(forecast.4.s)

par(mfrow=c(2,2))
forecast.1.l <- forecast::forecast(arima110, h=10, level=95)
forecast.2.l <- forecast::forecast(arima210, h=10, level=95)
forecast.3.l <- forecast::forecast(best.arima, h=10, level=95)
forecast.4.l <- forecast::forecast(ets.mult, h=10, level=95)
plot(forecast.1.l)
plot(forecast.2.l)
plot(forecast.3.l)
plot(forecast.4.l)


