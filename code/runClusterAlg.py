import sys, getopt

from sklearn.cluster import KMeans
from sklearn.cluster import DBSCAN
from sklearn.cluster import AgglomerativeClustering
from sklearn.cluster import SpectralClustering
from sklearn.ensemble import IsolationForest
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import seaborn as sns # plotting
import numpy as np


import h5py
import os
import code 
import getPostProcessData as gd
import ProcessMacroFeatData as gmd
from tools import VisualizationTools as vis

from sklearn.cluster import SpectralClustering
from sklearn.metrics import silhouette_score


def runClusterAlg(Data,X,fn_List,outDir,hdrString,n_maxClusters=6,dimReduction=False):
    outDir=outDir+'/ClusterAlg'

    if not os.path.exists(outDir):
        os.makedirs(outDir)
    
    # Run Through Hyper Parameters
    for n_clusters in range(2,n_maxClusters+1):

        # ============================
        # Create cluster objects
        #   1) K-Menas Clustering
        #   2) Ward-Agglomerative Clustering
        # ============================

        k = KMeans(n_clusters=n_clusters,random_state=10)

        # ==============================================================
        # Agglomerative Clustering: Linkage={ward,complete,average}
        #                           Affinity={cosine,euclidean,manhattan}
        # ==============================================================

        # Ward linkage
        ward = AgglomerativeClustering(
            n_clusters=n_clusters, linkage='ward')
        
        # =====================================
        # Create Name, and Cluster Objects Pair
        # =====================================
    
        clustering_algorithms = (
            ('KMeans', k),
            ('Ward',ward),
            )

        idx=Data[(Data["Analyze"] == True)].index
        idx_Ignore=Data[(Data["Analyze"] == False)].index
        for name, algorithm in clustering_algorithms:
            algorithm.fit(X.iloc[idx,:])
            # Assign Labels
            Data.ix[idx,"Clusters"]=algorithm.labels_
            # Labels to Ignore
            Data.ix[idx_Ignore,"Clusters"]=-10

            clusterHdr = 'n_clusters-' + str(n_clusters)

            descriptor = {
                "model": name,
                "dataHdr": hdrString,
                "clusterHdr":clusterHdr
            }

            getDescriptivePlots(X,Data,fn_List,outDir,descriptor,dimReduction=dimReduction) 



def runDBSCANAlg(Data,X,fn_List,outDir,hdrString,dimReduction=False):
    name='DBSCAN'
    outDir=outDir+'/'+name

    if not os.path.exists(outDir):
        os.makedirs(outDir)
    

    idx=Data[(Data["Analyze"] == True)].index
    idx_Ignore=Data[(Data["Analyze"] == False)].index

    epsVals=[0.1,0.5,1,1.5,2,3,5]
    minSamples=[5,10,25,50,100]
    
    for epsVal in epsVals:
        for NumSamples in minSamples:
            hdr=hdrString +"_eps-"+str(epsVal)+"_minSamples-"+str(NumSamples)

            db = DBSCAN(eps=epsVal,min_samples=NumSamples).fit(X.iloc[idx,:])
            labels=db.labels_

            # Number of clusters in labels, ignoring noise if present.
            n_clusters_ = len(set(labels)) - (1 if -1 in labels else 0)
            n_noise_ = list(labels).count(-1)

            if(n_clusters_>=1):
                # Assign Labels
                Data.ix[idx,"Clusters"]=db.labels_
                # Labels to Ignore
                Data.ix[idx_Ignore,"Clusters"]=-10

                clusterHdr='n_clusters-' + str(n_clusters_) + '_n_noise-'+str(n_noise_)

                descriptor = {
                    "model": name,
                    "dataHdr": hdr,
                    "clusterHdr":clusterHdr
                }
                
                getDescriptivePlots(X,Data,fn_List,outDir,descriptor,dimReduction=dimReduction)


            else:
                continue
        

def runRandForestAlg(Data,X,fn_List,outDir,hdrString,dimReduction=False):
    name='RandomForest'
    outDir=outDir+'/'+name

    if not os.path.exists(outDir):
        os.makedirs(outDir)

    idx=Data[(Data["Analyze"] == True)].index
    idx_Ignore=Data[(Data["Analyze"] == False)].index

    clf = IsolationForest(behaviour='new', max_samples=100,
                            random_state=10, contamination='auto')
    
    clf.fit(X.iloc[idx,:])
    Labels = clf.predict(X.iloc[idx,:])
    
    # Assign Labels
    Data.ix[idx,"Clusters"]=Labels
    # Labels to Ignore
    Data.ix[idx_Ignore,"Clusters"]=-10

    n_clusters_=2
    n_noise_=np.sum(Labels==-1)
    
    clusterHdr='n_clusters-' + str(n_clusters_) + '_n_noise-'+str(n_noise_)

    descriptor = {
        "model": name,
        "dataHdr": hdrString,
        "clusterHdr":clusterHdr
    }
 
    getDescriptivePlots(X,Data,fn_List,outDir,descriptor,dimReduction=dimReduction)



def getDescriptivePlots(X,Data,fn_List,outDir,descriptor,dimReduction=False):
    ##################################################################################################################
    # Description:
    # Generate Descriptive Plots that describe the results of clustering.
    # Generates following plots:
    #   1) Average Profile plots (Density and Size)
    #   2) Segmented Slides or painted slides (colored by clusters/labels)
    #   3) Labeled Data Plots (pair plots with hue assigned as the labels from clustering)
    #   4) Radar Plots describing the weighting of features for each cluster
    #   5) Pie Charts describing the proportions of a clusters within a subject. 

    #Inputs:
    # <Data>: Pandas Dataframe containing subject (j) specific data containing Clusters column and SubjId 

    #Outputs:
    # <P>: numpy array of proportions of clusters within a subject

    ##################################################################################################################
    
    XLabeled=X.copy(deep=True)
    XLabeled["Clusters"]=Data["Clusters"]
    print(XLabeled)

    idx=Data[(Data["Analyze"] == True)].index

    # ========= 1) Average Profiles =========
    plt.figure(figsize=[10,10])
    plt.subplot(1,2,1); vis.AverageDensityClusterProfile(Data.iloc[idx,:])
    plt.subplot(1,2,2); vis.AverageSizeClusterProfile(Data.iloc[idx,:])
    
    out=outDir + "/AverageProfiles"

    if not os.path.exists(out):
        os.makedirs(out)

    plt.savefig(out + '/'+ descriptor['model'] +'_AverageProfiles_' + descriptor['clusterHdr'] + '_' + descriptor['dataHdr']+ '.png')
    plt.close()
    # ======================================

    # ======== 2) Segmented Slides =========
    # changed this to a read only process to have multple proceses to acess file
    with h5py.File(fn_List, "r") as mat:
        vis.DispSegmentation(mat,Data,includeIgnoreLabel=True)

        out=outDir + "/Segmentation"

        if not os.path.exists(out):
            os.makedirs(out)

        plt.savefig(out +'/'+ descriptor['model'] + '_ClusterResults_' + descriptor['clusterHdr'] + '_' + descriptor['dataHdr'] +'.png')
        plt.close()
    # ======================================

    # ========= 3) Labeled Data =========== 
    plt.figure(figsize=[50,50])
    try:
    # Display Data with cluster Labels
        sns.pairplot(XLabeled.iloc[idx,:],hue="Clusters",plot_kws=dict(edgecolor="none"))

    except:
        print("PairPlot Failed with KDE diagnol Plot")
        sns.pairplot(XLabeled.iloc[idx,:],hue="Clusters",diag_kind = 'hist',plot_kws=dict(edgecolor="none"))

    out=outDir + "/LabeledData"

    if not os.path.exists(out):
        os.makedirs(out)

    plt.savefig(out + '/'+ descriptor['model'] +'_DataLabeled_'+ descriptor['clusterHdr'] + '_' + descriptor['dataHdr'] +'.png')
    plt.close()
    # ====================================== 


    # ========= 4) RADAR PLOTS ============= 
    # initialize the figure

    out=outDir + "/RadarPlots"

    if not os.path.exists(out):
        os.makedirs(out)

    Features=["Density","Area","Eccentricity"]
    my_dpi=96
    if(dimReduction):
        plt.figure(figsize=(1000/my_dpi, 1000/my_dpi), dpi=my_dpi)
        feat="PCA"
        # Obtain radar Data Frame
        df=vis.create_radarDataFrame(X,Data)

        # Create a color palette:
        my_palette = plt.cm.get_cmap("Set2", len(df.index))

        genSpiderPlot(df,my_palette)
        plt.savefig(out+'/'+ descriptor['model'] +'_'+feat+'-RadarPlot_' + descriptor['clusterHdr'] + '_' + descriptor['dataHdr'] +'.png')
        plt.close()

    else:    
        for i,feat in enumerate(Features):
        
            plt.figure(figsize=(1000/my_dpi, 1000/my_dpi), dpi=my_dpi)

            l_bound=0+10*i
            u_bound=10*(i+1)
        
            # Obtain radar Data Frame
            df=vis.create_radarDataFrame(X.iloc[:,l_bound:u_bound],Data)

            # Create a color palette:
            my_palette = plt.cm.get_cmap("Set2", len(df.index))

            genSpiderPlot(df,my_palette)
            plt.savefig(out+'/'+ descriptor['model'] +'_'+feat+'-RadarPlot_' + descriptor['clusterHdr'] + '_' + descriptor['dataHdr'] +'.png')
            plt.close()
    

    # =====================================

    # ========= 5) Pie Charts =============
    SubjectList=Data["SubjId"].values
    SubjectList=np.unique(SubjectList)

    LabelList=Data["Clusters"].values
    LabelList=np.unique(LabelList)

    idx= Data[(Data["SubjId"] == SubjectList[0])].index

    plt.figure(figsize=[150,150])

    for i,subj in enumerate(SubjectList):
        ax = plt.subplot(round(len(SubjectList)/3),3,i+1)

        idx= Data[(Data["SubjId"] == SubjectList[i])].index
    
        P,LabelList=getlabelProportion(Data.iloc[idx,:],LabelList)
   
    
        wedges, texts, autotexts = ax.pie(P, autopct=lambda pct: func(pct),
                                  textprops=dict(color="w"))
    
        for j in range(len(autotexts)):
            if(autotexts[j].get_text()=='0.0%'):
                autotexts[j] =[]

        if(i==0):
            ax.legend(wedges, LabelList,
                loc="center left",
                bbox_to_anchor=(1, 0, 0.5, 1),fontsize=75)
        
        plt.setp(autotexts, size=65, weight="bold")
        ax.set_title("EPI_"+subj,fontsize=100,weight='bold')
    
    plt.tight_layout()

    out=outDir + "/PieCharts"

    if not os.path.exists(out):
        os.makedirs(out)
    
    plt.savefig(out+'/'+ descriptor['model'] +'_PieChart_'+ descriptor['clusterHdr'] + '_' + descriptor['dataHdr'] +'.png')
    plt.close()
    # =====================================


# These methods are required to generate the Pie Charts    
def getlabelProportion(df,LabelList):
    ##################################################################################################################
    # Description:
    # Extractions the proportions of clusters within a subject
    # Definition of proportions (P) for each cluster (i) and subject (j):

    # Pi,j =( Number of Cluster i Points in Subject j )/ (Total Number of Points in Subject j )

    #Inputs:
    # <df>: Pandas Dataframe containing subject (j) specific data containing Clusters column and SubjId 

    #Outputs:
    # <P>: numpy array of proportions of clusters within a subject

    ##################################################################################################################
    
    if (LabelList[0]==-10):
        LabelList=np.delete(LabelList, (0), axis=0)
        
    P=np.zeros(len(LabelList))
    # Labels with -10 are meant to be ignored!
    ignorePoints=len(df[(df["Clusters"] == -10)])
    total=len(df)-ignorePoints
    
    for i,labelVal in enumerate(LabelList):
        labelOccurence=len(df[(df["Clusters"] == labelVal)])
        
        P[i]=labelOccurence/total
    
    
    return P,LabelList

def func(pct):
    return "{:.1f}%".format(pct)

def genSpiderPlot(df,palette):
    # number of Groups is the number of rows in dataframe df
    numGroups=len(df.index)
    # Loop to plot
    for row in range(0, numGroups):
        vis.make_spider(df,row=row, title='group '+df['group'][row], color=palette(row),numGroups=numGroups)
    