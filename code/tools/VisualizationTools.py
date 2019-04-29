############################################ VISUALIZATION AND PLOT FUNCTIONS ########################################
import matplotlib.pyplot as plt
import seaborn as sns # plotting
import numpy as np
import pandas as pd



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

def DispSubjectDataStreamline(mat,Data):
    ##################################################################################################################
    # Description:
    # Creates a subplot of density featuremap images for each slide in addition overlays streamlines colored by the label. 

    #Inputs:
    # <mat>: h5py data containing list of subject data each containing Density Feature Maps and Streamlines
    # <Data>: Pandas Dataframe containing header information and labels for each streamline (Cluster Labels)

    ##################################################################################################################

    
    LabelMinMax=[min(Data["Clusters"]),max(Data["Clusters"])]
    subjList=list(dict.fromkeys(Data["Subject"])) 
    
    comp = mat['/dataList/Comp']
    hdr = mat['/dataList/hdr']

    plt.figure(figsize=[50,50])
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
                Streamlineplot(mat,subjData(sliceName,compNum+1,Data),i,compNum,LabelMinMax)
                idx=idx+1
        else:
            ax=plt.subplot(8,9,idx+1)
            plt.imshow(mat[comp[i,0]]["FeatureMap"].value,cmap="viridis")
            plt.axis('off')
            ax.set_aspect('auto')
            Streamlineplot(mat,subjData(sliceName,1,Data),i,compNum,LabelMinMax)
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

def Streamlineplot(mat,Data,subjNum,Comp,LabelMinMax):
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
    NumLabels=int(LabelMinMax[1]-LabelMinMax[0]+1)
    
    NaNList=[i for i in range(NumLabels)]

    labelList=np.append(labelList,NaNList)
    
    NaNStreams = np.empty(NumLabels) * np.nan
    x = np.append(x,NaNStreams)
    y = np.append(y,NaNStreams)
     # ....................................................................................................
    if(subjNum==0 & Comp==0):                    
        sns.scatterplot(x=y,y=x,hue=labelList,legend='full',size=0.00001,
                        edgecolor='none',palette="Paired")
    else:
        sns.scatterplot(x=y,y=x,hue=labelList,legend=False,size=0.00001,
                        edgecolor='none',palette="Paired")                   


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