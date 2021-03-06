library(ggplot2)
library(ggmap)

instances<-11
time_instances <-list()             # Tiempo que tarda la ejecucion de una instancia
inst_best_objetive <-list()         # Mejores objetivos por instancia
inst_best_objetive_iter <-list()    # Mejores objetivos por iteracion
initial<-list()                     # Primera solucion (soluci�n inicial)

objectiveFunction <- function(sismos, centroids){
  totalDist = 0
  for (i in 1:length(sismos)) {
    for (j in 1:length(centroids)) {
      if(sismos[[i]][[9]] == j){
        d <- distHaversine(c(sismos[[i]][[3]],sismos[[i]][[2]]),c(centroids[[j]][[3]],centroids[[j]][[2]]),r= 6371.0)
        totalDist = totalDist + d
      }
    }
  }
  return (totalDist)
}


ILS <- function(max_iteraciones,funcion_vecindad,sismos, max_clusters,medians,inst){
  # Inicializando soluciones inicial
  centroids <- initialSolution(sismos, num_centroids=max_clusters)
  lista <- kmedians(sismos,centroids,medians)
  sismos <- lista[[1]]
  centroids <- lista[[2]]
  dist <- objectiveFunction(sismos,centroids)
  initial <<- sismos
  bestObjective= dist
  objectives <- list()
  objectives <- append(objectives,dist)

  for (i in 1:max_iteraciones) {

    if(funcion_vecindad == 1){
      centroids_new = randomSwap(centroids, sismos)
    }else{
      centroids_new = averageNeighbour(centroids, sismos)
    }

    sismos_new <- sismos
    lista_new <- kmedians(sismos_new, centroids_new,medians)
    sismos_new <- lista_new[[1]]
    centroids_new = lista_new[[2]]
    dist_new <- objectiveFunction(sismos_new,centroids_new)

    if (dist_new < dist){
      sismos <- sismos_new
      centroids <- centroids_new
      dist <- dist_new
      bestObjective= dist_new
    }
    objectives <- append(objectives,dist)
  }

  inst_best_objetive_iter[[inst]] <<-objectives
  inst_best_objetive<<- append(inst_best_objetive, bestObjective)

  final  <- list(sismos,centroids)
  return (final)
}
#-------Ciclo de instancias-------

#for (inst in 1:instances) {

#--------- INICIO --------------
  start_time = Sys.time()
  finales <- ILS(50, 2,sismos,3,1,inst)
  end_time = Sys.time()
#------------ FIN --------------
  total_time = end_time - start_time
  total_time = as.numeric(total_time, units = "secs")
  print(total_time)
  time_instances <<- append(time_instances, total_time)
#------ fin instancia------------
}
time_average <- mean(as.numeric(time_instances))
print(c("El tiempo promedio es de: ",time_average," seg."))
time_sum <- sum(as.numeric(time_instances))
print(c("El tiempo total es de: ", time_sum," seg."))

print(inst_best_objetive_iter)

#-------- Graficar ---------------
sismos_finales <- finales[[1]]
centroides_finales <- finales[[2]]

#clustering_plot(initial)
clustering_plot(sismos_finales)
objectivesIterations_plotting(inst_best_objetive)
objectivesInstances_plotting(inst_best_objetive_iter)
