library(cluster)
library(factoextra)

instances<-3
time_instances <-list()             # Tiempo que tarda la ejecucion de una instancia

tusDatos <- read.table(file.choose(), skip = 0, header = TRUE, sep =',')

sismos <- list()
# Creando y llenando la estructura de datos listas de listas `sismos`
                   # latitud          longitud 
sismos <-rbind(cbind(tusDatos[,2],tusDatos[,3])) 

# Specify column and row names
colnames(sismos) <- c("latitud ", "longitud") 

#LLamado de la funci�n:

#'x: una matriz de datos num�ricos o data frame, cada fila corresponde: a una observaci�n y cada columna 
#'corresponde a una variable. Se permiten valores perdidos (NA).
#'
#'k: the number of clusters.
#'
#'m�trica: m�trica de distancia que se utilizar�. Las opciones disponibles 'son "euclidiana" y "manhattan".
#'Las distancias euclidianas son la ra�z de la suma de cuadrados de las diferencias, y las distancias de
#'Manhattan son la suma de las diferencias absolutas. Leer m�s sobre medidas de distancia (Cap�tulo).
#'Tenga en cuenta que la distancia de Manhattan es menos sensible a los valores at�picos.
#'
#'
#'stand: valor l�gico; si es verdadero, las variables (columnas) en x se estandarizan antes de calcular las
#'diferencias. Tenga en cuenta que se recomienda estandarizar las variables antes de agruparlas.
#'
#'samples: n�mero de muestras que se extraer�n del conjunto de datos. El valor predeterminado es 5, pero se
#'recomienda un valor mucho mayor.
#'
#'pamLike: l�gica que indica si se debe utilizar el mismo algoritmo en la funci�n pam ().
#' Esto deber�a ser siempre TRUE.
#'

#for (inst in 1:instances) {
  
  #--------- INICIO --------------
  start_time = Sys.time()
  clara.res <- clara(sismos, 5, metric = "manhattan", stand =FALSE, samples = 100, pamLike = TRUE)
  end_time = Sys.time()
  #------------ FIN --------------
  total_time = end_time - start_time
  total_time = as.numeric(total_time, units = "secs")
  print(total_time)
  time_instances <<- append(time_instances, total_time)
  #------ fin instancia------------
  time_average <- mean(as.numeric(time_instances))
  print(time_average)
#}

#------------------------ Visualizar Datos + Graficos --------------------------
# Compute CLARA metrica de distancia?  clara.res <- clara(df, 2, samples = 50, pamLike = TRUE)

print(clara.res)

#dd <- cbind(clara.res, cluster = clara.res$cluster)
# Medoids
clara.res$medoids
print(clara.res$clustering)
# Clustering
#head(clara.res$clustering, 10)

#require(cluster)
#pam.res <- pam(iris.scaled, 3)
# Visualize pam clustering              frame.type = "norm"
fviz_cluster(clara.res, geom = "point", frame.type = "t")

