import sys, getopt

from sklearn.cluster import KMeans
from sklearn.cluster import DBSCAN
from sklearn.cluster import AgglomerativeClustering
from sklearn.cluster import SpectralClustering
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import seaborn as sns # plotting


import h5py
import os
import code 
import getPostProcessData as gd
from tools import VisualizationTools as vis


def main(fn_Table,fn_List,outDir,sigma,slideNorm,dimReduction):

    clusterData(fn_Table,fn_List,outDir,sigma=sigma,slideNorm=slideNorm,dimReduction=dimReduction)

def clusterData(fn_Table,fn_List,outDir,n_maxClusters=30,sigma=5,slideNorm=False,dimReduction=False):

    # Header info used to save images
    hdrString='_Smoothing-'+str(sigma)+'_WithinSlideNormalization-'+str(slideNorm)+'_dimReduction-'+str(dimReduction)
    print(hdrString)


    # Data is the Original unprocessed Data
    # X is the Processed Data
    # Xhdr is the Header info 

    Data,X,Xhdr=gd.getPostProcessData(fn=fn_Table,outDir=outDir,sigma=sigma,slideNorm=slideNorm,dimReduction=dimReduction)

    plt.figure(figsize=[10,10])
    sns.pairplot(X)
    plt.savefig(outDir+'/'+'Data'+hdrString+'.png')
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
            plt.subplot(1,2,1); vis.AverageDensityClusterProfile(Data)
            plt.subplot(1,2,2); vis.AverageSizeClusterProfile(Data)
            plt.savefig(outDir + '/' + name + '_AverageProfiles_n_clusters-' + str(n_clusters) + hdrString + '.png')
            plt.close()

            # changed this to a read only process to have multple proceses to acess file
            with h5py.File(fn_List, "r") as mat:
                vis.DispSegmentation(mat,Data)
                plt.savefig(outDir +'/'+ name + '_ClusterResults_n_clusters-' + str(n_clusters) + hdrString +'.png')
                plt.close()
            
            # Display Data with cluster Labels
            #plt.figure(figsize=[10,10])
            #sns.pairplot(X,hue=Data["Clusters"].values)
            #plt.savefig(outDir+'Data-Labels_n_clusters-'+ str(n_clusters) +hdrString+'.png')
            #plt.close()


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Clusters Data")
    parser.add_argument("-i",dest="infile",help="Table containing data (csv)",required=True)
    parser.add_argument("-list",dest="list",help="h5py List containing variety of structured data",required=True)
    parser.add_argument("-o",dest="outdir",help="Output directory",required=True)
    parser.add_argument("--sig",dest="sig",default=5,type=int,help="Gussian Smoothing Sigma <Default sig=5>")
    parser.add_argument("--norm",dest="norm_flag",default='False',type=str,help="Normalize Data within slide <True/False>")
    parser.add_argument("--pca",dest="dimReduction",default='False',type=str,help="Apply PCA to data <True/False>")
    args=parser.parse_args()

    main(args.infile,args.list,args.outdir,args.sig,args.norm_flag=='True',args.dimReduction=='True')



