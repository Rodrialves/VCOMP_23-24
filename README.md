# VCOMP_23-24

All the work carried out on this repository was done as part of the final project for FEUP's Computer Vision course ([M.EEC034]).

### Task 1
The aim of this work was to detect the hand in the [images](Datasets\Task1\Images\ ) and create a Bounding Box around it by segmenting it and comparing it with the ground truth provided in the [Dataset](Datasets\Task1\Hand_masks). This was done in ([task1.m](task1.m)) and the result was the following:

|  Task 1    | Values |
| ---------- | ------|
| Recall     | 1 |
| Precision  | 0.7105 |
| F1-Measure | 0.8308 |

### Task 2
Then we needed to identify a subset of letters of the American sign language using the images available in the folder [Datasets\Task2\Images_with_BBs](Datasets\Task2\Images_with_BBs) using script [task2.m](task2.m), and the result was the following: 

|  Task 2    | Values |
| ---------- | ------|
| Recall     |  0.7357|
| Precision  | 0.6357 |
| F1-Measure | 0.6821 |

### Task 3

Finally, we used the [images](Datasets\Task1\Results)  obtained in the segmentation of Task 1 as the input dataset for the script developed in Task 2, [task3.m](task3.m). The result was as follows:

|  Task 3    | Values |
| ---------- | ------|
| Recall     |  0.3810|
| Precision  | 0.4328 |
| F1-Measure | 0.4052 |


[M.EEC034]: https://sigarra.up.pt/feup/pt/ucurr_geral.ficha_uc_view?pv_ocorrencia_id=516516
