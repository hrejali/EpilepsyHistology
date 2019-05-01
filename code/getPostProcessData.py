# Importing libaries - Pandas used to read and manipulate data
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import scipy as sp
import seaborn as sns # plotting
import sklearn as sk

# Import in house made tools
from tools import VisualizationTools as vis
from tools import ProcessingTools as pt


exec(open("./code/tools/ProcessingTools.py").read())
exec(open("./code/tools/VisualizationTools.py").read())


def getPostProcessData(fn,outDir='./',sigma=5,slideNorm=False,dimReduction=False):
    # Reading in the Data 
    Data=pd.read_csv(fn)
    Data=vis.getCondenseSubjectList(Data)

    ## Header Data
    dataHdr=Data.iloc[:,-4:len(Data.columns)]

    ## Predictive Features (X)
    # create a DataFrame called `X` holding the predictive features.
    # Features include all columns with the excpetion of the last 5, which are descriptors
    X=Data.iloc[:,:-4]

    ############### Withing Slide Smoothing (OPTINAL - Data is already smoothed) ########################

    X.iloc[:,0:3000]=pt.smoothSlideProfiles(X.iloc[:,0:3000],dataHdr,sigma)

    # Plot Original Profiles for Density,Area,Eccentricity
    plt.subplot(2,3,1)
    plt.imshow(Data.iloc[0:5000,0:1000].transpose())
    plt.subplot(2,3,2)
    plt.imshow(Data.iloc[0:5000,1000:2000].transpose());plt.title("Original Data Across Profiles")
    plt.subplot(2,3,3)
    plt.imshow(Data.iloc[0:5000,2000:3000].transpose())

    # Plot Smoothed Profiles for Density,Area,Eccentricity
    plt.subplot(2,3,4)
    plt.imshow(X.iloc[0:5000,0:1000].transpose())
    plt.subplot(2,3,5)
    plt.imshow(X.iloc[0:5000,1000:2000].transpose());plt.title("Smoothed Data Across Profiles")
    plt.subplot(2,3,6)
    plt.imshow(X.iloc[0:5000,2000:3000].transpose())


    plt.savefig(outDir+'Profiles_Sigma-'+str(sigma)+'.png')
    plt.close()
    print("Within Slide Smoothing Applied - Sigma: "+ str(sigma) )

    ################ Withing Slide Normalization (OPTINAL - May not be appropriate step ) ###############

    if(slideNorm):
        # Density Profiles
        X.iloc[:,0:1000] = pt.slideNormalization(X.iloc[:,0:1000] ,dataHdr)
        
        # Area Profiles
        X.iloc[:,1000:2000] = pt.slideNormalization(X.iloc[:,1000:2000] ,dataHdr)

        # Eccentricity Profiles
        X.iloc[:,2000:3000] = pt.slideNormalization(X.iloc[:,2000:3000] ,dataHdr)
        
        # Plot Original Profiles for Density,Area,Eccentricity
        plt.subplot(2,3,1)
        plt.imshow(Data.iloc[0:5000,0:1000].transpose())
        plt.subplot(2,3,2)
        plt.imshow(Data.iloc[0:5000,1000:2000].transpose());plt.title("Original Data Across Profiles")
        plt.subplot(2,3,3)
        plt.imshow(Data.iloc[0:5000,2000:3000].transpose())

        # Plot Normalized Profiles for Density,Area,Eccentricity
        plt.subplot(2,3,4)
        plt.imshow(X.iloc[0:5000,0:1000].transpose())
        plt.subplot(2,3,5)
        plt.imshow(X.iloc[0:5000,1000:2000].transpose());plt.title("Normalized Data Across Profiles")
        plt.subplot(2,3,6)
        plt.imshow(X.iloc[0:5000,2000:3000].transpose())
        plt.savefig(outDir+'Profiles_Normalized_Sigma-'+ str(sigma) +'.png')

        print("Within Slide Normalization Applied")
    else:
        print("No Within Slide Normalization Applied")


    ##### Reduced Predictive Features (X) using Amunts Zilles Features to describe profile shape #####
 
    # Density Profiles
    xDensity=pt.getProfileShapeFeat(X.iloc[:,0:1000])
    
    # Area Profiles
    xArea=pt.getProfileShapeFeat(X.iloc[:,1000:2000])

    # Eccentricity Profiles
    xEccentricity=pt.getProfileShapeFeat(X.iloc[:,2000:3000])

    # MacroFeatures (Curvature and Thickness)
    xMacroFeat=X.iloc[:,3000:3003]

    Xreduced=pd.concat([xDensity,xArea,xEccentricity,xMacroFeat],axis=1)
    print("Profile Feature Extraction - Features Describe Profile Shape")

    ############################## Bewteen Subject Normalization #########################################

    # Normalize Data using Z-scores
    cols = list(Xreduced.columns)
    Xz=pd.DataFrame()
    for col in cols:
        col_zscore = col + '_zscore'
        Xz[col_zscore] = (Xreduced[col] - Xreduced[col].mean())/Xreduced[col].std(ddof=0)
    Xz
    
    print("Bewteen Subject Normalization Applied")

    ##################################### Macrofeature Filtering #########################################

    Xz['Curvature_zscore']=sp.signal.medfilt(Xz['Curvature_zscore'],kernel_size=11)
    Xz['Thickness_zscore']=sp.signal.medfilt(Xz['Thickness_zscore'],kernel_size=11)

    Xout=Xz

    print("Macroscale Features Filtered Using Median Filter")

    ######################### Reduce Dimensionality using PCA (OPTIONAL) #################################

    from sklearn.decomposition import PCA
    if(dimReduction):
        pca = PCA(n_components=0.95)
        X_PComponents=pca.fit_transform(Xout)
        Xout=pd.DataFrame(X_PComponents)

        name="Component"
        compList=list()
        for compNum in range(1,pca.n_components_+1):
            compList.append( name + str(compNum) )
        Xout.columns=compList

        print("Diminesionality Reduction Applied")

    else:
        print("Diminesionality Reduction Not Applied")

    ########################################   Return Data    ############################################
    print("###########################################################################################")
    print(Xout.head(n=5))
    print("###########################################################################################")
    Data=pd.concat([X,dataHdr],axis=1)
    return Data,Xout,dataHdr
