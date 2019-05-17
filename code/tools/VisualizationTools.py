############################################ VISUALIZATION AND PLOT FUNCTIONS ########################################
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.cm as cm
import seaborn as sns # plotting
import numpy as np
import pandas as pd
from sklearn.metrics import silhouette_samples, silhouette_score

from math import pi

def DispSubjectData(mat):
    ##################################################################################################################
    # Description:
    # Creates a subplot of density featuremap images for each slide. 

    #Inputs:
    # <mat>: h5py data containing list of subject data each containing Density Feature Maps and Streamlines

    ##################################################################################################################

    comp = mat['/dataList/Comp']
    plt.figure(figsize=[50,50])
    idx=0
    for i in range(0,53):
    
        if(mat[comp[i,0]]["FeatureMap"].dtype==object):
            NumComp=len(mat[comp[i,0]]["FeatureMap"])
            for compNum in range(0,NumComp):
                ax=plt.subplot(8,9,idx+1)
                plt.imshow(mat[mat[comp[i,0]]["FeatureMap"][compNum,0]].value,cmap="viridis")
                plt.axis('off')
                ax.set_aspect('auto')
                idx=idx+1
        else:
            ax=plt.subplot(8,9,idx+1)
            plt.imshow(mat[comp[i,0]]["FeatureMap"].value,cmap="viridis")
            plt.axis('off')
            ax.set_aspect('auto')
            idx=idx+1
        
    plt.tight_layout()

def DispSegmentation(mat,Data,includeIgnoreLabel=False):
    ##################################################################################################################
    # Description:
    # Creates a subplot of featuremap images for each slide in addition overlays streamlines colored by the label.
    # End Result is segmentation of labels overlayed ontop of Featuremaps found within mat file 

    #Inputs:
    # <mat>: h5py data containing list of subject data each containing Density Feature Maps and Streamlines
    # <Data>: Pandas Dataframe containing header information and labels for each streamline (Cluster Labels)

    ##################################################################################################################

    
    #LabelMinMax=[min(Data["Clusters"]),max(Data["Clusters"])]
    labelValues=Data["Clusters"].values
    labelValues=np.unique(labelValues)

    subjList=list(dict.fromkeys(Data["Subject"])) 
    
    comp = mat['/dataList/Comp']
    hdr = mat['/dataList/hdr']

    plt.figure(figsize=[80,80])
    idx=0
    for i in range(0,len(subjList)):
        sliceName=mat[hdr[i,0]]["slice"].value
        sliceName= "".join([chr(item) for item in sliceName])
    
        if(mat[comp[i,0]]["FeatureMap"].dtype==object):
            NumComp=len(mat[comp[i,0]]["FeatureMap"])

            for compNum in range(0,NumComp):
                ax=plt.subplot(8,9,idx+1)
                plt.imshow(mat[mat[comp[i,0]]["FeatureMap"][compNum,0]].value,cmap="viridis")
                plt.axis('off')
                ax.set_aspect('auto')
                Streamlineplot(mat,subjData(sliceName,compNum+1,Data),i,compNum,labelValues,includeIgnoreLabel)
                idx=idx+1
        else:
            ax=plt.subplot(8,9,idx+1)
            plt.imshow(mat[comp[i,0]]["FeatureMap"].value,cmap="viridis")
            plt.axis('off')
            ax.set_aspect('auto')
            Streamlineplot(mat,subjData(sliceName,1,Data),i,compNum,labelValues,includeIgnoreLabel)
            idx=idx+1
        
    plt.tight_layout()
    
def subjData(sliceName,Comp,hdrData):
    ##################################################################################################################
    # Description:
    # Extracts the Data in dataframe (Data) that corresponds to subject (sliceName) and compenent (Comp)

    #Inputs:
    # <sliceName>: Slice Name (string) ex. "EPI_P015_Neo_05_NEUN"
    # <Comp>: Slice Component (int) 
    # <Data>: Data containing Header details (DataFrame)

    #Outputs:
    # <DataOut>: Dataframe containing only data that corresponds the subject (sliceName) and compenent (Comp)

    ##################################################################################################################

    #DataOut=Data[Data["Subject"]==sliceName]
    #DataOut=Data[Data["Component"]==Comp]

    idx = hdrData[(hdrData['Component'] == Comp) & (hdrData['Subject'] == sliceName)].index
    DataOut=hdrData.iloc[idx,:]
    
    return DataOut

def Streamlineplot(mat,Data,subjNum,Comp,labelValues,includeIgnoreLabel):
    ##################################################################################################################
    # Description:
    # Creates a subplot of density featuremap images for each slide in addition overlays streamlines colored by the label. 

    #Inputs:
    # <mat>: h5py data containing list of subject data each containing Feature Mapc images and Streamlines
    # <Data>: Pandas Dataframe containing header information and labels for each streamline (Cluster Labels)
    #         NOTE This data corresponds to subject/slide/comp specific data

    ##################################################################################################################

    comp = mat['/dataList/Comp']
    labelList=0
    #Streams=mat["Comp"]["Streams"][0,0][0]
    
    # Determine # of Streamlines
    if(mat[comp[subjNum,0]]["FeatureMap"].dtype==object):
        lenStreamline=len(mat[mat[comp[subjNum,0]]["Streams"][Comp,0]])
    else:
        lenStreamline=len(mat[comp[subjNum,0]]["Streams"])

    # run through each streamline
    label=np.array(Data["Clusters"])
    
    x=np.array([])
    y=np.array([])
    labelList=np.array([])
    for i in range(0,lenStreamline-1):
        if(mat[comp[subjNum,0]]["FeatureMap"].dtype==object):
            #mat[mat[mat[comp[Subj,0]]["Streams"][Comp,0]][0,0]].value[XorY]
            xStreams=mat[mat[mat[comp[subjNum,0]]["Streams"][Comp,0]][i,0]].value[0]
            yStreams=mat[mat[mat[comp[subjNum,0]]["Streams"][Comp,0]][i,0]].value[1]
        else:
            xStreams=mat[mat[comp[subjNum,0]]["Streams"][i,0]].value[0]
            yStreams=mat[mat[comp[subjNum,0]]["Streams"][i,0]].value[1]
        
        
        x = np.append(x,xStreams)
        y = np.append(y,yStreams)
        labelList=np.append(labelList,[(label[i])]*len(xStreams))
        
    #......... THIS IS A HACK TO FORCE CONSISTENT LABEL COLORING SCHEM ACROSS SUBJECTS  .................
    # Adding NaN points at each label instance 
    NaNList=labelValues
    NumLabels=len(NaNList)

    labelList=np.append(labelList,NaNList)
    
    NaNStreams = np.empty(NumLabels) * np.nan
    x = np.append(x,NaNStreams)
    y = np.append(y,NaNStreams)

    c=sns.color_palette("Set1",NumLabels)

    # If this is True make first color black/greyish while keeping the original order of colors
    if(includeIgnoreLabel):
        temp=c.copy()
        for i in range(0,NumLabels-1):
            temp[i+1]=c[i]
        temp[0]=(0.1,0.1,0.1)
        c=temp 

     # ................................ Plot Scatter Points ................................................
    if(subjNum==0 & Comp==0):                    
        sns.scatterplot(x=y,y=x,hue=labelList,legend='full',size=0.00001,
                        edgecolor='none',palette=c)
    else:
        sns.scatterplot(x=y,y=x,hue=labelList,legend=False,size=0.00001,
                        edgecolor='none',palette=c)                   


def ClusterProfile(Data):
    
    minClusterNum=min(Data["Clusters"])
    maxClusterNum=max(Data["Clusters"])
    
    for clusterNum in range(minClusterNum,maxClusterNum+1):
        temp=Data.loc[Data["Clusters"]==clusterNum]
        ProfilesDensity=temp.loc[:,"Density_1":"Density_1000"]
        ProfilesArea=temp.loc[:,"Area_1":"Area_1000"]
        x = np.linspace(0,100, 1000)
        
        plt.figure()
        # Plotting Density Cluster 
        plt.subplot(1,2,1)
        plt.title("Density Cluster %d: (n = %d) "% (clusterNum,len(ProfilesDensity)))
        plt.plot(x,np.mean(ProfilesDensity),'k')
        meanPlusSTD = np.mean(ProfilesDensity) + np.std(ProfilesDensity)
        meanMinusSTD = np.mean(ProfilesDensity) - np.std(ProfilesDensity)
        plt.fill( np.append(x,x[::-1]), np.append(meanPlusSTD, meanMinusSTD[::-1]),'tab:gray')
        
        # Plotting Average size Cluster 
        plt.subplot(1,2,2)
        plt.title("Area Cluster %d: (n = %d) "% (clusterNum,len(ProfilesDensity)))
        plt.plot(x,np.mean(ProfilesArea),'k')
        meanPlusSTD = np.mean(ProfilesArea) + np.std(ProfilesArea)
        meanMinusSTD = np.mean(ProfilesArea) - np.std(ProfilesArea)
        plt.fill( np.append(x,x[::-1]), np.append(meanPlusSTD, meanMinusSTD[::-1]),'tab:gray')
        
        
def AverageDensityClusterProfile(Data):
    # Description: Obtain average density profile in every cluster
    
    legendList=list()
    minClusterNum=min(Data["Clusters"])
    maxClusterNum=max(Data["Clusters"])
    x = np.linspace(0,100, 1000)

    for clusterNum in range(minClusterNum,maxClusterNum+1):
        temp=Data.loc[Data["Clusters"]==clusterNum]
        ProfilesDensity=temp.loc[:,"Density_1":"Density_1000"]
        legendList.append("Cluster " + str(clusterNum))
        # Plotting Density Cluster 
        plt.plot(x,np.mean(ProfilesDensity))
    plt.title("Density Cluster (n=%d)" % (maxClusterNum - minClusterNum+1))
    plt.xlabel("Cortical Depth %")
    plt.ylabel("`Neuron Density Intensity")
    plt.legend(legendList)
    
def AverageSizeClusterProfile(Data):
    
    legendList=list()
    minClusterNum=min(Data["Clusters"])
    maxClusterNum=max(Data["Clusters"])
    x = np.linspace(0,100, 1000)

    for clusterNum in range(minClusterNum,maxClusterNum+1):
        temp=Data.loc[Data["Clusters"]==clusterNum]
        ProfilesDensity=temp.loc[:,"Area_1":"Area_1000"]
        legendList.append("Cluster " + str(clusterNum))
        # Plotting Density Cluster 
        plt.plot(x,np.mean(ProfilesDensity))
    plt.title("Area Cluster (n=%d)" % (maxClusterNum - minClusterNum+1))
    plt.xlabel("Cortical Depth %")
    plt.ylabel("Average Neuron Size Intensity")
    plt.legend(legendList)
    
def dispFeaturesByCluster(X,Feat1="Thickness",Feat2="Curvature"):
    Xz=pd.DataFrame()
    Xz=X
    for col in [Feat1,Feat2]:
        Xz[col] = (X[col] - X[col].mean())/X[col].std(ddof=0)
    
    Xz=getCondenseSubjectList(Data)
    
    sns.scatterplot(x=Xz[Feat1],y=Xz[Feat2],
                hue="SubjId",size="Clusters",edgecolors='none',data=Data) 
        
        
def getCondenseSubjectList(Data):
    subjList=list(dict.fromkeys(Data["Subject"]))
    subjList.sort()
    for i in range(0,len(Data)):
        if(Data.ix[i,"Subject"] == subjList[0]):
           subjId=Data.ix[i,"Subject"]
        else:
            subjList.remove(subjId)
            subjId=Data.ix[i,"Subject"]
                  
        subjIdNum=subjId[4:8]
        Data.ix[i,"SubjId"]=subjIdNum
    return Data


def getSilhouettePlot(X,cluster_labels,n_clusters):
    
    # Create a subplot with 1 row and 2 columns
    fig, (ax1, ax2) = plt.subplots(1, 2)
    fig.set_size_inches(18, 7)
    
    # The 1st subplot is the silhouette plot
    # The silhouette coefficient can range from -1, 1 but in this example all
    # lie within [-0.1, 1]
    ax1.set_xlim([-0.1, 1])
    # The (n_clusters+1)*10 is for inserting blank space between silhouette
    # plots of individual clusters, to demarcate them clearly.
    ax1.set_ylim([0, len(X) + (n_clusters + 1) * 10])

    # Initialize the clusterer with n_clusters value and a random generator
    # seed of 10 for reproducibility.
    #clusterer = KMeans(n_clusters=n_clusters, random_state=10)
    #cluster_labels = clusterer.fit_predict(X)

    # The silhouette_score gives the average value for all the samples.
    # This gives a perspective into the density and separation of the formed
    # clusters
    silhouette_avg = silhouette_score(X, cluster_labels)
    print("For n_clusters =", n_clusters,
          "The average silhouette_score is :", silhouette_avg)

    # Compute the silhouette scores for each sample
    sample_silhouette_values = silhouette_samples(X, cluster_labels)

    y_lower = 10
    for i in range(n_clusters):
        # Aggregate the silhouette scores for samples belonging to
        # cluster i, and sort them
        ith_cluster_silhouette_values = \
            sample_silhouette_values[cluster_labels == i]

        ith_cluster_silhouette_values.sort()

        size_cluster_i = ith_cluster_silhouette_values.shape[0]
        y_upper = y_lower + size_cluster_i

        color = cm.nipy_spectral(float(i) / n_clusters)
        ax1.fill_betweenx(np.arange(y_lower, y_upper),
                          0, ith_cluster_silhouette_values,
                          facecolor=color, edgecolor=color, alpha=0.7)

        # Label the silhouette plots with their cluster numbers at the middle
        ax1.text(-0.05, y_lower + 0.5 * size_cluster_i, str(i))

        # Compute the new y_lower for next plot
        y_lower = y_upper + 10  # 10 for the 0 samples

    ax1.set_title("The silhouette plot for the various clusters.")
    ax1.set_xlabel("The silhouette coefficient values")
    ax1.set_ylabel("Cluster label")

    # The vertical line for average silhouette score of all the values
    ax1.axvline(x=silhouette_avg, color="red", linestyle="--")

    ax1.set_yticks([])  # Clear the yaxis labels / ticks
    ax1.set_xticks([-0.1, 0, 0.2, 0.4, 0.6, 0.8, 1])
    # 2nd Plot showing the actual clusters formed
    colors = cm.nipy_spectral(cluster_labels.astype(float) / n_clusters)
    ax2.scatter(X.iloc[:, 0], X.iloc[:, 1], marker='.', s=30, lw=0, alpha=0.7,
                c=colors, edgecolor='k')


    ax2.set_title("The visualization of the clustered data.")
    ax2.set_xlabel("Feature space for the 1st feature")
    ax2.set_ylabel("Feature space for the 2nd feature")

    plt.suptitle(("Silhouette analysis clustering on sample data "
                "with n_clusters = %d" % n_clusters),
                fontsize=14, fontweight='bold')
    return  silhouette_avg

def displayProcessedProfiles(Data,X):
    plt.figure(figsize=[50,50])
    # Plot Original Profiles for Density,Area,Eccentricity
    plt.subplot(2,3,1)
    plt.imshow(Data.iloc[:,0:1000].transpose())
    plt.subplot(2,3,2)
    plt.imshow(Data.iloc[:,1000:2000].transpose());plt.title("Original Data Across Profiles")
    plt.subplot(2,3,3)
    plt.imshow(Data.iloc[:,2000:3000].transpose())

    # Plot Normalized Profiles for Density,Area,Eccentricity
    plt.subplot(2,3,4)
    plt.imshow(X.iloc[:,0:1000].transpose())
    plt.subplot(2,3,5)
    plt.imshow(X.iloc[:,1000:2000].transpose());plt.title("Processed Data Across Profiles")
    plt.subplot(2,3,6)
    plt.imshow(X.iloc[:,2000:3000].transpose())

##################################### RADAR PLOTS ################################################


# ------- PART 1: Define a function that structures in a correct manner
def create_radarDataFrame(X,Data,numFeat=10):
    # list of labels in dataframe data 
    labelList=Data["Clusters"].values
    labelList=np.unique(labelList)
    
    cols = list(X.columns)
    df=pd.DataFrame()
    
    # If Label is -10 this must be ignored
    if (labelList[0]==-10):
        labelList=np.delete(labelList, (0), axis=0)
    numLabels=len(labelList)

    # Calculate Average Feature within each cluster
    featAvg = np.zeros((numFeat,numLabels))
    for i,label in enumerate(labelList):
        for j in range(0,numFeat):
            idx= Data[(Data['Clusters'] == label)].index
            featAvg[j,i]=X.iloc[idx,j].mean()
    
    for i,col in enumerate(cols):
        col_avg = col[0] + str(i+1)
        df[col_avg]=featAvg[i,:]
    # convert Group labels to String
    labelList = [str(numeric_string) for numeric_string in labelList]
    df["group"]=labelList
    return df


# ------- PART 2: Define a function that do a plot for one line of the dataset!
 
def make_spider(df,row, title, color,numGroups=4):
 
    # number of variable
    categories=list(df)[0:-1]
    N = len(categories)
 
    # What will be the angle of each axis in the plot? (we divide the plot / number of variable)
    angles = [n / float(N) * 2 * pi for n in range(N)]
    angles += angles[:1]
 
    # Initialise the spider plot
    ax = plt.subplot(np.ceil(numGroups/2),2,row+1, polar=True, )
 
    # If you want the first axis to be on top:
    ax.set_theta_offset(pi / 2)
    ax.set_theta_direction(-1)
 
    # Draw one axe per variable + add labels labels yet
    plt.xticks(angles[:-1], categories, color='grey', size=8)
 
    # Draw ylabels
    ax.set_rlabel_position(0)
    plt.yticks([-2,-1,0,1,2], ["-2","-1","0","1","2"], color="grey", size=7)
    #maxVal=df.max().max();minVal=df.min().min()
    #plt.ylim(minVal,maxVal)
    plt.ylim(-2,2)
 
    # Ind1
    values=df.loc[row].drop('group').values.flatten().tolist()
    values += values[:1]
    ax.plot(angles, values, color=color, linewidth=2, linestyle='solid')
    ax.fill(angles, values, color=color, alpha=0.4)
 
    # Add a title
    plt.title(title, size=11, color=color, y=1.1)


    
################################################################################################