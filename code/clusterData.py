from sklearn.cluster import KMeans
from sklearn.cluster import DBSCAN
from sklearn.cluster import AgglomerativeClustering
from sklearn.cluster import SpectralClustering
import matplotlib.pyplot as plt
import seaborn as sns # plotting


import h5py
import os

exec(open("./code/getPostProcessData.py").read())
#exec(open("C:/Users/Hossein/Documents/MASc/Projects/EpilepsyHistology/code/tools/ProcessingTools.py").read())
#exec(open("C:/Users/Hossein/Documents/MASc/Projects/EpilepsyHistology/code/getPostProcessData.py").read())

    
#clusterData(fn_Table='C:/Users/Hossein/Desktop/Table.csv',fn_List='C:/Users/Hossein/Desktop/subjList.mat',outDir='C:/Users/Hossein/Desktop/Results/',n_maxClusters=2)

def clusterData(fn_Table,fn_List,outDir,n_maxClusters=30,SmoothData=True,sigma=5,slideNorm=False,dimReduction=False):

    # Header info used to save images
    if(SmoothData):
        hdrString='_Smoothing-'+str(sigma)+'_WithinSlideNormalization-'+str(slideNorm)+'_dimReduction-'+str(dimReduction)
    else:
        hdrString='_Smoothing-'+str(SmoothData)+'_WithinSlideNormalization-'+str(slideNorm)+'_dimReduction-'+str(dimReduction)

    # Data is the Original unprocessed Data
    # X is the Processed Data
    # Xhdr is the Header info 

    Data,X,Xhdr=getPostProcessData(fn=fn_Table,outDir=outDir,SmoothData=SmoothData,sigma=sigma,slideNorm=slideNorm,dimReduction=dimReduction)

    plt.figure(figsize=[10,10])
    sns.pairplot(X)
    plt.savefig(outDir+'Data'+hdrString+'.png')
    plt.close()

    ########################################   Cluster    ############################################
    print("###########################################################################################")
    print(Data.head(n=5))
    print("###########################################################################################")

    # Run Through Hyper Parameters
    for n_clusters in range(2,n_maxClusters+1):

        # ============================
        # Create cluster objects
        #   1) K-Menas Clustering
        #   2) Spectral Clustering
        #   3) Agglomerative Clustering
        # ============================

        k = KMeans(n_clusters=n_clusters,random_state=10)
    
        spectral = SpectralClustering(
            n_clusters=n_clusters, eigen_solver='arpack',random_state=10,
            affinity ="nearest_neighbors")

        # ==============================================================
        # Agglomerative Clustering: Linkage={ward,complete,average}
        #                           Affinity={cosine,euclidean,manhattan}
        # ==============================================================

        # Ward linkage
        ward = AgglomerativeClustering(
            n_clusters=n_clusters, linkage='ward')
        
        # Average Linkage
        average_linkage_cosine = AgglomerativeClustering(
            linkage="average", affinity="cosine",
            n_clusters=n_clusters)

        average_linkage_euclidean = AgglomerativeClustering(
            linkage="average", affinity="euclidean",
            n_clusters=n_clusters)
        
        average_linkage_manhattan = AgglomerativeClustering(
            linkage="average", affinity="manhattan",
            n_clusters=n_clusters)
        
        # Complete Linkage
        complete_linkage_cosine = AgglomerativeClustering(
            linkage="complete", affinity="cosine",
            n_clusters=n_clusters)

        complete_linkage_euclidean = AgglomerativeClustering(
            linkage="complete", affinity="euclidean",
            n_clusters=n_clusters)
        
        complete_linkage_manhattan = AgglomerativeClustering(
            linkage="complete", affinity="manhattan",
            n_clusters=n_clusters)

        # =====================================
        # Create Name, and Cluster Objects Pair
        # =====================================
    
        clustering_algorithms = (
            ('KMeans', k),
            ('SpectralClustering', spectral),
            ('Ward',ward),
            ('AgglomerativeClustering_Avg_Cosine',average_linkage_cosine),
            ('AgglomerativeClustering_Avg_Cosine',average_linkage_euclidean),
            ('AgglomerativeClustering_Avg_Cosine',average_linkage_manhattan),
            ('AgglomerativeClustering_Comp_Cosine',complete_linkage_cosine),
            ('AgglomerativeClustering_Comp_Euclidean',complete_linkage_euclidean),
            ('AgglomerativeClustering_Comp_manhattan',complete_linkage_manhattan),
            )
    
        for name, algorithm in clustering_algorithms:
            algorithm.fit(X)
            # Assign Labels
            Data["Clusters"]=algorithm.labels_

            ## Plotting Average Density and Size Profiles
            plt.figure(figsize=[10,10])
            plt.subplot(1,2,1); AverageDensityClusterProfile(Data)
            plt.subplot(1,2,2); AverageSizeClusterProfile(Data)
            plt.savefig(outDir+name+'AverageProfiles_n_clusters-'+ str(n_clusters) + hdrString + '.png')
            plt.close()

            with h5py.File(fn_List, "a") as mat:
                DispSubjectDataStreamline(mat,Data)
                plt.savefig(outDir + name + 'ClusterResults_n_clusters-' + str(n_clusters) + hdrString +'.png')
                plt.close()
            
            # Display Data with cluster Labels
            #plt.figure(figsize=[10,10])
            #sns.pairplot(X,hue=Data["Clusters"].values)
            #plt.savefig(outDir+'Data-Labels_n_clusters-'+ str(n_clusters) +hdrString+'.png')
            #plt.close()








