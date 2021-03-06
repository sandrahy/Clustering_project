library(geosphere)
library(seqinr)

#Funci�n para calcular distancia promedio de cada cluster
calculateAVGdistance <- function(centroids,sismos){
  list_avg <- list()
  for (i in 1:length(centroids)) {
    distancias <- list()
    for (j in 1:length(sismos)) {
      if(sismos[[j]][[2]]!=centroids[[i]][[2]] & sismos[[j]][[3]]!=centroids[[i]][[3]]){
        if(sismos[[j]][[9]] == i){
          d <- distHaversine(c(sismos[[j]][[3]],sismos[[j]][[2]]),c(centroids[[i]][[3]],centroids[[i]][[2]]),r= 6371.0) 
          distancias <- append(distancias,d)
        }
      }
    }
    avg <- mean(as.numeric(distancias))
    list_avg <- append(list_avg,avg)
  }
  return (list_avg)
}

#Funci�n de vecindad promedio
#Entrada: centroids (lista centroides), avg_dist (lista distancia promedio de cada cluster), datos con su cluster correspondiente
averageNeighbour <- function(centroids, sismos){ 
  avg_dist = calculateAVGdistance(centroids,sismos) ##En caso de error, volver como estaba antes
  len_centroids<-length(centroids)
  len_sismos<-length(sismos)
  for(i in 1:len_centroids){
    for(j in 1:len_sismos) {
      rand_position <- sample(1:len_sismos, 1)
      while(sismos[[rand_position]][[9]] != i){
        rand_position <- sample(1:len_sismos, 1)
      }
      rand_data <- sismos[rand_position]
      if(rand_data[[1]][[2]]!=centroids[[i]][[2]] & rand_data[[1]][[3]]!=centroids[[i]][[3]]){
        distance <- distHaversine(c(rand_data[[1]][[3]],rand_data[[1]][[2]]),c(centroids[[i]][[3]],centroids[[i]][[2]]),r= 6371.0)
        if(distance <= as.numeric(avg_dist[i])) {
          centroids[[i]][[2]]=rand_data[[1]][[2]]
          centroids[[i]][[3]]=rand_data[[1]][[3]]
          break
        } 
      }
    }
  }
  return (centroids)
}

#Funci�n de random_swap
#Entrada: centroids (lista centroides), datos con su cluster correspondiente
randomSwap <- function(centroids, sismos){ 
  len_centroids<-length(centroids)
  len_sismos<-length(sismos)
  
  rand_pos_centroid <- sample(1:len_centroids, 1)
  rand_pos_sismo <- sample(1:len_sismos, 1)
  
  centroids[[rand_pos_centroid]][[2]]=sismos[[rand_pos_sismo]][[2]]
  centroids[[rand_pos_centroid]][[3]]=sismos[[rand_pos_sismo]][[3]]
  
  return (centroids)
}
