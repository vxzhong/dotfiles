#! /usr/bin/env python3

import os
import sys
import pysftp


# 将本地文件拷贝到远程路径下
def _sftp_upload_file(connection, file_path, remote_path):
    if not connection.exists(remote_path):
        connection.makedirs(remote_path)

    with connection.cd(remote_path):
        connection.put(file_path)

    print('Copy file [%s] to remote [%s], SUCCESS!' % (file_path, remote_path))


# 将本地目录拷贝到远程路径下
def _sftp_upload_directory(connection, directory_path, remote_path):
    if not connection.exists(remote_path):
        connection.makedirs(remote_path)

    directory = os.path.split(directory_path)[1]
    remote_directory_path = os.path.join(remote_path, directory)

    if not connection.exists(remote_directory_path):
        connection.mkdir(remote_directory_path)

    connection.put_r(directory_path, remote_directory_path)
    print('Copy directory [%s] to remote [%s], SUCCESS!' % (directory, remote_directory_path))


def _sftp_upload(file_path, remote_path):
    options = pysftp.CnOpts()
    options.hostkeys = None
    info = get_host_info()
    info['cnopts'] = options

    with pysftp.Connection(**info) as sftp:
        is_file = os.path.isfile(file_path)
        if is_file:
            _sftp_upload_file(sftp, file_path, remote_path)
        else:
            _sftp_upload_directory(sftp, file_path, remote_path)


def get_host_info():
    return {
        'host': '114.215.159.150',
        'username': 'root',
        'password': 'qcastRSS!@#$',
        'port': 20002
    }


default_remote_path = '/var/www/zhangzhong'


def sftp_upload(file=None, remote_path=None):
    promote = False
    if file is None:
        promote = True
        file = os.getcwd()

    file_path = os.path.realpath(file)
    if not os.path.exists(file_path):
        print("%s 不存在" % (file_path,))
        return

    is_file = os.path.isfile(file_path)

    if promote:
        filetype = 'file' if is_file else 'directory'
        answer = input('Upload [%s] %s?' % (file_path, filetype))
        answer = answer.lower()
        if answer not in ('y', 'yes'):
            return

    if remote_path is None:
        remote_path = default_remote_path

    _sftp_upload(file_path, remote_path)

if len(sys.argv) > 2:
    sftp_upload(sys.argv[1], sys.argv[2])
elif len(sys.argv) > 1:
    sftp_upload(sys.argv[1])
else:
    sftp_upload()
