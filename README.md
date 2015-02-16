# ENPG
Extraction of Narratives from a Provenance Graph

These files are Matlab code to accompany the workshop paper submitted to AAMAS 2015 by 
Ebden, Huynh, Moreau, and Roberts. Submitted February 2015.

        runme.m - top-level file
    prov31545.m - loads a small provenance graph (Graph 'A' of the paper)
    getMotifs.m - a wrapper to call findMotifs.m, returning a graph's motifs
   findMotifs.m - the recursive function outlined in 'Algorithm 1' of the paper
 checkBinCode.m - called by findMotifs.m to compare two graph edges

The code implements one aspect of M2 motif-detection: single sentences are extracted 
rather than a  complete narrative based on a range of motifs. More code is available 
upon request.
