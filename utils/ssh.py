#! /usr/bin/env python3

import os
import sys
import pysftp

cnopts = pysftp.CnOpts()
cnopts.hostkeys = None
default_connection_info = {
    'host': '114.215.159.150',
    'username': 'root',
    'password': 'qcastRSS!@#$',
    'cnopts': cnopts,
    'port': 20002
}

default_remote_path = '/var/www/zhangzhong'

def sftp_up(local_path=None, connection_info=None, remote_path=default_remote_path):
    promote = False
    if local_path is None:
        promote = True
        local_path = os.getcwd()

    real_path = os.path.realpath(local_path)
    if not os.path.exists(real_path):
        print("%s 不存在" % (real_path,))
        return

    is_file = os.path.isfile(real_path)

    if promote:
        filetype = '文件' if is_file else '目录'
        answer = input('是否要上传%s%s?' % (real_path, filetype))
        answer = answer.lower()
        if answer not in ('y', 'yes'):
            return

    if connection_info is None:
        cninfo = default_connection_info

    with pysftp.Connection(**cninfo) as sftp:
        if is_file:
            with sftp.cd(remote_path):
                sftp.put(real_path)
        else:
            lastpath = os.path.split(real_path)[1]
            new_remote_path = os.path.join(remote_path, lastpath)

            if not sftp.exists(new_remote_path):
                sftp.mkdir(new_remote_path)

            git_ignore_dirs = gitignore(real_path)

            for entry in os.listdir(real_path):
                if git_ignore_dirs:
                    if os.path.isdir(os.path.join(real_path, entry)):
                        if entry + '/' in git_ignore_dirs:
                            continue
                    else:
                        if entry in git_ignore_dirs:
                            continue

                print(real_path, new_remote_path, entry)
                a_path = os.path.join(real_path, entry)
                a_remote_path = os.path.join(new_remote_path, entry)
                if os.path.isfile(a_path):
                    with sftp.cd(new_remote_path):
                        sftp.put(entry)
                else:
                    if not sftp.exists(a_remote_path):
                        sftp.mkdir(a_remote_path)
                    sftp.put_r(a_path, a_remote_path)

def gitignore(directory):
    ignored = ['.git/']
    try:
        gitignorepath = os.path.join(directory, '.gitignore')
        gitignored = open(gitignorepath).readlines()
        gitignored = [i.strip() for i in gitignored]
        ignored.extend(gitignored)
        return ignored
    except OSError:
        return ignored

if len(sys.argv) > 1:
    sftp_up(sys.argv[1])
else:
    sftp_up()

