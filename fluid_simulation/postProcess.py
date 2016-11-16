#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import os
from glob import glob
from shutil import copy
# from paraview.simple import *

DO_NOT_PROCCES = ['forces']
ROOT_FOLDER = 'postProcessing' + os.sep
POST_DIR = ROOT_FOLDER + 'postSurfaces' + os.sep

FILES = [y for x in os.walk(ROOT_FOLDER + 'surfaces') for y in glob(os.path.join(x[0], '*.vtk'))]
FOLDERS = (i.split('.')[-2] for i in {i.split(os.sep)[-1] for i in FILES})

try:
    os.mkdir('asdf')
    [os.mkdir(POST_DIR + folder) for folder in FOLDERS]
except (os.error) as err:
    print err


# COPY_FILE = lambda file: copy(file, DEST(file))

def VtkToVtu(vtk_file, vtu_file):
    r = LegacyVTKReader( FileNames=[vtk_file] )
    w = XMLUnstructuredGridWriter()
    w.FileName = vtu_file
    w.DataMode = 0
    w.UpdatePipeline()
    os.remove(vtk_file)
    return vtu_file


DEST = lambda file: POST_DIR + file.split('.')[-2].split(os.sep)[-1] + os.sep + TIME(
    file) + '_' + file.split(os.sep)[-1].split('.')[0] + '.vtp'

def PvdFiles(file_list):
    FOLDERS = set('_'.join(i.split('.')[-2].split('_')[1:]) for i in {i.split(os.sep)[-1] for i in file_list})
    TIME = lambda file: file.split(os.sep)[-1].split('_')[0]
    for result in FOLDERS:
        pvd = '<VTKFile type="Collection" version="0.1" byte_order="LittleEndian">\n'
        pvd += '    <Collection>\n'
        for vtu in filter(lambda file: result in file, file_list):
            pvd += '        <DataSet timestep=\"%s\"         file=\'%s\'/>\n' % \
                (TIME(vtu), vtu.replace(POST_DIR, '').replace('\\', '/'))
        pvd += '    </Collection>\n'
        pvd += '</VTKFile>'
        with open(POST_DIR + result + '.pvd', "w") as log:
            log.write(pvd)
    

VTP_FILES = [y for x in os.walk(POST_DIR) for y in glob(os.path.join(x[0], '*.vtp'))]

PvdFiles(VTP_FILES)
[VtkToVtu(vtu, DEST(vtu)) for vtu in FILES if not os.path.exists(DEST(vtu))]
