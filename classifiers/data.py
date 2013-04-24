
import os
import sklearn
from treedict import TreeDict
import pandas as pd
import joblib

memory = joblib.Memory('cache')

#cached_csv_df = memory.cache(pd.read_csv)
cached_csv_df = pd.read_csv

DEBUG_DATASET_SIZE = 1000

class FeatureSet():
    
    def __init__(self, features, all_features, meta=None):
        if isinstance(features, str):
            features = [features]
            
        self.features = list(features)
        self.all_features = list(all_features)
        self.meta = meta
        
    @property
    def is_delta(self,):
        return float(len(self.features)) >= 0.5 * float(len(self.all_features))
    
    def complement(self,):
        comp_features = list(
                set(self.all_features).difference(
                    set(self.features)
                )
            )
        return FeatureSet(comp_features, self.all_features, meta=self.meta)

    def getTitle(self, style='latex'):
        features_in_title = self.features if not self.is_delta else set(self.all_features).difference(set(self.features))
        if self.meta: features_in_title = [self.meta,]
            
        def latexText(s):
            return r'\text{'+s+'}'
        
        if style == 'latex' or style=='text':
            if set(self.features) == set(self.all_features):
                return 'All features'
            
            separator = ' ' if self.is_delta else ' + '
            prefix = r'$\Delta$' if self.is_delta else r''
            return separator.join(prefix + f for f in features_in_title)
        
    def __repr__(self,):
        return self.getTitle(style='text')
    
#@memory.cache
def prepDataSet(csv_filename, feature_set=None, dataset_name='generic dataset',
        ddg_cutoff=1.0, truncate=False):
    '''
    prepares a data set object from a CSV file, under the conventions of this project:
    - the CSV is indexed by PDBID and residue number (columns 0,1)
    - the last column contains label-related data, mostly ddG values of residues.
    - all other columns are feature columns.

    The function reads the columns into a TreeDict structure, such that each component
    (normalized feature data, labels, PDB identifiers, columns used) is accessible as 
    an attribute.

    ``dataset_name`` is optional, giving the TreeDict a name.
    Optional argument ``features`` directs the function which features to select from 
    the table. By default, all features are selected.
    '''
    
    dataset = TreeDict(dataset_name)
    dataset.csv_filename = os.path.abspath(csv_filename)
    dataset.is_bound = (csv_filename.find('unbound') == -1)
    dataset._df = cached_csv_df(csv_filename, index_col=[0,1],
            true_values=['True'],
            false_values=['False'],
            )
    
    if truncate:
        dataset._df = dataset._df[:DEBUG_DATASET_SIZE]
    
    if feature_set is None:
        cols = dataset._df.columns[:-1]
        dataset.feature_set = FeatureSet(cols, cols)
    else:
        dataset.feature_set = feature_set
    
    all_feature_data_df = dataset._df.ix[:,dataset.feature_set.all_features]
    
    dataset.feature_data_df = all_feature_data_df.ix[:,dataset.feature_set.features]
    #dataset.X = dataset.feature_data_df.values 
    dataset.X = sklearn.preprocessing.scale(
                    dataset.feature_data_df.values.astype(float))
    
    dataset.label_data_df = dataset._df.ix[:,-1]
    dataset.ddg_cutoff = ddg_cutoff
    dataset.y = dataset.label_data_df.values > dataset.ddg_cutoff
    
    # sanity checks
    assert dataset.X.shape[0] == len(dataset.y)
    
    dataset.pdbs = dataset.feature_data_df.index.get_level_values(0)
    
    return dataset


