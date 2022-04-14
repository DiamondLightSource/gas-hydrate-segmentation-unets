This repository has been published to Zenodo [![DOI](https://zenodo.org/badge/345756620.svg)](https://zenodo.org/badge/latestdoi/345756620)

# Gas Hydrate Segmentation Using U-nets. Code Repository.

This code repository supports the article manuscript entitled 'U-Net Segmentation Methods for Variable-Contrast XCT Images of Methane-Bearing Sand Using Small Training Datasets'
Authored by F. J. Alvarez-Borges, O. N. F. King, B. N. Madhusudhan, T. Connolley, M. Basham and S. I. Ahmed.
April 2022

Copyright 2022 Diamond Light Source Ltd.
Licensed under the Apache License, Version 2.0

Funders:
Natural Environment Research Council (UK) grant No. NE/K00008X/1

## Description

### 2d and 3d U-net training and prediction scripts 

These can be found in the `unet_methods` directory.
On Linux, For ease of installation and use we recommend downloading the [singularity container](#singularity-container).

#### 2d methods

For 2d U-net training and prediction, settings are specified by editing the YAML files in `unet_2d/settings`. Paths for image data (HDF5 format), labels(HDF5 format) and input models are given via the command line.

##### For 2d U-net training

```shell
python train_2d_unet.py path/to/image/data.h5 path/to/corresponding/segmentation/labels.h5
```

A model will be trained and saved to your working directory

##### For 2d U-net prediction

```shell
python predict_2d_unet.py path/to/model_file.zip path/to/data_for_prediction.h5
```

A directory of segmented volumes will be saved to your working directory.

#### 3d methods

For 3d U-net training and prediction, settings are specified by editing the YAML files in `unet_3d/settings`. Paths for image data(HDF5 format), labels(HDF5 format) and input models are also given in the YAML files.

The 3d methods utilise the [Torchio](https://github.com/fepegar/torchio) library for data sampling and augmentation:
Pérez-García, Fernando, Rachel Sparks, and Sebastien Ourselin. ‘TorchIO: A Python Library for Efficient Loading, Preprocessing, Augmentation and Patch-Based Sampling of Medical Images in Deep Learning’. ArXiv:2003.04696 [Cs, Eess, Stat], 9 March 2020. http://arxiv.org/abs/2003.04696.

And the 3d U-net utilises the [pytorch-3dunet](https://github.com/wolny/pytorch-3dunet) library:
Wolny, Adrian, Lorenzo Cerrone, Athul Vijayan, Rachele Tofanelli, Amaya Vilches Barro, Marion Louveaux, Christian Wenzl, et al. ‘Accurate and Versatile 3D Segmentation of Plant Tissues at Cellular Resolution’. Edited by Christian S Hardtke, Dominique C Bergmann, Dominique C Bergmann, and Moritz Graeff. ELife 9 (29 July 2020): e57613. https://doi.org/10.7554/eLife.57613.


##### For 3d U-net training

```shell
python train_3d_unet.py 
```

A model will be trained and saved to the directory where your input data resides.

##### For 3d U-net prediction

```shell
python predict_3d_unet.py
```

A segmented volume will be saved to the directory where your input data resides.

#### Installation

In order to run the scripts you will need an NVIDIA GPU, ideally with at least 8GB of memory and that supports CUDA 10 or greater. 
For U-Net segmentation, we recommend using the [singularity container](#singularity-container).  
Otherwise, If you want to install locally, create an [Anaconda](https://www.anaconda.com/products/individual#Downloads) environment using the `unet_environment.yaml` file found in `unet_methods`.

```shell
conda env create -n unet_env -f unet_methods/unet_environment.yaml
```

Once the environment is installed you can activate it

```shell
conda activate unet_env
```
You should now be able to run the U-net training and prediction by calling the relevant scripts using Python.

### Singularity Container

Rather than installing your own anaconda environment and downloading the codebase, both can be retrieved in a singularity container.
```shell
singularity pull library://ollyking/unet-segmentation/unet_conda_container
```
To run the container, first a writable data directory needs to be created to be bound to the container. This directory should contain:
- the data and label files for model training
- a subdirectory named `unet-settings`, this will contain the YAML settings files. This directory can be copied from the repository and is found [here](https://github.com/DiamondLightSource/gas-hydrate-segmentation-unets/tree/main/unet_methods/unet-settings). 

In addition, the trained models and any predictions will also be output to this folder.

The following examples assume that the data directory was named `my_data_dir` and sits in the same directory as the singularity image. The container is run with `singularity run` and the data directory is bound with the commandline argument `-B my_data_dir/:/data`, this binds it at the location `/data` within the container. In addition the flag `--nv` is needed in order to give the container access to the GPU. 

#### For 2d U-net training using the container image

```shell
singularity run --nv -B my_data_dir/:/data unet_conda_container_latest.sif 2dunet-train --data /data/<my_data_file.h5> --labels /data/<my_label_file.h5> --data_dir /data
```

A model will be trained and saved to `my_data_dir` along with a preview image.

#### For 2d U-net prediction using the container image

```shell
singularity run --nv -B my_data_dir/:/data unet_conda_container_latest.sif 2dunet-predict /data/<my_trained_2d_model.zip> /data/<data_file_to_predict.h5> --data_dir /data
```

A directory of segmented volumes will be saved to `my_data_dir`.

#### For 3d U-net training using the container image

```shell
singularity run --nv -B my_data_dir/:/data unet_conda_container_latest.sif 3dunet-train /data/<my_data_file.h5> /data/<my_label_file.h5> /data/<my_validation_data_file.h5> /data/<my_validation_label_file.h5> --data_dir /data

```
A model will be trained and saved to `my_data_dir` along with a preview image and a graph of training and validation loss. In addition, a segmentation of the validation volume is saved. 

#### For 3d U-net prediction using the container image

```shell
singularity run --nv -B my_data_dir/:/data unet_conda_container_latest.sif 3dunet-predict /data/<my_trained_3d_model.pytorch> /data/<data_file_to_predict.h5> --data_dir /data
```
The segmented volume will be saved to `my_data_dir`.

### Data preparation and Rootpainter training data scripts

These can be found in the `matlab_scripts` directory.

For computation of segmentation performance based on the central 40 XY slices:
'segmentation_performance.m' 
 
To convert 572x572x572 voxel training and validation HDF5 subvolumes into RootPainter-readable slices:
'rootpainter_annot_CH4.m'
'rootpainter_annot_sand.m'
 
To convert HDF5 file data to tiff stacks for visualisation:
'h5_to_tiff_stack.m'
 
All MATLAB scripts are run using the MATLAB app and include a graphical user interface for file input/output.

MATLAB code was created using MATLAB 2020b.
