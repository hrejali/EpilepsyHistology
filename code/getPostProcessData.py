# Importing libaries - Pandas used to read and manipulate data
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import scipy as sp
import seaborn as sns # plotting
import sklearn as sk


exec(open("./code/tools/ProcessingTools.py").read())
exec(open("./code/tools/VisualizationTools.py").read())

#exec(open("C:/Users/Hossein/Documents/MASc/Projects/EpilepsyHistology/code/tools/ProcessingTools.py").read())
#exec(open("C:/Users/Hossein/Documents/MASc/Projects/EpilepsyHistology/code/tools/VisualizationTools.py").read())


def getPostProcessData(fn,outDir='./',SmoothData=True,sigma=5,slideNorm=False,dimReduction=False):
    # Reading in the Data 
    Data=pd.read_csv(fn)
    Data=getCondenseSubjectList(Data)

    ## Header Data
    dataHdr=Data.iloc[:,-4:len(Data.columns)]

    ## Predictive Features (X)
    # create a DataFrame called `X` holding the predictive features.
    # Features include all columns with the excpetion of the last 5, which are descriptors
    X=Data.iloc[:,:-4]

    ############### Withing Slide Smoothing (OPTINAL - Data is already smoothed) ########################
    if(SmoothData):
        X.iloc[:,0:3000]=smoothSlideProfiles(X.iloc[:,0:3000],dataHdr,sigma)

        # Plot to Viualize Results
        plt.figure(figsize=[10,10])
        ax=plt.subplot(2,1,1)
        plt.imshow(X.iloc[0:5000,0:1000].transpose());plt.title("Smoothed Data Across Profiles")
        plt.subplot(2,1,2)
        plt.imshow(Data.iloc[0:5000,0:1000].transpose());plt.title("Original Data Across Profiles")
        plt.savefig(outDir+'Profiles_Sigma-'+str(sigma)+'.png')
        plt.close()

    else:
        print("No Within Slide Smoothing Applied")

    ################ Withing Slide Normalization (OPTINAL - May not be appropriate step ) ###############

    if(slideNorm):
        X.iloc[:,0:3000] = slideNormalization(X.iloc[:,0:3000] ,dataHdr)

        plt.figure(figsize=[10,10])
        ax=plt.subplot(2,1,1)
        plt.imshow(X.iloc[0:5000,0:1000].transpose());plt.title("Normalized Data Across Profiles")
        plt.subplot(2,1,2)
        plt.imshow(Data.iloc[0:5000,0:1000].transpose());plt.title("Original Data Across Profiles")
        plt.savefig(outDir+'Profiles_Normalized_Sigma-'+str(sigma)+'.png')

        print("Within Slide Normalization Applied")
    else:
        print("No Within Slide Normalization Applied")


    ##### Reduced Predictive Features (X) using Amunts Zilles Features to describe profile shape #####
 
    # Density Profiles
    xDensity=getProfileShapeFeat(X.iloc[:,0:1000])
    
    # Area Profiles
    xArea=getProfileShapeFeat(X.iloc[:,1000:2000])

    # Eccentricity Profiles
    xEccentricity=getProfileShapeFeat(X.iloc[:,2000:3000])

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
    print(Data.head(n=5))
    print("###########################################################################################")
    Data=pd.concat([X,dataHdr],axis=1)
    return Data,Xout, dataHdr
