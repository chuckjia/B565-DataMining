#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Feb  3 00:50:57 2018

@author: chuckjia
"""

from csv import reader
import random
import sys, getopt
import math

# Read file from csv. We assume that the last column of the file is the true class label
def read_csv(filename):
    file = open(filename, "r")
    dset = list(reader(file))
    for row in dset:
        row[-1] = int(row[-1])
        for i in range(len(row) - 1):
            row[i] = float(row[i])
    return dset


# Caculate the gini score given a node is split up into 2 children
# children: a tuple or list of two lists of data points / rows
def gini_with_split(children):
    gini_parent = 0.
    for child in children:
        gini_child = 0.
        n = len(child)
        if n == 0: continue
        child_classes = [row[-1] for row in child]
        for class_lab in set(child_classes):
            rel_freq = child_classes.count(class_lab) / float(n)
            gini_child += rel_freq * rel_freq
        gini_parent += (1 - gini_child) * n
    return gini_parent / float(len(children[0]) + len(children[1]))


# Caculate the information gain score for a node
def info_gain_single_node(dset):
    info_gain = 0.
    n = len(dset)
    classes = [row[-1] for row in dset]
    for class_lab in set(classes):
        rel_freq = classes.count(class_lab) / float(n)
        info_gain += rel_freq * math.log2(rel_freq)
    return -info_gain


# Caculate the information gain score given a node is split up into 2 children
# children: a tuple or list of two lists of data points / rows 
def info_gain_with_split(children):
    sum = 0.
    for child in children:
        sum += info_gain_single_node(child) / float(len(child))
    parent = children[0].append(children[1])
    sum = sum / float(len(parent))
    return info_gain_single_node(parent) - sum


# This is the function used in main to calculate impurity measure. Candidates are gini_with_split and 
# info_gain_with_split, with the former as its default value.
calc_impurity = gini_with_split   


# Calculate the majority class for a node. Used for labeling leaf nodes
def calc_leaf_lab(dset):
    classes = [row[-1] for row in dset]
    return max(set(classes), key = classes.count)


# Split the data set into 2 parts by using a threshold on one feature
# Return a tuple of two lists as two children of a node
def split_at_loc(dset, feat, thr):
    left = list()
    right = list()
    for row in dset:
        if row[feat] < thr:
            left.append(row)
        else:
            right.append(row)
    return left, right


# Try all the possible binary splits and find the best split
# Return a dictionary as a node
def find_best_split(dset):
    classes = set(row[-1] for row in dset)
    if len(classes) == 1:
        return calc_leaf_lab(dset);

    split_feat = 0
    split_thr = 0
    best_impurity = 1
    children = None
    
    for feat in range(len(dset[0]) - 1):
        all_values = set(row[feat] for row in dset)
        for thr in all_values:
            children_this = split_at_loc(dset, feat, thr)
            impurity = calc_impurity(children_this)
            if impurity < best_impurity:
                split_feat = feat
                split_thr = thr
                best_impurity = impurity
                children = children_this
    # If all features of the data points in the node are identical, then return as a leaf node
    if children[0] == [] or children[1] == []:
        return calc_leaf_lab(dset);
    return { 'feat': split_feat, 'thr': split_thr, 'children': children }


# Check if a node is a leaf node
def is_leaf(node):
    return isinstance(node, int)


# Recursively split a node and all its descendent
def split(node):
    left, right = node['children']
    
    node['left'] = find_best_split(left)
    if not is_leaf(node['left']):
        split(node['left'])
        
    node['right'] = find_best_split(right)
    if not is_leaf(node['right']):
        split(node['right'])
    
    del node['children']
        

# Build the decision tree by recursively split all nodes starting from the root
# Return the root node
def build_decision_tree(train):
    root = find_best_split(train)
    split(root)
    return root


# Make prediction on the class label for a data point based on the subtree starting from a single node
def predict_by_node(datapt, node):
    if datapt[node['feat']] < node['thr']:
        if isinstance(node['left'], int):
            return node['left']
        else:
            return predict_by_node(datapt, node['left'])
    else:  
        if isinstance(node['right'], int):
            return node['right']
        else:
            return predict_by_node(datapt, node['right'])


# Build a decision tree using train set and make predictions on the class labels for the test set
def predict_by_decision_tree(train, test):
    tree = build_decision_tree(train)
    pred = list()
    for row in test:
        pred.append(predict_by_node(row, tree))
    return pred


def main(argv):
    inputfile = ''
    impurity_measure = ''
    try:
        opts, args = getopt.getopt(argv, "hm:i:",["mfile=","ifile="])
    except getopt.GetoptError:
        print('test.py -m <gini / infogain> -i <inputfile>')
        sys.exit(2)
       
    for opt, arg in opts:
        if opt == '-h':
            print('test.py -m <gini / infogain> -i <inputfile>')
            sys.exit()
        elif opt in ("-m", "--mfile"):
            impurity_measure = arg
        elif opt in ("-i", "--ifile"):
            inputfile = arg   
    
    if (impurity_measure == 'infogain'):
        calc_impurity = info_gain_with_split

    # Import data sets and separate into two sets as train and test
    train = read_csv(inputfile)
    random.shuffle(train)
    sep = int(len(train) / 2) + 1
    test = train[sep:len(train)]
    train = train[0:sep]

    nfeat = len(train[0]) - 1
    test_lab = list()
    for i in range(len(test)):
        row = test[i]
        test[i] = row[0:nfeat]
        test_lab.append(row[nfeat])

    pred = predict_by_decision_tree(train, test)

    # Calculate miscalculation rate
    sum = 0
    for i in range(len(pred)): 
        sum += pred[i] == test_lab[i]
    print("Decision tree correctly predicted: ", float(sum) / len(pred) * 100, "%")
    
    # Compare with pure guessing
    sum = 0
    all_class_labels = list(set(test_lab))
    num_classes = len(all_class_labels)
    for i in range(len(pred)): 
        random_num = random.randint(0, num_classes - 1)
        sum += pred[i] == all_class_labels[random_num]
    print("Randomly guess correct rate =", float(sum) / len(pred) * 100, "%")
    

if __name__ == "__main__":
    main(sys.argv[1:])



    
    
    

    







