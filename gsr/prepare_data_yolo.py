import pandas as pd
import os

width = 1360
height = 800


def prepare_data(base_dir, img_list_filename):
    train_data_dict = {}
    print("Generate Labeling Files")
    with open(os.path.join(base_dir, "gt.txt")) as f:
        for line in f:
            tokens = line.split(";")
            filename = tokens[0]
            rest = tokens[1:]
            if filename not in train_data_dict:
                train_data_dict[filename] = list()
            train_data_dict[filename].append(rest)

        for filename in train_data_dict:
            print(filename)
            new_file_name = filename.split(".")[0] + ".txt"
            with open(os.path.join(base_dir, new_file_name), mode="w") as fw:
                for obj_win in train_data_dict[filename]:
                    x1, y1, x2, y2, class_id = obj_win
                    obj_width = int(x2) - int(x1)
                    obj_relative_width = obj_width * 1.0 / width
                    obj_height = int(y2) - int(y1)
                    obj_relative_height = obj_height * 1.0 / height
                    center_x = (int(x2) + int(x1)) * 0.5
                    center_y = (int(y2) + int(y1)) * 0.5
                    fw.write("{0} {1} {2} {3} {4}\n".format(class_id.strip(), center_x / width, center_y / height,
                                                            obj_relative_width, obj_relative_height))

    print("Generate list of file names")
    with open(os.path.join(base_dir, img_list_filename), mode="w") as writer:
        for filename in train_data_dict:
            writer.write("{}\n".format(os.path.join(base_dir, filename)))


base_dir = "gsr/TrainIJCNN2013/"
img_list_filename = "train_gsr.txt"
prepare_data(base_dir, img_list_filename)

base_dir = "gsr/TestIJCNN2013/"
img_list_filename = "test_gsr.txt"

prepare_data(base_dir, img_list_filename)
