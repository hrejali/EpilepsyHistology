import sys, getopt

from sklearn.cluster import KMeans
from sklearn.cluster import DBSCAN
from sklearn.cluster import AgglomerativeClustering
from sklearn.cluster import SpectralClustering
from sklearn.metrics import silhouette_score
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import seaborn as sns # plotting


import h5py
import os
import code 
import ProcessMacroFeatData as gd
from tools import VisualizationTools as vis


def main(fn_Table,fn_List,outDir,sigma):

    clusterMacroFeat(fn_Table,fn_List,outDir,sigma=sigma)

def clusterMacroFeat(fn_Table,fn_List,outDir,n_maxClusters=10,sigma=5):

    # Header info used to save images
    hdrString='_Smoothing-'+str(sigma)
    print(hdrString)


    # Data is the Original unprocessed Data
    # X is the Processed Data
    # Xhdr is the Header info 

    Data,X,Xhdr=gd.ProcessMacroFeatData(fn=fn_Table,outDir=outDir,sigma=sigma)


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
            vis.getSilhouettePlot(X,algorithm.labels_,n_clusters)
            plt.savefig(outDir + '/' + name + '_Silhouette_n_clusters-' + str(n_clusters) + hdrString + '.png')
            plt.close()

            # changed this to a read only process to have multple proceses to acess file
            with h5py.File(fn_List, "r") as mat:
                vis.DispSegmentation(mat,Data)
                plt.savefig(outDir +'/'+ name + '_ClusterResults_n_clusters-' + str(n_clusters) + hdrString +'.png')
                plt.close()
            


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Clusters Data")
    parser.add_argument("-i",dest="infile",help="Table containing data (csv)",required=True)
    parser.add_argument("-list",dest="list",help="h5py List containing variety of structured data",required=True)
    parser.add_argument("-o",dest="outdir",help="Output directory",required=True)
    parser.add_argument("--sig",dest="sig",default=5,type=int,help="Gussian Smoothing Sigma <Default sig=5>")
    args=parser.parse_args()

    main(args.infile,args.list,args.outdir,args.sig)



