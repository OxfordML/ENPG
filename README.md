# ENPG
Extraction of Narratives from a Provenance Graph

These files are Matlab code to accompany the HAIDM workshop paper in AAMAS 2015 by 
Ebden, Huynh, Moreau, and Roberts. March 2015.

            runme.m - top-level file
        prov31545.m - loads a small provenance graph (Graph 'A' of the paper)
     getSubgraphs.m - a wrapper to call findSubgraphs.m, returning a graph's subgraphs
    findSubgraphs.m - the recursive function outlined in 'Algorithm 1' of the paper
     checkBinCode.m - called by findSubgraphs.m to compare two graph edges
 
The code implements one aspect of M2 subgraph matching: single sentences are extracted 
rather than a complete narrative based on a range of subgraphs. More code is available 
upon request.
