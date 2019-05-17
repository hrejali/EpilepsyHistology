# Importing libaries - Pandas used to read and manipulate data
import pandas as pd
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
import scipy as sp
import seaborn as sns # plotting
import sklearn as sk

# Import in house made tools
from tools import VisualizationTools as vis
from tools import ProcessingTools as pt


def getPostProcessData(fn,outDir='./',sigma=5,slideNorm=False,dimReduction=False):
    # Reading in the Data 
    Data=pd.read_csv(fn)
    # Labels each Streamline to a SubjID ex) P015
    Data=vis.getCondenseSubjectList(Data)

    ## Header Data
    dataHdr=Data.iloc[:,-4:len(Data.columns)]

    ################################## Predictive Features (X) ##########################################
    # create a DataFrame called `X` holding the predictive features.
    # Features include all columns with the excpetion of the last 5, which are descriptors
    X=Data.iloc[:,:-4]

    ############### Withing Slide Smoothing (OPTINAL - Data is already smoothed) ########################

    X.iloc[:,0:3000]=pt.smoothSlideFeat(X.iloc[:,0:3000],dataHdr,sigma)

    # Plot Figures and Save
    vis.displayProcessedProfiles(Data,X)
    plt.savefig(outDir+'/'+'Profiles_Sigma-'+str(sigma)+'.png')
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
        
         # Plot Figures and Save
        vis.displayProcessedProfiles(Data,X)
        plt.savefig(outDir + '/' + 'Profiles_Normalized_Sigma-' + str(sigma) +'.png')
        plt.close()

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
    #xMacroFeat=X.iloc[:,3000:3003]

    Xreduced=pd.concat([xDensity,xArea,xEccentricity],axis=1)
    print("Profile Feature Extraction - Features Describe Profile Shape")

    ############################## Bewteen Subject Normalization #########################################

    # Normalize Data using Z-scores
    cols = list(Xreduced.columns)
    Xz=pd.DataFrame()
    for col in cols:
        col_zscore = col + '_zscore'
        Xz[col_zscore] = (Xreduced[col] - Xreduced[col].mean())/Xreduced[col].std(ddof=0)
    Xz
    Xout=Xz
    print("Bewteen Subject Normalization Applied")

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
