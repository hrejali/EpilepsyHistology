import sys, getopt
import numpy as np
import pandas as pd

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
import ProcessMacroFeatData as gmd
import runClusterAlg as rc
from tools import VisualizationTools as vis

from sklearn.cluster import SpectralClustering
from sklearn.metrics import silhouette_score


def main(fn_Table,fn_List,outDir,sigma,slideNorm,dimReduction):

    clusterData(fn_Table,fn_List,outDir,sigma=sigma,slideNorm=slideNorm,dimReduction=dimReduction)

def clusterData(fn_Table,fn_List,outDir,n_maxClusters=30,sigma=5,slideNorm=False,dimReduction=False):

    # Header info used to save images
    #hdrString='Smoothing-'+str(sigma)+'_WithinSlideNormalization-'+str(slideNorm)+'_dimReduction-'+str(dimReduction)
    hdrString='Smoothing-'+str(sigma)+'_dimReduction-'+str(dimReduction)
    print(hdrString)


    # Data is the Original unprocessed Data
    # X is the Processed Data
    # Xhdr is the Header info 

    Data,X,Xhdr=gd.getPostProcessData(fn=fn_Table,outDir=outDir,sigma=sigma,slideNorm=slideNorm,dimReduction=dimReduction)

    plt.figure(figsize=[10,10])
    sns.pairplot(X)
    plt.savefig(outDir+'/'+'Data'+hdrString+'.png')
    plt.close()

    ####################################### Cluster Macro Feat ######################################

    XMacro=gmd.ProcessMacroFeatData(fn_Table,outDir,sigma=30)
    n_clusters=4
    k = KMeans(n_clusters=n_clusters,random_state=10)
    name='KMeans'

    k.fit(XMacro)
    # Assign Labels
    Data["macroLabel"]=k.labels_
    Data["Clusters"]=k.labels_

    ## Plotting Average Density and Size Profiles
    silhouette_avg=vis.getSilhouettePlot(XMacro,k.labels_,n_clusters)
    silhouette_avg = float("%0.3f" % silhouette_avg)
    plt.savefig(outDir + '/MacroClustering_' + name + '_SilhouetteAvg-'+str(silhouette_avg)+'_n_clusters-' + str(n_clusters) + hdrString + '.png')
    plt.close()

    # changed this to a read only process to have multple proceses to acess file
    with h5py.File(fn_List, "r") as mat:
        vis.DispSegmentation(mat,Data)
        plt.savefig(outDir +'/MacroClustering_'+ name + '_ClusterResults_SilhouetteAvg-'+str(silhouette_avg)+'_n_clusters-' + str(n_clusters) + hdrString +'.png')
        plt.close()

    # Get Cluster Label Corresponding to Out of Plane Slicing -- This is the Cluster with the highest avg thickness
    arrThickness=np.zeros(n_clusters)
    for cluster_num in range(0,n_clusters):
        idx = Data[(Data["macroLabel"] == cluster_num)].index
        # Second Column is Thickness
        avgThickness=np.mean(XMacro.iloc[idx,1])
        arrThickness[cluster_num]=avgThickness
    idxArtifact=arrThickness.argmax()

    ########################################   Cluster    ############################################
    # This is based on prior knowledge of how the data gets clustered
    regions=["Sulci","Artifact","Straight","Gyri"]
    # Run Through Each Cluster
    for cluster_num in range(0,n_clusters):
    
        if(cluster_num == idxArtifact):
            continue
        hdr=hdrString+"_Region-"+regions[cluster_num]
        # Only analyze data with boolean == TRUE 
        Data["Analyze"]=(Data["macroLabel"] == cluster_num)

        rc.runRandForestAlg(Data,X,fn_List,outDir,hdr,dimReduction=dimReduction)
        rc.runClusterAlg(Data,X,fn_List,outDir,hdr,dimReduction=dimReduction)
        # THIS NEEDS TO RUN ON ITS OWN 
        #rc.runDBSCANAlg(Data,X,fn_List,outDir,hdr,dimReduction=dimReduction)


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



