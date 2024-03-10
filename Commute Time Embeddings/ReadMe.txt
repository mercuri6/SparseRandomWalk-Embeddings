### Commute Time (CT) Embeddings with Diffusion Wavelets (DW)/SVD

This is an implementation of the algorithms discussed in:

P. Mercurio and D. Liu. Network Embedding Using Sparse Approximations of Random Walks. [Unpublished Manuscript]. Department of Mathematics, Michigan State University. 2023. https://arxiv.org/abs/2308.13663

The CT with DW codes provide node embeddings for a given network (in the form of an adjacency/weight matrix) such that similar nodes are close together in terms of commute time. To compute the embeddings, first the diffusion wavelet algorithm is applied to the adjacency/weight matrix, and the resulting diffusion wavelet tree is used to find an approximation to the Green function. Then, applying diffusion wavelets to the Green function results in embeddings.

The CT with SVD codes follow a similar method, but the diffusion wavelet algorithm is replaced by a truncated SVD routine.

These files are primarily for research purposes, and this implementation may not be computationally optimal.


### Requirements

For Matlab codes:
Matlab, Diffusion Wavelets (available from https://mauromaggioni.duckdns.org/code/), SuiteSparse (optional).

For Python codes:
numpy, sklearn, scipy, networkx, pandas, dgl, pytorch.

### Example Usage

To reproduce the results from the paper, run the file 'example_usage.m'. Uncomment one of lines 2-5 to select which network to load.

To run the Python example files, run the .ipynb corresponding to the desired network.


### Inputs/Outputs

Input: For a network with N nodes, example_usage.m takes as input a network mat file containing an NxN adjacency matrix and a length N vector containing class labels.

SVDembedder and DWembedder take as input a full or sparse adjacency/weight matrix.

Parameters: 
SVDembedder and DWembedder have parameters:
- Levels: number of iterations of SVDTree/DWTree used to compute the Green function
- Levels2: number of iterations of SVDTree/DWTree applied to the Green function to compute embeddings
- Precision (DWembedder only): Determines precision of the QR/orthogonalization routine.
- opts (SVDembedder only): A structure containing the options for SVDembedder.
	--lev1: Levels. Default is 5.
	--lev2: Levels2. Default is 5.
	--fraction: Determines what fraction of the singular values and singular 	vectors are retained in each SVD. Default is 0.5.

Output: The embedding matrix V, given in Matlab sparse matrix form (row, column, and data vectors). The Python code instead outputs an embedding matrix in scipy coo_matrix form.  

### Other References

The original diffusion wavelets paper:

R. Coifman and M. Maggioni. Diffusion wavelets. Applied and Computational Harmonic
Analysis, 21:53–94, 07 2006. doi: 10.1016/j.acha.2006.04.004.

Data sources:

SNAP Datasets: 
J. Leskovec and A. Krevl. SNAP Datasets: Stanford large network dataset collection. http://snap.stanford.edu/data, 06 2014.

Amazon Dataset:
J.J. McAuley, C. Targett, Q. Shi, and A. van den Hengel. Image-based recommendations on styles and substitutes, 2015. URL http://arxiv.org/abs/1506.04757.

Cora Dataset:
P. Sen, G. Namata, M. Bilgic, L. Getoor, B. Galligher, and T. Eliassi-Rad. Collective classification in network data, 2008

Deep Graph Library: 
M. Wang, L. Yu, Q. Gan, D. Zheng, Y. Gai, Z. Ye, M. Li, J. Zhou, Q. Huang, J. Zhao, H. Lin, C. Ma, D. Deng, Q. Guo, H. Zhang, J. Li, A. J. Smola, and Z. Zhang. Deep graph library: Towards efficient and scalable deep learning on graphs, 2020.
