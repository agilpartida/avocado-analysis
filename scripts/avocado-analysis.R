#####Análisis exploratorio #####
summary(avocado.updated.2020)
boxplot(avocado.updated.2020$average_price,
        main = "Precio promedio de aguacates")
boxplot(avocado.updated.2020$total_volume,
        main = "Ventas de aguacates")
boxplot(avocado.updated.2020$average_price ~ type, data = avocado.updated.2020,
        col = c("lightblue", "lightgreen"),
        main = "Precio promedio de aguacates por tipo",
        xlab = "Tipo de aguacate", 
        ylab = "Precio promedio (USD)",
        ylim = c(0, max(avocado.updated.2020$average_price) + 1))  # Aumento el espacio arriba

# 2. Agregar leyenda
legend("top",                 # Ahora la leyenda va arriba
       inset = 0.02,           # Pequeño espacio desde el borde
       legend = c("Convencional", "Orgánico"),
       fill = c("lightblue", "lightgreen"),
       horiz = TRUE,           # Poner la leyenda horizontal
       bty = "n")              # Sin borde de caja

var(avocado.updated.2020$average_price)
sd(avocado.updated.2020$average_price) #comando para la desviación típica

var(avocado.updated.2020$total_volume)
sd(avocado.updated.2020$total_volume)#comando para la desviación típica

#####Precio de Venta Albany y de Boston orgánicos#####
Albany_organic <- avocado.updated.2020 [avocado.updated.2020$type == "organic" & avocado.updated.2020$geography=="Albany",]
summary(Albany_organic)

Boston_organic <- avocado.updated.2020 [avocado.updated.2020$type == "organic" & avocado.updated.2020$geography=="Boston",]
summary(Boston_organic)

#####Covarianza y correlación precio aguacates orgánicos, convencionales y volumen de ventas #####
#Aislamos primero los tipos de aguacates
Organic <- avocado.updated.2020 [avocado.updated.2020$type == "organic",]
summary(Organic)

Conventional <- avocado.updated.2020 [avocado.updated.2020$type == "conventional",]
summary(Conventional)

#Calculamos Covarianza y Correlación Organic
cov(Organic$total_volume,Organic$average_price) #-3027.04
cor(Organic$total_volume,Organic$average_price) #-0.04665951
cor(Organic[, 2:3]) #Matriz de Correlación

#Calculamos Covarianza y Correlación conventional
cov(Conventional$total_volume,Conventional$average_price) #-122979.7
cor(Conventional$total_volume,Conventional$average_price, method = c("pearson")) #-0.09164995
cor(Conventional[, 2:3]) #Matriz de Correlación

#####Relación entre precio y volumen de ventas Organico y Convencional. ¿Y con log?#####
lm(Organic$total_volume~Organic$average_price)
lm(log(Organic$total_volume)~log(Organic$average_price))

lm(Conventional$total_volume~Conventional$average_price)
lm(log(Conventional$total_volume)~log(Conventional$average_price))

#####Predicción precios de venta de aguacates orgánicos en Albany a 3 meses#####
#1. Convertimos a Ts
Precio_Albany_Organico <- ts(Albany_organic$average_price, start = c(2015,1) , frequency =52) 
plot(Precio_Albany_Organico) #Vemos cómo se ve la serie temporal
plot(decompose(Precio_Albany_Organico)) 
Prediccion_Precio_Albany_Organico$mean 

#2. Llamamos a la librería para ARIMA
library(forecast) 

#3. Usamos auto.arima
forecast(auto.arima(Precio_Albany_Organico)) 
Prediccion_Precio_Albany_Organico <- plot(forecast(auto.arima(Precio_Albany_Organico),12)) #Ajustamos los meses

