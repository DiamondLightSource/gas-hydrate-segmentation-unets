"""Data to be shared across files.
"""
# Parser strings
TRAIN_DATA_ARG = "train_data_path"
LABEL_DATA_ARG = "label_vol_path"
MODEL_PTH_ARG = "model_file"
PREDICT_DATA_ARG = "predict_data_path"
# File extensions
TRAIN_DATA_EXT = {"h5", "hdf5", "nxs"}
LABEL_DATA_EXT = {"h5", "hdf5"}
MODEL_DATA_EXT = {"zip"}
PREDICT_DATA_EXT = {"h5", "hdf5", "nxs"}
# TODO Required settings - check required keys are in settings files
# Logging format
LOGGING_FMT = "%(asctime)s - %(levelname)s - %(message)s"
LOGGING_DATE_FMT = "%d-%b-%y %H:%M:%S"
# Settings yaml file locations
SETTINGS_DIR = "settings"
TRAIN_SETTINGS_FN = "2d_unet_train_settings.yaml"
PREDICTION_SETTINGS_FN = "2d_unet_predict_settings.yaml"


